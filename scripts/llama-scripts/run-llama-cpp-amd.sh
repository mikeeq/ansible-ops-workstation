#!/usr/bin/env bash
set -euo pipefail

LLAMA_DIR="llama.cpp"

if [ ! -d "$LLAMA_DIR" ]; then
	echo "Cloning llama.cpp..."
	git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
fi

cd "$LLAMA_DIR"

echo "Pulling latest llama.cpp..."
git pull

# Fix httplib short-circuit that prevents SSL_CERT_FILE from being picked up
sed -i \
	's/return loaded_any || SSL_CTX_set_default_verify_paths(ssl_ctx) == 1;/SSL_CTX_set_default_verify_paths(ssl_ctx); return loaded_any || true;/' \
	vendor/cpp-httplib/httplib.cpp

echo "Configuring CMake build for AMD ROCm (gfx1100 = RX 7900 XTX)..."
cmake -B build \
	-DCMAKE_BUILD_TYPE=Release \
	-DGGML_HIP=ON \
	-DAMDGPU_TARGETS=gfx1100

echo "Building..."
cmake --build build --config Release -j"$(nproc)"

echo ""
echo "Build complete."
./build/bin/llama-server --version
