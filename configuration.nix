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
  boot.loader.grub.device = "/dev/disk/by-id/ata-TOSHIBA_MK8009GAH_3799WGE8W";

  networking.hostName = "szumik"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = false;

  i18n = {
    defaultLocale = "pl_PL.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji typing-booster ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp16s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    git
    mosh
    tmux
    mc
    openssh
    vbetool
  ];

  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  users.users.mf = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
  };

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

  system.stateVersion = "20.09"; # Did you read the comment?

}

