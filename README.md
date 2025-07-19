# wasi-sdk-nixos

WASM LLVM toolchain and WASI sysroot.

Similar to [WebAssembly/wasi-sdk](https://github.com/WebAssembly/wasi-sdk), but re-implemented for NixOS.


## Goals

* Lean C/C++ toolchain leveraging as much as possible from upstream sources.
* Basic levels of WASI (no threading, no exceptions).


## Versioning

Provided are the upstream versions that WebAssembly/wasi-sdk used mid 2024:

* LLVM: 17
* wasi-libc: 21

Future releases may upgrade these upstream versions.


## Usage

The default package contains all required dependencies in the following package subdirectories:

* `bin`: compilers (`clang`, `clang++`) and linker (`wasm-ld`)
* `include`: *libc* headers
* `include/c++/v1`: *libcxx* headers
* `lib`: all *libc* and *libcxx* static libraries
* `lib/wasi`: compiler-rt builtins static library
* `share/wasi-sysroot`: the WASI sysroot

For concrete usage examples, see [michaelfranzl/clang-wasm-browser-starterpack](https://github.com/michaelfranzl/clang-wasm-browser-starterpack).
