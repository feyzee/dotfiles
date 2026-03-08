{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.helix = {
    enable = true;
  };

  xdg.configFile."nvim".source = ../../../nvim/.config/nvim;
  xdg.configFile."helix".source = ../../../helix/.config/helix;
}
