pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

contract Owner {
    address public owner;

    event TransferOwnerShip(address indexed from, address indexed to);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor () public {
        owner = msg.sender;
    }
    
    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
}

contract Authorised is Owner {
    address[] public owners;
    mapping(address => bool) authorised;
    uint8 maxAuthorisedNumber = 10;
    uint8 totalRequired = 6;

    struct Transaction {
        uint identifier;
        address From;
        uint value;
        uint8 numberOfComfirmed;
        uint8 Type;
    }

    mapping(uint => Transaction) transactions;
    mapping(uint => mapping(address => bool)) comfirmations;
    uint transactionCount;

    modifier onlyAuthorised() {
        require(authorised[msg.sender]);
        _;
    }

    modifier validRequirement(
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) {
        require(_totalRequired < _maxAuthoriseNumber && _totalRequired != 0 && _maxAuthoriseNumber != 0);
        _;
    }

    modifier transactionExists(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.From != 0x0);
        _;
    }

    modifier notConfirmed(uint _identifier, address _owner) {
        require(!comfirmations[_identifier][_owner]);
        _;
    }

    modifier notExecuted(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.numberOfComfirmed < totalRequired);
        _;
    }

    constructor(
        address[] _owners,
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) validRequirement(_maxAuthoriseNumber, _totalRequired) 
    public {
        require(_owners.length <= _maxAuthoriseNumber);
        maxAuthorisedNumber = _maxAuthoriseNumber;
        totalRequired = _totalRequired;
        for(uint i = 0; i < _owners.length; i++) {
            owners[i] = _owners[i];
            authorised[_owners[i]] = true;
        }
    }

    function authorisedAccount(
        address _owner
    ) onlyOwner public {
        address[] memory _owners = getTotalAuthoried();
        require(_owners.length <= maxAuthorisedNumber);
        require(!authorised[_owner]);
        owners.push(_owner);
        authorised[_owner] = true;
    }

    function authorisedManyAccount(
        address[] _owners
    ) onlyOwner public {
        address[] memory _owners1 = getTotalAuthoried();
        require((_owners.length + _owners1.length) <= maxAuthorisedNumber);
        for(uint8 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            authorised[_owners[i]] = true;
        } 
    }

    function blockAccount(
        address _owner
    ) onlyOwner public {
        require(authorised[_owner]);
        authorised[_owner] = false;
    }

    function blockManyAccount(
        address[] _owners
    ) onlyOwner public {
        for(uint8 i = 0; i < _owners.length; i++) {
            if(authorised[_owners[i]]) {
                authorised[_owners[i]] = false;
            }
        }
    }

    function getTotalAuthoried() public view returns(address[] _owners) {
        uint count = 0;
        for(uint i = 0; i < owners.length; i++) {
            if(authorised[owners[i]]) {
                _owners[count] = _owners[i];
                count += 1;
            }
        }

        return _owners;
    }

    function submitTransaction(
        uint _identifier, 
        address _from, 
        uint _value,
        uint8 _type
    ) public {
        Transaction memory _trans = Transaction({
            identifier: _identifier,
            From: _from,
            value: _value,
            numberOfComfirmed: 0,
            Type: _type
        });
        transactions[transactionCount] = _trans;
        transactionCount += 1;
    }

    function confirmedTransaction(
        uint _identifier
    ) 
        transactionExists(_identifier)
        notConfirmed(_identifier, msg.sender) 
        notExecuted(_identifier)
        onlyAuthorised() 
        public 
    {
        Transaction storage _trans = transactions[_identifier];
        _trans.numberOfComfirmed += 1;

        if(_trans.numberOfComfirmed >= totalRequired) {
            if(_trans.Type == 1) { // approve provider
                // Provider storage _provider = Provider.at(_trans.from);
            }else if(_trans.Type == 2) { // approve medecine
                // Medecine storage _medecine = Medecine.at(_trans.from);
            }else if(_trans.Type == 3) { //approve certificate
                // Certificate storage _certificate = Certificate.at(_trans.from);
            }
        }
    }

    function isExecuted(
        uint _identifier
    ) public view returns(bool) {
        Transaction storage _trans = transactions[_identifier];
        if(_trans.numberOfComfirmed >= totalRequired) {
            return true;
        }

        return false;
    }

    function getTransactionInfomation(
        uint _identifier
    ) public view returns(Transaction _trans) {
        _trans = transactions[_identifier];
        return _trans;
    }

    function getTransactionIds(
        uint _from,
        uint _to,
        bool _pending,
        bool _executed
    ) public view returns(uint[] _transactionIds) {
        require(_from < _to);
        uint[] memory _transactionTempIds = new uint[](transactionCount);
        uint count = 0;
        uint i;
        for(i = 0; i < transactionCount; i++) {
            if(_pending && !isExecuted(i) || _executed && isExecuted(i)) {
                _transactionTempIds[count] = i;
                count += 1;
            }
        }

        for(i = _from; i < _to; i++) {
            _transactionIds[i - _from] = _transactionTempIds[i];
        }

        return _transactionIds;
    }

    function getTransactionsConfirmedBy(
        address _from
    ) public view returns(uint[] _transactionsIds) {
        uint[] memory _transactionTempIds = new uint[](transactionCount);
        uint count = 0;
        uint i;
        for(i = 0; i < transactionCount; i++) {
            _transactionTempIds[count] = i;
            count += 1;
        }

        for(i = 0; i < count; i++) {
            if(comfirmations[_transactionTempIds[i]][_from]) {
                _transactionsIds[i] = _transactionTempIds[i];
            }
        }

        return _transactionsIds;    
    }

    function getConfirmations(
        uint _identifier
    ) public view returns(address[] _confirmations) {
        address[] memory _owners = new address[](owners.length);
        uint count = 0;
        uint i;
        for(i = 0; i < owners.length; i++) {
            if(comfirmations[_identifier][owners[i]]) {
                _owners[count] = owners[i];
                count++;
            }
        }

        for(i = 0; i < count; i++) {
            _confirmations[i] = _owners[i];
        }

        return _confirmations;
    }
}

