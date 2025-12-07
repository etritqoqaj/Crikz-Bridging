import { ethers } from "hardhat";

async function main() {
  const Vault = await ethers.deployContract("CrikzVault");
  await Vault.waitForDeployment();
  console.log("CrikzVault deployed →", await Vault.getAddress());

  await (await ethers.getSigner()).sendTransaction({
    to: await Vault.getAddress(),
    value: ethers.parseEther("1")
  });
  console.log("1 ETH deposited — Crikz Bridge is alive");
}

main();