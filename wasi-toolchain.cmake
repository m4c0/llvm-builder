set(CMAKE_SYSTEM_NAME WASI)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR wasm32)
set(CMAKE_C_COMPILER_TARGET "wasm32-wasi")
set(CMAKE_CXX_COMPILER_TARGET "wasm32-wasi")
set(CMAKE_CXX_FLAGS_INIT "-fno-exceptions")
