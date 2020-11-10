find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)

add_library(callpy SHARED callpy_mod.f90 ${CMAKE_CURRENT_BINARY_DIR}/plugin.c)
target_link_libraries(callpy ${PYTHON_LIBRARIES})
target_include_directories(callpy PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:include>
    ${PYTHON_INCLUDE_DIRS}
    )

install(TARGETS callpy
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    )

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/ DESTINATION include
    FILES_MATCHING PATTERN "*.mod"
    PATTERN "CMakeFiles" EXCLUDE
    )

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/plugin.c
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/builder.py ${CMAKE_CURRENT_SOURCE_DIR}/callpy.py
  COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/builder.py ${CMAKE_CURRENT_SOURCE_DIR}/callpy.py
  COMMENT "Building CFFI Module"
)