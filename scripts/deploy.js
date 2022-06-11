// scripts/deploy.js

const minute = 60;
const baseURI = "https://stela.io/";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Stela = await ethers.getContractFactory('Stela');
  console.log('Deploying Stela...');
  const stela = await Stela.deploy(minute * 5, baseURI);
  await stela.deployed();
  console.log('Stela deployed to:', stela.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
