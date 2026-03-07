{ inputs, self, ... }: {

	flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			self.nixosModules.myMachineModule
			self.nixosModules.myFirstModule
		];
	};

	flake.nixosModules.myMachineModule = { pkgs, ...}: {
		boot.loader.grub.enable = true;
	};
}
