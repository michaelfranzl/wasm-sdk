{ pkgs, lib, ... }:
let
  wasm-llvm = import ./wasm-llvm.nix { inherit pkgs; };
  wasm-libcxx = import ./wasm-libcxx.nix { inherit pkgs; };
  wasi-libc = import ./wasi-libc.nix { inherit pkgs; };
  wasm-compiler-rt = import ./wasm-compiler-rt.nix { inherit pkgs; };

  paths = {
    WASM_LLVM = wasm-llvm;
    WASM_LIBCXX_LIB = "${wasm-libcxx}/lib";
    WASM_LIBCXX_INC = "${wasm-libcxx}/include/c++/v1";
    WASM_COMPILER_RT_LIB = "${wasm-compiler-rt}/lib/wasi";
    WASI_LIBC_LIB = "${wasi-libc}/lib";
    WASI_LIBC_INC = "${wasi-libc.dev}/include";
  };

  pathsFileContents = lib.strings.concatLines (
    lib.attrsets.mapAttrsToList (name: value: name + "=" + value) paths
  );
in
pkgs.stdenv.mkDerivation rec {
  name = "wasm-sdk";
  version = "1.0.0";

  dontUnpack = true;

  installPhase = ''
    echo "${pathsFileContents}" > $out
  '';

  passthru = {
    inherit paths;
  };
}
