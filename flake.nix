{
  description = "An empty nix devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            self.packages.${system}.wozilla
            wofi
            nushell
            nushellPlugins.formats
          ];
        };

        packages.wozilla = pkgs.stdenv.mkDerivation {
          name = "wozilla";
          src = ./src/wofi;
          buildInputs = with pkgs; [
            wofi
            nushell
            nushellPlugins.formats
          ];
          installPhase = ''
            mkdir -p $out/bin
            cp ./wozilla.nu $out/bin/wozilla
            chmod +x $out/bin/wozilla
          '';
        };
      }
    );
}
