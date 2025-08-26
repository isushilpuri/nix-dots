{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    # nvf = {
    #    url = "github:notashelf/nvf";
    #    inputs.nixpkgs.follows = "nixpkgs";
    # };
    yazi.url = "github:sxyazi/yazi";
  };

  outputs = { self, nixpkgs, home-manager, yazi, ... }: 
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      # Export the home configuration
      home = ./home.nix;

      # Optionally, you could define homeConfigurations here for standalone usage
      homeConfigurations."v0idshil" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
	    # nvf.homeManagerModules.default
            ./home.nix
	    ({ pkgs, ... }: {
		nixpkgs.config.allowUnfree = true;
		home.packages = [
		  (yazi.packages.${pkgs.system}.default.override {
		    _7zz = pkgs._7zz-rar;  # Support for RAR extraction
		  })
		];
	    })
	];

        # To use 'self' inside home.nix
        extraSpecialArgs = { inherit self; };

      };
    };
}
