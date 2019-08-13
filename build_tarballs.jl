using BinaryBuilder

name = "ITK"
version = v"5.0.1"

# Collection of sources required to build zlib
sources = [
    "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v$(version)/InsightToolkit-$(version).tar.gz" =>
    "613b125cbf58481e8d1e36bdeacf7e21aba4b129b4e524b112f70c4d4e6d15a6",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/InsightToolkit-*
mkdir build && cd build

if [[ "${target}" == i686-linux-* ]]; then
    export EMU=
elif [[ "${target}" == x86_64-linux-* ]]; then
    export EMU=
elif [[ "${target}" == arm-linux-* ]]; then
    export EMU=
elif [[ "${target}" == powerpc64le-linux-* ]]; then
    export EMU=
elif [[ "${target}" == x86_64-apple-* ]]; then
    export EMU=
elif [[ "${target}" == i686-w64-mingw32 ]]; then
    export EMU=
elif [[ "${target}" == x86_64-w64-mingw32 ]]; then
    export EMU=
elif [[ "${target}" == *freebsd* ]]; then
    export EMU=
elif [[ "${target}" == aarch64-linux-* ]]; then
    export EMU=
else
    export EMU=
fi

cmake ../ -DCMAKE_CROSSCOMPILING_EMULATOR=${EMU} -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain

cmake -C TryRunResults.cmake ../
make install -j${nproc}
"""

# Build for ALL THE PLATFORMS!
platforms = supported_platforms()

# The products that we will ensure are always built
products = prefix -> [
    LibraryProduct(prefix, "libitk", :libitk),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
