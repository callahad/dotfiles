{
  description = "Nix / NixOS / Home Manager Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, plasma-manager }: {
    nixosConfigurations."bcachefsInstaller" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
        ({lib, pkgs, ...}: {
          boot.supportedFilesystems."bcachefs" = lib.mkForce true;
          boot.supportedFilesystems."zfs" = lib.mkForce false;
          boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
        })
      ];
    };

    nixosConfigurations."impact" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./NixOS/hardware/framework-16.nix
        ./NixOS/hosts/impact.nix
      ];
    };

    nixosConfigurations."meta" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./NixOS/hardware/x1carbon-5th.nix
        ./NixOS/hosts/meta.nix
      ];
    };

    # I use Home Manager standalone, rather than as a NixOS module.
    # This keeps usage consistent between my NixOS and macOS hosts.
    homeConfigurations."dan@impact" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        { home.username = "dan"; home.homeDirectory = "/home/dan"; }
        ./home.nix
        plasma-manager.homeManagerModules.plasma-manager
      ];
    };

    homeConfigurations."d.callahan@QCF9HHCXM5" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs-darwin.legacyPackages."aarch64-darwin";
      modules = [
        { home.username = "d.callahan"; home.homeDirectory = "/Users/d.callahan"; }
        ./home.nix
      ];
    };
  };
}
