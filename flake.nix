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
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
           shellHook = ''
             $SHELL
           '';
         };
    devShells.x86_64-linux.python =
      pkgs.mkShell
        {
           nativeBuildInputs = with pkgs; [
             python38Full
             libffi
             gcc
             pkg-config
             zlib
             libjpeg
             openjpeg
             librsvg
             libtiff
             lcms2
             freetype
             harfbuzz
             postgresql_12
           ];
           shellHook = ''
             $SHELL
           '';  
        };
    devShells.x86_64-linux.go =
      pkgs.mkShell
        {
          nativeBuildInputs = with pkgs; [
            go
            gotools
            gopls
            go-outline
            gopkgs
            gocode-gomod
            godef
            golint
            air
            google-cloud-sdk
          ];
          shellHook = ''
          $SHELL
          '';
        };
    devShells.x86_64-linux.cuda =
      pkgs.mkShell
        {
           nativeBuildInputs = with pkgs; [
             git gitRepo gnupg autoconf curl
             procps gnumake util-linux m4 gperf unzip
             cudatoolkit linuxPackages.nvidia_x11
             libGLU libGL
             xorg.libXi xorg.libXmu freeglut
             xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
             ncurses5 stdenv.cc binutils
           ];
           shellHook = ''
             $SHELL
           '';
        };
  };
}
