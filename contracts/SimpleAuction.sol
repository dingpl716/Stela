// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SimpleAuction is Ownable, ReentrancyGuard {
    // The ID of the token that is being auctioned
    uint256 public auctionTokenId;

    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address payable public beneficiary;
    uint256 public auctionEndTime;
    
    // The minimal number of wei to add in each bid round
    uint256 public minBid;

    // Current state of the auction.
    address public highestBidder;
    uint256 public highestBid;

    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    bool public ended;

    // Allowed withdrawals of previous bids
    mapping(address => uint256) private pendingReturns;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint256 amount);
    
    /// There is already a higher or equal bid.
    error BidNotHighEnough(uint256 currentHighestBid, uint256 minBid);

    /// Create a simple auction with `biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `beneficiaryAddress`.
    constructor(
        uint256 tokenId,
        uint256 biddingTime,
        address payable beneficiaryAddress,
        uint256 minBidWei
    ) {
        auctionTokenId = tokenId;
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
        minBid = minBidWei;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid() external payable {
        // Revert the call if the bidding
        // period is over.
        require(auctionEndTime < block.timestamp, "Auction has already ended.");
        
        // If the bid is not higher, send the
        // money back. 
        if (msg.value < highestBid + minBid)
            revert BidNotHighEnough(highestBid, minBid);

        if (highestBid != 0) {
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }
    
    /// Withdraw a bid that was overbid.
    function withdraw() external nonReentrant returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Withdraw failed.");
            pendingReturns[msg.sender] = 0;
            return true;
        }
        
        return false;
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() external onlyOwner {
        require(!ended, "Auction end call has already been made.");
        require(block.timestamp >= auctionEndTime, "Auction has not yet ended.");

        (bool success, ) = beneficiary.call{value: highestBid}("");
        require(success, "Transferring to beneficiary failed.");

        ended = true;
    }
}
