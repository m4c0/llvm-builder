#!/bin/bash

set -ex

export INSTALL=`pwd`/prefix
export SYSROOT=$INSTALL/sysroot

make -C wasi-libc

cmake -G Ninja -S llvm-project/runtimes -B llvm-project/build \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;compiler-rt" \
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
  -DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF 
ninja -C llvm-project/build cxx cxxabi compiler-rt
ninja -C llvm-project/build install-cxx install-cxxabi install-compiler-rt
