{ pkgs }:
let
  # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-26/cmake/wasi-sdk-sysroot.cmake#L29
  sysroot_path = "share/wasi-sysroot";

  # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-26/wasi-sdk.cmake#L10
  triple = "wasm32-wasi";
in
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
    "SYSROOT_LIB=${builtins.placeholder "out"}/${sysroot_path}/lib/${triple}"
    "SYSROOT_INC=${builtins.placeholder "dev"}/${sysroot_path}/include/${triple}"
    "SYSROOT_SHARE=${builtins.placeholder "share"}/${sysroot_path}/share/${triple}"
  ];
}
