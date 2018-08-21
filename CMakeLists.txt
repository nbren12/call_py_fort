cmake_minimum_required(VERSION 3.4)
enable_language(Fortran)

project(call_py_fort)

include(CTest)

set(CMAKE_C_COMPILER       mpicc)
set(CMAKE_Fortran_COMPILER mpif90)

if (${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -Wall -Wextra -Werror -fimplicit-none -fbacktrace")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -Wnoerror")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fbounds-check --coverage")

elseif(${CMAKE_Fortran_COMPILER_ID} MATCHES Intel)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -traceback -warn errors warn all")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -warn noerrors -xHost")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -check all")

elseif(${CMAKE_Fortran_COMPILER_ID} MATCHES PGI)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -traceback -Mdclchk -Mstandard")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -gopt -fast")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -Mbounds -Mchkptr -Mchkstk")

endif(${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)

add_subdirectory(src)
add_subdirectory(test)

