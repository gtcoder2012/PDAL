
# Predicate Filter
#
set(srcs PredicateFilter.cpp)
set(incs PredicateFilter.hpp)

PDAL_ADD_PLUGIN(predicate_libname filter predicate
    FILES "${srcs}" "${incs}"
    LINK_WITH ${PLANG_LIB_NAME})

#
# Programmable Filter
#
set(srcs ProgrammableFilter.cpp)
set(incs ProgrammableFilter.hpp)

PDAL_ADD_PLUGIN(programmable_libname filter programmable
    FILES "${srcs}" "${incs}"
    LINK_WITH ${PLANG_LIB_NAME})

if (WITH_TESTS)
    PDAL_ADD_TEST(python_predicate_test
            FILES ../test/PredicateFilterTest.cpp
            LINK_WITH ${predicate_libname} ${PLANG_LIB_NAME})

    PDAL_ADD_TEST(python_programmable_test
            FILES ../test/ProgrammableFilterTest.cpp
            LINK_WITH ${programmable_libname} ${PLANG_LIB_NAME})
endif()