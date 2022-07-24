// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../IAttributable.sol";

contract MyToken is ERC721, Ownable, IAttributable {
  constructor() ERC721("MyToken", "MTK") {}

  mapping(uint256 => mapping(address => mapping(uint8 => uint256))) internal _tokenAttributes;

  function attributesOf(
    uint256 _id,
    address _player,
    uint8 _index
  ) external view returns (uint256) {
    return _tokenAttributes[_id][_player][_index];
  }

  function authorizePlayer(uint256 _id, address _player) external {
    require(ownerOf(_id) == _msgSender(), "Not the owner");
    require(_tokenAttributes[_id][_player][0] == 0, "Player already authorized");
    _tokenAttributes[_id][_player][0] = 1;
  }

  function updateAttributes(
    uint256 _id,
    uint8 _index,
    uint256 _attributes
  ) external {
    require(_tokenAttributes[_id][_msgSender()][0] != 0, "Player not authorized");
    // notice that if the playes set the attributes to zero, it de-authorize itself
    // and not more changes will be allowed until the NFT owner authorize it again
    _tokenAttributes[_id][_msgSender()][_index] = _attributes;
  }
}