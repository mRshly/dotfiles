{
  description = "ShadowComet and ShadowMercury dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nix-darwin, home-manager, ... }:
    let
      mkDarwinConfiguration = { hostModule, username, userUid }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs username userUid; };
          modules = [
            ./nix/darwin/common.nix
            hostModule
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./nix/home;
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        ShadowComet = mkDarwinConfiguration {
          hostModule = ./nix/hosts/ShadowComet;
          username = "shadowcomet";
          userUid = 501;
        };

        ShadowMercury = mkDarwinConfiguration {
          hostModule = ./nix/hosts/ShadowMercury;
          username = "shadowmercury";
          userUid = 501;
        };
      };
    };
}
