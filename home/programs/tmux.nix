{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 2000;
    mouse = true;
    sensibleOnTop = true;
    prefix = "M-Space";
  };
}

