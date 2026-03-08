{
  description = "Faizal's Nix-based dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, sops-nix, ... }:
    let
      inherit (self) inputs;
    in {
      darwinConfigurations = {
        macbook = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/macbook/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.users.faizalmusthafa = import ./home/default.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      homeConfigurations = {
        "faizalmusthafa@desktop" = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/default.nix
            ./hosts/desktop/default.nix
          ];
        };
      };

      devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
        buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [
          nixpkgs-fmt
          rnix-lsp
        ];
      };

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          nixpkgs-fmt
          rnix-lsp
        ];
      };
    };
}
