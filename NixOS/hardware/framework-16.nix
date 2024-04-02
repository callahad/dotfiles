{ lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "amdgpu.sg_display=0" ]; # Try if extrnal display flickers
  boot.initrd.availableKernelModules = [ "nvme" "sd_mod" "thunderbolt" "usb_storage" "usbhid" "xhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];

  # Firmware / Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Hardware
  services.fprintd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hardware.bolt.enable = true;

  sound.enable = true;
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
}