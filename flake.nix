{
  description = "My favourite NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";  
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
	allowUnfree = true;
      };
    };

  in
  {

    nixosConfigurations = {
      myNixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

	modules = [
	  ./nixos/configuration.nix
	];
      };
    };

    devShells.x86_64-linux.node =
      pkgs.mkShell
        {
           nativeBuildInputs = with pkgs; [
             nodejs_21
             nest-cli
           ];
         };
    devShells.x86_64-linux.python =
      pkgs.mkShell
        {
           nativeBuildInputs = with pkgs; [
             python38
             postgresql_12
           ];
        };

  };
}
