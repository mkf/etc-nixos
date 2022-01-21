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
}
