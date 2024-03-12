{
  description = "Natural Language Processing";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        libDeps = with pkgs; [
            zlib
            stdenv.cc.cc.lib
            cmake
        ];
        libPath = pkgs.lib.makeLibraryPath libDeps;
      in with pkgs;
      {
        devShells.default = mkShell {
          packages = [
            python3
          ];
          buildInputs = libDeps ++ [
            gcc
            pkg-config
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libPath}"
          '';
        };
      }
    );
}
