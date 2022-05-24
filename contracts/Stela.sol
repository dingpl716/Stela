// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Stela is ERC721Enumerable, Ownable {
    
    constructor() ERC721("Stela", "ST") { }

    
    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://stela.io/tokens/";
    }

    function safeMint(address _to, uint256 _tokenId) public onlyOwner {
        ERC721._safeMint(_to, _tokenId);
    }
}
