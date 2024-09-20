{ lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Note: Hibernation seems unreliable with 6.11.0
  # boot.kernelParams = [ "hibernate.compressor=lz4" ]; # Note: Also add "lz4" to initrd.kernelModules
  # boot.initrd.kernelModules = [ "amdgpu" ]; # No clear advantage to loading early
  boot.initrd.availableKernelModules = [ "nvme" "sd_mod" "thunderbolt" "usb_storage" "usbhid" "xhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];

  # Firmware / Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Hardware
  hardware.bluetooth.enable = true;
  services.fprintd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hardware.bolt.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa = { enable = true; support32Bit = true; };
  services.pipewire.pulse.enable = true;

  # Software
  environment.systemPackages = with pkgs; [
    framework-tool
    nvtopPackages.amd
  ];

  # Flag keyboard as internal so "disable touchpad when typing" works
  # Included in libinput after 1.25.0
  environment.etc."libinput/local-overrides.quirks" =
    lib.mkIf (lib.versionOlder pkgs.libinput.version "1.26")
    { text = ''
        [Framework Laptop 16 Keyboard Module]
        MatchName=Framework Laptop 16 Keyboard Module*
        MatchUdevType=keyboard
        MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
        AttrKeyboardIntegration=internal
      '';
    };
}
