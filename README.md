# wasm-sdk

A SDK for LLVM C and C++ WebAssembly development based on Nix.

It builds all required dependencies (*clang, clang++, wasm-ld, libcxx, compiler-rt*, and *wasi-libc*)
and exposes the following environment variables needed to compile to WebAssembly, for example:

```
WASM_LLVM=/nix/store/akpcpb9ycb98jjbp6dyg1j65vkwqp1lm-wasm-llvm
WASM_LIBCXX_LIB=/nix/store/ll4hi2jkhv8399dhbz6q0qgw97c6hyja-wasm-libcxx/lib
WASM_LIBCXX_INC=/nix/store/ll4hi2jkhv8399dhbz6q0qgw97c6hyja-wasm-libcxx/include/c++/v1
WASM_COMPILER_RT_LIB=/nix/store/59lmk928vly8126zq7mabzc9123hknj2-wasm-compiler-rt/lib/wasi
WASI_LIBC_LIB=/nix/store/qislis4ivwv3l721dbhghax6j4kp3ccb-wasi-libc/lib
WASI_LIBC_INC=/nix/store/71k5vk20275571n0bsij42qdasbxc82b-wasi-libc-dev/include
```

## Goals

* Lean toolchain leveraging as much as possible from upstream sources.
* Basic levels of WASI (no threading, no exceptions).


## Versions

* LLVM: 17
* wasi-libc: 21


## Usage

The included derivation produces a single file with exportable environment variables.

Example:

```sh
env $(cat $(nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}')) printenv
```

A *flake* is also included that exposes the needed variables in the following ways (three ways to choose from, for convenience):

1. as the `paths` (*attrset* type) *passthru* of the *derivation* of the *default package* (to use in other *flakes*).
2. as exported environment variables in the *default development shell* (`nix develop`).
3. as text in a file (`nix build` produces the file `./result`).
