// scripts/deploy.js
async function main() {
  // We get the contract to deploy
  const Stele = await ethers.getContractFactory('Stele');
  console.log('Deploying Stele...');
  const stele = await Stele.deploy();
  await stele.deployed();
  console.log('Stele deployed to:', stele.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
