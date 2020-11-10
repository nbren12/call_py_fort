# call_py_fort

![status](https://github.com/VulcanClimateModeling/call_py_fort/workflows/Check/badge.svg)

Call python from Fortran (not the other way around). Inspired by this [blog
post](https://www.noahbrenowitz.com/post/calling-fortran-from-python/).

## Installation

This library has the following dependencies
1. pfUnit (v3.2.9) for the unit tests
1. python (3+) with numpy and cffi
1. cmake (>=3.4+)

To install pfunit on a linux system, you can run a commmand like the following:

    export F90=gfortran
    export F90_VENDOR=GNU
    export PFUNIT=/usr/local
    curl -L https://github.com/Goddard-Fortran-Ecosystem/pFUnit/archive/3.2.9.tar.gz | tar xz
    cd pFUnit-3.2.9 && \
        cmake . && \
        make &&\
        sudo make install INSTALL_DIR=${PFUNIT}

Installing python dependencies is out of scope of this documentation.

See the [continuous integration configuration](.github/workflows/check.yaml) for an example of how to install all these dependencies on an ubuntu system

Once the dependencies are installed, you can compile and install this library using

    mkdir build
    cd build 
    cmake ..
    make
    make install

This should install the `libcallpy` library to `/usr/local/lib` and the
necessary module files to `/usr/local/include`. The specific way to add this
library to a Fortran code base will depend on the build system of that code.
Typically, you will need to add a flag `-I/usr/local/include` to any fortran
compiler commands letting the compiler find the `.mod` file for this library,
and a `-L/usr/local/lib -lcallpy` to link against the dynamic library. On
some systems, you may need to set
`LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH` at runtime to help the
dynamic linker find the library.

## Usage

Once installed, this library is very simple to use. For example:

    program example
    implicit none
    use callpy
    
    real(8) :: a(10)

    call set_state("a", a)
    call call_function("builtins", "print")
    ! read any changes from "a" back into a.
    call get_state("a", a)

    end program example

It basically operates by pushing fortran arrays into a global python
dictionary, calling python functions with this dictionary as input, and then
reading numpy arrays from this dictionary back into fortran. Let this
dictionary by called STATE. In terms of python operations, the above lines
roughly translate to

    # abuse of notation signifyling that the left-hand side is a numpy array
    STATE["a"] = a[:]
    # same as `print` but with module name
    builtins.print(STATE)
    # transfer from python back to fortran memory
    a[:] = STATE["a"]

You should be able to compile the above by running

    gfortran -I/usr/local/include -L/usr/local/lib -lcallpy file.f90

By modifying, the arguments of `call_function` you can call any python
function in the pythonpath.

Currently, `get_state` and `set_state` support 4 byte or 8 byte floating
point of one, two, or three dimensions.

## Examples

See the [unit tests](/test/test_call_py_fort.pfunit) for more examples.