contract Provider is Owner {

}

contract Medecine {

}

contract Cetificate {

}
pragma solidity ^0.4.25;
pragma  experimental ABIEncoderV2;

contract Owner {
    address public owner;

    event TransferOwnerShip(address indexed from, address indexed to);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor () public {
        owner = msg.sender;
    }
    
    function transferOwnerShip(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        owner = newOwner;
        emit TransferOwnerShip(msg.sender, owner);
    }
}

contract Authorised is Owner {
    address[] public owners;
    mapping(address => bool) authorised;
    uint8 maxAuthorisedNumber = 10;
    uint8 totalRequired = 6;

    struct Transaction {
        uint identifier;
        address From;
        uint value;
        uint8 numberOfComfirmed;
        uint8 Type;
    }

    mapping(uint => Transaction) transactions;
    mapping(uint => mapping(address => bool)) comfirmations;
    uint transactionCount;

    modifier onlyAuthorised() {
        require(authorised[msg.sender]);
        _;
    }

    modifier validRequirement(
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) {
        require(_totalRequired < _maxAuthoriseNumber && _totalRequired != 0 && _maxAuthoriseNumber != 0);
        _;
    }

    modifier transactionExists(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.From != 0x0);
        _;
    }

    modifier notConfirmed(uint _identifier, address _owner) {
        require(!comfirmations[_identifier][_owner]);
        _;
    }

    modifier notExecuted(uint _identifier) {
        Transaction storage _trans = transactions[_identifier];
        require(_trans.numberOfComfirmed < totalRequired);
        _;
    }

    constructor(
        address[] _owners,
        uint8 _maxAuthoriseNumber, 
        uint8 _totalRequired
    ) validRequirement(_maxAuthoriseNumber, _totalRequired) 
    public {
        require(_owners.length <= _maxAuthoriseNumber);
        maxAuthorisedNumber = _maxAuthoriseNumber;
        totalRequired = _totalRequired;
        for(uint i = 0; i < _owners.length; i++) {
            owners[i] = _owners[i];
            authorised[_owners[i]] = true;
        }
    }

    function authorisedAccount(
        address _owner
    ) onlyOwner public {
        address[] memory _owners = getTotalAuthoried();
        require(_owners.length <= maxAuthorisedNumber);
        require(!authorised[_owner]);
        owners.push(_owner);
        authorised[_owner] = true;
    }

    function authorisedManyAccount(
        address[] _owners
    ) onlyOwner public {
        address[] memory _owners1 = getTotalAuthoried();
        require((_owners.length + _owners1.length) <= maxAuthorisedNumber);
        for(uint8 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            authorised[_owners[i]] = true;
        } 
    }

    function blockAccount(
        address _owner
    ) onlyOwner public {
        require(authorised[_owner]);
        authorised[_owner] = false;
    }

    function blockManyAccount(
        address[] _owners
    ) onlyOwner public {
        for(uint8 i = 0; i < _owners.length; i++) {
            if(authorised[_owners[i]]) {
                authorised[_owners[i]] = false;
            }
        }
    }

    function getTotalAuthoried() public view returns(address[] _owners) {
        uint count = 0;
        for(uint i = 0; i < owners.length; i++) {
            if(authorised[owners[i]]) {
                _owners[count] = _owners[i];
                count += 1;
            }
        }

        return _owners;
    }

    function submitTransaction(
        uint _identifier, 
        address _from, 
        uint _value,
        uint8 _type
    ) public {
        Transaction memory _trans = Transaction({
            identifier: _identifier,
            From: _from,
            value: _value,
            numberOfComfirmed: 0,
            Type: _type
        });
        transactions[transactionCount] = _trans;
        transactionCount += 1;
    }

    function confirmedTransaction(
        uint _identifier
    ) 
        transactionExists(_identifier)
        notConfirmed(_identifier, msg.sender) 
        notExecuted(_identifier)
        onlyAuthorised() 
        public 
    {
        Transaction storage _trans = transactions[_identifier];
        _trans.numberOfComfirmed += 1;

        if(_trans.numberOfComfirmed >= totalRequired) {
            if(_trans.Type == 1) { // approve provider
                // Provider storage _provider = Provider.at(_trans.from);
            }else if(_trans.Type == 2) { // approve medecine
                // Medecine storage _medecine = Medecine.at(_trans.from);
            }else if(_trans.Type == 3) { //approve certificate
                // Certificate storage _certificate = Certificate.at(_trans.from);
            }
        }
    }

    function isExecuted(
        uint _identifier
    ) public view returns(bool) {
        Transaction storage _trans = transactions[_identifier];
        if(_trans.numberOfComfirmed >= totalRequired) {
            return true;
        }

        return false;
    }

    function getTransactionInfomation(
        uint _identifier
    ) public view returns(Transaction _trans) {
        _trans = transactions[_identifier];
        return _trans;
    }

    function getTransactionIds(
        uint _from,
        uint _to,
        bool _pending,
        bool _executed
    ) public view returns(uint[] _transactionIds) {
        require(_from < _to);
        uint[] memory _transactionTempIds = new uint[](transactionCount);
        uint count = 0;
        uint i;
        for(i = 0; i < transactionCount; i++) {
            if(_pending && !isExecuted(i) || _executed && isExecuted(i)) {
                _transactionTempIds[count] = i;
                count += 1;
            }
        }

        for(i = _from; i < _to; i++) {
            _transactionIds[i - _from] = _transactionTempIds[i];
        }

        return _transactionIds;
    }

    function getTransactionsConfirmedBy(
        address _from
    ) public view returns(uint[] _transactionsIds) {
        uint[] memory _transactionTempIds = new uint[](transactionCount);
        uint count = 0;
        uint i;
        for(i = 0; i < transactionCount; i++) {
            _transactionTempIds[count] = i;
            count += 1;
        }

        for(i = 0; i < count; i++) {
            if(comfirmations[_transactionTempIds[i]][_from]) {
                _transactionsIds[i] = _transactionTempIds[i];
            }
        }

        return _transactionsIds;    
    }

    function getConfirmations(
        uint _identifier
    ) public view returns(address[] _confirmations) {
        address[] memory _owners = new address[](owners.length);
        uint count = 0;
        uint i;
        for(i = 0; i < owners.length; i++) {
            if(comfirmations[_identifier][owners[i]]) {
                _owners[count] = owners[i];
                count++;
            }
        }

        for(i = 0; i < count; i++) {
            _confirmations[i] = _owners[i];
        }

        return _confirmations;
    }
}

contract Provider is Owner {

}

contract Medecine {

}

contract Cetificate {

}
