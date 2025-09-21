{ config, pkgs, self, ... }:

{
  imports = [
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/ghostty.nix
    ./programs/hyprpanel.nix
  ];

  home.username = "v0idshil";
  home.homeDirectory = "/home/v0idshil";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    python313
    rustup
    uv
    vim
    postgresql
    nodejs_24
    ripgrep
    gcc
    zig
    gimp
    unzip
    foliate
    qutebrowser
    keepassxc
    gnumake
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    # ".config/nvim" = {
    #     source = "${self}/nvim";
    #  recursive = true;
    # };
    ".config/zed" = {
        source = "${self}/zed";
	    recursive = true;
    };
    ".config/mpv" = {
        source = "${self}/mpv";
	    recursive = true;
    };
    # ".config/tmux" = {
    #     source = "${self}/tmux";
    #  recursive = true;
    # };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/v0idshil/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
      hms = "home-manager switch --flake ~/nix-dots#v0idshil";
    };

    initExtra = ''
      export PS1='\[\e[38;5;45m\]\u\[\e[0m\] in \[\e[38;5;36m\]\w\[\e[0m\] \\$ '
    '';
  };

  programs.git = {
      enable = true;
      userName = "isushilpuri";
      userEmail = "isushilpuri@gmail.com";
      aliases = {
          pu = "push";
          co = "checkout";
          cm = "commit";
      };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # if you're using zsh
  };

  programs.neovim = {
      enable = true;
      extraPackages = with pkgs; [ lua-language-server rust-analyzer lldb vscode-extensions.vadimcn.vscode-lldb];
      extraWrapperArgs = [
	  "--prefix"
	      "PATH"
	      ":"
	      "${pkgs.rust-analyzer}/bin"
      ];
  };

}
