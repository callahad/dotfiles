{ pkgs, ... }:

{
  # General Services
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.pcscd.enable = true;
  sound.enable = true;

  # Printing / Scanning
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

  # Bluetooth Audio (including AptX and other codecs)
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Logitech Wireless Mouse
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Keyboard (Caps Lock is Control)
  console.useXkbConfig = true;
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Disable DNS extensions (DNSSEC, etc.)
  # When enabled, DNS resolution breaks on some networks
  networking.resolvconf.dnsExtensionMechanism = false;

  # Firewall
  networking.firewall.enable = false;
}
