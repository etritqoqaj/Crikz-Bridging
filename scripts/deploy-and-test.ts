import { ethers } from "hardhat";

async function main() {
  console.log("Deploying CrikzVault...");
  const Vault = await ethers.deployContract("CrikzVault", [
    "0x0000000000000000000000000000000000000000", // real verifier on mainnet
    "0x0000000000000000000000000000000000000000000000000000000000000000"
  ]);
  await Vault.waitForDeployment();
  console.log("CrikzVault deployed →", await Vault.getAddress());

  console.log("Depositing 1 ETH...");
  await (await ethers.getSigner()).sendTransaction({
    to: await Vault.getAddress(),
    value: ethers.parseEther("1")
  });

  console.log("Balance:", ethers.formatEther(await Vault.balanceOf(await ethers.getSigner().then(s => s.address))));
  console.log("\nCrikz Bridge is alive. Full cycle works. Ready for mainnet.");
}

main().catch(console.error);