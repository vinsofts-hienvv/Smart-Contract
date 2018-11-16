pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Provider.sol";

contract Medicines {

    address public providerContractAddress;
    address public mangerContractAddress;
    address public owner;

    struct Medicine {
        uint id;
        string name; // 
        string ingredient; // include ... 
        string benefit; // uses for, function for 
        string by;
        string detail;
        uint prices;
        bytes32 imgHash;
        uint digitalId;
        bool isAllowed; // id of digitalCertificateId default = 0;
    }

    mapping (address => Medicine[]) medicines;

    function addMedicine() {}
    function editMedicine() {}
    function deleteMedicine() {}
    function hiddenMedicine() {}

    function approveAddMedicine() {}
    function approveEditMedicine() {}
    function approveDeleteMedicine() {}
    
    function randomID(
        string _param1,
        string _pamra2,
        string _param3,
        string _param4,
        uint _param5,
        bytes32 _param6 
    ) 
        private
        view
        returns(uint) 
    {
        uint random = uint(keccak256(
                                    _param1, 
                                    _param2, 
                                    _param3, 
                                    _param4, 
                                    _param5,
                                     _param6, 
                                    msg.sender)) % (10 ** 16);
        return random;
    }

}