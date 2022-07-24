// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "../IAttributable.sol";
import "../IPlayer.sol";

contract MyPlayer is IPlayer, Ownable {
  address internal _operator;

  function setOperator(address operator) external onlyOwner {
    _operator = operator;
  }

  function updateAttributesOf(
    address _nft,
    uint256 tokenId,
    uint256 attributes
  ) external {
    require(_operator != address(0) && _operator == _msgSender(), "Not the operator");
    IAttributable(_nft).updateAttributes(tokenId, 0, attributes);
  }

  function attributesOf(address _nft, uint256 tokenId) external view returns (string memory) {
    uint256 _attributes = IAttributable(_nft).attributesOf(tokenId, address(this), 0);
    if (_attributes != 0) {
      return
        string(
          abi.encodePacked(
            "uint8 version:",
            Strings.toString(uint8(_attributes)),
            ";uint8 level:",
            Strings.toString(uint16(_attributes >> 8)),
            ";uint32 stamina:",
            Strings.toString(uint32(_attributes >> 16))
          )
        );
    } else {
      return "";
    }
  }
}