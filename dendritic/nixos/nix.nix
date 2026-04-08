{inputs, ...}: {
  flake.nixosModules.nix = {
    lib,
    config,
    ...
  }: {
    nixpkgs.config.allowUnfree = true;

    nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: lib.isType "flake") inputs);

    nix.nixPath = ["/etc/nix/path"];
    environment.etc =
      lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["root" "antoine" "a.rivoire"];
      extra-substituters = ["https://claude-code.cachix.org"];
      extra-trusted-public-keys = ["claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="];
    };
  };
}
