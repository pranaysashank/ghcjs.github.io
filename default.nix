{ compiler ? "ghcjs" }:

let 
  config = {
    packageOverrides = pkgs: rec {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          "${compiler}" = pkgs.haskell.packages."${compiler}".override {
            overrides = haskellPackagesNew: haskellPackagesOld: rec {

              heaps =
                haskellPackagesNew.callPackage ./heaps.nix { };

              abstract-deque-tests =
                haskellPackagesNew.callPackage ./abstract-deque-tests.nix { };

              streamly =
                haskellPackagesNew.callPackage ./streamly.nix { };

              ghcjs-dom =
                haskellPackagesNew.callHackage "ghcjs-dom" "0.9.2.0" { };

              ghcjs-demo =
                haskellPackagesNew.callPackage ./ghcjs-demo.nix { };
            };
          };
        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; };

in
  { ghcjs-demo = pkgs.haskell.packages.${compiler}.ghcjs-demo;
  }
