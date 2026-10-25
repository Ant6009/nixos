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
            inputs.mcp-nixos.overlays.default
            #inputs.claude-code.overlays.default
            inputs.audio.overlays.default
            inputs.llm-agents.overlays.shared-nixpkgs
            # tuigreety: active tuigreet-compatible greeter fork, not in
            # nixpkgs yet. Pure-Rust build, no native deps. Binary is
            # still named `tuigreet` for greetd config compatibility.
            # Pinned to release 0.11.1 (tag rev 0a36f9af).
            (final: _prev: {
              tuigreety = final.rustPlatform.buildRustPackage {
                pname = "tuigreety";
                version = "0.11.1";
                src = final.fetchFromGitHub {
                  owner = "Tobiichi-Origuchi";
                  repo = "tuigreety";
                  rev = "0a36f9af38989cc52a13163317e4dcf3a0994c66";
                  hash = "sha256-4UT5quFIWr8eFLx7Blpla05A23ViacHpuqSLvl5HhEg=";
                };
                cargoHash = "sha256-ZFDfpGd2Z800l189wTfunATSEPght7fhej1pgJv6NXA=";
                # 5 timing-sensitive power-supervisor unit tests fail inside
                # the Nix build sandbox (318/323 pass); crate compiles clean.
                doCheck = false;
                __structuredAttrs = true;
                meta = with final.lib; {
                  description = "Minimal, configurable console greeter for greetd (tuigreet-compatible fork)";
                  homepage = "https://github.com/Tobiichi-Origuchi/tuigreety";
                  license = licenses.gpl3Only;
                  platforms = platforms.linux;
                  mainProgram = "tuigreet";
                };
              };
            })
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
            in
              {pkgs, ...}: {
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
                home.packages = [pkgs.llm-agents.pi];
                programs.home-manager.enable = true;
                systemd.user.startServices = "sd-switch";
                home.stateVersion = "24.11";
              };
          };
        }
      ];
  };
}
