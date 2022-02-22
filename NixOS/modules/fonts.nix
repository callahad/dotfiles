{ pkgs, ... }:

{
  fonts.fontDir.enable = true;

  fonts.fontconfig.allowBitmaps = false;

  fonts.enableDefaultFonts = false;

  fonts.fonts = with pkgs; [
      # [Disabled] Default Fonts (modules/config/fonts.fonts.nix)
      #xorg.fontbhlucidatypewriter100dpi
      #xorg.fontbhlucidatypewriter75dpi
      #dejavu_fonts
      freefont_ttf
      #gyre-fonts # TrueType substitutes for standard PostScript fonts
      liberation_ttf
      #xorg.fontbh100dpi
      #xorg.fontmiscmisc
      #xorg.fontcursormisc
      #unifont
      noto-fonts-emoji

      # Added by GNOME 3 (modules/services/x11/desktop-managers/gnome3.nix)
      #cantarell_fonts
      #dejavu_fonts
      #source-code-pro
      #source-sans-pro

      # Monospaced Fonts
      #fira-code
      #ibm-plex
      iosevka-bin
      #inconsolata-lgc
      #input-fonts
      #monoid

      # Other Fonts
      noto-fonts
      noto-fonts-cjk
      zilla-slab
  ];
}
