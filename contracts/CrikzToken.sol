// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrikzToken {
    string public constant name = "Crikz Native ETH";
    string public constant symbol = "crikzETH";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    address public immutable vault;

    constructor(address _vault) { vault = _vault; }

    function mint(address to, uint256 amount) external {
        require(msg.sender == vault, "Only vault");
        totalSupply += amount;
        balanceOf[to] += amount;
    }
}