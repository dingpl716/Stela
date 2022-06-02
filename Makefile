TOP_DIR=.
NFT_NEWS_HOME=${TOP_DIR}

build:
	@echo "Building the software..."
	# @rm -rf _build/dev/lib/{ocap_rpc,abi}
	@make format

format:
	@mix compile; mix format;

init: submodule install dep
	@echo "Initializing the repo..."

install:
	@echo "Install software required for this repo..."
	@mix local.hex --force
	@mix local.rebar --force

dep:
	@echo "Install dependencies required for this repo..."
	@mix deps.get

test:
	@echo "Running test suites..."
	@MIX_ENV=test mix test

clean:
	@echo "Cleaning the build..."
	@rm -rf _build
	@rm -rf .elixir_ls
	@rm -rf deps

run:
	@echo "Running the software..."
	@iex -S mix

chain:
	@echo "Running parity chain..."
	@openethereum --config resources/parity/config.toml

rebuild-deps:
	@rm -rf mix.lock; rm -rf deps/utility_belt;
	@make dep

# NFT realated commands

run-node:
	@npx hardhat node

build-contracts:
	@echo "Building the contracts..."
	@npx hardhat compile

deploy-contracts:
	@npx hardhat run --network localhost scripts/deploy.js

hdconsole:
	@npx hardhat console --network localhost

run-contracts: build-contracts deploy-contracts hdconsole

# include .makefiles/*.mk


.PHONY: contracts build init travis-init install dep pre-build post-build all test doc precommit travis clean watch run bump-version create-pr submodule build-release
