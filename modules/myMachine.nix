{ inputs, self, ... }: {

	flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.myMachineModule
			self.nixosModules.myFirstModule
		];
	};

	flake.nixosModules.myMachineModule = { pkgs, ...}: {
		boot.loader.grub.enable = true;
	};
}
