{
  description = "mrshly's nix-darwin and home-manager configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  {
    darwin,
    home-manager,
    nixpkgs,
    ...
  }:
  {
    darwinConfigurations = {
      shadowcomet = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./machines/shadowcomet
          home-manager.darwinModules.home-manager
          {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = false;
	    home-manager.users.mrshly = {
	      imports = [
	        ./modules/home.nix
          ./modules/darwin
          ./modules/pkgs.nix
          ./modules/fzf.nix
          ./modules/ghostty
          # NOTE: There are 2 problems to install lazygit via home-manager
          # 1. I don't know how to write "customCommand" in `.nix` file.
          # 2. How to set config dir to $XDG_CONFIG_HOME
          # Workaround:
          #   Install lazygit via homebrew then its config dir path is set to $XDG_CONFIG_HOME
          #   `lazygit -cd -> ~/.config`
          # ./modules/lazygit.nix
          ./modules/shell.nix
	      ];
	    };
	  }
        ];
      };
    };
  };
}
