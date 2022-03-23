// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

contract Mystake {
    SilverToken public silverToken;
    GoldToken public goldToken;

    constructor(address _stakingToken, address _rewardsToken) {
        goldToken = GoldToken(_stakingToken);
        silverToken = SilverToken(_rewardsToken);
    }
    function stakeTokens(uint _amount) public {

		require(_amount > 0, "amount cannot be 0");

		goldToken.transferFrom(msg.sender, address(this), _amount);

	}

}

interface GoldToken {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface SilverToken {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}