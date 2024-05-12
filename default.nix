{ pkgs, ... }:
let
  wasm-llvm = import ./wasm-llvm.nix { inherit pkgs; };
  wasm-libcxx = import ./wasm-libcxx.nix { inherit pkgs; };
  wasi-libc = import ./wasi-libc.nix { inherit pkgs; };
  wasm-compiler-rt = import ./wasm-compiler-rt.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "wasm-sdk";
  version = "1.0.0";

  paths = [
    wasm-llvm
    wasm-libcxx
    wasi-libc
    wasi-libc.dev
    wasm-compiler-rt
  ];

  dontUnpack = true;
}
