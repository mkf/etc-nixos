# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  bash5 = pkgs.bashInteractive_5;
  bash5path = "${bash5}${bash5.shellPath}";
in
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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    wget tint2
    (vim_configurable.override { python = python3; })
    kakoune kak-lsp
    rxvt_unicode
    elinks links
    dillo
#    (netsurf.browser.override { uilib = "gtk3"; })
    midori
    firefox
    bash zsh
    git git-hub
    pass-otp passff-host
    qtpass
    gpm
    acpi
    tree
    ddrescue
#    ly
    htop iotop xclip
    fluxbox
    xorg.xinit
    udiskie
    gwenview
    terminus_font terminus_font_ttf
    xfontsel
    ibus ibus-engines.table ibus-engines.uniemoji ibus-qt
    gnupg
    rofi
    x2goclient
    openssh lsh
    strongswan
    powershell
    xlockmore xss-lock
    acpilight
    tdesktop
    bashInteractive_5
    mosh
    aerc
    scrot
    android-file-transfer
    pcmanfm
    zathura
    mplayer
    vlc
    youtube-dl
#    libreoffice
    emacs
    pv
    gimp
    neofetch
    leafpad
    tigervnc
    pavucontrol
    pandoc
    zip unzip
    xarchiver
    brave
    stalonetray
    pulseaudio-ctl
    feedreader
    jetbrains.idea-ultimate
    teams
    spice
    win-spice
    win-qemu
    aqemu
#    texlive.combined.scheme-small
#    rubber
#    texworks
    direnv
    unar
    zim
    graphviz python38Packages.xdot
#    texlive.combined.scheme-medium
    bc
    alpine
    chromium
    gparted hdparm
    guvcview
    hugo
    imagemagick
    jq
    inetutils
    lm_sensors
    mc
    minetest
    openarena
    mosh
    powertop
    thunderbird
    tmux
    xorg.xev
  ];

  environment.shells = [ bash5path ];

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

  services.xserver.desktopManager.gnome3.enable = true;

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
    shell = bash5path;
  };

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  system.stateVersion = "20.09"; # Did you read the comment?
}
