{ inputs, self, ... }: {

  flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.myMachineModule
      self.nixosModules.myFirstModule
    ];
  };

  flake.nixosModules.myMachineModule = { ... }: {
  imports = [
	inputs.disko.nixosModules.disko
	self.diskoConfigurations.baseModule
  ];
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;   
users.users.nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBulB722y+drb1c3bRGJXkGIjVF/bWYfYd2NzXCo4Y5H danielmeyer@d5m4.com"
      ];
    };

    security.sudo.wheelNeedsPassword = false;
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;
    system.stateVersion = "26.05";
  };
}
