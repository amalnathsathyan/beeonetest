// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");


async function main() {

  const erc20 = await hre.ethers.deployContract("BEE");

  await erc20.waitForDeployment();

  const tokenAddress = await erc20.getAddress();

  console.log(
    `BEE Token Deployed To :${tokenAddress}`
  );

  const sale = await hre.ethers.deployContract("SimpleSale",[tokenAddress]);

  await sale.waitForDeployment();

  const saleAddress = await sale.getAddress();

  console.log(
    `Sale Contract Deployed To :${saleAddress}`
  );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
