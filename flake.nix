{
  description = "My favourite NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-24.11";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templ = {
      url = "github:a-h/templ";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, templ, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
	      allowUnfree = true;
      };
    };
    templ = system: inputs.templ.packages.${system}.templ;

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
             nodejs_22
             nest-cli
             postgresql_15
           ];
           shellHook = ''
	     echo "Node environment running"
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
             echo "Python environment running"
           '';
        };
    devShells.x86_64-linux.go =
      pkgs.mkShell
        {
          hardeningDisable = [ "fortify" ];
          nativeBuildInputs = with pkgs; [
            go
            air
            google-cloud-sdk
            delve
            gopls
            (templ system)
            nodejs
            (nodePackages.tailwindcss.override { nodejs = nodejs; })
            go-migrate
            go-outline
            gopkgs
            go-tools
            delve
          ];
          shellHook = ''
            export PATH=$PATH:$(pwd)/node_modules/.bin
            echo "Go environment running"
          '';
        };
    devShells.x86_64-linux.cuda =
      pkgs.mkShell
        {
           nativeBuildInputs = with pkgs; [
             gnupg autoconf
             procps gnumake util-linux m4 gperf
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
    devShells.x86_64-linux.odin =
      pkgs.mkShell
        {
          nativeBuildInputs = with pkgs; [
            gcc
            odin
            raylib
            glfw
            xorg.libX11
            xorg.libXrandr
            xorg.libXinerama
            xorg.libXcursor
            xorg.libXi
            xorg.xeyes
            mesa
            libglvnd
          ];

          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXi}/lib:${pkgs.raylib}/lib:${pkgs.mesa}/lib:${pkgs.libglvnd}/lib:$LD_LIBRARY_PATH
            export LIBGL_ALWAYS_SOFTWARE=1
            export DISPLAY=:0
            export XDG_SESSION_TYPE=x11
            export GDK_BACKEND=wayland
            export SDL_VIDEODRIVER=wayland
            echo "Odin environment running"
          '';
        };
    devShells.x86_64-linux.love =
      pkgs.mkShell
        {
	  nativeBuildInputs = with pkgs; [
	    love
	    lua
	    lua-language-server
	  ];

	  shellHook = ''
	    echo "Enjoy making games, I know you can do it"
	  '';
	};
  };
}
