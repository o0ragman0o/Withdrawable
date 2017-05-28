/******************************************************************************\

file:   Withdrawable.sol
ver:    0.0.2
updated:23-May-2017
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
    address public owner;
    // Trigger upon recieving a deposit
    event Deposit(address sender, uint value);
    
    // Triggered upon a withdrawal
    event Withdrawal(address to, uint value);
    
    // Trigger when a call to withdrawl from an external contract
    event WithdrawFrom(address from, uint value);
    
    /// @notice withdraw `_value` from account `msg.sender`
    /// @param _value the value to withdraw
    /// @return success
    function withdraw(uint _value) returns (bool);
    
    /// @notice withdraw `_value` from account `_addr`
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
    
    // Need to overload in deriving contract
    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }
}

contract Withdrawable is WithdrawableInterface
{
    function ()
        payable
    {
        Deposit(msg.sender, msg.value);
    }
    
    function withdraw(uint _value)
        public
        returns (bool)
    {
        owner.transfer(_value);
        Withdrawal(owner, _value);
        return true;
    }
    
    function withdrawFor(address _to, uint _value)
        public
        onlyOwner
        returns (bool)
    {
        _to.transfer(_value);
        Withdrawal(_to, _value);
        return true;
    }
    
    function withdrawFrom(address _from, uint _value)
        public
        returns (bool)
    {
        WithdrawFrom(_from, _value);
        return Withdrawable(_from).withdraw(_value);
    }
}