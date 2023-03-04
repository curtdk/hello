require("@nomicfoundation/hardhat-toolbox");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");
// 0x38d5CEeBE3673E5A81E58c9B0f1096a09eC97131
const ROPSTEN_PRIVATE_KEY = "0c2d8c7abe26557777f19ec1df102337c2ac49fd9b621550509b53713a575059";
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  
  solidity: {
    compilers: [
      {
        version: "0.8.9",
      },
      {
        version: "0.8.13",
      },
      {
        version: "0.8.14",
      },
      {
        version: "0.8.16",
      },
      {
        version: "0.5.0",
      },
      {
        version: "0.5.16",
        settings: {},
      },
    ],
  },
  networks: {
    localhost: {
      url: `http://127.0.0.1:8545`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`]
    }
    ,
    hardhat: {
      chainId: 1337 // We set 1337 to make interacting with MetaMask simpler
    }
    ,
    goerli: {
      url: `https://goerli.infura.io/v3/3318c4f32dbb4bb29fbb8f1f3dba7299`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`]
    }    
  }
};
