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
  flake.nixosConfigurations.rocinante-dendritic = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs outputs userConfig;
      hostname = "rocinante";
      nixosModules = "${self}/modules/nixos";
    };
    modules = [
      ../../hosts/rocinante
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
          users.antoine = import ../../home/antoine/rocinante;
        };
      }
    ];
  };
}
