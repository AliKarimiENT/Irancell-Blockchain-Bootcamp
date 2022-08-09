pragma solidity ^0.8.*;
contract MyToken {
    string private _name;
    string private _symbol;
    uint32 private _decimal;
    uint256 private _totalSupply;

    constructor(){
        _name = "My first token";
        _symbol = "MFT";
        _decimal = 0;
        _totalSupply = 1000000;
        balance[msg.sender] = _totalSupply;
    }

    mapping(address=>uint) balance;
    mapping(address =>mapping(address=>uint)) allow;

    event _Transfer(address indexed sender,address indexed reciever,uint indexed amount);
    event _Approval(address indexed owner,address indexed spender,uint indexed amount);

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimal() public view returns (uint){
        return _decimal;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _account) public view returns (uint256){
        return balance[_account];
    }

    function Transfer(address _reciever,uint _amount) public returns (bool){
        // first step :
        // check that reciever's address has been intialized
        require(_reciever!= address(0),"Invalid Address");
        // check that sender has enough balance to do transfer
        require(balance[msg.sender]>= _amount,"Not Enough Money");
        // if yes 
        balance[msg.sender] -= _amount;
        balance[_reciever] += _amount;
        emit _Transfer(msg.sender,_reciever,_amount);
        return true; 
    }

    // using Approve function is for allowing the spender to spent money
    function Approve(address _reciever,uint _amount) public returns (bool){
        // check that sender and reciever addresses is initialized
        require(msg.sender != address(0),"Invalid Address");
        require(_reciever!= address(0),"Invalid Address");
        // here we set that owner (msg.sender) wants to spend money to reciever
        allow[msg.sender][_reciever] = _amount;
        emit _Approval(msg.sender,_reciever,_amount);
        return true;
 
    }

    function Allowance (address _owner , address _spender) public view returns (uint){
        return allow[_owner][_spender];
    }

    function TransferFrom(address _sender,address _reciever,uint256 _amount) public{
        require (_sender != address(0),"Invalid Address");
        require (_amount > 0 , "Not Enough Money");
        require (_reciever != address(0) , "Invalid Address");
        require (balance[_sender]>= _amount,"Not Enough Money");

        allow[_sender][msg.sender]= _amount;
        balance[_sender] -= _amount;
        balance[_reciever] += _amount;
        emit _Transfer(_sender,_reciever,_amount);
    }
}