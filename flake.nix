{
  description = "An empty nix devshell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            packages.wofizilla
            wofi
            nushell
            nushellPlugins.formats
          ];
        };

        packages.default = packages.wofizilla;
        packages.wofizilla = pkgs.stdenv.mkDerivation rec {
          name = "wofizilla";
          src = ./src;
          buildInputs = with pkgs; [
            makeWrapper
            wofi
            nushell
            nushellPlugins.formats
          ];
          installPhase = ''
            mkdir -p $out/bin
            cp ./wofizilla.nu $out/bin/${name}
            chmod +x $out/bin/${name}
            wrapProgram $out/bin/${name} \
              --prefix PATH : ${pkgs.lib.makeBinPath [
              pkgs.wofi
              pkgs.nushell
              pkgs.nushellPlugins.formats
            ]}
          '';
        };
      };
    };
}
