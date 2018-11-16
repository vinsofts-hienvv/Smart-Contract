pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

contract DigitalCertificates {
    struct DigitalCertificate{
        uint id;
        string contents;  // contents
        uint dateOf;
        string by;
        address addr;
        bool isLock;
    }

    mapping(address => DigitalCertificate[]) digitalcertificates;
    function addDigitalCertificate() {}
    function editDigitalCertificate() {}
    function approveAddDigitalCertificate() {}
    function approveEditeCertificate() {}

}
