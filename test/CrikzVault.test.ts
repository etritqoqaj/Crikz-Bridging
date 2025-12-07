// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/CrikzVault.sol";

contract CrikzVaultTest is Test {
    CrikzVault vault;

    function setUp() public {
        vault = new CrikzVault(address(1), bytes32(0));
    }

    function testDeposit() public {
        vm.deal(address(this), 1 ether);
        payable(address(vault)).transfer(1 ether);
        assertEq(address(vault).balance, 1 ether);
    }

    function testWithdrawRequiresProof() public {
        vm.expectRevert();
        vault.withdraw(1, bytes32(0), "");
    }
}