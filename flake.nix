{
  description = "NixOS configuration with flakes and caelestia shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland.url = "github:hyprwm/hyprland?rev=386376400119dd46a767c9f8c8791fd22c7b6e61"; # 0.53.3 - last known good for hyprexpo
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?rev=8c1212e96b81aa5f11fe21ca27defa2aad5b3cf3";
      inputs.hyprland.follows = "hyprland";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, caelestia-shell, caelestia-cli, zen-browser, home-manager, nix-cachyos-kernel, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.meterra = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          (let system = "x86_64-linux"; in { pkgs, ... }: {
            environment.systemPackages = [
              ((inputs.caelestia-cli.packages.${system}.with-shell.override {
                inherit (pkgs) app2unit;
                caelestia-shell = inputs.caelestia-shell.packages.${system}.default.override {
                  inherit (pkgs) app2unit;
                };
              }).overrideAttrs (old: {
                patchPhase = ''
                  mkdir -p src/caelestia/data/templates
                  echo "Darkly" > src/caelestia/data/templates/qtct.conf
                '' + old.patchPhase;
              }))
              inputs.zen-browser.packages.${system}.default
            ];
          })
        ];
      };
    };
  };
}
