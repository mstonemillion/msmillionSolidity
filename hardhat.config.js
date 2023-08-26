require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomicfoundation/hardhat-verify");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    "bitrock-testnet": {
      url: "https://testnet.bit-rock.io",
      accounts: process.env.BITROCK_TEST_DEPLOYER_KEY,
      gasPrice: 1000000000,
    },
  },
  etherscan: {
    apiKey: {
      "bitrock-testnet": "PLACEHOLDER_STRING",
    },
    customChains: [
      {
        network: "bitrock-testnet",
        chainId: 7771,
        urls: {
          apiURL: "https://testnet.bit-rock.io",
          browserURL: "https://testnetscan.bit-rock.io",
        },
      },
    ],
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
};
