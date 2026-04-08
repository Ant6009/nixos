{
  self,
  inputs,
  ...
}: let
  inherit (self) outputs;

  users = {
    antoine = {
      name = "antoine";
      email = "ant.rivoire@gmail.com";
      fullName = "Antoine Rivoire";
      avatar = ../../files/avatar/face;
      gitKey = "E4B6639BFD0391F3";
    };
    "a.rivoire" = {
      name = "a.rivoire";
      email = "a.rivoire@ulster.ac.uk";
      fullName = "Antoine Rivoire";
      avatar = ../../files/avatar/face;
      gitKey = "41647D6B470660D4";
    };
  };

  nixosModulesPath = "${self}/modules/nixos";
  nhModulesPath = "${self}/modules/home-manager";

  mkNixosConfiguration = hostname: username:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${username};
        nixosModules = nixosModulesPath;
      };
      modules = [
        ../../hosts/${hostname}
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.claude-code.overlays.default
            inputs.audio.overlays.default
          ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs outputs;
              userConfig = users.${username};
              nhModules = nhModulesPath;
            };
            sharedModules = [
              inputs.nvf.homeManagerModules.default
              inputs.catppuccin.homeModules.catppuccin
            ];
            users.${username} = import ../../home/${username}/${hostname};
          };
        }
      ];
    };

  mkDarwinConfiguration = hostname: username:
    inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # Do NOT thread `inputs` or `outputs` through specialArgs here:
      # darwin's module system strictly evaluates specialArgs, and
      # flake-parts puts `self` inside `inputs`, which causes infinite
      # recursion via inputs.self.darwinConfigurations.
      specialArgs = {
        inherit hostname;
        userConfig = users.${username};
      };
      modules = [
        ../../hosts/${hostname}
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];
    };

  mkHomeConfiguration = system: username: hostname:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.claude-code.overlays.default
          inputs.audio.overlays.default
        ];
      };
      extraSpecialArgs = {
        inherit inputs outputs;
        userConfig = users.${username};
        nhModules = nhModulesPath;
      };
      modules = [
        {nixpkgs.config.allowUnfree = true;}
        ../../home/${username}/${hostname}
        inputs.nvf.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
in {
  flake = {
    nixosConfigurations.rocinante = mkNixosConfiguration "rocinante" "antoine";

    darwinConfigurations."MACMNPV9WL3V7" = mkDarwinConfiguration "MACMNPV9WL3V7" "a.rivoire";

    homeConfigurations = {
      "antoine" = mkHomeConfiguration "x86_64-linux" "antoine" "rocinante";
      "a.rivoire" = mkHomeConfiguration "aarch64-darwin" "a.rivoire" "MACMNPV9WL3V7";
    };

    overlays = import ../../overlays {inherit inputs;};
  };
}
