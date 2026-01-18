{
  description = "An empty nix devshell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:lassulus/wrappers";
  };

  outputs = inputs @ {
    flake-parts,
    wrappers,
    ...
  }:
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
        packages.wofizilla = let
          package = pkgs.stdenv.mkDerivation rec {
            name = "wofizilla";
            src = ./src;
            installPhase = ''
              mkdir -p $out/bin
              cp ./wofizilla.nu $out/bin/${name}
              chmod +x $out/bin/${name}
            '';
            meta.mainProgram = "wofizilla";
          };
        in
          wrappers.lib.wrapPackage {
            inherit pkgs package;
            runtimeInputs = with pkgs; [
              wofi
              nushell
              nushellPlugins.formats
            ];
          };
      };
    };
}
