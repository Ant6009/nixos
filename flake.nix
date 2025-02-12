{
  description = "Config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    darwin = {
      url = "github:LnL7/nix-darwin";    
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  };

  outputs = {
    self,
    nixpkgs,
    catppuccin,
    nix-homebrew,
    darwin,
    home-manager,
  #   sddm-sugar-candy-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;


  users = {
    antoine = {
      name = "antoine";
      email = "ant.rivoire@gmail.com";
      fullName = "Antoine Rivoire";
      avatar = ./files/avatar/face;
     };
    };
  
  mkNixosConfiguration = hostname: username:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${username};
        nixosModules = "${self}/modules/nixos";
      };
      modules = [./hosts/${hostname}];
    };

 # Function for nix-darwin system configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
          nhModules = "${self}/modules/home-manager";
        };
        modules = [
          ./home/${username}/${hostname}
          catppuccin.homeManagerModules.catppuccin
        ];
      };
  in {
    nixosConfigurations = {
      my-nixos = mkNixosConfiguration "my-nixos" "antoine";
    /*  antoine-mac = mkNixosConfiguration "antoine-mac" "antoine"; */
    };

    darwinConfigurations = {
      "antoine-mac" = mkDarwinConfiguration "antoine-mac" "antoine";
    };

    homeConfigurations = {
      "antoine@my-nixos" = mkHomeConfiguration "x86_64-linux" "antoine" "my-nixos";
      "antoine@antoine-mac" = mkHomeConfiguration "aarch64-darwin" "antoine" "antoine-mac";
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
