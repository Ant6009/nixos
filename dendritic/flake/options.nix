{lib, ...}: {
  # Declare freeform options for outputs that flake-parts doesn't know
  # about natively so that multiple modules can contribute entries.
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };
  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };
}
