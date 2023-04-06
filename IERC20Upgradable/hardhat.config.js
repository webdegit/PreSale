require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");

/** @type import('hardhat/config').HardhatUserConfig */
require("dotenv").config();

const TESTNET_PRIVATE_KEY = process.env.TESTNET_PRIVATE_KEY;
const BSC_API_KEY = process.env.BSC_API_KEY;
const License = ('MIT');
module.exports = {
  solidity: {
    version: "0.8.15",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://bscscan.com/
    apiKey: BSC_API_KEY,
  },

  defaultNetwork: "bsctestnet",
  // defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      accounts: [TESTNET_PRIVATE_KEY],
      gas: "auto",
      gasPrice: 10000000000,
    },
    
  },
};
