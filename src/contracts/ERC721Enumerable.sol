// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;


import "./ERC721.sol";

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
contract ERC721Enumerable  is ERC721 {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256=>uint256) private _tokenId_index;
    // mapping of owner to list of all owner token ids
    mapping(address=>uint256[]) private _owner_tokensIdsArray;
    // mapping from tokenId index of the owner tokens lists
    mapping(uint256=>uint256) private _ownedTokensIndex;

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view returns (uint256){
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external view returns (uint256){
        require(_index < totalSupply());
        return _allTokens[_index];

    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view notZeroAccount(_owner) returns (uint256){
        require(_index < balanceOf(_owner));
        return _owner_tokensIdsArray[_owner][_index];
    }
 
    /// @notice mint a NFT with id {_tokenId} to the owner {_to}
    function _mint(address _to, uint256 _tokenId) internal override(ERC721) {
        super._mint(_to,_tokenId);
        _addTokensToAllTokensEnumeration(_tokenId);
    }

    function _addTokensToAllTokensEnumeration(uint256 _tokenId) private{
        _allTokens.push(_tokenId);
    }
}