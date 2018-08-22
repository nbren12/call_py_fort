add_library(callpy SHARED callpy_mod.f90)

target_include_directories(callpy PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:include>
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


# make python embedding module
set(CFFI_LIB ${CMAKE_CURRENT_BINARY_DIR}/libplugin.so)
set(CFFI_LIB ${CFFI_LIB} PARENT_SCOPE)

add_custom_command(
  OUTPUT ${CFFI_LIB}
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/builder.py
  COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/builder.py
  COMMENT "Building CFFI Module"
)

# need to wrap this in a custom target to make it discoverable the test cmakelists.txt
add_custom_target(cffi_lib
  DEPENDS ${CFFI_LIB}
)

install(FILES ${CFFI_LIB} DESTINATION lib) 
