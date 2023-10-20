const hre = require("hardhat");

async function main() {

    let Owners = [["0xdfAbb4B17a31F67a4e1973d4dc39EFd63571B959",
        "0xAb48E9a9E1Fa7772f589Bad549e3f238061eD109",
        "0x4a5f3c6406079079aCaAdD89A48dd108bB166c74",
        "0xd798F5199354B9fD3e5692D44fA2840B163Ffa9A",
        "0x5Ccf9B609f94f67244D3fbAba9b683DCB29F3073"]];
    const DS = await hre.ethers.deployContract("DataStorage", Owners);

    await DS.waitForDeployment();

    console.log(
        `Data Storage deployed to ${DS.target}`
    );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});