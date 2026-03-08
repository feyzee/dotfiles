{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/common/shell.nix
    ../modules/common/git.nix
    ../modules/common/editors.nix
    ../modules/common/terminal.nix
    ../modules/common/packages.nix
  ];

  home.username = "faizalmusthafa";
  home.homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/faizalmusthafa"
    else "/home/faizalmusthafa";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
