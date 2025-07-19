{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "wasm-libcxx";
  version = "17.0.6";
  src = fetchzip {
    url = "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-17.0.6.tar.gz";
    hash = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
  };

  wasm-llvm = import ./wasm-llvm.nix { inherit pkgs; };

  wasi-libc = import ./wasi-libc.nix { inherit pkgs; };

  dontFixup = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  configurePhase = ''
    cmake -G Ninja \
    -DCMAKE_C_COMPILER_WORKS=ON \
    -DCMAKE_CXX_COMPILER_WORKS=ON \
    -DCMAKE_AR=${wasm-llvm}/bin/ar \
    -DCMAKE_MODULE_PATH=${wasm-llvm.dev}/cmake \
    -DCMAKE_TOOLCHAIN_FILE=/${wasm-llvm.dev}/cmake/toolchain.cmake \
    -DCMAKE_STAGING_PREFIX=$out \
    -DCMAKE_POSITION_INDEPENDENT_CODE=OFF \
    -DLIBCXX_ENABLE_THREADS:BOOL=OFF \
    -DLIBCXX_HAS_PTHREAD_API:BOOL=OFF \
    -DLIBCXX_HAS_EXTERNAL_THREAD_API:BOOL=OFF \
    -DLIBCXX_HAS_WIN32_THREAD_API:BOOL=OFF \
    -DLLVM_COMPILER_CHECKED=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DLIBCXX_ENABLE_SHARED:BOOL=OFF \
    -DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF \
    -DLIBCXX_ENABLE_FILESYSTEM:BOOL=OFF \
    -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT:BOOL=OFF \
    -DLIBCXX_CXX_ABI=libcxxabi \
    -DLIBCXX_HAS_MUSL_LIBC:BOOL=ON \
    -DLIBCXX_ABI_VERSION=2 \
    -DLIBCXXABI_ENABLE_EXCEPTIONS:BOOL=OFF \
    -DLIBCXXABI_ENABLE_SHARED:BOOL=OFF \
    -DLIBCXXABI_SILENT_TERMINATE:BOOL=ON \
    -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF \
    -DLIBCXXABI_HAS_PTHREAD_API:BOOL=OFF \
    -DLIBCXXABI_HAS_EXTERNAL_THREAD_API:BOOL=OFF \
    -DLIBCXXABI_HAS_WIN32_THREAD_API:BOOL=OFF \
    -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF \
    -DUNIX:BOOL=ON \
    --debug-trycompile \
    -DCMAKE_SYSROOT_COMPILE=${wasi-libc.dev}/share/wasi-sysroot/ \
    -DCMAKE_SYSROOT_LINK=${wasi-libc}/share/wasi-sysroot \
    -DCMAKE_CXX_FLAGS="-fno-exceptions" \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
    ${src}/runtimes
  '';

  buildPhase = ''
    ninja -v
  '';

  installPhase = ''
    ninja -v install
  '';
}
