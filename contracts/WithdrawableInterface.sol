/******************************************************************************\

file:   WithdrawableInterface.sol
ver:    0.0.1
updated:21-May-2017
author: Darryl Morris (o0ragman0o)
email:  o0ragman0o AT gmail.com

A contract interface presenting an API for withdraw functionality for balance
holders and inter-contract pull payments.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

\******************************************************************************/

pragma solidity ^0.4.10;


contract WithdrawableInterface
{
    /// @notice Withdraw `_value` from account `msg.sender`
    /// @param _value the value to withdraw
    /// @return success
    function withdraw(uint _value) returns (bool);
    
    /// @notice Withdraw `_value` from account `_addr`
    /// @param _addr a holder address in the contract
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFor(address _addr, uint _value) returns (bool);
    
    /// @notice Withdraw `_value` from external contract at `_addr` to this
    /// this contract
    /// @param _addr a holder address in the contract
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFrom(address _addr, uint _value) returns (bool);
}