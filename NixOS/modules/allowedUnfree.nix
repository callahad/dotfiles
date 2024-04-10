{ config, lib, ... }:

let
  inherit (lib.types) listOf str;
in

{
  # Polyfill for https://github.com/NixOS/nixpkgs/issues/55674
  options.allowedUnfree = lib.mkOption { type = listOf str; default = [ ]; };
  config.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowedUnfree;
}
