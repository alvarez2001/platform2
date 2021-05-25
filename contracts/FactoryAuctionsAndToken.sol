// contracts/FactoryAuctionsAndToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleAuction.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract FactoryAuctionsAndToken is ERC721 {

    SimpleAuction[] public Auctions;
    mapping(address => SimpleAuction[]) private AuctionsWhereAddress;
    mapping(uint256 => bool) private OnAuction;
    mapping(address => bool) private ActiveTokenOfAddress;
    mapping(uint256 => address) private TokenForAddress;

    constructor(string memory _nameToken, string memory _symbolToken) 
    ERC721(_nameToken, _symbolToken)
    {}
    
    function getAuctionsWhereAddress(address _address)public view returns( SimpleAuction[] memory auctions){
        return  AuctionsWhereAddress[_address];
    }
    
    function addAuctionToToken( 
            uint _biddingTime, 
            uint256 _tokenID 
        ) public returns(address) 
    {
        require(balanceOf(msg.sender) > 0, 'Minimum 1 token to create the auction');
        require(msg.sender == ownerOf(_tokenID), 'Owner only');
        require( !OnAuction[_tokenID] , 'Up for auction');
        
        SimpleAuction Auction = new SimpleAuction(_biddingTime, payable(msg.sender),  _tokenID, address(this));
        Auctions.push(Auction);
        OnAuction[_tokenID] = true;
        TokenForAddress[_tokenID] = address(Auction); 
        safeTransferFrom(msg.sender, address(Auction), _tokenID);
        ActiveTokenOfAddress[address(Auction)] = true;
        AuctionsWhereAddress[msg.sender].push(Auction);
        return address(Auction);
    }

    
    function StateActiveAddressToken(uint256 _tokenID) external view  returns(bool){
        return ActiveTokenOfAddress[TokenForAddress[_tokenID]];
    }
    
    function ChangeStateAuctions(uint256 _tokenID, bool _state, address _auctions) external {
        require(msg.sender == _auctions, 'The ChangeStateAuctions function must be called from the SimpleAuction smart contract to change the auction state');
        OnAuction[_tokenID] = _state;   
    }
 
    function StateOnAuction(uint256 _tokenID) external view returns(bool) {
        return OnAuction[_tokenID];
    } 

    //----------------------   TOKEN CREATES   -------------------------
    ArtStruct[] public artsArray;
    mapping(string => bool) _imageArtExists;

    struct ArtStruct{
        address creator;
        string creatorName;
        string nameArt;
        string descriptionArt;
        string imageArt;
        string audioArt;
    }
    
    function mint(
        address _creator,
        string memory _creatorName,
        string memory _nameArt,
        string memory _descriptionArt,
        string memory _imageArt,
        string memory _audioArt
        ) public  returns(uint){
            require(!_imageArtExists[_imageArt], 'Image already exists');
            require(msg.sender == _creator, 'You must be the owner to create the token');
            ArtStruct memory _art = ArtStruct(_creator, _creatorName, _nameArt, _descriptionArt, _imageArt, _audioArt);
            artsArray.push(_art);
            uint _id = artsArray.length - 1;
            _mint(msg.sender, _id);
            _imageArtExists[_imageArt] = true;
            return _id;
    }




}
