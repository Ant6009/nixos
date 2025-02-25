{ config, lib, pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Downloads/and-machines-EtMQsqtfBCo-unsplash.jpg"
       ]; 
      wallpaper = [
        ",~/Downloads/and-machines-EtMQsqtfBCo-unsplash.jpg"
        ];
      };
    };
}
