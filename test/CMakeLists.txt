enable_testing()

add_pfunit_ctest (my_tests
  TEST_SOURCES test_call_py_fort.pfunit
  LINK_LIBRARIES callpy
)