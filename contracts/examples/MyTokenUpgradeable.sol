// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "../IAttributable.sol";

contract MyTokenUpgradeable is IAttributable, Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  uint256 internal _nextTokenId;
  mapping(uint256 => mapping(address => mapping(uint8 => uint256))) internal _tokenAttributes;

  function initialize() initializer public {
    __ERC721_init("MyToken", "MTK");
    __Ownable_init();
    __UUPSUpgradeable_init();
    _nextTokenId = 1;
  }

  function _authorizeUpgrade(address newImplementation)
  internal
  onlyOwner
  override
  {}

  function attributesOf(
    uint256 _id,
    address _player,
    uint8 _index
  ) external view override returns (uint256) {
    return _tokenAttributes[_id][_player][_index];
  }

  function authorizePlayer(uint256 _id, address _player) external override {
    require(ownerOf(_id) == _msgSender(), "Not the owner");
    require(_tokenAttributes[_id][_player][0] == 0, "Player already authorized");
    _tokenAttributes[_id][_player][0] = 1;
  }

  function updateAttributes(
    uint256 _id,
    uint8 _index,
    uint256 _attributes
  ) external override {
    require(_tokenAttributes[_id][_msgSender()][0] != 0, "Player not authorized");
    // notice that if the playes set the attributes to zero, it de-authorize itself
    // and not more changes will be allowed until the NFT owner authorize it again
    _tokenAttributes[_id][_msgSender()][_index] = _attributes;
  }

  function mint(address to) external onlyOwner {
    _safeMint(to, _nextTokenId++);
  }
}