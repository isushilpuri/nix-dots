{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    enableZshIntegration = true;
  };
}

