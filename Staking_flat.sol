
// File: contracts/SolidityByExample/mRange.sol


pragma solidity ^0.8.10;
contract mRange {

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    string public constant name = "mRange";
    string public constant symbol = "MRNG";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) {
      totalSupply_ = total;
      balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view returns (uint256) {
      return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
// File: contracts/SolidityByExample/Range.sol


pragma solidity ^0.8.10;
contract Range {

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    string public constant name = "Range";
    string public constant symbol = "RNG";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) {
      totalSupply_ = total;
      balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view returns (uint256) {
      return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
// File: contracts/SolidityByExample/Staking.sol


pragma solidity ^0.8.10;



contract TokenForm {
	string public name = "Range Token Farm";
	address public owner;
	Range public rangeToken;
	mRange public mRangeToken;

	address[] public stakers;
	mapping(address => uint) public stakingBalance;
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;

	constructor(Range _range, mRange _mRange) {

		rangeToken = _range;
		mRangeToken = _mRange;
		owner = msg.sender;
	}

	//1. stake tokens(Deposit)

	function stakeTokens(uint _amount) public {

		//Require amount greater than 0
		require(_amount > 0, "amount cannot be 0");

		// Transfer Mock Dai tokens to this contract for staking
		rangeToken.transferFrom(msg.sender, address(this), _amount);

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
		rangeToken.transfer(msg.sender, balance);

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
				mRangeToken.transfer(recipient, balance);
			}
		}
	}
}