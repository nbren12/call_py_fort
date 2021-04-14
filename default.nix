{
    lib,
    stdenv,
    gfortran,
    cmake,
    pfunit,
    pythonPackages,
    llvmPackages
} :
stdenv.mkDerivation {
    name = "call_py_fort";
    src = ./.;

    nativeBuildInputs = [ pfunit ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;
    buildInputs = [ gfortran gfortran.cc.lib cmake  gfortran.cc pfunit  pythonPackages.python ];
    propagatedBuildInputs = [ pythonPackages.cffi pythonPackages.numpy ] ;
    doCheck = true;

    preCheck = ''
        export PYTHONPATH=$(pwd)/../test:$PYTHONPATH
        # for mac
        export DYLD_LIBRARY_PATH=$(pwd)/src
        # for linux
        export LD_LIBRARY_PATH=$(pwd)/src
    '';
    inherit pfunit;

}
