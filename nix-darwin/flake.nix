{
  description = "Hermetica Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          # To install packages that are not open source:
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          # Or check online: https://search.nixos.org
          environment.systemPackages = [
            (pkgs.aspellWithDicts (dicts: with dicts; [ en ])) # spellcheck backend for Doom's :checkers spell
            pkgs.bat
            pkgs.bitwarden-cli
            pkgs.coreutils
            pkgs.diff-so-fancy
            pkgs.emacs30-macport # Mac port (jdtsmith fork), native-comp on by default
            pkgs.eza
            pkgs.fastfetch
            pkgs.fd
            pkgs.fnm
            pkgs.fzf
            pkgs.gh
            pkgs.isync # mbsync, for mu4e mail sync
            pkgs.jq
            pkgs.ledger
            pkgs.libdvdcss
            pkgs.lua
            pkgs.meslo-lgs-nf
            pkgs.mkalias
            pkgs.msmtp # SMTP forwarder, for sending mail from mu4e
            pkgs.mpv
            pkgs.nil # to get the nix daemon working for Zed's nix support
            pkgs.nixd # to get the nix daemon working for Zed's nix support
            pkgs.nodejs_22
            pkgs.obsidian
            pkgs.ollama
            pkgs.platformio
            pkgs.procs
            pkgs.pyenv
            pkgs.raycast
            pkgs.ripgrep
            pkgs.sd
            pkgs.sshpass # TODO confirm
            pkgs.tldr
            pkgs.tmux
            pkgs.tree
            pkgs.watchexec
            pkgs.xbar
            pkgs.zola
            pkgs.zsh-autosuggestions
            pkgs.zsh-syntax-highlighting
          ];

          fonts.packages = [
            pkgs.fira
            pkgs.go-font
            pkgs.symbola # Emacs' recommended unicode fallback font (doom doctor)
          ];

          homebrew = {
            enable = true;
            brews = [
              "ffmpeg"
              "mas" # Mac App Store CLI: mas search Xcode for finding the App Store IDs used below
              "mu" # mu4e mail indexer; Homebrew's build ships mu4e.el, nixpkgs' doesn't
              "pi-coding-agent"
              "powerlevel10k" # Broken in Nix?
              "quarkdown-labs/quarkdown/quarkdown"
              "yt-dlp"
            ];
            # Add strings to the list to install Casks (GUI apps)
            casks = [
              "backblaze"
              "chatgpt"
              "claude"
              "discord"
              "font-zed-mono-nerd-font"
              "handbrake-app" # nix pkg is broken
              "kicad"
              "lm-studio" # nix pkg is broken
              "zed" # nix pkg is broken
            ];
            # For Mac App Store installations
            # Breaking change to mas hasn't been pulled into
            # nix-darwin, so these install attempts fail.
            masApps = {
              # "Amazon Kindle" = 302584613;
              # "Bitwarden" = 1352778147; # 2026.7.0
              # "Elmedia Video Player" = 1044549675;
              # "Tailscale" = 1475387142;
              # "ToyViewer" = 414298354;
              # "UTC Time" = 1538245904;
              # "Xcode" = 497799835;
            };
            # onActivation.cleanup = "zap";
            # TEMPORARILY off: the nix-homebrew-pinned Homebrew (6.0.1) is too
            # old for current bottles (missing install steps set_permissions /
            # configure_clang_system), so `brew upgrade` crashes. Re-enable
            # after bumping the nix-homebrew/brew-src flake input and cleaning
            # up the accumulated duplicate kegs (`brew cleanup`).
            onActivation.autoUpdate = false;
            onActivation.upgrade = false;
          };

          system.primaryUser = "b";

          system.activationScripts.applications.text =
            let
              env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = [ "/Applications" ];
              };
            in
            pkgs.lib.mkForce ''
              # Set up applications
              echo "Setting up applications..." >&2
              rm -rf /Applications/Nix\ Apps
              mkdir -p /Applications/Nix\ Apps
              find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
              while read -r src; do
                  app_name=$(basename "$src")
                  echo "!!Copying $src" >&2
                  ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
              done
            '';

          networking = {
            dns = [
              "1.1.1.1"
              "1.0.0.1"
            ];
            knownNetworkServices = [ "Wi-Fi" ];
          };

          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToControl = true;

          # Dock
          system.defaults.dock.autohide = true;
          # Fix scrolling direction so it is not natural
          system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

          # Allow TouchID for terminal auth
          # Must run after each reboot
          security.pam.services.sudo_local.touchIdAuth = true;

          # Auto upgrade nix package and the daemon service.
          nix.enable = true;
          nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina

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
      # Build and switch to new Darwin flake:
      # $ darwin-rebuild switch --flake ~/.config/nix-darwin#max
      darwinConfigurations."max" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "b";
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."max".pkgs;

    };
}
