TOP_DIR=.
PROJECT_HOME=${TOP_DIR}

# ------------------------------------  General  -----------------------------------------
init: install dep
	@echo "Initializing the repo..."

install:
	@echo "Install software required for this repo..."
	@mix local.hex --force
	@mix local.rebar --force
	@npm install --save-dev hardhat
	@npm install --save-dev @openzeppelin/contracts
	@npm install --save-dev @nomiclabs/hardhat-ethers ethers

clean:
	@echo "Cleaning the build..."
	@rm -rf _build
	@rm -rf .elixir_ls
	@rm -rf deps
	@rm -rf artifacts
	@rm -rf priv/gen
	@rm -rf solc_out

build:
	@make contracts
	@make elixir

all:
	@rm -rf _build/dev/lib/{ocap_rpc,abi}
	@make build

# ------------------------------------  Elixir Related  -----------------------------------------
elixir:
	@rm -rf priv/gen
	@rm -rf _build/dev/lib/stela
	@make format

format:
	@mix compile; mix format;

dep:
	@echo "Install dependencies required for this repo..."
	@mix deps.get

test:
	@echo "Running test suites..."
	@MIX_ENV=test mix test

run:
	@echo "Running the software..."
	@iex -S mix

rebuild-deps:
	@rm -rf mix.lock; rm -rf deps/utility_belt;
	@make dep

# ------------------------------------  Chain Related  -----------------------------------------
chain:
	@echo "Running Erigon chain..."
	@erigon \
		--datadir=dev_chain \
		--chain dev \
		--private.api.addr=localhost:9090 \
		--http.api=eth,erigon,web3,net,debug,trace,txpool,trace,parity \
		--mine \
		--dev.period=13

rpc:
	@rpcdaemon \
		--datadir=dev  \
		--private.api.addr=localhost:9090 \
		--http.api=eth,erigon,web3,net,debug,trace,txpool,trace,parity

hdnode:
	@npx hardhat node

hdconsole:
	@npx hardhat console --network localhost

# ------------------------------------  Contracts Related  -----------------------------------------
contracts:
	@echo "Building the contracts..."
	@rm -rf artifacts/contracts
	@npx hardhat compile

deploy:
	@make chain
	@mix stela.deploy stela

hd-contracts:
	@npx hardhat run --network localhost scripts/deploy.js

run-contracts: build-contracts deploy-contracts hdconsole

asm:
	@solc contracts/Stela.sol \
    	--base-path . \
    	--include-path node_modules/ \
    	--asm \
    	-o ./out \
    	--optimize \
    	--optimize-runs=1000

bin:
	@solc contracts/Stela.sol \
    	--base-path . \
    	--include-path node_modules/ \
    	--bin \
    	-o ./out \
    	--optimize \
    	--optimize-runs=1000

# include .makefiles/*.mk


.PHONY: contracts build init travis-init install dep pre-build post-build all test doc precommit travis clean watch run bump-version create-pr submodule build-release
