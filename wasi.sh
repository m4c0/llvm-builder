#!/bin/bash

set -ex

export CC=${LLVM}/bin/clang
export CXX=${LLVM}/bin/clang++

export INSTALL=`pwd`/prefix
export SYSROOT=$INSTALL/sysroot

make -C wasi-libc

cmake -G Ninja -S llvm-project/runtimes -B build/runtimes \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;compiler-rt" \
  -DLLVM_CONFIG_PATH=$LLVM/bin/llvm-config \
  -DCMAKE_C_COMPILER_WORKS=ON \
  -DCMAKE_CXX_COMPILER_WORKS=ON \
  -DCMAKE_TOOLCHAIN_FILE=`pwd`/wasi-toolchain.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSROOT=$SYSROOT \
  -DCMAKE_INSTALL_PREFIX=$INSTALL \
  -DUNIX:BOOL=ON \
  -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF \
  -DLIBCXXABI_ENABLE_SHARED:BOOL=OFF \
  -DLIBCXXABI_ENABLE_EXCEPTIONS:BOOL=OFF \
  -DLIBCXXABI_HAS_PTHREAD_API:BOOL=OFF \
  -DLIBCXX_HAS_MUSL_LIBC:BOOL=ON \
  -DLIBCXX_ENABLE_SHARED:BOOL=OFF \
  -DLIBCXX_ENABLE_THREADS:BOOL=OFF \
  -DLIBCXX_ENABLE_FILESYSTEM:BOOL=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF \
  -DCOMPILER_RT_BAREMETAL_BUILD:BOOL=ON \
  -DCOMPILER_RT_BUILD_BUILTINS:BOOL=ON \
  -DCOMPILER_RT_BUILD_LIBFUZZER:BOOL=OFF \
  -DCOMPILER_RT_BUILD_MEMPROF:BOOL=OFF \
  -DCOMPILER_RT_BUILD_PROFILE:BOOL=OFF \
  -DCOMPILER_RT_BUILD_SANITIZERS:BOOL=OFF \
  -DCOMPILER_RT_BUILD_XRAY:BOOL=OFF \
  -DCOMPILER_RT_DEFAULT_TARGET_ONLY:BOOL=ON \
  -DCOMPILER_RT_OS_DIR=wasi
ninja -C build/runtimes cxx cxxabi compiler-rt
ninja -C build/runtimes install-cxx install-cxxabi install-compiler-rt

pushd $INSTALL
mv sysroot/include include/wasm32-wasi
mv sysroot/lib/wasm32-wasi lib
mv lib/libc++* lib/wasm32-wasi
popd
