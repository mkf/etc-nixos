# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./ibus.nix
    ./additional-filesystems.nix
  ];
  boot.loader.grub = import ./grub.nix;
  networking.hostName = import ./hostname.nix;

  networking.wireless.enable = true; # Enables wpa_supplicant.
  networking.networkmanager.enable = false;

  i18n.defaultLocale = "pl_PL.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = import ./envsyspackages.nix pkgs;

  nixpkgs.config.allowUnfree = true;

  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true; # enable OpenSSH daemon

  services.printing.enable = true; # enable CUPS

  virtualisation.docker.enable = true;

  #  virtualisation.virtualbox.host = {
  #    enable = true;
  #    enableExtensionPack = true;
  #  };

  virtualisation.libvirtd = { enable = true; };

  services.lorri.enable = true;

  services.gpm.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
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

  services.xserver = {
    enable = true;

    layout = "pl,pl";
    xkbVariant = "qwertz,dvorak";
    xkbOptions = "caps:ctrl_modifier,grp:sclk_toggle,compose:menu";
    # consider: eurosign:e , caps:super

    libinput.enable = true; # Enable touchpad support.

    displayManager = {
      lightdm.enable = true; # consider: sddm
      sessionCommands = ''
        xset m 3/2 16 &
      '';
    };

    desktopManager.plasma5.enable = false;
    windowManager = {
      cwm.enable = true;
      fluxbox.enable = true;
      awesome.enable = true;
    };
  };

  systemd.user.services.pasystray = {
    enable = true;
    wantedBy = [ "multi-user.target" "graphical-session.target" ];
    description = "pasystray";
    script = "${pkgs.pasystray}/bin/pasystray";
  };

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

  system.stateVersion = "19.03"; # Did you read the comment?
}
