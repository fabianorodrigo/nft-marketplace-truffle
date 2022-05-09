// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract ERC721{

    mapping(uint256=>address) private _tokenOwner;
    mapping(address=>uint256) private _ownerBalance;

    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    modifier notZeroAccount(address _account){
        require(_account != address(0),"ERC721: minting to zero address is not allowed");
        _;
    }

    modifier notMintedToken(uint256 _tokenId){
        require(_tokenOwner[_tokenId] ==address(0),"ERC721: token has already been minted");
        _;
    }

    /// @notice mint a NFT with id {_tokenId} to the owner {_to}
    function _mint(address _to, uint256 _tokenId) internal notZeroAccount(_to) notMintedToken(_tokenId) {
        _tokenOwner[_tokenId] = _to;
        _ownerBalance[_to]++;
        emit Transfer(address(0),_to,_tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256){
        return _ownerBalance[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address){
        return _tokenOwner[_tokenId];
    }

}