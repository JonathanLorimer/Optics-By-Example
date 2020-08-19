with import ./default.nix {};

hsPkgs.shellFor {
    packages = myHsPkgs: [
			myHsPkgs.OpticsByExample
    ];
    withHoogle = true;
    buildInputs = with pkgs; [
      cabal-install # cabal, haskell build tool
      cabal2nix # Utility to download Haskell packages into Nix format
      hsPkgs.ghcid # haskell repl with hot reloading
      hsPkgs.hpack # generate cabal file from package.yaml
		];
}

