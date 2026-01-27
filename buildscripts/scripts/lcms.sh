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

unset CC CXX
meson setup .. \
  --cross-file "$prefix_dir"/crossfile.txt \
  --prefix="$prefix_dir" \
  -Dtests=disabled

ninja -C $build -j$cores
DESTDIR="$prefix_dir" ninja -C $build install