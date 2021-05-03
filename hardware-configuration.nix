# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ata_piix" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4971ccda-d9e6-43fb-849e-c06285f68437";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b2b95464-38e7-480a-9cfe-9cd7593ed120"; }
    ];

  networking.enableIntel3945ABGFirmware = true;
}
