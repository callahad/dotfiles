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
  services.printing.drivers = [ pkgs.brgenml1cupswrapper ];
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

  # Bluetooth Audio (including AptX and other codecs)
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Keyboard (Caps Lock is Control)
  console.useXkbConfig = true;
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Disable DNS extensions (DNSSEC, etc.)
  # When enabled, DNS resolution breaks on some networks
  networking.resolvconf.dnsExtensionMechanism = false;

  # Firewall
  networking.firewall.enable = true;

  networking.firewall.allowedTCPPorts = [
    8010  # VLC -> Chromecast streaming
    #3400 3401 3500  # Noson (SONOS Controller)
  ];

  networking.firewall.allowedTCPPortRanges = [
    { from = 1400; to = 1410; }  # Noson (SONOS Controller)
  ];

  networking.firewall.allowedUDPPorts = [
    #1900 1901  # Noson (SONOS Controller)
  ];

  networking.firewall.allowedUDPPortRanges = [
    { from = 32768; to = 60999; }  # Ephemeral ports (also needed by Noson)
  ];

  # MDN Development
  networking.hosts = {
    "127.0.0.1" = ["mdn.localhost" "beta.mdn.localhost" "wiki.mdn.localhost"];
    "::1" = ["mdn.localhost" "beta.mdn.localhost" "wiki.mdn.localhost"];
  };
}
