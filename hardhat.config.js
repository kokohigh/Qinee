require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    localhost:{
      url:'HTTP://127.0.0.1:7545',
      accounts: [
        `0x615d9487341775269de2265aa5b1b8c8caa12ced7de47449ab4c0760274f0fb5`,
      ],
    }
  }
};
