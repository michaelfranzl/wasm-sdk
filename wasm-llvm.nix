{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "wasm-llvm";
  version = "17.0.6";
  src = fetchzip {
    url = "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-17.0.6.tar.gz";
    hash = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  phases = [
    "configurePhase"
    "installPhase"
  ];

  outputs = [
    "out"
    "dev"
  ];

  configurePhase = ''
    cmake -G Ninja \
    -DCMAKE_INSTALL_PREFIX=$out \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ZLIB=OFF \
    -DLLVM_ENABLE_TERMINFO=OFF \
    -DLLVM_ENABLE_ZSTD=OFF \
    -DLLVM_STATIC_LINK_CXX_STDLIB=ON \
    -DLLVM_HAVE_LIBXAR=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_UTILS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_TARGETS_TO_BUILD=WebAssembly \
    -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
    -DLLVM_ENABLE_PROJECTS="lld;clang;clang-tools-extra" \
    -DLLVM_INSTALL_BINUTILS_SYMLINKS=TRUE \
    -DLLVM_ENABLE_LIBXML2=OFF \
    $src/llvm
  '';

  installPhase = ''
        mkdir -p $dev/cmake

        cat > $dev/cmake/toolchain.cmake <<-CMAKE
        set(CMAKE_SYSTEM_NAME WASI)
        set(CMAKE_SYSTEM_VERSION 1)
        set(CMAKE_SYSTEM_PROCESSOR wasm32)
        set(triple wasm32-wasi)

        set(CMAKE_C_COMPILER $out/bin/clang)
        set(CMAKE_CXX_COMPILER $out/bin/clang++)
        set(CMAKE_ASM_COMPILER $out/bin/clang)
        set(CMAKE_AR $out/bin/llvm-ar)
        set(CMAKE_RANLIB $out/bin/llvm-ranlib)

        set(CMAKE_C_COMPILER_TARGET wasm32-wasi)
        set(CMAKE_CXX_COMPILER_TARGET wasm32-wasi)
        set(CMAKE_ASM_COMPILER_TARGET wasm32-wasi)

        set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
        set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
        set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
    CMAKE

        mkdir -p $dev/cmake/Platform
        echo "set(WASI 1)" > $dev/cmake/Platform/WASI.cmake

        ninja -v \
        install-clang \
        install-clang-format \
        install-clang-tidy \
        install-clang-apply-replacements \
        install-lld \
        install-llvm-mc \
        install-llvm-ranlib \
        install-llvm-strip \
        install-llvm-dwarfdump \
        install-clang-resource-headers \
        install-ar \
        install-ranlib \
        install-strip \
        install-nm \
        install-size \
        install-strings \
        install-objdump \
        install-objcopy \
        install-c++filt \
        install-llvm-config
  '';
}
