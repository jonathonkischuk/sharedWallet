// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

// import our allowance contract
import "./Allowance.sol";

// extends our allowance contract to our new sharedWallet contract that we are creating here
contract SharedWallet is Allowance {


// we create two new events for the purpose of giving feedback
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);


// this function allows users to withdraw funds, up to and including the full balance amount, and emits the MoneySent event
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough money available.");
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

// this is a fallback function that allows you to send money to the contract and emits the MoneyReceived event
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

}
