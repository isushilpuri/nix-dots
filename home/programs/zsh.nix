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
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      # Custom configs go here
      export EDITOR=nvim
      bindkey '^R' history-incremental-search-backward
    '';
  };
}

