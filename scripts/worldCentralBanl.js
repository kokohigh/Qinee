const hre = require("hardhat");

async function main() {

  const WCB = await hre.ethers.deployContract("WorldCentralBank");

  await WCB.waitForDeployment();

  console.log(
    `World central bank deployed to ${WCB.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});