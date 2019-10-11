{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.cwm;
in
{
  options = {
    services.xserver.windowManager.cwm.enable = mkEnableOption "cwm";
  };
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton
      { name = "cwm";
        start =
          ''
            cwm &
            waitPID=$!
          '';
      };
    environment.systemPackages = [
      (import (builtins.fetchTarball {
        url = https://github.com/NixOS/nixpkgs/archive/f251c29484e6a6a3e493b72b7179bddfb8a2a618.tar.gz;
        sha256 = "079p4s12djjcx5c0is9b76r64xibm1hl4c175lhxhmpssg1ym43n";
        }) {} ).cwm
    ];
  };
}
