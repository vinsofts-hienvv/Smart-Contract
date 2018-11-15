pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";
import "./Provider.sol";

contract Medicine {

    Provider provier;
    struct Medicine {
        uint medicineId;
        string medicineName; // 
        string ingredient; // include ... 
        string benefit; // uses for, function for 
        string productsBy;
        string detail;
        uint prices;
        bytes32 imgHash;
        uint digitalId; // id of digitalCertificateId default = 0;
        bool status; 
    }

    Medicine[] public medicines;

    mapping(address => uint[]) public mpGetMedicineIndexByAddress;
    mapping(address => mapping(uint => bool)) public mpIsProviderOf;

    modifier isUnLocked(address _providerContract) {
        bool isLocked = provier(_address).isLockedProvider();
        require(!isLocked);
        _;
    }

    modifier isProviderOf(uint _index) {
        require(mpIsProviderOf[msg.sender][_index]);
        _;
    } 

    function getAllMedicines() public view returns(Medicine[]) {
        return medicines; // get all medicine infor
    }

    function getAllMedicinesValid() public view returns(Medicine[]) {
        Medicine[] memory _medicine = new Medicine[](medicines.length);
        uint index = 0;
        for(uint i = 0; i < medicines.length; i++) {
            if(medicines[i].status == true) {
                _medicine[index] = medicines[i];
                index++;
            }
        }
        return _medicine;
    }

    function getAllMedicinesNotValid() public view returns(Medicine[]) {
        Medicine[] memory _medicine = new Medicine[](medicines.length);
        uint index = 0;
        for(uint i = 0; i < medicines.length; i++) {
            if(medicines[i].status == false) {
                _medicine[index] = medicines[i];
                index++;
            }
        }
        return _medicine;
    }

    function getMedicineByIndex(uint _index)
        public
        view 
        returns(Medicine)
    {
        return medicines[_index];
    }
    
    function getMedinces(uint[] _index) public view returns(Provider[]) {
        uint[] memory _medicine = new uint[](_index.length);
        for(uint i = 0; i < _index.length; i++) {
            _medicine[i] = medicines[_index[i]];
        }

        return _medicine;
    } // get medicne by index

    function insertMedicine(
        string _name,
        string _ingredient,
        string _benefit,
        string _product,
        string _detail,
        uint _prices,
        bytes32 _imgHash,
        uint _digitalId,
        address _providerContract
    )
        public 
        isUnLocked(_providerContract)
        returns(bool) 
    {
        uint _index = medicines.push(medicines.length, _name, _ingredient, _benefit, _product, _detail, _prices, _imgHash, _digitalId, false) - 1;
        mpGetMedicineIndexByAddress[msg.sender].push(_index);
        isProviderOf[_index] = true;
    }

    function deleteMedicine(uint _index, address _providerContract) 
        public
        isProviderOf(_index)
        isUnLocked(_providerContract)
        returns(bool)
    {
        medicines[_index].status = false;
        return true;
    }

    function updateMedicine(
        string _name,
        string _ingredient,
        string _benefit,
        string _product,
        string _detail,
        uint _prices,
        bytes32 _imgHash,
        uint _index,
        address _providerContract
    )   
        public
        isProviderOf(_index)
        isUnLocked(_providerContract)
        returns(bool)
    {
        medicines[_index].medicineName = _name;
        medicines[_index].ingredient = _ingredient;
        medicines[_index].benefit = _benefit;
        medicines[_index].productsBy = _product;
        medicines[_index].detail = _detail;
        medicines[_index].prices = _prices;
        medicines[_index].imgHash = _imgHash;
        return true;
    }
    




}