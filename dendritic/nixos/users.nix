{...}: {
  flake.nixosModules.users = {
    pkgs,
    userConfig,
    ...
  }: {
    users.users.${userConfig.name} = {
      description = userConfig.fullName;
      extraGroups = ["plugdev" "networkmanager" "wheel" "camera" "dialout" "libvirtd" "storage" "audio" "jackaudio"];
      isNormalUser = true;
      shell = pkgs.zsh;
    };

    users.groups.plugdev = {};

    system.activationScripts.script.text = ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp ${userConfig.avatar} /var/lib/AccountsService/icons/${userConfig.name}

      touch /var/lib/AccountsService/users/${userConfig.name}

      if ! grep -q "^Icon=" /var/lib/AccountsService/users/${userConfig.name}; then
        if ! grep -q "^\[User\]" /var/lib/AccountsService/users/${userConfig.name}; then
          echo "[User]" >> /var/lib/AccountsService/users/${userConfig.name}
        fi
        echo "Icon=/var/lib/AccountsService/icons/${userConfig.name}" >> /var/lib/AccountsService/users/${userConfig.name}
      fi
    '';

    security.sudo.wheelNeedsPassword = false;
  };
}
