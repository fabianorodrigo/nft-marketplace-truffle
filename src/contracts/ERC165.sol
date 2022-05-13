// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./interfaces/IERC165.sol";

contract ERC165 is IERC165 {
  mapping(bytes4 => bool) private _supportedInterfaces;

  constructor() {
    _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
  }

  /// @notice Query if a contract implements an interface
  /// @param _interfaceID The interface identifier, as specified in ERC-165
  /// @dev Interface identification is specified in ERC-165. This function
  ///  uses less than 30,000 gas.
  /// @return `true` if the contract implements `interfaceID` and
  ///  `interfaceID` is not 0xffffffff, `false` otherwise
  function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
    return _supportedInterfaces[_interfaceID];
  }

  function _registerInterface(bytes4 _interfaceId) internal {
    require(_interfaceId != 0xffffffff, "ERC165: Invalid _interfaceId");
    _supportedInterfaces[_interfaceId] = true;
  }
}
