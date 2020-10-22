ghcid:
	hpack .
	cabal new-configure
	ghcid -o ghcid.txt --command 'cabal new-repl lib:OpticsByExample' --allow-eval --warnings

format:
	ormolu --mode inplace $(find src/ -name '*.hs')
