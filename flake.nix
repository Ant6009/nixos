{
  description = "Config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-colors.url = "github:misterio77/nix-colors";    

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      };

    hyprland = {
      url = "github:hyprwm/hyprland";
      };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
      };  
  };

  outputs = { self, nixpkgs, home-manager, ...}@inputs:

  let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  
  in {
  nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix
      inputs.home-manager.nixosModules.default
    ];
  };
};
} 
