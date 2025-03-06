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
              home-manager.useUserPackages = false;
              home-manager.backupFileExtension = "bak";
              home-manager.users.mrshly = {
                imports = [
                  ./modules/home.nix
                  ./modules/darwin
                  ./modules/pkgs.nix
                  ./modules/fzf.nix
                  ./modules/ghostty
                  # ./modules/wezterm
                  ./modules/git
                  ./modules/gh
                  ./modules/lazygit
                  ./modules/shell.nix
                ];
              };
            }
          ];
        };
      };
    };
}
