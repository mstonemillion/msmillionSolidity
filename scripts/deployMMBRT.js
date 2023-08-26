// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  const MLM = await hre.ethers.getContractFactory("MSMILLION", deployer);
  console.log("Deploying MSMILLION with the account:", deployer.address);
  const mlm = await MLM.deploy({
    name: "MilestoneMillions",
    symbol: "MSMILLIONV4",
    routerAddress: "0x9F90708cFd5e36C74c14c706b27154dcbb7Ce7d9",
    operationalFeeReceiver: "0x6294A3c8a318Be92919fC8dDC1D0FEa8C869e72E",
    maxPercentageForWallet: 5,
    maxPercentageForTx: 1,
    feesToSwapPercentage: 2,
    liquidityFeeRate: 3,
    operationalFeeRate: 2,
    totalSupply: 500000000,
  });

  console.log(`MLM deployed to ${mlm.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
