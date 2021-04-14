let 
    nixpkgs = import <nixpkgs> { };
    pfunit = nixpkgs.callPackage ./pfunit.nix { };
in
    nixpkgs.callPackage ./default.nix { inherit pfunit; pythonPackages = nixpkgs.python3Packages; }