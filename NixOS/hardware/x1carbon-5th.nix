{ lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "i915.enable_fbc=1" # Save an infinitesimal amount of power by compressing the framebuffer
    "i915.fastboot=1"   # Avoid modesets until we're in a graphical environment
  ];
  boot.initrd.availableKernelModules = [ "nvme" "rtsx_pci_sdmmc" "sd_mod" "uas" "usb_storage" "usbhid" "xhci_pci" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];

  # Firmware / Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Hardware
  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;
  #services.tlp.enable = true;
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa = { enable = true; support32Bit = true; };
  services.pipewire.pulse.enable = true;

  # Acceleration
  environment.variables = { VDPAU_DRIVER = "va_gl"; };
  hardware.opengl.extraPackages = with pkgs; [ intel-vaapi-driver libvdpau-va-gl intel-media-driver ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.opengl.driSupport32Bit = true;
}
