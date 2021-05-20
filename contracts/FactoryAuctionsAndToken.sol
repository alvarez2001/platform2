// contracts/FactoryAuctionsAndToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleAuction.sol";
import "./Arts.sol";


contract FactoryAuctionsAndToken {

    SimpleAuction[] public Auctions;
    mapping(address => SimpleAuction[]) private AuctionsWhereAddress;
    mapping(uint256 => bool) private OnAuction;
    
    Arts public tokenArts;

    constructor(string memory _nameToken, string memory _symbolToken){
        tokenArts = new Arts(_nameToken, _symbolToken);
    }
    function getAuctionsWhereAddress(address _address)public view returns( SimpleAuction[] memory auctions){
        return  AuctionsWhereAddress[_address];
    }
    
    function addAuctionToToken( 
            uint _biddingTime, 
            uint256 _tokenID 
        ) public returns(address) 
    {
        require(tokenArts.balanceOf(msg.sender) > 0, 'You must have at least 1 token to create an auction');
        require(msg.sender == tokenArts.ownerOf(_tokenID), 'You must be the owner of the token to create an auction');
        require( !OnAuction[_tokenID] , 'The token is currently at auction');
            
        SimpleAuction Auction = new SimpleAuction(_biddingTime, payable(msg.sender), address(tokenArts), _tokenID, address(this));
        Auctions.push(Auction);
        OnAuction[_tokenID] = true;
        tokenArts.safeTransferFrom(tokenArts.ownerOf(_tokenID), address(Auction), _tokenID);
        AuctionsWhereAddress[msg.sender].push(Auction);
        return address(Auction);
    }

    
    function ChangeStateAuctions(uint256 _tokenID, bool _state, address _auctions) public {
        require(msg.sender == _auctions, 'The ChangeStateAuctions function must be called from the SimpleAuction smart contract to change the auction state');
        OnAuction[_tokenID] = _state;   
    }
 
    function StateOnAuction(uint256 _tokenID) public view returns(bool) {
        return OnAuction[_tokenID];
    } 


}
