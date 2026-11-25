{ self, inputs, ... }:
let
  inherit (self) outputs;
  hm = "${self}/modules/home-manager";

  commonOverlays = [
    inputs.mcp-nixos.overlays.default
    inputs.audio.overlays.default
    inputs.llm-agents.overlays.shared-nixpkgs
    # virtualenv-clone 0.5.7's test_clone_contents fails under
    # python 3.14 (finds the source venv path in the cloned
    # pyvenv.cfg). Disable the check just for pipenv's copy so
    # the global python set is untouched.
    (_final: prev: {
      pipenv = prev.pipenv.override {
        python3 = prev.python3.override {
          packageOverrides = _pf: pp: {
            virtualenv-clone = pp.virtualenv-clone.overridePythonAttrs (_: {doCheck = false;});
          };
        };
      };
    })
  ];

  commonHomeModules = [
    "${hm}/desktop/hyprland"
    "${hm}/programs/zoom"
    "${hm}/services/easyeffects"
    "${hm}/services/ulauncher"
    "${hm}/services/hyprpaper"
    "${hm}/services/hyprlock"
    "${hm}/misc/wallpaper"
  ];
in {
  mkNixosHost = {
    hostname,
    userConfig,
    hardwareModules,
    extraNixosModules ? [],
    extraHomeModules ? [],
    palette ? "faded",
    stateVersion ? "24.11",
  }:
  inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs outputs userConfig hostname;
      nixosModules = "${self}/modules/nixos";
    };
    modules =
      (builtins.attrValues self.nixosModules)
      ++ hardwareModules
      ++ extraNixosModules
      ++ [
        "${self}/modules/nixos/desktop/hyprland"
        {
          networking.hostName = hostname;
          system.stateVersion = stateVersion;
        }
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = commonOverlays;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs outputs userConfig;
              nhModules = hm;
            };
            sharedModules = [
              inputs.nvf.homeManagerModules.default
              inputs.catppuccin.homeModules.catppuccin
            ];
            users = {
              ${userConfig.name} = {pkgs, ...}: {
                imports =
                  (builtins.attrValues self.homeModules)
                  ++ commonHomeModules
                  ++ extraHomeModules;
                rocinante.palette = palette;
                home.packages = [pkgs.llm-agents.pi];
                programs.home-manager.enable = true;
                systemd.user.startServices = "sd-switch";
                home.stateVersion = stateVersion;
              };
            };
          };
        }
      ];
  };
}
