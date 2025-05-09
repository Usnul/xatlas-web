#!/bin/bash

set -e

export OPTIMIZE="-O3"
export LDFLAGS="${OPTIMIZE}"
export CFLAGS="${OPTIMIZE}"
export CPPFLAGS="${OPTIMIZE}"

echo "============================================="
echo "Compiling wasm bindings"
echo "============================================="
(
  # Compile C/C++ code
  emcc \
    -std=c++1y \
    -DXA_MULTITHREADED=0 \
    -DNDEBUG \
    ${OPTIMIZE} \
    --bind \
    --no-entry \
    -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s MALLOC=emmalloc \
    -s MODULARIZE=1 \
    -s ENVIRONMENT='web,worker' \
    -s ASSERTIONS=0 \
    --post-js './web/module-post.js' \
    -o ./xatlas-web.js \
    web/*.cpp \
    xatlas.cpp

  # Create output folder
  mkdir -p dist
  # Move artifacts
  mv xatlas-web.{js,wasm} dist
)
echo "============================================="
echo "Compiling wasm bindings done"
echo "============================================="