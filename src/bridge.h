#ifndef BRIDGE_H
#define BRIDGE_H

#include <stdint.h>

void* js_get_request(void);
void js_send_response(void* ptr, int size);

#endif
