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
  boot.loader.grub.device =
    "/dev/disk/by-id/ata-LITEON_LMH-128V2M-11_MSATA_128GB_TW0G50CY550855BLB2Q1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "sturnix"; # Define your hostname.

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    bash
    git
    gpm
    acpi
    tree
    ddrescue
    htop iotop
    fluxbox
    xorg.xinit
    udiskie
    gnupg
    openssh lsh
    strongswan
    acpilight
    mosh
    pv
    neofetch
    tigervnc
    zip unzip
#    spice
#    win-spice
#    win-qemu
#    aqemu
    direnv
    unar
    bc
    alpine
    gparted hdparm
    jq
    inetutils
    lm_sensors
    mc
    powertop
    tmux
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  virtualisation.docker.enable = true;

  #virtualisation.virtualbox.host = {
  #  enable = true;
  #  enableExtensionPack = true;
  #};

#  virtualisation.libvirtd = {
#    enable = true;
#  };

  services.lorri.enable = true;

  services.gpm.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth = {
    enable = true;
    extraConfig = "
      [General]
      Enable=Source,Sink,Media,Socket
    ";
  };
  services.blueman.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  nixpkgs.config.pulseaudio = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "pl,pl";
  services.xserver.xkbVariant = "qwertz,dvorak";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbOptions = "capslock:ctrl_modifier,grp:sclk_toggle";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = false;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.cwm.enable = true;
  services.xserver.windowManager.fvwm.enable = true;
  services.xserver.windowManager.fluxbox.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mf = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "video"
      "audio"
      "docker"
      "vboxusers"
      "libvirtd"
    ];
  };

#  services.vsftpd = {
#    enable = true;
#    anonymousUser = true;
#    anonymousUploadEnable = true;
#    anonymousMkdirEnable = true;
#    
#  };
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  fileSystems."/chudy" = {
    fsType = "ext4";
    device = "/dev/disk/by-uuid/6cb49a46-e8f6-47fd-af3e-c1a4f043fe68";
    options = [ "noauto" "users" "rw" "noexec" "nodev" "nosuid" "async" ];
  };
  
  fileSystems."/archhome" = {
    fsType = "xfs";
    device = "/dev/disk/by-uuid/ad19d261-fa12-43d1-9e9e-c733ebb67440";
    options = [ "noauto" "users" "ro" "noexec" "nodev" "nosuid" "async" ];
  };

  fileSystems."/supl" = {
    fsType = "f2fs";
    device = "/dev/disk/by-uuid/0e20551a-075f-4485-a465-f6ff743347dc";
    options = [ "noauto" "users" "ro" "noexec" "nodev" "nosuid" "async" ];
  };

}
