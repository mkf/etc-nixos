# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ibus.nix
    ];

  boot.loader.grub = import ./grub.nix;
  networking.hostName = import ./hostname.nix;
  networking.wireless = {
    enable = true;
    interfaces = ["wlp2s0"]; # https://github.com/NixOS/nixpkgs/issues/101963
  };  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = false;

  i18n.defaultLocale = "pl_PL.UTF-8";

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

  environment.systemPackages = import ./envsyspackages.nix pkgs;

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

  programs.browserpass.enable = true;

  services.gnome.gnome-keyring.enable = true;

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

  services.acpid.enable = true;

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
  services.xserver = {
    enable = true;
    layout = "pl,pl";
    xkbVariant = "qwertz,";
    xkbOptions = lib.concatStringsSep "," [
      "compose:prsc"
      "compose:lwin_altgr"
      "ctrl:nocaps"
      "capslock:ctrl_modifier"
      "grp:sclk_toggle"
      "grp:ctrl_shift_toggle"
      # "eurosign:e"
    ];
    libinput.enable = true;

    displayManager.sddm.enable = true; # Enable the KDE Desktop Environment.
    displayManager.lightdm.enable = true;

    desktopManager = {
      plasma5.enable = false;
      # lxqt.enable = true;
      cde.enable = true;
      xfce.enable = true;

      gnome3.enable = true;
    };

    windowManager = {
      cwm.enable = true;
      fvwm.enable = true;
      fluxbox.enable = true;
      awesome.enable = true;
    };
  };

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
