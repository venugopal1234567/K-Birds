// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector{
    string[] public KryptoBirdz;

    mapping(string => bool) _kryptoBirdzExist;

    function mint(string memory _KryptoBird) public {

        require(!_kryptoBirdzExist[_KryptoBird], 'Error - krypto bird already existts');
        
        KryptoBirdz.push(_KryptoBird);
        uint _id = KryptoBirdz.length -1;

        _mint(msg.sender, _id);

        _kryptoBirdzExist[_KryptoBird] = true;
    }
    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {
    }
}
