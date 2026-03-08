{ config, pkgs, lib, ... }:

{
  imports = [
    ../home/default.nix
    ../modules/common/packages.nix
    ../modules/linux/packages.nix
  ];

  home.username = "faizalmusthafa";
  home.homeDirectory = "/home/faizalmusthafa";
  home.stateVersion = "24.11";
}
