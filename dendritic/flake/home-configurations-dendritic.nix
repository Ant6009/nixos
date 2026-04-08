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

  antoine = {
    name = "antoine";
    email = "ant.rivoire@gmail.com";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "E4B6639BFD0391F3";
  };

  a-rivoire = {
    name = "a.rivoire";
    email = "a.rivoire@ulster.ac.uk";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "41647D6B470660D4";
  };

  hm = "${self}/modules/home-manager";
in {
  flake.homeConfigurations = {
    "antoine-dendritic" = mkUserHome {
      system = "x86_64-linux";
      userConfig = antoine;
      extraModules = [
        "${hm}/desktop/hyprland"
        "${hm}/programs/zoom"
        "${hm}/services/easyeffects"
        "${hm}/services/ulauncher"
        "${hm}/services/hyprpaper"
        "${hm}/services/hyprlock"
        "${hm}/misc/wallpaper"
      ];
    };

    "a.rivoire-dendritic" = mkUserHome {
      system = "aarch64-darwin";
      userConfig = a-rivoire;
    };
  };
}
