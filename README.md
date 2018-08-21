# call_py_fort

[![Documentation Status](https://readthedocs.org/projects/call_py_fort/badge/?version=latest)](https://readthedocs.org/projects/call_py_fort/?badge=latest)
[![Build Status](https://travis-ci.org/nbren12/call_py_fort.svg?branch=master)](https://travis-ci.org/nbren12/call_py_fort)
[![codecov.io](http://codecov.io/github/nbren12/call_py_fort/coverage.svg?branch=master)](http://codecov.io/github/nbren12/call_py_fort?branch=master)

Call fortran from python

Build Instructions:
-------------------

Requires:
 * Fortran compiler
 * MPI library
 * pFUnit

To build & test:

    mkdir build && pushd build
    cmake ..
    make
    ctest

A Vagrantfile is provided to create a VM with the required dependencies:

    vagrant up
    vagrant ssh
    make
    ctest
