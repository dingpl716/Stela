# nft_news

### Data for testing

Miner
- address: `0x9174d70d98093d57234287c48731a8a2b9e11277`
  
Rich Account
- address: `0xfb597fa80538b61c1be2434b0dcdc73df06d4a82`
- private key: `0x9f815bb1f5de9cf240235b3e54839dcf6673bb48a2cfbeecda14613f1ea48765`


## Init/Install

```shell
# install hardhat
npm install --save-dev hardhat

# install openzeppelin contracts so that you can reference them to.
npm install --save-dev @openzeppelin/contracts

# install ethers, a Ethereum wallet and utility implementation
npm install --save-dev @nomiclabs/hardhat-ethers ethers

# Create an empty config file for later use.
npx hardhat 

# Run a node that uses instant seal.
npx hardhat node

# Build your contracts
make contracts
```

```javascript
const [deployer, alice, bob, charley, david] = await ethers.getSigners()
const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
const Stela = await ethers.getContractFactory('Stela');
const stela = await Stela.attach(contractAddress);

// In the console you will send transaction using `deployer` by default,
// if you want to send transaction with another wallet, you need to `connect`
// to the `Contract` with the method being executed, for example:

await stela.connect(alice).setApprovalForAll(charley.address, true);

```
