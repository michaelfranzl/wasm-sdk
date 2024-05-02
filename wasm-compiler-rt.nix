{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "wasm-compiler-rt";
  version = "17.0.6";
  src = fetchzip {
    url = "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-17.0.6.tar.gz";
    hash = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
  };

  wasm-llvm = import ./wasm-llvm.nix { inherit pkgs; };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontFixup = true;

  configurePhase = ''
    cmake -G Ninja \
    -DCMAKE_MODULE_PATH=${wasm-llvm.dev}/cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=${wasm-llvm.dev}/cmake/toolchain.cmake \
    -DCOMPILER_RT_BAREMETAL_BUILD=ON \
    -DCOMPILER_RT_INCLUDE_TESTS=OFF \
    -DCOMPILER_RT_HAS_FPIC_FLAG=OFF \
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON \
    -DCMAKE_INSTALL_PREFIX=$out \
    $src/compiler-rt/lib/builtins
  '';

  buildPhase = ''
    ninja -v
  '';

  installPhase = ''
    ninja -v install
  '';
}
