// SPDX-License-Identifier: MIT

pragma solidity^0.8.4;

import "./Staking.sol";
import "./Reward.sol";

contract TokenFarm {


    // Initial statements
    string public name = "Stellart Token";
    address public owner;
    Staking public staking;
    Reward public reward;

    // Data Structures
    address [] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Builder

    constructor (Staking _staking, Reward_reward) {
        staking = _staking;
        reward = _reward;
        owner = msg.sender;
    }

    // Staks of yhe tokens
    function stakeToken (uint _amount) public {
        // Quantity is required to be greater than zero
        require (_amount > 0, "The amount can't be less than zero");
        // Transfering Jams Token to the main Smart Contract
        staking.transferFrom(msg.sender, address(this), _amount);
        // Update the staking balance
        stakingBalance [msg.sender] += _amount;
        // safe the user
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }  

        // Update staking values
     isStaking[msg.sender] = true;
     hasStaked[msg.sender] = true;

    }

    // Quit stakings from the Tokens
    function unstakeTokens () public {
        // User's staking Blance
        uint balance = stakingBalnce[msg.sender];
        // is required an amount more than zero
        require (balance > 0, "The staking Blance is zero");
        // Transfering the tokens to the user
        staking.transfer(msg.sender, balance);
        // reset stauser's staking balance
        stakingBalance[msg.sender] = 0;
        isStaking = false; 
    }

    // Tokens reward
    function issueToken () public {
        //only be modified by the owner
        require (msg.sender == owner, "You are not the owner");
        //issuencing token to all of the stakers
        for (uint i=0; i<stakers.length; i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance >0 ) {
                reward.transfer(recipient, balance);
            }
        }
    }


     

}