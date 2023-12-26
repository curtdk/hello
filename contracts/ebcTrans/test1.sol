// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract ERC721UpgradeableMint is  OwnableUpgradeable {
    // using StringsUpgradeable for uint256;

    string public email;

    function initialize(string memory _tokenName, string memory _tokenSymbol, string memory _email) initializer public {
        // __ERC721_init(_tokenName, _tokenSymbol);
        __Ownable_init();

        setEmail(_email);
    }

    function setEmail(string memory _email) public onlyOwner {
        email = _email;
    }
} 