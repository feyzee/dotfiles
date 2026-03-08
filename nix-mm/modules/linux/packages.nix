{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Linux-specific CLI tools
    coreutils
    findutils
    gawk
    sed
    which
  ];
}
