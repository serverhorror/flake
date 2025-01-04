{
  description = "Home Manager configuration of serverhorror";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dotfiles = {
    #   url = "github:serverhorror/dotfiles";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};

      # from the nixpkgs docs: https://nixos.org/manual/nixpkgs/unstable/
      buildInputs = with pkgs; [
        # # home-manager
        # home-manager
        # # common
        awscli
        bash
        coreutils
        curl
        dig
        direnv
        fd
        gcc
        gh
        git-credential-manager
        git-credential-oauth
        gitFull
        gnumake
        httpie
        jq
        lazygit
        libsecret
        libxml2
        neovim
        openrsync
        pup
        ripgrep
        fzf
        rsync
        stow
        tmux
        tree
        unzip
        xclip  # so we have a working vim clipboard
        yq
        zellij
        zk
        oh-my-posh
        # IaC, containers, K8S
        docker-client
        docker-buildx
        cri-tools
        cue
        kind
        openshift
        pulumi-bin
        # lua51Packages.luarocks
        lua51Packages.luarocks-nix
        # Python
        python3Full
        poetry
        uv
        # python313Full
        # NodeJS
        # nodejs_18
        # nodejs_20
        nodejs_22
        # Go
        go gopls
        # Zig
        zig
        zls
	texliveFull
        # nix stuff
        nixfmt-rfc-style
      ];
    in {

      #environment = {
      #  # https://mynixos.com/nixpkgs/option/environment.systemPackages
      #  # The set of packages that appear in /run/current-system/sw. These
      #  # packages are automatically available to all users, and are
      #  # automatically updated every time you rebuild the system configuration.
      #  # (The latter is the main difference with installing them in the
      #  # default # profile, /nix/var/nix/profiles/default.)
      #  systemPackages = buildInputs;
      #};

      homeConfigurations.m = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit buildInputs;
          systemUserName = "m";
        };
      };

      homeConfigurations.ec2-user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit buildInputs;
          systemUserName = "ec2-user";
        };
      };
      # # # Used by: `nix [run\build]`
      # packages.${system}.default = pkgs.mkShell{
      #   buildInputs = buildInputs;
      # };

      # Used by: `nix develop`
      devShells.${system}.default = pkgs.mkShell { buildInputs = buildInputs; };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

    };
}
