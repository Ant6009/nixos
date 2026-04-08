{...}: {
  flake.nixosModules.udev-teensy = {...}: {
    services.udev.extraRules = ''
      # Teensy boards for M8
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="16c0", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", MODE:="0666"
    '';
  };
}
