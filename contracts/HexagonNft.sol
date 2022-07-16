// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Openzeppelin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract HexagonNft is ERC721URIStorage, Ownable, ReentrancyGuard {
    // token counter
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;

    // genral
    uint256 public maxSupply = 100;
    uint256 public totalSupply;

    // normal mint
    uint256 public mintPrice = 0.4 ether;
    uint256 public maxPerWalletMint = 4;
    bool public mintingEnabled;

    mapping(address => uint256) totalMinted;

    // wl mint
    uint256 public wlPrice = 0.1 ether;
    uint256 public maxPerWalletWl = 2;
    uint256 public totalWl;
    bool public wlMintingEnabled;

    mapping(address => uint256) totalMintedWl;
    mapping(address => bool) wlAddresses;

    // events
    event Minted(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("HexagonNFT", "HXNFT") {
        totalSupply = 0;
    }

    // Enable Minting Functions

    function enableMinting(bool enabled) public onlyOwner {
        mintingEnabled = enabled;
    }

    function enableWhiteList(bool enabled) public onlyOwner {
        wlMintingEnabled = enabled;
    }

    // Whitelist Functions
    function addAddressToWhiteList(address addr) public onlyOwner {
        require(!wlAddresses[addr], "Address already whitelisted !");
        wlAddresses[addr] = true;
        totalWl++;
    }

    function verifyWhiteList(address addr) public view returns (bool) {
        return wlAddresses[addr];
    }

    function removeAddressFromWhiteList(address addr) public onlyOwner {
        require(wlAddresses[addr], "Address not whitelisted !");
        wlAddresses[addr] = false;
        totalWl--;
    }

    function getTotalWl() public view returns (uint256) {
        return totalWl;
    }

    function getTotalWlMinted(address addr) public view returns (uint256) {
        return totalMintedWl[addr];
    }

    function mintWl(string memory uri, uint256 quantity) public payable {
        require(wlMintingEnabled, "WL minting is not enabled");
        require(verifyWhiteList(msg.sender), "Address not whitelisted");
        require(msg.value == wlPrice * quantity, "Not enough ether to mint");
        require(totalSupply + quantity <= maxSupply, "Max supply reached");
        require(quantity <= maxPerWalletWl, "Max per wallet reached");
        require(
            totalMintedWl[msg.sender] + quantity <= maxPerWalletWl,
            "Max per wallet reached"
        );

        for (uint256 i = 0; i < quantity; i++) {
            tokenId.increment();
            uint256 newItemId = tokenId.current();

            _safeMint(msg.sender, newItemId);
            _setTokenURI(newItemId, uri);

            if (totalMintedWl[msg.sender] == 0) {
                totalMintedWl[msg.sender] = quantity;
            } else {
                totalMintedWl[msg.sender]++;
            }

            emit Minted(msg.sender, newItemId);
        }
    }

    // Mint Functions

    function mint(string memory uri, uint256 quantity) public payable {
        require(mintingEnabled, "WL minting is not enabled");
        require(totalSupply + quantity <= maxSupply, "Max per wallet reached");
        require(msg.value == mintPrice * quantity, "Not enough ether to mint");
        require(totalSupply + quantity <= maxSupply, "Max supply reached");
        require(quantity <= maxPerWalletMint, "Max per wallet reached");
        require(
            totalMinted[msg.sender] + quantity <= maxPerWalletMint,
            "Max per wallet reached"
        );

        for (uint256 i = 0; i < quantity; i++) {
            tokenId.increment();
            uint256 newItemId = tokenId.current();

            _safeMint(msg.sender, newItemId);
            _setTokenURI(newItemId, uri);

            if (totalMinted[msg.sender] == 0) {
                totalMinted[msg.sender] = quantity;
            } else {
                totalMinted[msg.sender]++;
            }

            emit Minted(msg.sender, newItemId);
        }
    }

    // Burn Function

    function burn(uint256[] calldata tokenIds) public onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i]);
        }
    }

    // Withdraw Function

    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
