#!/bin/sh

set -e

ARGS=("$@")

mkdir -p "${BUILT_PRODUCTS_DIR}/DerivedSources/JavaScriptCore"
cd "${BUILT_PRODUCTS_DIR}/DerivedSources/JavaScriptCore"

/bin/ln -sfh "${SRCROOT}" JavaScriptCore
export JavaScriptCore="JavaScriptCore"
export BUILT_PRODUCTS_DIR="../.."

if [ ! "$CC" ]; then
    export CC="`xcrun -find clang`"
fi

echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"
echo "***********************************************************"
echo "setting ncpu 4 for JavaScriptCore Derived source generation"
make --no-builtin-rules -f "JavaScriptCore/DerivedSources.make" -j 4 SDKROOT="${SDKROOT}" "${ARGS[@]}"
