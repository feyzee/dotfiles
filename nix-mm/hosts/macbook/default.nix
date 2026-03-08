{ config, pkgs, lib, ... }:

{
  imports = [
    ../home/default.nix
    ../modules/common/packages.nix
    ../modules/darwin/packages.nix
  ];

  home.username = "faizalmusthafa";
  home.homeDirectory = "/Users/faizalmusthafa";
  home.stateVersion = "24.11";
}
