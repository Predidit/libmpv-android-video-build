#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

toolchain=$(echo "$DIR/sdk/android-sdk-linux/ndk/$v_ndk/toolchains/llvm/prebuilt/"*)

cmake -B $build -L \
  -DCMAKE_TOOLCHAIN_FILE="$toolchain/build/cmake/android.toolchain.cmake" \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX="$prefix_dir" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SKIP_RPATH=TRUE \
  -DSHADERC_SKIP_TESTS=ON \
  -DSHADERC_SKIP_EXAMPLES=ON \
  -DSHADERC_SKIP_COPYRIGHT_CHECK=ON \
  -DSHADERC_ENABLE_WERROR_COMPILE=OFF \
  -DANDROID_ABI="$ndk_triple" \
  -DANDROID_PLATFORM=android-34 \
  -GNinja

ninja -C $build -j$cores
DESTDIR="$prefix_dir" ninja -C $build install