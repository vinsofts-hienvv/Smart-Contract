pragma solidity ^0.4.25;

contract Owner {

    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isNotOwner(address _addr) {
        require(_addr != owner);
    }
    
    event TransferOwnerShip(address indexed from, address indexed to);
    
    constructor () public {
        owner = msg.sender;
    }
    
    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
}