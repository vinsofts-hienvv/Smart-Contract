pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";
import "./Manger.sol";

contract Provider is Owner {

    Manger manger;
    struct Provider{
        uint providerId;
        string providerName;
        string providerAddress;
        string providerTelephone;
        bytes32 imgHash;
        bool status;
    }

    modifier isLocked() {
        require(isLocked[msg.sender]);
        _;
    }

    modifier isUnlocked() {
        require(!isLocked[msg.sender]);
        _;
    }

    modifier isManger(address _manger) {
        bool _isManger = manger(_manger).getIsManger();
        require(_isManger);
        _;
    }

    function isLockedProvider() public returns(bool) {
        return isLocked[msg.sender];
    }
    // mapping(address => bool) public isProvider;
    mapping(address => uint[]) public mpAddressToListProvider;
    mapping(address => bool) public isLock;

    Provider[] public providers;

    function getAllProviders() public view returns(Provider[]) {
        return providers;
    }

    function getProviderById(uint _index) public view returns(Provider) {
        return providers[_index];
    }

    function getProviders(uint[] _index) public view returns(Provider[]) {
        uint[] memory _pro = new uint[](_index.length);
        for(uint i = 0; i < _index.length; i++) {
            _pro[i] = providers[_index[i]];
        }

        return _pro;
    }

    function insertProvider(
        string _name,
        string _address,
        string _phone,
        bytes32 _imgHash
    )
        public
        isManger
        returns(bool) 
    {
        uint _index = providers.push(Provider(providers.length, _name, _address, _phone, _imgHash, false)) - 1;
        isLock[msg.sender] = true;
        mpAddressToListProvider[msg.sender].push(_index);
        return true;
    }

    function deleteProVider(uint _index)
        public 





}