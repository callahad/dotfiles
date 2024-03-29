{
  description = "NixOS System Configurations";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  inputs.secrets.url = "path:/etc/nixos-secrets";

  outputs = { self, nixpkgs, secrets }: {

    nixosConfigurations.meta = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
      ];

      specialArgs = { inherit secrets; };
    };
  };
}
