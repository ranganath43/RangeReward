pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
	string public name = "Dapp Token Form";
	address public owner;
	DappToken public dappToken;
	DaiToken public daiToken;

	address[] public stakers;
	mapping(address => uint) public stakingBalance;
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;

	constructor(DappToken _dappToken, DaiToken _daiToken) public {

		dappToken = _dappToken;
		daiToken = _daiToken;
		owner = msg.sender;
	}

	//1. stake tokens(Deposit)

	function stakeTokens(uint _amount) public {

		//Require amount greater than 0
		require(_amount > 0, "amount cannot be 0");

		// Transfer Mock Dai tokens to this contract for staking
		daiToken.transferFrom(msg.sender, address(this), _amount);

		// update staking balance
		stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

		// Add user to stakers array *only* if they haven't staked already
		if(!hasStaked[msg.sender]) {
			stakers.push(msg.sender);
		}

		//Update staking status
		isStaking[msg.sender] = true;
		hasStaked[msg.sender] = true;

	}

	//2. unstake tokens(withdraw)

	function unstakeTokens() public {
		//fetch staking balance
		uint balance =stakingBalance[msg.sender];

		//require amount greater than 0
		require(balance > 0, "staking balance cannot be 0");

		//transfer Mock Dai tokens to this contract for  staking
		daiToken.transfer(msg.sender, balance);

		//reset stakig balance
		stakingBalance[msg.sender] = 0;

		//update staking status
		isStaking[msg.sender] = false;

	}

	//3.issue tokens

	function issueTokens() public {
		// only owner call this function
		require(msg.sender == owner, "caller must be the owner");

		//issue tokens to all stakers
		for (uint i=0; i<stakers.length; i++) {
			address recipient = stakers[i];
			uint balance = stakingBalance[recipient];
			if(balance > 0) {
				dappToken.transfer(recipient, balance);
			}
		}
	}
}