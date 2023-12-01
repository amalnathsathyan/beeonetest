// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    IERC20 public token;  // ERC20 token being sold
    uint256 public rate;  // Rate of tokens in wei (e.g., 1 token = 0.01 ETH)
    uint256 public releaseTime;  // Timestamp when tokens can be released

    mapping(address => uint256) public purchasedTokens;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);

    constructor(
        address _tokenAddress,
        uint256 _rate,
        uint256 _lockPeriod // Amount of lock period in seconds
    ) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
        rate = _rate;
        releaseTime = block.timestamp + _lockPeriod; // One Year
    }

    function purchaseTokens(uint256 _tokenAmount) external payable {
        
        require(block.timestamp < releaseTime, "Tokens can only be purchased before release time");
        
        uint256 cost = _tokenAmount * rate;
        require(msg.value >= cost, "Insufficient funds");

        purchasedTokens[msg.sender] += _tokenAmount;
        emit TokensPurchased(msg.sender, _tokenAmount, cost);
    }

    function releaseTokens() external onlyOwner {
        require(block.timestamp >= releaseTime, "Tokens cannot be released before release time");

        for (uint256 i = 0; i < msg.sender.balance; i++) {
            uint256 tokenAmount = purchasedTokens[msg.sender];
            require(tokenAmount > 0, "No tokens to release");

            purchasedTokens[msg.sender] = 0;
            token.transfer(msg.sender, tokenAmount);
        }
    }

    // Function to withdraw ETH from the contract
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
