{
  self,
  inputs,
  ...
}: let
  inherit (self) outputs;

  mkPkgs = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.claude-code.overlays.default
        inputs.audio.overlays.default
      ];
    };

  mkUserHome = {
    system,
    userConfig,
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        inherit inputs outputs userConfig;
        nhModules = "${self}/modules/home-manager";
      };
      modules =
        [
          {nixpkgs.config.allowUnfree = true;}
          inputs.nvf.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
          {
            programs.home-manager.enable = true;
            systemd.user.startServices = "sd-switch";
            home.stateVersion = "24.11";
          }
        ]
        ++ (builtins.attrValues self.homeModules)
        ++ extraModules;
    };

  a-rivoire = {
    name = "a.rivoire";
    email = "a.rivoire@ulster.ac.uk";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "41647D6B470660D4";
  };

in {
  # rocinante (antoine) is NOT here on purpose: home-manager is wired into
  # nixosConfigurations.rocinante as a NixOS module, so its HM generation is
  # baked into the system generation and re-activated at boot by
  # home-manager-antoine.service. A standalone homeConfigurations entry there
  # would build a second, divergent home whose activation is thrown away on the
  # next boot/switch. Activate antoine with:
  #   sudo nixos-rebuild switch --flake .#rocinante
  flake.homeConfigurations = {
    "a.rivoire" = mkUserHome {
      system = "aarch64-darwin";
      userConfig = a-rivoire;
    };
  };
}
