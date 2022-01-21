{ ... }:

{
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
