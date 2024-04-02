{ libs, pkgs, ... }:

{
  networking.hostName = "impact";
  system.stateVersion = "24.05";

  imports = [
    ../modules/users.nix
    ../modules/common.nix
    ../modules/desktop.nix
    ../modules/desktop-plasma.nix
  ];

  # Disks
  boot.supportedFilesystems = [ "bcachefs" ];
  # Note: No need for fstrim on bcachefs as "we discard buckets as soon as they become empty"
  # https://lore.kernel.org/linux-bcachefs/20231119231001.tb3teva5j4azqp7i@moria.home.lan/T/
  boot.tmp.useTmpfs = true;

  fileSystems."/" = {
    device = "UUID=95f9b11b-d899-4624-930c-64777e02d222";
    fsType = "bcachefs";
    options = [ "noatime" "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F0C7-3391";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/60ce858a-d0b5-4680-926a-5d37d6eb4886"; }
  ];
}
