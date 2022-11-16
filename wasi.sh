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
  -DUNIX=ON \
  -DLIBCXXABI_ENABLE_THREADS=OFF \
  -DLIBCXXABI_ENABLE_SHARED=OFF \
  -DLIBCXXABI_ENABLE_EXCEPTIONS=OFF \
  -DLIBCXXABI_HAS_PTHREAD_API=OFF \
  -DLIBCXX_HAS_MUSL_LIBC=ON \
  -DLIBCXX_ENABLE_SHARED=OFF \
  -DLIBCXX_ENABLE_THREADS=OFF \
  -DLIBCXX_ENABLE_FILESYSTEM=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS=OFF \
  -DCOMPILER_RT_BAREMETAL_BUILD=ON \
  -DCOMPILER_RT_BUILD_BUILTINS=ON \
  -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
  -DCOMPILER_RT_BUILD_MEMPROF=OFF \
  -DCOMPILER_RT_BUILD_PROFILE=OFF \
  -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
  -DCOMPILER_RT_BUILD_XRAY=OFF \
  -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
  -DCOMPILER_RT_OS_DIR=wasi
ninja -C build/runtimes cxx cxxabi compiler-rt
ninja -C build/runtimes install-cxx install-cxxabi install-compiler-rt

pushd $INSTALL
mv sysroot/include include/wasm32-wasi
mv sysroot/lib/wasm32-wasi lib
popd
