{inputs, ...}: {
	flake.nixosModules.myFirstModule = { pkgs, ...}: {

		programs.firefox.enable = true;

		environment.systemPackages = with pkgs; [
			vim
			git
		];
		
	};
}
