{ pkgs, ... }:

{
  # General Services
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.pcscd.enable = true;
  sound.enable = true;

  # PipeWire Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing / Scanning
  nixpkgs.config.allowUnfree = true; # For hardware.sane.dsseries
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

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
