pragma solidity ^0.8.*;
contract MultiSignWallet {
    address private _owner;
    // a mapping from address to uint which contains two part
    // first part is our owner address
    // second part is an amount that owener wants to add on transaction
    mapping (address => uint8) private _owners;
    uint8 constant MIN_SIGNATURE = 2;
    
    struct Transaction {
        // whenever amount of money want to exit from a smart contract or enter a contract
        // its datatype must be payable
        // if we don't set them payable > we must set our funtion to payable type
        address payable sender;
        address payable reciever;
        uint amount;
        bool isSigned;
        uint8 signatureCount;
    }

    Transaction[] _transactions;
    // a mapping from an address to a uint , which will show us that a specific address has signed a transaction or not
    mapping(address=>uint8) signed;
    // list of pending transactions that have not executed completely becuase number of signatures is not enough
    uint[] private _pendingTransactions;

    //define events
    event DepositFunds(address _from , uint amount);
    event TransactionCreated(address _from , address _to , uint amount , uint transactionId);
    event TransactionSigned(address _by,uint transactionId);
    event TransactionCompleted(address _from,address _to,uint amount,uint transactionId);

    modifier isOwner() {
        require(msg.sender==_owner);
        _;
    }
    // if modifier doesn't have any parameters we can remove the parantheses
    modifier validOwner {
        require (msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }

    //define constructor 
    constructor() {
        _owner = msg.sender;
    }

    function addOwner(address owner) public isOwner{
        _owners[owner] = 1;
    }

    function removeOwner(address owner) public isOwner{
        _owners[owner] = 0;
    }

    function deposite() public payable{
        emit DepositFunds(msg.sender,msg.value);
    }

    function withDraw(uint amount) public {
        transferTo(payable(msg.sender),amount);
    }

    function transferTo(address payable _reciever,uint _amount) public validOwner{
        require(address(this).balance >= _amount ,  "Not Enough Money");
        _transactions.push(Transaction(
            {
                sender:payable(msg.sender),
                reciever: _reciever,
                amount: _amount,
                isSigned: false,
                signatureCount: 0
            }
        ));

        _pendingTransactions.push(_transactions.length);
        emit TransactionCreated(msg.sender,_reciever,_amount,_transactions.length);
    }

    function getPendingTransactions() public view validOwner returns(uint[] memory) {
        return _pendingTransactions;
    }

    function getTransaction(uint _id) public view validOwner returns(Transaction memory){
        Transaction memory selectedTransaction = _transactions[_id];
        return selectedTransaction;
    }

    function selectedTransactionBalance() public view returns (uint){
        return address(this).balance;
    }

    function signTransaction (uint _id) public validOwner{
        // _id is transaction id
        Transaction storage selectedTransaction = _transactions[_id];
        // owner of transaction can not sign the transaction here
        require(msg.sender != selectedTransaction.sender,"Creator can't sign");
        // an account can't sign more than 1 time
        require(signed[msg.sender] != 1 , "You have already signed");

        signed[msg.sender] = 1;
        selectedTransaction.isSigned = true;
        selectedTransaction.signatureCount++;
    
        emit TransactionSigned(msg.sender,_id);


        if(selectedTransaction.signatureCount >= MIN_SIGNATURE){
             require(address(this).balance >= selectedTransaction.amount , "Not Enough Money");
             selectedTransaction.reciever.transfer(selectedTransaction.amount);

             delete _pendingTransactions[_id];
             emit TransactionCompleted(selectedTransaction.sender,selectedTransaction.reciever,selectedTransaction.amount,_id);
        }
    }
}