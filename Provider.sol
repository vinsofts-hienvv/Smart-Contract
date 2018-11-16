pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";

contract Providers is Owner {
    address public mangerContractAddress;
    address[] public providerAddress;
    struct Provider {
        address addr;
        string name;
        string street;
        string phone;
        bytes32 imgHash;
        bool isActive;
    }

    mapping (address => Provider) public provider; // key address is msg.sender  
    mapping (address => Provider) public providerUpdating; 
        // waiiting for change value

    function signUpProvider() {}
    function updateProvider() {}
    function blockProvider() {}
    function approveProvider() {}
}