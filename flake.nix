{
  description = "Home Manager configuration of m";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };



  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};

    # from the nixpkgs docs: https://nixos.org/manual/nixpkgs/unstable/
    buildInputs =  [
      # # home-manager
      # pkgs.home-manager
      # common
      pkgs.neovim pkgs.jq pkgs.yq pkgs.ripgrep pkgs.fzf
      pkgs.curl pkgs.dig
      # Python
      pkgs.python3Full
      # pkgs.python313Full
      # NodeJS
      # pkgs.nodejs_18
      # pkgs.nodejs_20
      pkgs.nodejs_22
      # Go
      pkgs.go
      # Zig
      pkgs.zig
      ];
    in {
      homeConfigurations."serverhorror" = home-manager.lib.homeManagerConfiguration {
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
