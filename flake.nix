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
            self.packages.${system}.wofizilla
            wofi
            nushell
            nushellPlugins.formats
          ];
        };

        packages.wofizilla = pkgs.stdenv.mkDerivation rec {
          name = "wofizilla";
          src = ./src;
          buildInputs = with pkgs; [
            wofi
            nushell
            nushellPlugins.formats
          ];
          installPhase = ''
            mkdir -p $out/bin
            cp ./wofizilla.nu $out/bin/${name}
            chmod +x $out/bin/${name}
          '';
        };
      }
    );
}
