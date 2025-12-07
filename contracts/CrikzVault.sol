// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ISP1Verifier {
    function verifyProof(
        bytes32 vkey,
        bytes calldata publicValues,
        bytes calldata proof
    ) external view returns (bool);
}

contract CrikzVault is ReentrancyGuard {
    address public immutable VERIFIER;
    bytes32 public immutable PROGRAM_VKEY;

    mapping(address => uint256) public balanceOf;
    mapping(bytes32 => bool)    public usedProofs;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount, bytes32 proofId);

    constructor(address _verifier, bytes32 _vkey) {
        require(_verifier != address(0), "Invalid verifier");
        VERIFIER = _verifier;
        PROGRAM_VKEY = _vkey;
    }

    receive() external payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        uint256 amount,
        bytes32 publicValuesHash,
        bytes calldata proof
    ) external nonReentrant {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        bytes32 proofId = keccak256(abi.encode(msg.sender, amount, publicValuesHash, proof));
        require(!usedProofs[proofId], "Proof replay");

        bool valid = ISP1Verifier(VERIFIER).verifyProof(
            PROGRAM_VKEY,
            abi.encode(publicValuesHash),
            proof
        );
        require(valid, "Invalid SP1 proof");

        usedProofs[proofId] = true;
        balanceOf[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount, proofId);
    }
}