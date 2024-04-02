{
  description = "Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
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
  };
}
