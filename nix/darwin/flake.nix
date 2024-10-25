{
  description = "Hermetica Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
        # To install packages that are not open source:
        # nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        # Or check online: https://search.nixos.org
        environment.systemPackages =
            [
                pkgs.bat
                pkgs.bun
                pkgs.coreutils
                pkgs.diff-so-fancy
                pkgs.eza
                pkgs.fd
                pkgs.fzf
                pkgs.gh
                pkgs.jq
                pkgs.mkalias
                pkgs.procs
                pkgs.pyenv
                pkgs.ripgrep
                pkgs.tailscale
                pkgs.tldr
                pkgs.zed-editor
                # pkgs.zsh-autosuggestions
                # pkgs.zsh-syntax-highlighting
            ];

        fonts.packages =
            [
                pkgs.fira
                pkgs.gofonts
            ];

        homebrew = {
            enable = true;
            brews = [
                "mas" # Mac App Store CLI: mas search Xcode for finding the App Store IDs used below
            ];
            # Add strings to the list to install Casks (GUI apps)
            casks = [];
            # For Mac App Store installations
            masApps = {
                "Amazon Kindle" = 302584613;
                "ToyViewer" = 414298354;
                "Yoink" = 457622435;
                "Xcode" = 497799835;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
        }

        system.activationScripts.applications.text = let
            env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
            };
        in
            pkgs.lib.mkForce ''
                # Set up applications
                echo "Setting up applications..." >&2
                rm -rf /Applications/Nix\ Apps
                mkdir -p /Applications/Nix\ Apps
                find ${env}/Applications -maxdepth 1 -tyle l -exec readlink '{}' + |
                while read src; do
                    app_name=$(basename "$src")
                    echo "Copying $src" >&2
                    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
                done
            '';

        # TODO: set 1.1.1.1 for DNS
        # TODO: map caps lock to control key
        # TODO: set up keyboard shortcuts for window management

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;  # default shell on catalina

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
    };
    in
    {
        # Build darwin flake using:
        # Work:
        # $ darwin-rebuild build --flake .#ddw
        # Personal:
        # $ darwin-rebuild build --flake .#max
        # Could add another pair of configurations after these, to target a different system.
        darwinConfigurations."ddw" = nix-darwin.lib.darwinSystem {
            modules = [
                configuration
                nix-homebrew.darwinModules.nix-homebrew
                {
                    nix-homebrew = {
                        enable = true;
                        enableRosetta = true;
                        user = "boette";
                        # If Homebrew is already installed:
                        # autoMigrate = true;
                    };
                }
            ];
        };

        # Expose the package set, including overlays, for convenience.
        darwinPackages = self.darwinConfigurations."ddw".pkgs;

        local = {
            dock.enable = false;
            dock.entries = [
                { path = "/System/Applications/Freeform.app"; }
                { path = "/System/Applications/Notes.app"; }
                { path = "/System/Applications/Mail.app"; }
                { path = "/System/Applications/Music.app/"; }
            ]
        }
    };
}
