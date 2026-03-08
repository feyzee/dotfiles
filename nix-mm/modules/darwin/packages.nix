{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # macOS-specific CLI tools
    gnupg
    openssh
  ];
}
