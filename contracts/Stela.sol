// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Stela is ERC721Enumerable, Ownable {

    mapping(uint256 => string) private _stelaText;

    string private baseURI;

    /**
     * @dev Emitted when stela text of `tokenId` token is updated by `from` to `text`.
     */
    event UpdateText(address indexed from, uint256 indexed tokenId, string text);
    
    constructor() ERC721("Stela", "ST") { }

    
    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function updateBaseURI(string memory newURI) public onlyOwner {
        baseURI = newURI;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        ERC721._safeMint(to, tokenId);
    }

    function getStelaText(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Query text for nonexistent token");
        return _stelaText[tokenId];
    }

    function updateStelaText(uint256 tokenId, string memory text) public {
        require(_exists(tokenId), "Update text for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "Text updating caller is not owner nor approved for all"
        );

        _stelaText[tokenId] = text;

        emit UpdateText(_msgSender(), tokenId, text);
    }
}
