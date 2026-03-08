{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
  };

  xdg.configFile."ghostty/config".source = ../../../ghostty/.config/ghostty/config;
  xdg.configFile."ghostty/macos.conf".source = ../../../ghostty/.config/ghostty/macos.conf;
  xdg.configFile."ghostty/linux.conf".source = ../../../ghostty/.config/ghostty/linux.conf;
  xdg.configFile."ghostty/themes".source = ../../../ghostty/.config/ghostty/themes;

  xdg.configFile."wezterm".source = ../../../wezterm/.config/wezterm;
  xdg.configFile."kitty".source = ../../../kitty/.config/kitty;
  xdg.configFile."lazygit".source = ../../../lazygit/.config/lazygit;
  xdg.configFile."bat".source = ../../../bat/.config/bat;
  xdg.configFile."procs".source = ../../../procs/.config/procs;
}
