{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Console tools; I expect these to be installed systemwide on Linux
    bat
    eza
    fd
    git
    ripgrep
    tree
    unar
  ];
}
