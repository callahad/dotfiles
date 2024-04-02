{ libs, pkgs, ... }:

{
  networking.hostName = "meta";
  system.stateVersion = "24.05";

  imports = [
    ../modules/users.nix
    ../modules/common.nix
    ../modules/desktop.nix
    ../modules/desktop-gnome.nix
  ];

  # Sleep
  #   https://www.kernel.org/doc/html/latest/admin-guide/pm/sleep-states.html#basic-sysfs-interfaces-for-system-suspend-and-hibernation
  #   Force hybrid-sleep on suspend:
  #     - When suspending, write RAM to disk (hibernate)
  #     - When done writing hibernation image, suspend.
  environment.etc."systemd/sleep.conf".text = pkgs.lib.mkForce ''
    [Sleep]
    SuspendState=disk
    SuspendMode=suspend
  '';

  # Self-Encrypting Drive (OPAL 2.0 SED)
  nixpkgs.config.packageOverrides = pkgs: {
    sedutil = (pkgs.sedutil.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        # Add support for enabling unlocking when resuming from sleep
        # See: https://github.com/Drive-Trust-Alliance/sedutil/pull/190
        ../sedutil-1.20.0-pr190.patch
      ];
    }));
  };

  environment.systemPackages = [ pkgs.sedutil ];

  systemd.services."sedutil-s3sleep" = {
    description = "Enable S3 sleep on OPAL self-encrypting drives";
    documentation = [ "https://github.com/Drive-Trust-Alliance/sedutil/pull/190" ];
    path = [ pkgs.sedutil ];
    # Note: Generate password hash with: sedutil-cli --printPasswordHash PASSWORD /dev/nvme0n1
    script = "sedutil-cli -n -x --prepareForS3Sleep 0 ${(import ./meta-secrets.nix).diskEncryptionHash} /dev/nvme0n1";
    wantedBy = [ "multi-user.target" ];
  };

  #

  # Disks
  services.fstrim.enable = true;
  boot.tmp.useTmpfs = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/53858a4b-8085-4d3e-966f-31dcc9176024";
    fsType = "btrfs";
    options = [ "noatime,subvol=root" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/53858a4b-8085-4d3e-966f-31dcc9176024";
    fsType = "btrfs";
    options = [ "noatime,subvol=home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A890-68BC";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/475d3b05-809c-4f62-bc4a-5a1136337fcc"; }
  ];
}
