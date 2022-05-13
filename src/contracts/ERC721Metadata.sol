// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./interfaces/IERC721Metadata.sol";
import "./ERC165.sol";

/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
contract ERC721Metadata is IERC721Metadata, ERC165 {
  string private _name;
  string private _symbol;
  string private _tokenURI;

  constructor(
    string memory __name,
    string memory __symbol,
    string memory __tokenURI
  ) {
    _name = __name;
    _symbol = __symbol;
    _tokenURI = __tokenURI;
    IERC721Metadata i;
    _registerInterface(
      i.name.selector ^ i.symbol.selector ^ i.tokenURI.selector
    );
  }

  /// @notice A descriptive name for a collection of NFTs in this contract
  function name() external view override returns (string memory) {
    return _name;
  }

  /// @notice An abbreviated name for NFTs in this contract
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

  /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
  /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
  ///  3986. The URI may point to a JSON file that conforms to the "ERC721
  ///  Metadata JSON Schema".
  function tokenURI(uint256 _tokenId) external view returns (string memory) {
    return string(abi.encodePacked(_tokenURI, _tokenId));
  }
}
