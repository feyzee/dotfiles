{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Faizal Mustofa";
    userEmail = "faizalmusthafa@icloud.com";
    init = {
      defaultBranch = "main";
    };

    delta = {
      enable = true;
      options = "--theme=OneHalfDark";
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".env"
      ".env.local"
    ];

    extraConfig = {
      pull = {
        rebase = "true";
      };
      push = {
        default = "current";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
    };
  };
}
