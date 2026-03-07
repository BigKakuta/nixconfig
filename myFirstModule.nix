{inputs, ...}: {
	flake.nixosModules.myFirstModule = { pkgs, ...}: {

		programs.firefox.enable = true;

		enviroment.systemPackages = with pkgs; [
			vim
		];
		
	};
}
