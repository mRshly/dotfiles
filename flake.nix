{
  inputs = {
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
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
        }
      );
  in
  {
    darwinConfigurations = {
      shadowsirius = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./machines/shadowsirius
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.mrshly = {
              imports = [

              ];
            };
          }
        ];
      };
    };

    devShells = forAllSystems (
      system:
      let
        pkgs = nixpkgsFor.${system};
      in
      {
        default = pkgs.mkShellNoCC {
          buildInputs = with pkgs; [
            (writeScriptBin "dot-clean" ''
              nix-collect-garbage -d --delete-older-than 30d
            '')
            (writeScriptBin "dot-sync" ''
              git pull --rebase origin main
              nix flake update
              dot-clean
              dot-apply
            '')
            (writeScriptBin "dot-apply" ''
              if test $(uname -s) == "Linux"; then
                sudo nixos-rebuild switch --flake .#
              fi
              if test $(uname -s) == "Darwin"; then
                nix build "./#darwinConfigurations.$(hostname | cut -f1 -d.).system"
                ./result/sw/bin/darwin-rebuild switch --flake .
              fi
            '')
          ];
        };
      }
    );
  };
}
