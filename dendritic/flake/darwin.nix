{
  self,
  inputs,
  ...
}: let
  userConfig = {
    name = "a.rivoire";
    email = "a.rivoire@ulster.ac.uk";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "41647D6B470660D4";
  };
in {
  # Parallel dendritic entry for the darwin work machine. The legacy
  # hosts/MACMNPV9WL3V7/default.nix carries all of the darwin system
  # config (dock, finder, homebrew, keyboard remap, etc.) and is reused
  # verbatim here — home-manager is NOT wired in at the system level on
  # this host; a.rivoire uses the standalone homeConfigurations entry
  # below instead.
  flake.darwinConfigurations.MACMNPV9WL3V7 = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    # Do NOT thread `inputs` here — darwin strict-evaluates specialArgs
    # and would recurse through inputs.self.darwinConfigurations.
    specialArgs = {
      inherit userConfig;
      hostname = "MACMNPV9WL3V7";
    };
    modules = [
      ../../hosts/MACMNPV9WL3V7
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      {
        nixpkgs.overlays = [
          inputs.mcp-nixos.overlays.default
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
      }
    ];
  };
}
