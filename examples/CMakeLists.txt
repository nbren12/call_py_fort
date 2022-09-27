function(add_example name source)
    add_executable(${name} ${source})
    target_link_libraries(${name} ${PYTHON_LIBRARIES} callpy)
endfunction()

add_example(setget_array setget_array.f90)
add_example(initialize_stuff initialize_stuff.f90)
add_example(hello_world hello_world.f90)

