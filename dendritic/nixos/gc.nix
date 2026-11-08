{ ... }:
let
  keepGenerations = 3;
in {
  flake.nixosModules.gc =
    { config, pkgs, ... }:
    {
      # boot.loader.systemd-boot.configurationLimit = 3 already writes boot
      # entries for the three newest generations only, so any older system
      # generation is unbootable and its closure is just dead weight. Prune
      # those profile links on a weekly timer, then run the store garbage
      # collector so the closure is actually reclaimed.
      #
      # nix-collect-garbage -d is deliberately NOT used: it would keep only the
      # current generation and leave no rollback target.
      systemd.services.nix-generation-prune = {
        description = "Keep ${toString keepGenerations} NixOS generations, then garbage collect the Nix store";
        # Background maintenance: let interactive builds win contention.
        serviceConfig = {
          Type = "oneshot";
          Nice = 15;
          IOWeight = 10;
        };
        path = [ pkgs.nix ];
        # find prints the links themselves; ls would follow them and list the
        # generation directories instead.
        script = ''
          set -eu

          profiles=/nix/var/nix/profiles

          find "$profiles" -maxdepth 1 -name 'system-*-link' | sort -V | head -n -${toString keepGenerations} | while read -r link; do
            rm -v "$link"
          done

          nix store gc
        '';
      };

      systemd.timers.nix-generation-prune = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "Sun *-*-* 03:30:00";
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
      };
    };
}
