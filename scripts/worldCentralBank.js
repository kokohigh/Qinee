const hre = require("hardhat");

async function main() {

  const ds = ["0x612cA52A6C4193efdb7aB29d7738894208CD9903"];
  const WCB = await hre.ethers.deployContract("WorldCentralBank",ds);

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