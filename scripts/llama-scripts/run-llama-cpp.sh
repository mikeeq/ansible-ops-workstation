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

# Fix httplib short-circuit that prevents SSL_CERT_FILE from being picked up on macOS
sed -i '' \
	's/return loaded_any || SSL_CTX_set_default_verify_paths(ssl_ctx) == 1;/SSL_CTX_set_default_verify_paths(ssl_ctx); return loaded_any || true;/' \
	vendor/cpp-httplib/httplib.cpp

echo "Configuring CMake build..."
cmake -B build \
	-DCMAKE_BUILD_TYPE=Release \
	-DGGML_METAL_EMBED_LIBRARY=ON

echo "Building..."
cmake --build build --config Release -j"$(sysctl -n hw.ncpu)"

echo ""
echo "Build complete."
./build/bin/llama-server --version
