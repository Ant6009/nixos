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
  flake.darwinConfigurations.MACMNPV9WL3V7-dendritic = inputs.darwin.lib.darwinSystem {
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
    ];
  };
}
