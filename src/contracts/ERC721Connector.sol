// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721Metadata.sol";
import "./ERC721Enumerable.sol";

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {
  constructor(
    string memory __name,
    string memory __symbol,
    string memory __tokenURI
  ) ERC721Metadata(__name, __symbol, __tokenURI) {}
}
