ifeq ($(OS),Windows_NT)
	GPLK_LIBS_INCLUDES := --extra-include-dirs=$(glpk)/src --extra-include-dirs=$(glpk)/src/amd --extra-include-dirs=$(glpk)/src/colamd --extra-include-dirs=$(glpk)/src/minisat --extra-include-dirs=$(glpk)/src/zlib --extra-lib-dirs=$(glpk)/w32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
	MAC_USR_LIB := --extra-lib-dir=/opt/local/lib --extra-include-dir=/opt/local/include/
	endif
endif

all: build

init:
	cabal sandbox init --sandbox=../.clafertools-cabal-sandbox
	cabal install --only-dependencies $(GPLK_LIBS_INCLUDES) $(MAC_USR_LIB)

build:
	cabal configure
	cabal build