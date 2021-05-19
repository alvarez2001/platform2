// contracts/FactoryAuctionsAndToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleAuction.sol";

contract FactoryAuctionsAndToken {

    SimpleAuction[] public Auctions;
    mapping(address => SimpleAuction[]) public AuctionsWhereAddress;
    address public addressStore;

    constructor(address _addressStore){
        addressStore = _addressStore;
    }
    
    function addAuctionAndToken( uint _biddingTime, address payable _beneficiary ) public returns(address) {
        SimpleAuction Auction = new SimpleAuction(_biddingTime, _beneficiary);
        Auctions.push(Auction);
        AuctionsWhereAddress[_beneficiary].push(Auction);
        return address(Auction);
    }
    


}
