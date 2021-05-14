// contracts/Arts.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";



contract Arts is ERC721Enumerable {
    ArtStruct[] public artsArray;
    mapping(string => bool) _imageArtExists;

    constructor()  ERC721('Slipstream', 'ST') {}
    
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
        ) public {
            require(!_imageArtExists[_imageArt], 'Image already exists');
            ArtStruct memory _art = ArtStruct(_creator, _creatorName, _nameArt, _descriptionArt, _imageArt, _audioArt);
            artsArray.push(_art);
            uint _id = artsArray.length;
            _mint(msg.sender, _id);
            _imageArtExists[_imageArt] = true;
    }


}