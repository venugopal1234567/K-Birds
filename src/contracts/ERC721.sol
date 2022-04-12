// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165 , IERC721 {
    
     mapping(uint256 => address) private _tokenOwner;

     mapping(address => uint256) private _OwnedTokensCount;

     mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registeredInterface(bytes4(keccak256('balanceOf(bytes4)')^
         keccak256('ownerOf(bytes4)')^ keccak256('ownerOf(bytes4)')));
    }

    function balanceOf(address _owner) public override view returns(uint256) {
        require(_owner != address(0), 'owner query for non-existant token');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existant token');
        return owner;
    }

     function _exists(uint256 tokenId) internal view returns(bool) {
         address owner = _tokenOwner[tokenId];
         return owner != address(0);
     }

     function _mint(address to, uint256 tokenId) internal virtual {
         require(to != address(0), 'ERC721; minting to zero address');
         require(!_exists(tokenId), 'ERC721; token already minted');

         _tokenOwner[tokenId] = to;
         _OwnedTokensCount[to] += 1;

         emit Transfer(address(0), to, tokenId);
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
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        require(_to != address(0), 'Error -ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer address does not own');
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner');
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 _tokenId) internal view returns(bool) {
        require(_exists(_tokenId), 'token does not exist');
        address  owner= ownerOf(_tokenId);
        return(spender == owner);
    }
} 