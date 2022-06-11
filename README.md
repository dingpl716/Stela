# Stela

### Data for testing

Miner
- address: `0x9174d70d98093d57234287c48731a8a2b9e11277`
  
Rich Accounts
- address: `0xfb597fa80538b61c1be2434b0dcdc73df06d4a82`
- private key: `0x9f815bb1f5de9cf240235b3e54839dcf6673bb48a2cfbeecda14613f1ea48765`

- address: `0x3a6b394826d37d44907881d687800bfe59dd70ea`
- private key: `0x81c8094c8195c8a65634bc963c0283355915d3c70ffe9127c891170ebffdc819`

- address: `0xb4fe85f018f529e82310f0177d5e89e262e02987`
- private key: `0x2c7aba90a5f1ea4cc4e1fca76b0ea7b99132bdb581150aa6071f0c6e1d6f07aa`

- address: `0x1232e790af68e71025b911823e2d01a5c2496354`
- private key: `0xe86362dac584359a9effa2ac024123d1fc8657ce3a50e4ae1e1ad266385e710e`

- address: `0xddd410783d3d9db3acc7143b6b4328e192479d6d`
- private key: `0xdeb6538f9e3a0d6d78caa0c1fa3515d93f5f5090ff3de9638305b211ad7a4d46`

- address: `0xa6c92a1323ac73c9f1219407d12b4c525cc767a9`
- private key: `0x601dfc85ec19a0b9c84f2827f0b8ff560e8eecece08ac10ac7bb2cbdea6ef24f`

- address: `0xe206caad25e906f22fd87ae93d07e389862db252`
- private key: `0xdfb245ac29efc2134241dd08d135b2fa60ff4330b424c2b14e32dda08a9cc1af`

- address: `0x1eccc2067472c8b878ca6b3618b0d40b36020857`
- private key: `0x5017a2a045df37570636d3620680c1218928d70eccbfadff0fbe56375896181b`

- address: `0x7cfaf1172df6e1f01d1b439ad804f818a094708f`
- private key: `0xf63501c13438340daaec6403e0e3514d4ec32a47dda96b73ded978eb769d3866`

- address: `0x126c416f14039975b48099492cad947edad3b910`
- private key: `0x91eea7a6a54fba8c153d43edacddbde4cb07c93dfab1edba61d2199921852e72`













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
const stelaAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
const Stela = await ethers.getContractFactory('Stela');
const stela = await Stela.attach(stelaAddress);
await stela.startAuction(1, 10, 1000);

const auctionAddress = await stela.getAuction();
const Auction = await ethers.getContractFactory('SimpleAuction');
const auction = await Auction.attach(auctionAddress);

// In the console you will send transaction using `deployer` by default,
// if you want to send transaction with another wallet, you need to `connect`
// to the `Contract` with the method being executed, for example:

await stela.connect(alice).setApprovalForAll(charley.address, true);

```

## Securities

Here are some points to think about when doing tests:
1. Would startAuction / endAuction be stuck somehow. If this happens, the whole contract is stuck.
