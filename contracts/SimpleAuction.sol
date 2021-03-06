// contracts/SimpleAuction.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./FactoryAuctionsAndToken.sol";

contract SimpleAuction is IERC721Receiver{
    address payable public beneficiary;
    uint private auctionEndTime;

    address public highestBidder;
    uint public highestBid;

    uint256 public tokenID;
    
    FactoryAuctionsAndToken factoryAuctions;
    
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    
    mapping(address => uint) private pendingReturns;

    bool ended = false;

    event HighestBidIncrease(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _biddingTime, address payable _beneficiary, uint256 _tokenID, address _factory){
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
        tokenID = _tokenID;
        factoryAuctions = FactoryAuctionsAndToken(_factory);
    }
    
    function HowMuchLeft() public view returns(uint){
        return uint(block.timestamp - auctionEndTime);
    }


    function bid() public payable{
        if(block.timestamp > auctionEndTime){
            revert('The auction has already ended');
        }
        if(msg.value <= highestBid){
            revert('There is already a higher or equal bid');
        }
        if(msg.sender == beneficiary){
            revert('You cannot place the bid since you are the owner of the auction');
        }
        if(msg.sender == highestBidder){
            revert('the current highest bidder cannot raise their own bid');
        }

        if(highestBid != 0){
            pendingReturns[highestBidder] += highestBid;
            address lastBidder = highestBidder;
            uint amount = pendingReturns[lastBidder];
            if(amount > 0){
                pendingReturns[lastBidder] = 0;
                if(!payable(lastBidder).send(amount)){
                    pendingReturns[lastBidder] = amount;
                }
            }
        }

        
        


        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncrease(msg.sender, msg.value);
    }

    function withdraw() public returns(bool) {
        uint amount = pendingReturns[msg.sender];
        if(amount > 0){
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }


    function auctionEnd() public {

        if(block.timestamp < auctionEndTime){
            revert('The auction has not ended yet');
        }
        if(ended){
            revert('The function auctionEnded has already been called');
        }
         if(!factoryAuctions.StateOnAuction(tokenID)){
            revert('Has already been claimed');
        } 
        require((msg.sender == beneficiary) || (msg.sender == highestBidder), 'To withdraw the token you must be the one who won the auction');
        
        ended = true;
        factoryAuctions.ChangeStateAuctions(tokenID, false, address(this));
        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
        factoryAuctions.safeTransferFrom(address(this), highestBidder, tokenID);
    }


}
