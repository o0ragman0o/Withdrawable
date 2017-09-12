# Withdrawable
v0.3.1

A contract API and example implimentation to privision point to point pull 
payments from contract to contract or contract to external account using
a *withdraw* paradigm rather than *transfer*.

Ether differs from other value mechanisms such as ERC20 tokens in that it is 
intrinsically transferrable between accounts rather than accounts being 
registered against tokens existing only in a contract. While ERC20 offers `transfer()` and `transferFrom()` 
the nature of ether differs enough from tokens for ether to warrent a dedicated 
API standard for moving money between contracts and addresses in a permissioned 
or unpermissioned manner.

Payment channels, for example, may have a single internally defined recipient
so it may be of benefit not to permission the `withdrawAll()` function and allow
any address to call it and move the money to that recipient.  This makes
contract to contract transfers and clearing house operations simpler.

The API describes two getters, one adminitrative function, five variants of
withdraw functions and three events.
`withdrawAll()` along with `Deposit()` and `Withdrawal()` events should
be the minimal implimentation with other functions left as optional. 

## ABI
```
[{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"etherBalanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawTo","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"withdraw","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"withdrawAll","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_accept","type":"bool"}],"name":"acceptDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_for","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFor","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"acceptingDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_accept","type":"bool"}],"name":"AcceptingDeposits","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Withdrawal","type":"event"}]
```

## WithdrawableAbstract

### acceptingDeposits
```
function acceptingDeposits() public constant returns(bool)
```
Returns true if the contract is accepting deposits.
  
### etherBalanceOf
```
function etherBalanceOf(address _addr) constant returns (uint)
```
Returns the balance of ether held in the contract for `_addr`

`_addr` An ethereum address

### withdraw
```
function withdraw(uint _value) returns (bool)
```
Withdraws a value of ether from the contract. Returns success boolean.

`_value` the value to withdraw

### withdrawAll
```
function withdrawAll() returns (bool);
```
Withdraws entire balance of sender to the sender or other internally specified
address.

Returns success boolean

### withdrawTo
```
function withdrawTo(address _to, uint _value) returns (bool)
```
Withdraws a value of ether from the contract sending it to a thirdparty address.

`_to` a recipient address

`_value` the value to withdraw

Returns success boolean
    
### withdrawFor
```
function withdrawFor(address _addr, uint _value) returns (bool)
```
Sends a value of ether held for an address to that address.

`_addr` a holder address in the contract

`_value` the value to withdraw

Return success boolean

### withdrawFrom
```
function withdrawFrom(address _addr, uint _value) returns (bool)
```
Withdraws a value of ether from an external `Withdrawable` contract in
which the current contract address may hold value. This function calls the
`withdraw(value)` function of the thirdparty contract.

`_addr` The address of a third party `Withdrawable` contract.'

`_value` The value to withdraw into the current contract.

Returns success boolean

### acceptDeposits
```
function acceptDeposits(bool _accept) public returns (bool)
```
Changes the deposit acceptance state.

`_accept` An accept (`true`) or decline (`false`) boolean.

Returns success boolean

### Events
```
event AcceptingDeposits(bool indexed _accept)
```
Logged upon change to deposit acceptance state

`event Deposit(address indexed _from, uint _value)`

Logged upon receiving a deposit
    
`event Withdrawal(address indexed _from, address indexed _to, uint _value)`

Logged upon a withdrawal