pragma solidity ^0.8.*;

contract Auction{
    struct Post {
        address payable seller;
        // min value for entering to the auction
        uint minBid;
        string name;
        uint time;
    }

    struct Bid{
        address payable buyer;
        uint amount;
        uint time;
        bool isFinished;
    }

    // list of auctions
    Post[] posts;
    // map number to list of buyers
    mapping (uint => Bid[]) bids;
    // maps which address has segusted which amount
    mapping (address => uint) balances;

    // ایجاد یک مزایده
    // Generate an auction 
    function createPost (string memory _name,uint _minBid) public {
        posts.push(Post({seller: payable(msg.sender),minBid: _minBid,name:_name,time:block.timestamp}));
    }

    // create bid or suggestion
    function createBid (uint _postId) public payable {
        Post memory post = posts[_postId];
        // check that bid's sender is not the seller
        require (msg.sender!= post.seller,"You can't bid on your own post");
        // check the input value for bid
        require (msg.value != 0, "Invalid amount of Bid");
        require (post.time < 400, "This auction is finished");
        require (msg.value >= post.minBid * 1000000000000000000 , "This bid needs to be more than min bid value");

        bids[_postId].push(Bid({
            amount: msg.value,
            buyer : payable(msg.sender),
            time : block.timestamp,
            isFinished:false
        }));

        balances[address(this)] += msg.value;
    }

    function getBalance(address _address) public view returns (uint){
        return balances[_address]/1000000000000000000;
    }

    function getTotalBids(uint _postId) public view returns (uint){
        Post memory post = posts[_postId];
        require(msg.sender==post.seller,"You don't have permission");
        return bids[_postId].length;
    }

    // get specific bid by its id and post id
    function getPostBid(uint _postId,uint _bidId) public view returns (address buyer , uint amount , uint time){
        Post memory post = posts[_postId];
        Bid memory bid = bids[_postId][_bidId];
        require(msg.sender == post.seller,"You don't have permission");
        return (bid.buyer,bid.amount/1000000000000000000,bid.time);
    }

    function acceptBid(uint _postId,uint _bidId) public payable {
        Post memory post = posts[_postId];
        Bid storage bid = bids[_postId][_bidId];
        require(msg.sender==post.seller,"You don't have permission");
        require(bid.isFinished == false , "The auction has ended");
        require(bid.time + 400 > block.timestamp , "The bid has been expired");

        bid.isFinished = true;
        uint payamount = bid.amount;
        bid.amount = 0;
        balances[address(this)] -= payamount;
        post.seller.transfer(payamount);
    }

    function cancelBid(uint _postId,uint _bidId) public payable{
        Bid storage bid = bids[_postId][_bidId];
        require (msg.sender == bid.buyer , "You don't have permission");
        require (bid.isFinished== false,"The auction has ended");
        require (bid.time + 400 < block.timestamp,"You can't cancel the bid");

        uint payamount = bid.amount;
        bid.amount = 0;
        balances[address(this)] -= payamount;
        bid.buyer.transfer(payamount);
    }
}