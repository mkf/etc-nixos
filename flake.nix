{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      # Overlays-module makes "pkgs.unstable" available in configuration.nix
      overlay-unstable-module = { config, pkgs, ... }: {
        nixpkgs.overlays = [ overlay-unstable ];
      };
    in {
      nixosConfigurations.sturnix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "sturnix";
          wlan = "wlp3s0";
          rootfs = {
            device = "/dev/disk/by-uuid/211a9f82-43c9-49dc-b20b-16351cead07e";
            fsType = "ext4";
          };
          swap = [ {
            device = "/dev/disk/by-uuid/95c244ac-5d2b-4065-b04f-42cc85b8f0ad";
          } ];
          grub = {
            enable = true;
            version = 2;
            device =
              "/dev/disk/by-id/ata-LITEON_LMH-128V2M-11_MSATA_128GB_TW0G50CY550855BLB2Q1";
            useOSProber = true;
}
          xkbopt = [
            "compose:menu"
            "caps:ctrl_modifier"
            "grp:sclk_toggle"
            # "eurosign:e"
            # "caps:super"
          ];
        };
        modules = [
          (overlay-unstable-module)
          ./configuration.nix
          ./additional-filesystems.nix
          ({config, pkgs, ... }: {
            services.xserver.displayManager.sessionCommands = ''
              xset m 3/2 16 &
            '';
            system.stateVersion = "19.03"; # Did you read the comment?
          })
        ];
      };
      nixosConfigurations.honey = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "honey";
          wlan = "wlp2s0";
          rootfs = {
            device = "/dev/disk/by-uuid/0bc88cdc-ca39-42cb-b2a0-c5699465d146";
            fsType = "ext4";
          };
          swap = [ {
            device = "/dev/disk/by-uuid/84ef289c-42b9-4609-a3a7-4afbd583d801";
          } ];
          grub = {
            enable = true;
            version = 2;
            devices = [
              "/dev/disk/by-id/ata-120GB_SSD_1605250040004"
              "/dev/disk/by-id/ata-Samsung_SSD_840_PRO_Series_S12RNEAD205690L"
            ];
}
          xkbopt = [
            "compose:prsc"
            "compose:lwin_altgr"
            "ctrl:nocaps"
            "capslock:ctrl_modifier"
            "grp:sclk_toggle"
            "grp:ctrl_shift_toggle"
            # "eurosign:e"
          ];
        };
        modules = [
          (overlay-unstable-module)
          ./configuration.nix
          ./honey-dhcp.nix
          ./honey-otherusers.nix
          ({config, pkgs, ... }: {
            services.xserver.dpi = 128;
            system.stateVersion = "20.09"; # Did you read the comment?
          })
        ];
      };
    };
}
