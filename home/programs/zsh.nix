{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    initExtra = ''
      # Custom configs go here
      export EDITOR=nvim
      bindkey '^R' history-incremental-search-backward
    '';
  };
}

