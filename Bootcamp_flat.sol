
// File: contracts/Bootcamp.sol

pragma solidity ^0.8.0;

contract bootCamp{
    // variables
    int a ; 
    int b ;
    string str = "";
    // payable
    // pure : will display the computation 
    // view : will display the output

    // when we need to get data and post that to blockchain we need to use memory. Actually for saving data use memory
    function sample(string memory _name) public view returns (string memory){
        return _name;
    }
    function testArray() public pure returns (uint){
        uint[3] memory ar;
        ar[0] = 1;
        ar[1] = 2;
        ar[2] = 3;
        uint output = 0;
        for(uint i=0;i<=ar.length;i++){
             output+= i*5;
        }
        return output;
    }
    uint[] test;
    function pushArray() public returns (uint){
        test.push(10);
        test.push(20);
        uint output = 0;
        for(uint i=0;i<=test.length;i++){
             output+= test[i];
        }
        return output;
    }

    function Send() payable public{
        if(msg.value <1 ether) revert("Not Enough Money");
    }
        
    mapping (address => uint) balance;
    // 2 dimentional mapping
    mapping (uint => mapping(address => uint)) balanceList;
    function testMapping() public{
        balance[msg.sender] = 1000; //create
        balance[msg.sender];        //read
        balance[msg.sender] = 800;  //edit
        delete balance[msg.sender]; //delete
    }

    mapping (address => uint[]) transactions;
    function logTransaction() public{
        transactions[msg.sender][0] = 100; //create
        transactions[msg.sender][0];       //read
        transactions[msg.sender][0] = 200; //update
        delete transactions[msg.sender][0]; //delete
    }


    function GetBalance() public view returns(uint){  
        return address(this).balance;
    }
    function testNested(uint _id) public{
        balanceList[_id][msg.sender] = 100; //create
        balanceList[_id][msg.sender]; //read
        balanceList[_id][msg.sender] = 200; //update
        delete balanceList[_id][msg.sender]; //delete
    }
    function keywords(address _adrs) public view returns(uint){
        // msg.sender : is account address of person who run the smart contract
        // block.timestamp : the time when transaction is evaluted
        // block.sizeof : the size of the block , how much space do we have
        // block.gaslimit
        // block.gasleft 
        // msg.value : means that how much value that is input
        // tx : is transaction 
        // tx.gasprice
        // tx.origin(address payable)
        // mapping (uint => address) memory address_;
        // balance[msg.sender] = 1000;
        // delete balance[msg.sender];
        return balance[_adrs];
    }

    function transferTo(address _adrs,uint _amount) public payable{
        payable(_adrs).transfer(_amount);
    }

    struct Student{
        int id;
        string name;
        int age;
        // address strudentAdr;
    }
    function testStruct() public{
        Student memory st;
        st.id = 100;
        st.name = "ALI";
        st.age = 20;

        Student memory st2 = Student(101,"SAM",22);
    }

    function hash(string memory _input) public view returns (bytes32){
        return keccak256(abi.encodePacked(_input));
    } 
    
    function hash2(string memory _input) public view returns (uint256){
        return uint256(keccak256(abi.encode(_input)));
    }

    function errorHandling(uint _input) public {
        // if (_input>5) revert ("The input number is not valid !!!");
        
        // require will stop the code untill this executed
        // if the statement is true no error will be displayed but if is false the error will be shown
        // catch in try-catch
        // require(_input>5 , "It's not valid ");

        // assert : is through exception
        assert(_input > 5);
        
    }

    function testLibrary() public returns(uint){
       return fullMath.add(10,20);
    }

    event TransferFee(address sender , address reciever, uint amount , uint time, bool status);
    function finalTransfer (address _from,address _to,uint _amount) public {
        // Steps befor calling the event
        // after these steps we call emit 
        emit TransferFee(_from,_to,_amount,block.timestamp,true);
    }
}

abstract contract UserTransaction {
    uint public balance;
    constructor(uint _balance){
        balance = _balance;
    }
    function getBalance() public view returns (uint){
        return balance;
    }

    function deposite(uint _amount) public {
        balance += _amount;
    }

    function withdraw(uint _amount) public {
        balance -= _amount;
    }
}

// contract NewTransaction is UserTransaction {
    // constructor(uint _value){
    //     balance = _value;
    // }
// }

library fullMath{
    function add(uint a, uint b) external pure returns (uint){
        return a+b;
    }
}