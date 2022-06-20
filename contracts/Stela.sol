// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimpleAuction.sol";

contract Stela is ERC721Enumerable, Ownable {

    mapping(uint256 => string) private _stelaText;

    string private _tokenBaseURI;

    SimpleAuction private _auctionContract;
    bool private _auctionInProgress;
    
    // Timestamp of last minted stela
    uint256 private _lastMintTime;

    // Number of seconds between mints;
    uint256 private immutable _mintInterval; 

    /**
     * @dev Emitted when stela text of `tokenId` token is updated by `from` to `text`.
     */
    event UpdateText(address indexed from, uint256 indexed tokenId, string text);

    /**
     * @dev Emitted when an auction denoted by `auctionContractAddress` is started for `tokenId` token. The
     * auction will last `biddingTime` seconds and the minimal bid amount is `minBid` wei in each round.
     */
    event AuctionStarted(uint256 tokenId, address auctionContractAddress, uint256 biddingTime, uint256 minBid);

    /**
     * @dev Emitted when an auction denoted by `auctionContractAddress` is ended and the `winner` winner won
     * the `tokenId` token for `amount` wei.
     */
    event AuctionEnded(uint256 tokenId, address auctionContractAddress, address winner, uint256 amount);
    
    constructor(uint256 mintInterval, string memory baseURI) ERC721("Stela", "ST") {
        _tokenBaseURI = baseURI;
        _mintInterval = mintInterval;
     }

    
    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view override returns (string memory) {
        return _tokenBaseURI;
    }

    function updateBaseURI(string memory newURI) public onlyOwner {
        _tokenBaseURI = newURI;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function getStelaText(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Query stela text for nonexistent token");
        return _stelaText[tokenId];
    }

    function updateStelaText(uint256 tokenId, string memory text) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Updating stela text caller is not owner nor approved");

        _stelaText[tokenId] = text;

        emit UpdateText(_msgSender(), tokenId, text);
    }

    function startAuction(uint256 tokenId, uint256 biddingTime, uint256 minBid) public onlyOwner returns (address) {
        require(!_exists(tokenId), "Cannot start auction for an existent token.");
        require(!_auctionInProgress, "One auction is already in progress.");
        require(_lastMintTime + _mintInterval <= block.timestamp, "Cannot start new auction yet.");
        
        _auctionContract = new SimpleAuction(tokenId, biddingTime, payable(_msgSender()), minBid);
        _auctionInProgress = true;
        _lastMintTime = block.timestamp;
        address auctionContractAddress = address(_auctionContract);

        emit AuctionStarted(tokenId, auctionContractAddress, biddingTime, minBid);
        return auctionContractAddress;
    }

    function endAuction() public onlyOwner {
        require(_auctionInProgress, "No auction in progress.");

        uint256 amount = _auctionContract.highestBid();
        uint256 tokenId = _auctionContract.auctionTokenId();
        address winner = _auctionContract.highestBidder();

        if (winner == address(0)) {
            winner = _msgSender();
        }

        _auctionContract.auctionEnd();

        _auctionInProgress = false;

        emit AuctionEnded(tokenId, address(_auctionContract), winner, amount);

        _safeMint(winner, tokenId);
    }

    function getAuction() public view returns (address) {
        require(_auctionInProgress, "No auction is in progress now.");
        return address(_auctionContract);
    }
}
