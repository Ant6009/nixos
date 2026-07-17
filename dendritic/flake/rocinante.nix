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
        "${self}/modules/nixos/services/tftpd"
        {
          networking.hostName = "rocinante";
          system.stateVersion = "24.11";
        }
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.claude-code.overlays.default
            inputs.audio.overlays.default
            inputs.llm-agents.overlays.shared-nixpkgs
            # virtualenv-clone 0.5.7's test_clone_contents fails under
            # python 3.14 (finds the source venv path in the cloned
            # pyvenv.cfg). Disable the check just for pipenv's copy so
            # the global python set is untouched.
            (final: prev: {
              pipenv = prev.pipenv.override {
                python3 = prev.python3.override {
                  packageOverrides = _pf: pp: {
                    virtualenv-clone =
                      pp.virtualenv-clone.overridePythonAttrs (_: {doCheck = false;});
                  };
                };
              };
            })
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
