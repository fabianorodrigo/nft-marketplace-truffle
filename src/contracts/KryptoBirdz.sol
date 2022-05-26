// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721Connector.sol";

contract KryptoBirdz is ERC721Connector {
  string[] public kryptoBirdz;
  mapping(string => bool) _kriptoBirdzExists;

  constructor()
    ERC721Connector("KriptoBirdz", "KBIRDZ", "http://kryptobirdz.com/nfts/")
  {}

  function mint(string memory _kryptoBird) public {
    require(
      _kriptoBirdzExists[_kryptoBird] == false,
      "KriptoBird already exists"
    );
    kryptoBirdz.push(_kryptoBird);
    uint256 _id = kryptoBirdz.length - 1;
    _kriptoBirdzExists[_kryptoBird] = true;
    _mint(msg.sender, _id);
  }
}
