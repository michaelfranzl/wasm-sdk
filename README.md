# wasm-sdk

A *Nix*-based SDK for C and C++ development targeting WebAssembly.

## Goals

* Lean toolchain leveraging as much as possible from upstream sources.
* Basic levels of WASI (no threading, no exceptions).


## Versions

* LLVM: 17
* wasi-libc: 21


## Usage

The package contains all required dependencies in the following build subdirectories:

* `bin`: compilers (`clang`, `clang++`) and linker (`wasm-ld`)
* `include`: *libc* headers
* `include/c++/v1`: *libcxx* headers
* `lib`: all *libc* and *libcxx* static libraries
* `lib/wasi`: compiler-rt builtins static library
