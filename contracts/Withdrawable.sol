/******************************************************************************\

file:   Withdrawable.sol
ver:    0.2.0
updated:2-Aug-2017
author: Darryl Morris (o0ragman0o)
email:  o0ragman0o AT gmail.com

A contract interface presenting an API for withdraw functionality for balance
holders and inter-contract pull payments.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

Change Log
----------
* Added `withdrawTo(address _to, uint _value)`
* Change `_addr` parameters to semantic names `_to`, `_for`, `_from`
* Move events above transfers.

\******************************************************************************/

pragma solidity ^0.4.13;


contract WithdrawableAbstract
{
//
// State
//

    // Accept/decline payments switch state. Blocking by default
    bool public acceptingDeposits;

//
// Events
//

    // Triggered upon change to deposit acceptance state
    event AcceptingDeposits(bool indexed _accept);
    
    // Triggered upon receiving a deposit
    event Deposit(address indexed _from, uint _value);
    
    // Triggered upon a withdrawal
    event Withdrawal(address indexed _to, uint _value);
    
    // Trigger when a call to withdrawl from an external contract
    event WithdrawnFrom(address indexed _from, uint _value);

//
// Modifiers
//    
    modifier isAcceptingDeposits() {
        require(acceptingDeposits);
        _;
    }
    
//
// Function Abstracts
//

    /// @param _addr An ethereum address
    /// @return The balance of ether held in the contract for `_addr`
    function etherBalanceOf(address _addr) constant returns (uint);
    
    /// @notice withdraw `_value` from account `msg.sender`
    /// @param _value the value to withdraw
    /// @return success
    function withdraw(uint _value) returns (bool);
    
    /// @notice Withdraw `_value` from account `msg.sender` and send `_value` to
    /// address `_to`
    /// @param _to a recipient address
    /// @param _value the value to withdraw
    /// @return success
    function withdrawTo(address _to, uint _value) returns (bool);
    
    /// @notice withdraw `_value` from account `_for`
    /// @param _for a holder address in the contract
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFor(address _for, uint _value) returns (bool);
    
    /// @notice Withdraw `_value` from external contract at `_from` to this
    /// this contract
    /// @param _from a holder address in the contract
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFrom(address _from, uint _value) returns (bool);
    
    /// @notice Change the deposit acceptance state to `_accept`
    /// @param _accept Boolean acceptance state to change to
    /// @return State change success
    function acceptDeposits(bool _accept) public returns (bool);
}


// Example implimentation
contract Withdrawable is WithdrawableAbstract
{
    // Withdrawable contracts should have an owner
    address public owner;

    function Withdrawable()
    {
        owner = msg.sender;
    }
    
    // Payable on condition that contract is accepting deposits
    function ()
        payable
        isAcceptingDeposits
    {
        Deposit(msg.sender, msg.value);
    }
    
    // Change deposit acceptance state
    function acceptDeposits(bool _accept)
        public
        returns (bool)
    {
        require(msg.sender == owner);
        acceptingDeposits = _accept;
        AcceptingDeposits(_accept);
        return true;
    }
    
    // Return an ether balance of an address
    function etherBalanceOf(address _addr)
        constant
        returns (uint)
    {
        return _addr == owner ? this.balance : 0;    
    }
    
    // Withdraw a value of ether awarded to the caller's address
    function withdraw(uint _value)
        public
        returns (bool)
    {
        require(etherBalanceOf(msg.sender) >= _value);
        Withdrawal(msg.sender, _value);
        msg.sender.transfer(_value);
        return true;
    }
    
    // Withdraw a value of ether sending it to the specified address
    function withdrawTo(address _to, uint _value)
        public
        returns (bool)
    {
        require(etherBalanceOf(msg.sender) >= _value);
        Withdrawal(msg.sender, _value);
        _to.transfer(_value);
        return true;
    }
    
    // Push a payment to an address of which has awarded ether
    function withdrawFor(address _for, uint _value)
        public
        returns (bool)
    {
        require (msg.sender == owner);
        Withdrawal(_for, _value);
        _for.transfer(_value);
        return true;
    }
    
    // Withdraw ether from an external contract in which this instance holds
    // a balance of ether
    function withdrawFrom(address _from, uint _value)
        public
        returns (bool)
    {
        WithdrawnFrom(_from, _value);
        return WithdrawableAbstract(_from).withdraw(_value);
    }
}