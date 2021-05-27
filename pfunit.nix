{ stdenv, m4, fetchFromGitHub, gfortran, cmake, python3 }:
stdenv.mkDerivation {
  name = "pFUnit";
  src = fetchFromGitHub {
    owner = "Goddard-Fortran-Ecosystem";
    repo = "pFUnit";
    rev = "v4.2.1";
    fetchSubmodules = true;
    sha256 = "sha256-yjuJHvJ83PAQBDDk7TD4b6VWGoKbiexdjBCTLsNIIxI=";

  };
  buildInputs = [ python3 gfortran cmake gfortran.cc m4 ];

}
