{ config, pkgs, buildInputs, ... } @ inputs:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "m";
  home.homeDirectory = "/home/m";

  xdg = {
    enable = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = buildInputs;
  # home.packages = [
  #     # # Adds the 'hello' command to your environment. It prints a friendly
  #     # # "Hello, world!" when run.
  #     # pkgs.hello
  #
  #     # # It is sometimes useful to fine-tune packages, for example, by applying
  #     # # overrides. You can do that directly here, just don't forget the
  #     # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  #     # # fonts?
  #     # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  #
  #     # # You can also create simple shell scripts directly inside your
  #     # # configuration. For example, this adds a command 'my-hello' to your
  #     # # environment:
  #     # (pkgs.writeShellScriptBin "my-hello" ''
  #     #   echo "Hello, ${config.home.username}!"
  #     # '')
  #   ];

  # # how?
  # home.activation = {
  #   init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     mkdir -p ~/bin
  #   '';
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nvim" = {
      source = builtins.fetchGit {
        url = "https://github.com/serverhorror/dotfiles-vim.git";
        ref = "main";
        rev = "d1b4d20718e61ed2a4368fa2b286fc8f0c358a32";
        # sha256 = "...";
      };
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
  #  /etc/profiles/per-user/m/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # GOBIN  = "~/bin";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    tmux = {
      enable = true;
      clock24 = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash = {
      enable = true;
      historyControl= ["erasedups" "ignoredups" "ignorespace" "ignoreboth"];
      historyIgnore = [
      "cd .." "cd" "exit" "ll" "ls -l" "ls"
      "history"
      ];
      ## near the start
      initExtra = ''
      echo "#INIT [ -e zsh ] && exec zsh"
      echo '#INIT [ -d ~/bin ] && export PATH="~/bin:$PATH"'
      '';

      ## near the end
      bashrcExtra = ''
      echo "#EXTRA [ -e zsh ] && exec zsh"
      '';
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      oh-my-zsh = {
        enable = true;
      };

    };

    go = {
      enable = true;
      goBin = "bin";
      goPrivate = [
        "*.biscrum.com"
      ];
    };

    awscli = {
      enable = true;
      # # overwrites ~/.aws/config
      # settings = {
      #   "default" = {
      #     region = "eu-west-1";
      #     output = "json";
      #   };
      # };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "serverhorror";
      userEmail = "serverhorror@users.noreply.github.com";
      extraConfig = {
        # # This is an example of how to configure git to use a credential helper.
        # # This is useful for example when you want to use a password manager to
        # # store your git credentials.
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        credential = {
          helper = "cache";
          useHttpPath = true;
        };
      };
    };
  };
}
