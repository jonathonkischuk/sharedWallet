// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;


// import the ownable contract from the OpenZeppelin github account
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// create new contact and extend the Ownable functionality and create isOwner function to set owner to msg.sender
contract Allowance is Ownable {
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }


// create an event for feedback purposes and a mapping to keep track of who has what balance
    event allowanceChanged(address indexed _forWho, address indexed _byWho, uint _oldAmount, uint _newAmount);
    mapping(address => uint) public allowance;

// this function has the msg.sender sending funds to another wllet for them to use
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit allowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

// this modifier makes it so that either the owner or any sender with enough funds can do something
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed.");
        _;
    }

// this reduces the allowance by a set amount, and uses the above modifier to avoid any issues.
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit allowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }

}
