// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
   function add(uint x, uint y) internal pure returns(uint256) {
       uint256 r = x + y;
        require(r >= x, 'Safemath addition oveflow');
       return r;
   }

   function sub(uint x, uint y) internal pure returns(uint256) {
       require(y <= x, 'Safemath subtraction oveflow');
       uint256 r = x - y;
       return r;
   }

   function mul(uint x, uint y) internal pure returns(uint256) {
       if(x == 0) {
           return 0;
       }
       uint256 r = x * y;
        require(r / x == y, 'Safemath multiplication oveflow');
       return r;
   }

   function divide(uint x, uint y) internal pure returns(uint256) {
       require(y > 0 , 'Safemath devision by zero');
       uint256 r = x / y;
       return r;
   }

   function mod(uint x, uint y) internal pure returns(uint256) {
       require(y != 0 , 'Safemath modulo by zero');
       uint256 r = x % y;
       return r;
   }
    
}