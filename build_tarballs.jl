using BinaryBuilder

name = "ITK"
version = v"5.0.1"

# Collection of sources required to build zlib
sources = [
    "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v$(version)/InsightToolkit-$(version).tar.gz" =>
    "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/InsightToolkit-*

mkdir ITK-build
cd ITK-build
cmake ../ITK -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
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
