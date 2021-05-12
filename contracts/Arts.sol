// contracts/Arts.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Arts is ERC721 {

    constructor() ERC721("NFTARTS", "SLIP") {}
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(string => uint8) urlsImages;


    struct Art{
        string name;
        string description;
        string imageUrl;
        string creatorName;
        uint256 created;
    }

    Art[] arts;

    function mint(string memory _imageUrl, string memory _name, string memory _description, string memory _creatorName) public returns(uint256, uint256) {
        require(urlsImages[_imageUrl] != 1);
        urlsImages[_imageUrl] = 1;
        Art memory _art = Art(_name, _description, _imageUrl, _creatorName, block.timestamp);
        arts.push(_art);
        // uint _id = arts.length - 1;
        _tokenIds.increment();
        uint256 _id = _tokenIds.current();
        _mint(msg.sender, _id);
        return (_id, block.timestamp);
    }

    function getArtFromId(uint256 id) public view returns(string memory name, string memory description, string memory imageUrl, string memory creatorName, uint256 created){
        return (arts[id].name, arts[id].description, arts[id].imageUrl, arts[id].creatorName, arts[id].created);
    }


}