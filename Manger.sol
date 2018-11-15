pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";

contract Manger is Owner {

    struct Manger{
        uint id; 
        string name;
        string street;
        string department;
        string detail;
        bytes32 imgHash;
        bool status;
    }

    Manger public mangers;
    Manger tempMangers;

    mapping(address => bool) public mpIsManger;
    mapping(address => uint) public mpGetMangerIndexByAddress;

    modifier isManger() {
        require(mpIsManger[msg.sender]);
        _;
    }

    modifier mangerNotExists(address _address) {
        require(!mpIsManger[_address]);
        _;
    }

    function getIsManger() public returns(bool) {
        return mpIsManger[msg.sender];
    }

    function getAllMangers() public view returns(Manger[]) {
        return mangers;
    }

    function getMangerByIndex(uint _index)
        public
        view
        returns(Manger)
    {
        return mangers[_index];
    }

    function getMangers(uint[] _index) public view returns(Manger[]) {
        uint[] memory _manger = new uint[](_index.length);
        for(uint i = 0; i < _index.length; i++) {
            _manger[i] = mangers[_index[i]];
        }
        return _manger;
    } 

    function insertManger(
        address _address,
        string _name,
        string _street,
        string _department,
        string _detail,
        bytes32 _imgHash
    )
        public
        onlyOwner
        mangerNotExists(_address)
        returns(bool)
    {
        uint index = mangers.push(Manger(mangers.length, _name, _street, _department, _detail, _imgHash, true));
        mpGetMangerIndexByAddress[_address] = index;
        mpIsManger[msg.sender] = true;
        return true;
    }

    function insertMangerNotOwner(
        address _address,
        string _name,
        string _street,
        string _department,
        string _detail,
        bytes32 _imgHash
    )
        public
        mangerNotExists(_address)
        isManger
        returns(bool)
    {
        tempMangers.push(Manger(mangers.length, _name, _street, _department, _detail, _imgHash, false));
        return true;
    }

    function getlistMangerForAccept()
        public
        isManger
        return(Manger[]) 
    {
        return tempMangers;
    }

}