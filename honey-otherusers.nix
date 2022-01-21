{config, pkgs, ... }: {
  users.users.kat = {
    isNormalUser = true;
    uid = 1137;
    extraGroups = [
      "video"
      "audio"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.fish;
  };

  users.users.riir = {
    isNormalUser = true;
    uid = 1138;
    extraGroups = [
      "video"
      "audio"
      "networkmanager"
      "docker"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
