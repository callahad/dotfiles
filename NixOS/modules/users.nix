{ pkgs, ... }:

{
  # Fish Shell
  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  # Nuke default aliases to avoid shadowing user-defined functions in Fish
  environment.shellAliases = pkgs.lib.mkForce { };

  # Me
  users.users.dan = {
    isNormalUser = true;
    description = "Dan Callahan";
    uid = 1000;
    shell = pkgs.fish;
    extraGroups = [
      "wheel" "audio" "video" "scanner"
      "networkmanager" "systemd-journal"
      "docker"
    ];
  };
}
