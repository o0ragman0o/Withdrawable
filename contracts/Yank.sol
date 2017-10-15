/******************************************************************************\

file:   Yank.sol
ver:    0.4.1
updated:15-Oct-2017
author: Darryl Morris (o0ragman0o)
email:  o0ragman0o AT gmail.com

Yank is a stand-alone and stateless tool to pull a series of `WithdrawAll()`
and `WithdrawAllFor()` payments from Withdrawable contracts. This can pull ether
through a chain of contract addresses to exit address/s

`yank(_kAddrs, _addrs)` is provided two arrays of contract addresses and
recipient addresses of the same length. If a recipient address for an index
is 0x0, Yank will call the WithdrawAll(), else WithdrawAllFor()

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

Change Log
----------
* Using Withdrawlable API 0.4.1

\******************************************************************************/

pragma solidity ^0.4.13;

import "./Withdrawable.sol";

contract Yank
{
//
// Constants
//
	bytes32 public constant VERSION = "Yank v0.4.1";

	// For SandalStraps registration
	bytes32 public constant regName = "yank";

//
// Events
//

    // Logged when a call to WithdrawlAll is made
    event WithdrawnAll(address indexed _kAddr);
    
    // Logged when a call to WithdrawAllFor is made
    event WithdrawnAllFor(address indexed _kAddr, address indexed _for);

    // Logged when a withdraw fails
    event Failed(address indexed _kAddr, address indexed _for);

//
// Functions
//

    /// @dev Arrays must be same length. Recipient addresses may be 0x0
    /// @param _kAddrs An array of Withdrawable contract addresses
    /// @param _addrs An array of recipient addresses
    function yank(address[] _kAddrs, address[] _addrs)
    	public
    	returns (bool)
    {
        uint i;
        bool pass;
        uint l = _kAddrs.length;
        address kAddr;
        address addr;
        address[] memory arr;
        for(i; i < l; i++) {
            kAddr = _kAddrs[i];
            addr = _addrs[i];
            if (addr == 0x0) {
                pass = Withdrawable(kAddr).withdrawAll();
                if(pass) WithdrawnAll(kAddr);
            } else {
               arr[0] = addr;
                pass = Withdrawable(kAddr).withdrawAllFor(arr);
                if(pass) WithdrawnAllFor(kAddr, addr);
            }
            if (!pass) Failed(kAddr, addr);
        }
        return true;
    }
}
