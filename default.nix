{ lib, pfunit, stdenv, gfortran, cmakeCurses, cmake, pythonPackages
, llvmPackages }:
let appleSilicon = (stdenv.isAarch64 && stdenv.isDarwin);
in stdenv.mkDerivation {
  name = "call_py_fort";
  src = ./.;

  nativeBuildInputs = (lib.optional stdenv.isDarwin llvmPackages.openmp
    ++ lib.optional (!appleSilicon) pfunit);
  buildInputs = [
    gfortran
    gfortran.cc.lib
    cmake
    cmakeCurses
    gfortran.cc
    pythonPackages.python
  ];
  propagatedBuildInputs = [ pythonPackages.cffi pythonPackages.numpy ];
  doCheck = true;

  preCheck = ''
    export PYTHONPATH=$(pwd)/../test:$PYTHONPATH
    # for mac
    export DYLD_LIBRARY_PATH=$(pwd)/src
    # for linux
    export LD_LIBRARY_PATH=$(pwd)/src
  '';
  shellHook = ''
    export PYTHONPATH=$(pwd)/test:$PYTHONPATH
    export PYTHONPATH=$(pwd)/examples:$PYTHONPATH
    # for mac
    export DYLD_LIBRARY_PATH=$(pwd)/src
    # for linux
    export LD_LIBRARY_PATH=$(pwd)/src

    # to help find the right python
    export Python_ROOT_DIR=${pythonPackages.python}
  '';
  # inherit pfunit;
  hardeningDisable = lib.optionals (appleSilicon) [ "stackprotector" ];
}
