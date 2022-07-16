// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract HexagonNft is ERC721URIStorage, Ownable, ReentrancyGuard {
    // token counter
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    // token properties
    uint256 public mintPrice;
    uint256 public wlPrice;
    uint256 public maxSupply;
    uint256 public totalSupply;
    uint256 public maxPerWalletWL;
    uint256 public maxPerWalletMint;

    // Enable Minting
    bool public mintingEnabled;
    bool public wlMintingEnabled;

    constructor() ERC721("HexagonNFT", "HXNFT") {
        mintPrice = 0.4 ether;
        wlPrice = 0.1 ether;
        maxSupply = 20;
        totalSupply = 0;
        maxPerWalletMint = 4;
        maxPerWalletWL = 2;
    }

    function enableMinting(bool enabled) public onlyOwner {
        mintingEnabled = enabled;
    }

    function enableWhiteList(bool enabled) public onlyOwner {
        wlMintingEnabled = enabled;
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
