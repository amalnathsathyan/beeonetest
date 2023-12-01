// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    IERC20 public token;  // ERC20 token being sold
    uint256 public rate;  // Rate of tokens in wei (e.g., 1 token = 0.01 ETH)
    uint256 public lockPeriod = 31536000 ;  //365 days in seconds 
    

    mapping(address => uint256) public purchasedTokens;
    mapping(address => uint256) public lockExpiration;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);

    constructor(
        address _tokenAddress,
        uint256 _rate,
    ) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
        rate = _rate;
    }

    function startSale() external onlyOwner {
        token.transferFrom(msg.sender, address(this),token.balanceOf(msg.sender))
    }

    function purchaseTokens(uint256 _tokenAmount) external payable {
        
        require(msg.value == _tokenAmount * rate, "Incorrect Ether amount");
        uint256 userLockPeriod = block.timestamp + lockPeriod;
        lockExpiration[msg.sender] = userLockPeriod;
        purchasedTokens[msg.sender] += _tokenAmount;
        emit TokensPurchased(msg.sender, _tokenAmount,  _tokenAmount * rate);
    }

    function withdrawUnlockedTokens() external {

        require(block.timestamp >= lockExpiration[msg.sender], "Tokens are still locked");
        uint256 amountToBeUnlocked = purchasedTokens[msg.sender];
        purchasedTokens[msg.sender] = 0; // Reset the purchased amount
        lockExpiration[msg.sender] = 0; // Reset the lock expiration
        token.approve(address(this),unlockedAmount);
        token.token.transferFrom(address(this),msg.sender,amountToBeUnlocked);
    }

    function endSale() external onlyOwner {
        token.approve(address(this),token.balanceOf(address(this)));
        token.transferFrom(address(this),msg.sender,token.balanceOf(address(this)))
    }

    // Function to withdraw ETH from the contract
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
