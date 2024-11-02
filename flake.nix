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



  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
    nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};

    # from the nixpkgs docs: https://nixos.org/manual/nixpkgs/unstable/
    buildInputs =  with pkgs; [
      # # home-manager
      # home-manager
      # common
      neovim
      # gitFull
      coreutils
      rsync openrsync
      tmux
      ripgrep fzf
      jq yq
      curl httpie
      dig
      # Python
      python3Full
      # python313Full
      # NodeJS
      # nodejs_18
      # nodejs_20
      nodejs_22
      # Go
      go gopls
      # Zig
      zig zls
      ];
    in {
      homeConfigurations.m= home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit buildInputs;
        };
      };

      # packages.x86_64-linux.hello = pkgs.hello;
      #
      # # Used by: `nix [run\build]`
      packages.x86_64-linux.default = pkgs.mkShell{
        buildInputs = buildInputs;
      };

      # Used by: `nix develop`
      devShells.x86_64-linux.default = pkgs.mkShell{
        buildInputs = buildInputs;
      };

    };
}
