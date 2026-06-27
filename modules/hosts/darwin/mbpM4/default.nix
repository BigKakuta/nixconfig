{ inputs, self, ... }:
{
  flake.darwinConfigurations.mbp = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      self.darwinModules.mbpM4
    ];
  };

  flake.darwinModules.mbpM4 =
    { config, pkgs, ... }:
    {

      environment.systemPackages = with pkgs; [
        neovim
        cloc
        go
        python3
        autoconf
        autoconf-archive
        automake
        ccache
        cmake
        nasm
        ninja
        pkg-config
        ocaml
        opam
        fontforge
        nushell
        jujutsu
        fzf
        difftastic
        uv
        nixos-rebuild
        bat
        nodejs
        opencode
        codex
        claude-code
	jdk25
	htop
	restic
      ];

      nixpkgs.config.allowUnfree = true;
      nix.enable = false;
      nix.settings.experimental-features = "nix-command flakes";

      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "dm";
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };

      homebrew = {
        enable = true;
        taps = builtins.attrNames config.nix-homebrew.taps;
        brews = [ ];
        casks = [
          "helium-browser"
          "ghostty"
          "microsoft-excel"
	  "actual"
	  "proton-pass"
	  "protonvpn"
	  "proton-mail"
	  "raycast"
	  "zwift"
	  "codex-app"
	  "jetbrains-toolbox"
	  "cmux"
          "orbstack"
	  "t3-code"
	  "utm"
	  "logi-options+"
	  "secretive"
	  "zed"
	  "cursor"
	  "visual-studio-code"

        ];
      };

      system.defaults = {
        dock = {
          autohide = true;
          tilesize = 48;
          persistent-apps = [
            "/Applications/Helium.app/"
            "/Applications/Ghostty.app/"
            "/Applications/cmux.app/"
	    "/Applications/Zed.app"
	    "/Application/Codex.app"
          ];
        };
        NSGlobalDomain = {
          NSWindowResizeTime = 0.001;
          "com.apple.keyboard.fnState" = true;
        };
        CustomSystemPreferences."com.apple.Accessibility".ReduceMotionEnabled = 1;
        finder = {
          NewWindowTarget = "Computer";
          QuitMenuItem = true;
        };
      };

      security.pam.services.sudo_local.touchIdAuth = true;
      system.stateVersion = 5;
      system.primaryUser = "dm";
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
}
