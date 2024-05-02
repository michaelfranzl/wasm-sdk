{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "wasi-libc";
  version = "21";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    rev = "refs/tags/wasi-sdk-21";
    hash = "sha256-mQp54JYb3bsmyQy5SByPFu9uxhKDy/XXF7lF9bEUfOo=";
  };

  wasm-llvm = import ./wasm-llvm.nix { inherit pkgs; };

  outputs = [
    "out"
    "dev"
    "share"
  ];

  dontInstall = true;
  dontFixup = true;

  makeFlags = [
    "CC=${wasm-llvm}/bin/clang"
    "NM=${wasm-llvm}/bin/nm"
    "AR=${wasm-llvm}/bin/ar"
    "SYSROOT_LIB=${builtins.placeholder "out"}/lib"
    "SYSROOT_INC=${builtins.placeholder "dev"}/include"
    "SYSROOT_SHARE=${builtins.placeholder "share"}/share"
  ];
}
