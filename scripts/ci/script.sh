#!/bin/bash -e
# Builds and tests PDAL

clang --version

cd /pdal
source ./scripts/ci/common.sh

mkdir -p _build || exit 1
cd _build || exit 1

case "$PDAL_OPTIONAL_COMPONENTS" in
    all)
        OPTIONAL_COMPONENT_SWITCH=ON
        ;;
    none)
        OPTIONAL_COMPONENT_SWITCH=OFF
        ;;
    *)
        echo "Unrecognized value for PDAL_OPTIONAL_COMPONENTS=$PDAL_OPTIONAL_COMPONENTS"
        exit 1
esac


cmake \
    -DBUILD_PLUGIN_CPD=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_GREYHOUND=OFF \
    -DBUILD_PLUGIN_HEXBIN=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_ICEBRIDGE=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_MRSID=OFF \
    -DBUILD_PLUGIN_NITF=OFF \
    -DBUILD_PLUGIN_OCI=OFF \
    -DBUILD_PLUGIN_P2G=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_PCL=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_PGPOINTCLOUD=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PGPOINTCLOUD_TESTS=OFF \
    -DBUILD_PLUGIN_SQLITE=$OPTIONAL_COMPONENT_SWITCH \
    -DBUILD_PLUGIN_RIVLIB=OFF \
    -DBUILD_PLUGIN_PYTHON=$OPTIONAL_COMPONENT_SWITCH \
    -DENABLE_CTEST=OFF \
    -DWITH_APPS=ON \
    -DWITH_LAZPERF=$OPTIONAL_COMPONENT_SWITCH \
    -DWITH_GEOTIFF=$OPTIONAL_COMPONENT_SWITCH \
    -DWITH_LASZIP=$OPTIONAL_COMPONENT_SWITCH \
    -DLASZIP_INCLUDE_DIR:PATH=/usr/include \
    -DLASZIP_LIBRARY:FILEPATH=/usr/lib/liblaszip.so \
    -DWITH_TESTS=ON \
    -G "$PDAL_CMAKE_GENERATOR" \
    ..

cmake ..

MAKECMD=ninja

# Don't use ninja's default number of threads becuase it can
# saturate Travis's available memory.
NUMTHREADS=2
${MAKECMD} -j ${NUMTHREADS} && \
    LD_LIBRARY_PATH=./lib && \
    PGUSER=postgres ctest -V && \
    ${MAKECMD} install && \
    /sbin/ldconfig

if [ "${OPTIONAL_COMPONENT_SWITCH}" == "ON" ]; then
    cd /pdal/python
    pip install packaging
    python setup.py build
    echo "current path: " `pwd`
    export PDAL_TEST_DIR=/pdal/_build/test
    python setup.py test
    
    # Build all examples
    for EXAMPLE in writing writing-filter writing-kernel writing-reader writing-writer
    do
        cd /pdal/examples/$EXAMPLE
        mkdir -p _build || exit 1
        cd _build || exit 1
        cmake -G "$PDAL_CMAKE_GENERATOR" .. && \
        ${MAKECMD}
    done
fi
