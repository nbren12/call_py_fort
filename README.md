# call_py_fort

![status](https://github.com/VulcanClimateModeling/call_py_fort/workflows/Check/badge.svg)[![DOI](https://zenodo.org/badge/145489904.svg)](https://zenodo.org/badge/latestdoi/145489904)


Call python from Fortran (not the other way around). Inspired by this [blog
post](https://www.noahbrenowitz.com/post/calling-fortran-from-python/).

## Installation

This library has the following dependencies
1. pfUnit (v3.2.9) for the unit tests
1. python (3+) with numpy and cffi, with libpython built as a shared library.
1. cmake (>=3.4+)

This development environment can be setup with the nix package manager. To
enter a developer environment with all these dependencies installed run:

    nix-shell

Once the dependencies are installed, you can compile this library using

    mkdir build
    cd build 
    cmake ..
    make

Run the tests:

    make test

Install on your system

    make install

This will usually install the `libcallpy` library to `/usr/local/lib` and the
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
```
program example
use callpy_mod
implicit none

real(8) :: a(10)
a = 1.0
call set_state("a", a)
call call_function("builtins", "print")
! read any changes from "a" back into a.
call get_state("a", a)

end program example
```

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

    gfortran -I/usr/local/include -Wl,-rpath=/usr/local/lib -L/usr/local/lib main.f90 -lcallpy
    
Here's what happens when you run the compiled binary:
```
$ ./a.out 
{'a': array([1., 1., 1., 1., 1., 1., 1., 1., 1., 1.])}
```


By modifying, the arguments of `call_function` you can call any python
function in the pythonpath.

Currently, `get_state` and `set_state` support 4 byte or 8 byte floating
point of one, two, or three dimensions.

## Examples

See these [examples](/examples). Most examples pair one fortran driver file
(e.g. `hello_world.f90`) with a python module that it calls (e.g. `hello_world.py`).

They can be built from the project root like this:

```
cmake -B build .
make -C build
# need to add the example python modules to the import path
export PYTHONPATH=$(pwd)/examples:$PYTHONPATH
# run the example
./build/examples/hello_world
```

See the [unit tests](/test/test_call_py_fort.pfunit) for more examples.

## Troubleshooting

Embedded python does not initialize certain variables in the `sys` module the
same as running a python script via the `python` command line. This leads to
some common errors when using `call_py_fort`.

### Module not found errors

Example of error:
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'your_module'
```

Solution: When run in embedded mode, python does not include the current working
directory in `sys.path`. You can fix this in a few ways
#. add the current directory to the PYTHONPATH environment variable `export PYTHONPATH=$(pwd)`
#. If you have packaged it you can install it in editable mode `pip install
-e`.

### `sys.argv` is None

Some evil libraries like tensorflow actually look at your command line
arguments when they are imported. Unfortunately, `sys.argv` is not initialized
when python is run in embedded mode so this will lead to errors when importing
such packages. Fix this by setting `sys.argv` before importing such packages
e.g.
```
import sys
sys.argv = []
import tensorflow
```

