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
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    address public publicContractAddress;
    uint256 public mintPrice;
    uint256 public wlPrice;
    uint256 public maxSupply;
    uint256 public totalSupply;
    uint256 public maxPerWalletWL;
    uint256 public maxPerWalletMint;

    bool public mintingEnabled;
    bool public wlMintingEnabled;

    constructor() ERC721("HexagonNFT", "HXNFT") {}
}
