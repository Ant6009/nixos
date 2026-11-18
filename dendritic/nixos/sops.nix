# Roci-only secret provisioning via sops + age.
#
# Auto-imported into the rocinante system by `attrValues self.nixosModules`
# (see dendritic/flake/rocinante.nix). The darwin/Mac config never imports
# nixosModules, so this stays Roci-only.
#
# Secrets are committed as ciphertext (secrets/*.age) and decrypted to the
# Nix store at build time using an age key that only exists on Roci.
{ inputs, ... }: {
  flake.nixosModules.sops = { config, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      # The age identity (private key) lives on Roci only, in the standard
      # sops/age location. It is never committed to git. If it is lost, the
      # committed .age secrets can no longer be decrypted — keep a backup.
      age = {
        keyFile = "/home/antoine/.config/sops/age/keys.txt";
      };

      # Pre-encrypted secret (committed as ciphertext). `key = ""` emits the
      # whole JSON document instead of extracting a single top-level key.
      # Consumed by the SMB automount as
      # config.sops.secrets."smb.json".path  ->  /run/secrets/smb.json
      secrets."smb.json" = {
        format = "json";
        key = "";
        sopsFile = ../../secrets/smb.json.age;
      };

      # OPNsense API credentials for the `pi-mcp` user, as {"key":..,"secret":..}.
      # Read by pi running as the invoking user, so this one cannot stay
      # at the sops-nix default of root:root 0400.
      secrets."opnsense-apikey" = {
        format = "json";
        key = "";
        sopsFile = ../../secrets/opnsense-apikey.age;
        owner = config.users.users.antoine.name;
        group = config.users.users.antoine.group;
        mode = "0400";
      };
    };
  };
}
