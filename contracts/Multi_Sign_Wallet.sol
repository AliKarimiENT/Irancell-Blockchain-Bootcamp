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
    event DepositFuncds(address _from , uint amount);
    event TransactionCreated(address _from , address _to , uint amount , uint transactionId);
    event TransactionSigned(address _by,uint transactionId);
    event TransactionCompleted(address _from,address _to,uint amount,uint transactionId);
}