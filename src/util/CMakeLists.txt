#
# Make sure we don't attempt to add a library more than once
#
get_property(EXISTS GLOBAL PROPERTY _UTIL_INCLUDED)
if(EXISTS)
    return()
endif()

set(PDAL_UTIL_HPP
    "${PDAL_INCLUDE_DIR}/pdal/util/Algorithm.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Bounds.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Charbuf.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Extractor.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/FileUtils.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Georeference.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Inserter.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/IStream.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/OStream.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Utils.hpp"
    "${PDAL_INCLUDE_DIR}/pdal/util/Uuid.hpp"
    )

set(PDAL_UTIL_CPP
    "${PDAL_UTIL_DIR}/Bounds.cpp"
    "${PDAL_UTIL_DIR}/Charbuf.cpp"
    "${PDAL_UTIL_DIR}/FileUtils.cpp"
    "${PDAL_UTIL_DIR}/Georeference.cpp"
    "${PDAL_UTIL_DIR}/Utils.cpp"
    )

set(PDAL_UTIL_SOURCES
    ${PDAL_UTIL_CPP}
    ${PDAL_UTIL_HPP})

PDAL_ADD_LIBRARY(${PDAL_UTIL_LIB_NAME} SHARED ${PDAL_UTIL_SOURCES})
target_link_libraries(${PDAL_UTIL_LIB_NAME} ${PDAL_BOOST_LIB_NAME} ${CMAKE_DL_LIBS} ${PDAL_ARBITER_LIB_NAME} ${CURL_LIBRARIES} )
if (PDAL_HAVE_JSONCPP)
    target_link_libraries(${PDAL_UTIL_LIB_NAME} ${JSONCPP_LIBRARY})
else()
    target_link_libraries(${PDAL_UTIL_LIB_NAME} ${PDAL_JSONCPP_LIB_NAME})
endif()

set_target_properties(${PDAL_UTIL_LIB_NAME} PROPERTIES
    VERSION "${PDAL_BUILD_VERSION}"
    SOVERSION "${PDAL_API_VERSION}"
    CLEAN_DIRECT_OUTPUT 1)

set_property(GLOBAL PROPERTY _UTIL_INCLUDED TRUE)
