/******************************************************************************\

file:   Withdrawable.sol
ver:    0.3.4
updated:7-Oct-2017
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
* Added minimal interface
* Fixed WithdrawableItfc typo

\******************************************************************************/

pragma solidity ^0.4.13;

interface WithdrawableMinItfc
{
//
// Events
//

    // Logged upon receiving a deposit
    /// @param _from The address from which value has been recieved
    /// @param _value The value of ether received
    event Deposit(address indexed _from, uint _value);
    
    // Logged upon a withdrawal
    /// @param _by the address of the withdrawer
    /// @param _to Address to which value was sent
    /// @param _value The value in ether which was withdrawn
    event Withdrawal(address indexed _by, address indexed _to, uint _value);

    /// @notice withdraw total balance from account `msg.sender`
    /// @return success
    function withdrawAll() public returns (bool);
}

interface WithdrawableItfc
{
//
// Events
//

    // Triggered upon change to deposit acceptance state
    /// @param _accept Boolean acceptance value
    event AcceptingDeposits(bool indexed _accept);

    // Logged upon receiving a deposit
    /// @param _from The address from which value has been recieved
    /// @param _value The value of ether received
    event Deposit(address indexed _from, uint _value);
    
    // Logged upon a withdrawal
    /// @param _by the address of the withdrawer
    /// @param _to Address to which value was sent
    /// @param _value The value in ether which was withdrawn
    event Withdrawal(address indexed _by, address indexed _to, uint _value);

//
// Function Abstracts
//

    /// @return Returns whether deposits are accepted
    function acceptingDeposits() public view returns (bool);

    /// @param _addr An ethereum address
    /// @return The balance of ether held in the contract for `_addr`
    function etherBalanceOf(address _addr) public view returns (uint);
    
    /// @notice withdraw total balance from account `msg.sender`
    /// @return success
    function withdrawAll() public returns (bool);

    /// @notice withdraw `_value` from account `msg.sender`
    /// @param _value the value to withdraw
    /// @return success
    function withdraw(uint _value) public returns (bool);
    
    /// @notice Withdraw `_value` from account `msg.sender` and send `_value` to
    /// address `_to`
    /// @param _to a recipient address
    /// @param _value the value to withdraw
    /// @return success
    function withdrawTo(address _to, uint _value) public returns (bool);
    
    /// @notice withdraw `_value` from account `_for`
    /// @param _for a holder address in the contract
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFor(address _for, uint _value) public returns (bool);
    
    /// @notice Withdraw all this contracts held value from external contract
    /// at `_from`
    /// @param _from a contract address where this contract's value is held
    /// @return success
    function withdrawAllFrom(address _from) public returns (bool);
    
    /// @notice Withdraw `_value` from external contract at `_from` to this
    /// this contract
    /// @param _from a contract address where this contract's value is held
    /// @param _value the value to withdraw
    /// @return success
    function withdrawFrom(address _from, uint _value) public returns (bool);
    
    /// @notice Change the deposit acceptance state to `_accept`
    /// @param _accept Boolean acceptance state to change to
    /// @return State change success
    function acceptDeposits(bool _accept) public returns (bool);
}


contract WithdrawableAbstract is WithdrawableItfc
{
//
// State
//

    // Accept/decline payments switch state. Blocking by default
    bool accepting;

//
// Modifiers
//    
    modifier isAcceptingDeposits() {
        require(accepting);
        _;
    }
}


// Example implimentation
contract Withdrawable is WithdrawableAbstract
{
    // Withdrawable contracts should have an owner
    address public owner;

    function Withdrawable()
        public
    {
        owner = msg.sender;
    }
    
    // Payable on condition that contract is accepting deposits
    function ()
        public
        payable
        isAcceptingDeposits
    {
        Deposit(msg.sender, msg.value);
    }
    
    function acceptingDeposits()
        public
        view
        returns (bool)
    {
        return accepting;
    }
    
    // Return an ether balance of an address
    function etherBalanceOf(address _addr)
        public
        view
        returns (uint)
    {
        return _addr == owner ? this.balance : 0;    
    }
    
    // Change deposit acceptance state
    function acceptDeposits(bool _accept)
        public
        returns (bool)
    {
        require(msg.sender == owner);
        accepting = _accept;
        AcceptingDeposits(_accept);
        return true;
    }
    
    // Withdraw a value of ether awarded to the caller's address
    function withdraw(uint _value)
        public
        returns (bool)
    {
        require(etherBalanceOf(msg.sender) >= _value);
        Withdrawal(msg.sender, msg.sender, _value);
        msg.sender.transfer(_value);
        return true;
    }
    
    // Withdraw entire ether balance from caller's account to caller's address
    function withdrawAll()
        public
        returns (bool)
    {
        return withdraw(etherBalanceOf(msg.sender));
    }
    
    // Withdraw a value of ether sending it to the specified address
    function withdrawTo(address _to, uint _value)
        public
        returns (bool)
    {
        require(etherBalanceOf(msg.sender) >= _value);
        Withdrawal(msg.sender, _to, _value);
        _to.transfer(_value);
        return true;
    }
    
    // Push a payment to an address of which has awarded ether
    function withdrawFor(address _for, uint _value)
        public
        returns (bool)
    {
        require(etherBalanceOf(_for) >= _value);
        Withdrawal(msg.sender, _for, _value);
        _for.transfer(_value);
        return true;
    }
    
    // Withdraw all awarded ether from an external contract in which this
    // instance holds a balance
    function withdrawAllFrom(address _kAddr)
        public
        returns (bool)
    {
        uint currBal = this.balance;
        WithdrawableMinItfc(_kAddr).withdrawAll();
        Deposit(_kAddr, this.balance - currBal);
        return true;
    }
    
    // Withdraw ether from an external contract in which this instance holds
    // a balance
    function withdrawFrom(address _kAddr, uint _value)
        public
        returns (bool)
    {
        Deposit(_kAddr, _value);
        return WithdrawableAbstract(_kAddr).withdraw(_value);
    }
}