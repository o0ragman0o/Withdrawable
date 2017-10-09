/******************************************************************************\

file:   Yank.sol
ver:    0.4.0
updated:9-Oct-2017
author: Darryl Morris (o0ragman0o)
email:  o0ragman0o AT gmail.com

Yank is a standalone took to pull a series of `WithdrawAll()` and
`WithdrawAllFor()` payments from Withdrawable contracts. This can pull ether
through a chain of contract addresses to exit address/s

`yankAll(_kAddrs, _addrs)` is provided two arrays of contract addresses and
recipient addresses of the same length. If a recipient address for an index
is 0x0,Yank will call the WithdrawAll(), else WithdrawAllFor()

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

Change Log
----------
* First release

\******************************************************************************/

pragma solidity ^0.4.13;

import "./Withdrawable.sol";

contract Yank
{
//
// Constants
//
	bytes32 public constant VERSION = "Yank v0.4.0";

//
// Events
//

    // Logged when a call to WithdrawlAll is made
    event WithdrawnAll(address indexed _kAddr);
    
    // Logged when a call to WithdrawAllFor is made
    event WithdrawnAllFor(address indexed _kAddr, address indexed _for);

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
        uint l = _kAddrs.length;
        for(i; i < l; i++) {
            if (_addrs[0] == 0x0) {
                Withdrawable(_kAddrs[i]).withdrawAll();
                WithdrawnAll(_kAddrs[i]);
            } else {
                Withdrawable(_kAddrs[i]).withdrawAllFor(_addrs[i]);
                WithdrawnAllFor(_kAddrs[i], _addrs[i]);
            }
        }
        return true;
    }
}

