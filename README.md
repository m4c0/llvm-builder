# llvm-builder

Scripts, workflows and general trickery to build my own LLVM toolchains

## wasm

Build with:

```
LLVM=/path/to/llvm ./wasi.sh
```

Use with

```
clang++ ... --sysroot /path/to/prefix -resource-dir /path/to/prefix
```

This allows using any clang with the contents of the prefix folder.
