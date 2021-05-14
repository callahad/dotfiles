local wezterm = require 'wezterm';

if wezterm.target_triple:find("darwin") then
    -- macOS
    font_size = 13.0;
    window_decorations = "TITLE | RESIZE";
else
    -- Linux
    font_size = 10.5;
    window_decorations = "RESIZE";
end

return {
  font = wezterm.font("Iosevka Term"),
  font_size = font_size,
  harfbuzz_features = {"calt=0", "JSPT=1"},

  font_rules = {
    {
      intensity = "Bold",
      font = wezterm.font("Iosevka Term", {weight="Bold"})
    }
  },

  native_macos_fullscreen_mode = true,
  window_decorations = window_decorations,

  term = "wezterm",

  -- Decent color schemes:
  --   Argonaut, Ayu, Bright Lights, Builtin Tango Dark, Dark+, Elementary,
  --   FirefoxDev, Glacier, Monokai Remastered, Monokai Vivid, Nocturnal Winter
  --   Raycast_Dark, Seti, synthwave, Wez

  color_scheme = "Monokai Remastered",
  window_background_opacity = 0.98,
  hide_tab_bar_if_only_one_tab = true,

  keys = {
    {key="s", mods="SUPER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="d", mods="SUPER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  }
}
