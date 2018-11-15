pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

import "./Owner.sol";

contract DigitalCertificate is Owner {
    //giay chung nhan
    struct DigitalCertificate{
        uint id;
        string contents;  // contents
        uint dateOf;
        string by;
        bool status;
    }

    DigitalCertificate public digitalCertificates;

    function getAllMedicines() public view returns(DigitalCertificate[]) {
        return digitalCertificates; // get all medicine infor
    }

    function getMedicineByIndex(uint _index)
        public
        view 
        returns(DigitalCertificate)
    {
        return digitalCertificates[_index];
    }
    
    function getMedinces(uint[] _index) public view returns(DigitalCertificate[]) {
        uint[] memory _digital = new uint[](_index.length);
        for(uint i = 0; i < _index.length; i++) {
            _digital[i] = digitalCertificates[_index[i]];
        }
        return _digital;
    }

    function insertDigitalCertificate(
        string _content,
        address _manger
    )
        public 
        returns(bool) 
    {
        
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