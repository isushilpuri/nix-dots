{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    # # Dotfiles flake
    # nix-dots.url = "path:/home/v0idshil/nix-dots"; # Change path if needed
  };
  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."$(system)";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ 
            ./hosts/laptop/configuration.nix
	    # Inline module to install Home Manager CLI
	    ({ config, pkgs, ... }:
	      {
	        environment.systemPackages = with pkgs; [
		  (home-manager.packages.${system}.home-manager)
	        ];
	      }
	    )
	  ];
      };
    };
}
