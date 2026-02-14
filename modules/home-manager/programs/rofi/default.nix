{pkgs, ...}: let
  rofiTheme = pkgs.writeText "catppuccin-macchiato.rasi" ''
    * {
        font: "Roboto 14";

        bg0:     #24273aF2;
        bg1:     #1e2030;
        bg2:     #363a4fCC;
        bg3:     #494d64;
        fg0:     #cad3f5;
        fg1:     #a5adcb;
        fg2:     #6e738d;
        accent:  #c6a0f6;
        accent2: #f5a97f;
        urgent:  #ed8796;
        green:   #a6da95;

        background-color: transparent;
        text-color: @fg0;

        margin: 0;
        padding: 0;
        spacing: 0;
    }

    window {
        location: center;
        width: 680;
        border-radius: 20px;
        background-color: @bg0;
        border: 2px solid;
        border-color: @accent;
    }

    mainbox {
        padding: 28px;
        spacing: 20px;
    }

    inputbar {
        children: [prompt, entry];
        background-color: @bg1;
        border-radius: 14px;
        padding: 16px 20px;
        spacing: 14px;
        border: 1px solid;
        border-color: @bg3;
    }

    prompt {
        background-color: @accent;
        text-color: @bg1;
        padding: 8px 16px;
        border-radius: 10px;
        font: "JetBrainsMono Nerd Font Bold 12";
    }

    entry {
        placeholder: "Type to search...";
        placeholder-color: @fg2;
        cursor-color: @accent;
        vertical-align: 0.5;
    }

    listview {
        lines: 7;
        columns: 1;
        scrollbar: false;
        fixed-height: true;
        spacing: 6px;
    }

    element {
        padding: 12px 16px;
        border-radius: 12px;
        spacing: 16px;
    }

    element normal.normal,
    element alternate.normal {
        background-color: transparent;
        text-color: @fg1;
    }

    element normal.urgent,
    element alternate.urgent {
        background-color: transparent;
        text-color: @urgent;
    }

    element selected.normal {
        background-color: @bg2;
        text-color: @fg0;
        border: 1px solid;
        border-color: @accent;
    }

    element selected.urgent {
        background-color: @urgent;
        text-color: @bg0;
    }

    element-icon {
        size: 32px;
        vertical-align: 0.5;
    }

    element-text {
        vertical-align: 0.5;
        highlight: bold underline;
        text-color: inherit;
    }

    message {
        background-color: @bg1;
        border-radius: 12px;
        padding: 12px;
        border: 1px solid;
        border-color: @bg3;
    }

    textbox {
        text-color: @fg1;
    }
  '';
in {
  home.packages = [pkgs.papirus-icon-theme];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      drun-display-format = "{name}";
      icon-theme = "Papirus-Dark";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      steal-focus = true;
    };
    theme = "${rofiTheme}";
  };
}
