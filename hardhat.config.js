require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    localhost:{
      url:'HTTP://127.0.0.1:7545',
      accounts: [
        `16bce92e23b084453dacec396d2a2c9af3cca30027de9eec9198895748279999`,
      ],
    }
  }
};
