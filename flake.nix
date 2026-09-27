{
  description = "yonux-shell: Quickshell desktop shell + Hyprland config";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosModules.default = import ./nix/yonux.nix;
      devShells.${system}.default = import ./nix/devshell.nix { inherit pkgs; };
    };
}
