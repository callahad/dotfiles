{ lib, pkgs, ... }:

{
  programs.fish.enable = true;

  environment.shellAliases = lib.mkForce { };

  users.users."dan" = {
    description = "Dan Callahan";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };
}
