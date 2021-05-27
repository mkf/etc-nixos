# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/ata-Hitachi_HDT725050VLA360_VFH401R41H17EH"
    "/dev/disk/by-id/ata-WDC_WD10EZRZ-00Z5HB0_WD-WCC4M7FHH2Z4"
  ];

  boot.kernel.sysctl = {
    "net.ifnames" = 0;
    "biosdevname" = 0;
  };

  networking.hostName = "gaymer"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  i18n.defaultLocale = "pl_PL.UTF-8";
  console.keyMap = "pl";

  users.users.mf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    wget vim
    tmux git mc
  ];

  programs.mtr.enable = true;

  services.openssh.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      addresses = true;
      domain = true;
      enable = true;
      userServices = true;
      workstation = true;
      hinfo = true;
    };
    extraServiceFiles.ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
  };

  programs.mosh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

