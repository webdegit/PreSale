// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

interface IERC20_EXTENDED {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (string memory);
}

contract PresaleUpgradeable is Initializable, PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {

    uint256 private tokenPrice;
    address private tokenAddress;
    address private tokenSeller;
    uint256 private totalTokenSold;
    bool private isTokenBuyEnabled;
    
    function initialize() initializer public {
        __Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function setTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function changeContractOwner(address newOwner) external onlyOwner {
        transferOwnership(newOwner);
    }

    function enableTokenBuy() external onlyOwner {
        isTokenBuyEnabled = true;
    }

    function disableTokenBuy() external onlyOwner {
        isTokenBuyEnabled = false;
    }

    function buyToken() external payable {
        require(isTokenBuyEnabled, "Token buy is disabled");
        require(msg.value >= tokenPrice, "Not enough BNB to buy token");

        uint256 tokensToBuy = msg.value * tokenPrice;
        require(tokensToBuy > 0, "Insufficient BNB to buy token");

        IERC20Upgradeable(tokenAddress).transfer(msg.sender, tokensToBuy);
        totalTokenSold += tokensToBuy;
    }

    function withdrawToken() external onlyOwner {
        uint256 balance = IERC20Upgradeable(tokenAddress).balanceOf(address(this));
        IERC20Upgradeable(tokenAddress).transfer(owner(), balance);
    }

    function withdrawBNB() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }

    function getTotalTokenSold() external view returns (uint256) {
        return totalTokenSold;
    }

    function getTotalTokenAvailable() external view returns (uint256) {
        return IERC20Upgradeable(tokenAddress).balanceOf(address(this));
    }

    function getTokenBuyStatus() external view returns (bool) {
        return isTokenBuyEnabled;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}