#include <emscripten.h>
#include <emscripten/html5.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

// Global buffers to share data with JS
int32_t* js_request_buffer = NULL;
int js_request_size = 0;

int32_t* js_response_buffer = NULL;
int js_response_size = 0;

// Asyncify flag
int request_ready = 0;

// Called by JS to allocate a request buffer
EMSCRIPTEN_KEEPALIVE
int32_t* alloc_request(int size) {
    if (js_request_buffer) free(js_request_buffer);
    js_request_buffer = (int32_t*)malloc(size * sizeof(int32_t));
    js_request_size = size;
    return js_request_buffer;
}

// Called by JS to trigger the next frame/compute step
EMSCRIPTEN_KEEPALIVE
void trigger_compute() {
    request_ready = 1;
}

// Called by JS to get the response buffer pointer
EMSCRIPTEN_KEEPALIVE
int32_t* get_response() {
    return js_response_buffer;
}

// Called by JS to get the response size
EMSCRIPTEN_KEEPALIVE
int get_response_size() {
    return js_response_size;
}

// Called by Idris to block until JS triggers a compute step
void* js_get_request() {
    // Wait until JS sets request_ready to 1
    // EM_ASM_INT uses Asyncify to sleep/yield to the browser event loop
    EM_ASM({
        return Asyncify.handleSleep(function(wakeUp) {
            var check = function() {
                if (Module.ccall('check_ready', 'number', [], []) === 1) {
                    wakeUp(0);
                } else {
                    setTimeout(check, 10);
                }
            };
            check();
        });
    });
    
    request_ready = 0; // reset for next time
    return js_request_buffer;
}

EMSCRIPTEN_KEEPALIVE
int check_ready() {
    return request_ready;
}

// Called by Idris to send the computed response back
void js_send_response(void* ptr, int size) {
    js_response_buffer = (int32_t*)ptr;
    js_response_size = size;
    
    // Notify JS that response is ready
    EM_ASM({
        if (typeof window.on_idris_response === 'function') {
            window.on_idris_response();
        }
    });
}
