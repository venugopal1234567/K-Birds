// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
interface IERC721Metadata {

    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

    // function tokenURI(uint256 _tokenId) external view returns (string);
}