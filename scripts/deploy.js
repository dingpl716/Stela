// scripts/deploy.js
async function main() {
  // We get the contract to deploy
  const Stela = await ethers.getContractFactory('Stela');
  console.log('Deploying Stela...');
  const stela = await Stela.deploy();
  await stela.deployed();
  console.log('Stela deployed to:', stela.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
