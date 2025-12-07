use sp1_sdk::{ProverClient, SP1Stdin};

const ELF: &[u8] = include_bytes!("../../../elf/riscv32im-succinct-zkvm-elf");

fn main() {
    let mut stdin = SP1Stdin::new();

    let collateral: u128 = stdin.read();
    let supply: u128     = stdin.read();
    let pending: u128    = stdin.read();

    assert!(collateral >= supply + pending, "Solvency violation");

    let client = ProverClient::new();
    let (pk, vk) = client.setup(ELF);
    let proof = client.prove(&pk, stdin).run().unwrap();

    client.verify(&proof, &vk).unwrap();
}