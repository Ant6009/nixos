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

    kickstartnix-nvim = {
      url = "github:Ant6009/kickstartnix-nvim";
    };

    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

#    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kickstartnix-nvim,
    sddm-sugar-candy-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      system = system;
      overlays = [ 
      <kickstartnix-nvim>.overlays.default 
      sddm-sugar-candy-nix.overlays.default
      ];

    };
  in {
    nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        sddm-sugar-candy-nix.nixosModules.default
#     inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
