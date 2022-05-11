// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract ERC721 {
  mapping(uint256 => address) private _tokenOwner;
  mapping(address => uint256) private _ownerBalance;
  //mapping from tokenId to approved addresses
  mapping(uint256 => address) private _tokenApprovals;

  /// @dev This emits when ownership of any NFT changes by any mechanism.
  ///  This event emits when NFTs are created (`from` == 0) and destroyed
  ///  (`to` == 0). Exception: during contract creation, any number of NFTs
  ///  may be created and assigned without emitting Transfer. At the time of
  ///  any transfer, the approved address for that NFT (if any) is reset to none.
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

  /// @dev This emits when the approved address for an NFT is changed or
  ///  reaffirmed. The zero address indicates there is no approved address.
  ///  When a Transfer event emits, this also indicates that the approved
  ///  address for that NFT (if any) is reset to none.
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

  modifier notZeroAccount(address _account) {
    require(
      _account != address(0),
      "ERC721: minting to zero address is not allowed"
    );
    _;
  }

  modifier notMintedToken(uint256 _tokenId) {
    require(
      _tokenOwner[_tokenId] == address(0),
      "ERC721: token has already been minted"
    );
    _;
  }

  modifier isTokenOwner(address _owner, uint256 _tokenId) {
    require(
      this.ownerOf(_tokenId) == _owner,
      "ERC721: transfer has to be executed only by the onwer"
    );
    _;
  }

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) public view returns (uint256) {
    require(_owner != address(0), "ERC721: zero address is not allowed");
    return _ownerBalance[_owner];
  }

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) external view returns (address) {
    address _owner = _tokenOwner[_tokenId];
    require(_owner != address(0), "ERC721: invalid _tokenId");
    return _owner;
  }

  /// @notice mint a NFT with id {_tokenId} to the owner {_to}
  function _mint(address _to, uint256 _tokenId)
    internal
    virtual
    notZeroAccount(_to)
    notMintedToken(_tokenId)
  {
    _tokenOwner[_tokenId] = _to;
    _ownerBalance[_to] += 1;
    emit Transfer(address(0), _to, _tokenId);
  }

  /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function _transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal notZeroAccount(_to) isTokenOwner(_from, _tokenId) {
    //update the balance of the address from and to
    _ownerBalance[_from]--;
    _ownerBalance[_to]++;
    //add the safe funcionality ???
    //add tokenId to the address receiving the token
    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) public payable {
    require(
      isApprovedOrOwner(msg.sender, _tokenId),
      "ERC721: sender not the owner nor approved to do it"
    );
    _transferFrom(_from, _to, _tokenId);
  }

  /// @notice Change or reaffirm the approved address for an NFT
  /// @dev The zero address indicates there is no approved address.
  ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
  ///  operator of the current owner.
  /// @param _approved The new approved NFT controller
  /// @param _tokenId The NFT to approve
  function approve(address _approved, uint256 _tokenId)
    external
    payable
    isTokenOwner(msg.sender, _tokenId)
  {
    require(
      _approved != this.ownerOf(_tokenId),
      "ERC721: Approval to current owner is now allowed"
    );
    _tokenApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  function isApprovedOrOwner(address _spender, uint256 _tokenId)
    internal
    view
    returns (bool)
  {
    require(
      _tokenOwner[_tokenId] != address(0),
      "ERC721: Token does not exist"
    );
    return
      this.ownerOf(_tokenId) == _spender ||
      _tokenApprovals[_tokenId] == _spender;
  }
}
