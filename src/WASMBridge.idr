module WASMBridge

import Data.Buffer

%foreign "C:js_get_request,bridge"
prim__js_get_request : PrimIO AnyPtr

%foreign "C:js_send_response,bridge"
prim__js_send_response : AnyPtr -> Int -> PrimIO ()

export
js_get_request : IO AnyPtr
js_get_request = primIO prim__js_get_request

export
js_send_response : AnyPtr -> Int -> IO ()
js_send_response ptr size = primIO (prim__js_send_response ptr size)

-- The main game loop
loop : IO ()
loop = do
  -- Block until JS provides a request (via Asyncify)
  reqPtr <- js_get_request
  
  -- TODO: Parse the Int32Array at reqPtr into a Substrate/Vexel state.
  -- For now, we just bounce it back to prove the bridge works!
  -- We'll assume the first int is the size of the request.
  -- In a real implementation, we would extract the values, 
  -- run `stepUniverseLocalized`, serialize the output to a new Buffer,
  -- and send the Buffer's raw pointer back.
  
  -- Let's just echo it for the prototype phase.
  js_send_response reqPtr 0
  
  loop

export
main : IO ()
main = do
  putStrLn "Idris WASM Bridge Initialized!"
  loop
