init:
	cabal sandbox init 
	cabal install --only-dependencies

build:
	cabal configure
	cabal build