{
  description = "Flake";

  inputs.haskell-nix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs, haskell-nix, ... }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [ haskell-nix.overlay
          (final: prev: {
            helloProject =
              final.haskell-nix.stackProject {
                src = ./.;
              };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskell-nix) config; };
        flake = pkgs.helloProject.flake {};
      in {
        devShells.default = pkgs.helloProject.shellFor {};
      }));
}
