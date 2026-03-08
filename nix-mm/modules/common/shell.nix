{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = lib.mkAfter ''
      # Import existing fish config
      ${builtins.readFile ../../../fish/.config/fish/config.fish}
    '';

    shellAliases = {
      cp = "cp -pr";
      ls = "eza";
      lsa = "eza --classify --color --long --all --git --header";
      lst = "eza --classify --color --long --git --header --tree";
      lsat = "eza --classify --color --long --all --git --header --tree";
      cat = "bat";
      rmrf = "rm -rf";
      grep = "rg";
      find = "fd";
      fd = "fd -Hi";
      vim = "nvim";
      n = "nvim";
      g = "git";
      lg = "lazygit";
      py = "python";
      k = "kubectl";
      tf = "terraform";
    };

    functions = {
      ".." = {
        body = "cd ..";
      };
      "..." = {
        body = "cd ../..";
      };
      "...." = {
        body = "cd ../../..";
      };
      "....." = {
        body = "cd ../../../..";
      };
    };

    conf = {
      fish_greeting = "";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
  };

  xdg.configFile."fish/aliases.fish".source = ../../../fish/.config/fish/aliases.fish;

  home.sessionVariables = {
    SHELL = if config.programs.fish.enable then "fish" else "zsh";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
