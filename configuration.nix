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
    "/dev/disk/by-id/ata-120GB_SSD_1605250040004"
    "/dev/disk/by-id/ata-Samsung_SSD_840_PRO_Series_S12RNEAD205690L"
  ];

  networking.hostName = "honey"; # Define your hostname.
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
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

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
    spice
    win-spice
    win-qemu
    aqemu
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
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"
    "p7zip-16.02"
  ];

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

  virtualisation.docker.enable = true;

  #virtualisation.virtualbox.host = {
  #  enable = true;
  #  enableExtensionPack = true;
  #};

  virtualisation.libvirtd = {
    enable = true;
  };

  services.lorri.enable = true;

  services.gpm.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth = {
    enable = true;
    config.General.Enable = "Source,Sink,Media,Socket";
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
  services.xserver.xkbVariant = "qwertz,";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbOptions = "compose:prsc,compose:lwin_altgr,ctrl:nocaps,capslock:ctrl_modifier,grp:sclk_toggle,grp:ctrl_shift_toggle";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = false;

  # services.xserver.desktopManager.lxqt.enable = true;
  services.xserver.desktopManager.cde.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.cwm.enable = true;
  services.xserver.windowManager.fvwm.enable = true;
  services.xserver.windowManager.fluxbox.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mf = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "vboxusers"
      "libvirtd"
    ];
  };

  programs.fish.enable = true;
  
  users.users.kat = {
    isNormalUser = true;
    uid = 1137;
    extraGroups = [
      "video"
      "audio"
      "networkmanager"
    ];
    shell = pkgs.fish;
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

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "mf";
    configDir = "/home/mf/.config/syncthing";
    dataDir = "/home/mf/.local/share/syncthing";
  };

  programs.mosh.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  boot = {
    extraModprobeConfig = "options nvidia-drm modeset=1";

    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  services.xserver.dpi = 128;

  system.stateVersion = "20.09"; # Did you read the comment?
}
