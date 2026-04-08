{
  self,
  inputs,
  ...
}: let
  inherit (self) outputs;

  userConfig = {
    name = "antoine";
    email = "ant.rivoire@gmail.com";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "E4B6639BFD0391F3";
  };
in {
  flake.nixosConfigurations.rocinante = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs outputs userConfig;
      hostname = "rocinante";
      nixosModules = "${self}/modules/nixos";
    };
    modules =
      (builtins.attrValues self.nixosModules)
      ++ [
        inputs.hardware.nixosModules.common-cpu-amd
        inputs.hardware.nixosModules.common-gpu-amd
        inputs.hardware.nixosModules.common-pc-ssd
        ../../hosts/rocinante/hardware-configuration.nix
        "${self}/modules/nixos/desktop/hyprland"
        {
          networking.hostName = "rocinante";
          system.stateVersion = "24.11";
        }
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
              inherit inputs outputs userConfig;
              nhModules = "${self}/modules/home-manager";
            };
            sharedModules = [
              inputs.nvf.homeManagerModules.default
              inputs.catppuccin.homeModules.catppuccin
            ];
            users.antoine = let
              hm = "${self}/modules/home-manager";
            in {
              imports =
                (builtins.attrValues self.homeModules)
                ++ [
                  "${hm}/desktop/hyprland"
                  "${hm}/programs/zoom"
                  "${hm}/services/easyeffects"
                  "${hm}/services/ulauncher"
                  "${hm}/services/hyprpaper"
                  "${hm}/services/hyprlock"
                  "${hm}/misc/wallpaper"
                ];
              programs.home-manager.enable = true;
              systemd.user.startServices = "sd-switch";
              home.stateVersion = "24.11";
            };
          };
        }
      ];
  };
}
