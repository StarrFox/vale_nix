{ self, inputs, ... }:
  let
    inherit (builtins) length map;
    inherit (inputs.nixpkgs.lib) optionals flatten;
    inherit (self) overlays;

    ## Core modules which are crucial for every system go here.
    ## These will be present on every NixOS machine by default.
    coreModules = [
      ../core/fonts.nix
      ../core/locale.nix
      ../core/networking.nix
      ../core/nix-daemon.nix
      ../core/users.nix

      inputs.home-manager.nixosModules.default
    ];

    ## Defines `home-manager` modules for personal user accounts.
    makeHomeModule = modules: system: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs system;
      };
      home-manager.users.vale = { ... }: {
        imports = modules;
        home.stateVersion = "22.11";
      };
    };

    ## Defines a new NixOS system given the system specifier and
    ## a list of modules which extends upon `coreModules`.
    makeSystem = { system, modules, homeModules ? [] }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { inherit system; };
        modules =
          [
            {
              # Globally configure nixpkgs so that we can get unfree
              # packages on both stable and unstable channels.
              nixpkgs = {
                overlays = [overlays.unstable-unfree-packages];

                config.allowUnfree = true;
              };
            }
          ]
          ++ coreModules
          ++ modules
          ++ (optionals (length homeModules != 0) [(makeHomeModule homeModules system)]);
      };

  in {
    # For every machine there is a dedicated .nix file which describes
    # hardware  configuration. Don't forget to include in `modules`.

    # My main desktop machine and daily driver. Used for just about anything.
    glacier = makeSystem {
      system = "x86_64-linux";
      modules = [
        ./glacier.nix

        ../core/zsh.nix

        ../core/gui/kde.nix

        ../core/hw/nvidia.nix
      ];
      homeModules = [
        ../home/alacritty.nix
        ../home/git.nix
        ../home/gpg.nix
        ../home/programs.nix
        ../home/x11
        ../home/zsh.nix
      ];
    };
  }
