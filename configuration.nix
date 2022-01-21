# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, hostname, wlan, grub, xkbopt, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ibus.nix
    ];

  nix.package = pkgs.nix_2_4;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.grub = grub;
  networking.hostName = hostname;
  networking.wireless = {
    enable = true; # Enables wpa_supplicant.
    interfaces = [wlan]; # https://github.com/NixOS/nixpkgs/issues/101963
  };
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
  
  # powerManagement.cpuFreqGovernor = "schedutil";
  services.tlp = {
    enable = true;
    settings = {
      USB_WHITELIST = lib.concatStringsSep " " [ # enable autosuspend
        "046d:c52b" # my Logitech Unifying for T620
      ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.browserpass.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.openssh.enable = true; # enable OpenSSH daemon

  # services.printing.enable = true; # enable CUPS

  virtualisation.docker.enable = true;

  #  virtualisation.virtualbox.host = {
  #    enable = true;
  #    enableExtensionPack = true;
  #  };

  virtualisation.libvirtd = {
    enable = true;
  };

  services.lorri.enable = true;

  services.gpm.enable = true;

  hardware.acpilight.enable = true;

  services.acpid.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "pl";
    xkbOptions = lib.concatStringsSep "," xkbopt;
    libinput.enable = true;

    displayManager.lightdm.enable = true;

    desktopManager = {
      plasma5.enable = false;
      # lxqt.enable = true;
      enlightenment.enable = true;
      cde.enable = true;
      xfce.enable = true;

      gnome.enable = true;
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

  # ##### for honey:
  # 
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  # hardware.nvidia.prime = {
  #   sync.enable = true;
  #   nvidiaBusId = "PCI:1:0:0";
  #   intelBusId = "PCI:0:2:0";
  # };
  #
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  #
  # boot = {
  #   extraModprobeConfig = "options nvidia-drm modeset=1";
  #
  #   initrd.kernelModules = [
  #     "nvidia"
  #     "nvidia_modeset"
  #     "nvidia_uvm"
  #     "nvidia_drm"
  #   ];
  # };
}
