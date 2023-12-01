require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-solhint");
const dotenv = require('dotenv');

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
    {
      version: '0.8.20'
    },
    {
      version: '0.8.0'
    },]
  },

  networks: {
    hardhat: {
      forking: {
        url: process.env.IFURA_SEPOLIA_URL,
        accounts: [process.env.PRIVATE_KEY],
      }
    },
    sepolia: {
        url: process.env.IFURA_SEPOLIA_URL,
        accounts: [process.env.PRIVATE_KEY],
      }
    },
  mocha:{
    timeout:600000
  }
  }