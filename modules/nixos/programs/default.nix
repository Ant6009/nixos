{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = true;
      vim.theme.name = "catpuccin";
      vim.theme.style = "dark";

      vim.languages.nix.enable = true;
    };
  };
}
