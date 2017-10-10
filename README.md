# Withdrawable
v0.4.0

A contract API and example implimentation to privision point to point pull 
payments from contract to contract or contract to external account using
a *withdraw* paradigm rather than *transfer*.

Ether differs significantly from other value mechanisms such as ERC20 tokens
in that it is intrinsically transferrable between accounts rather than accounts
being registered against tokens existing only in a contract. While ERC20 offers `transfer()` and `transferFrom()` 
the nature of ether differs enough from tokens for *ether* to warrent a dedicated 
API standard for moving money between contracts and addresses to which
destinations and values are permissioned but caller need not be.

Payment channels, for example, might have a single internally defined recipient
so it may be of benefit not to permission the `withdrawAll()` function and allow
any address to call it and move the money to that recipient.  This makes
contract to contract transfers and clearing house operations simpler.

The API describes two getters, one adminitrative function, five variants of
withdraw functions, two contract initiated withdraw functions and
three events.

A minimal API is offered containing `withdrawAll()` along with `Deposit()` and
`Withdrawal()` with all other functions being optional. 

A stateless singleton clearing house contract called `Yank` can be supplied an
array of withdrawable contract addresses and recipient addresses with which to
pull money through a chain or group of contracts to exit addresses.

## WithdrawableMinItfc
### ABI
```
[{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"etherBalanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawTo","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"withdraw","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"withdrawAll","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_accept","type":"bool"}],"name":"acceptDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_for","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFor","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"acceptingDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"}],"name":"withdrawAllFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_accept","type":"bool"}],"name":"AcceptingDeposits","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_by","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Withdrawal","type":"event"}]
```

### withdrawAll
```
function withdrawAll() public returns (bool);
```
Withdraws entire balance to the sender or other internally specified address.

Returns success boolean

### Events
```
event Deposit(address indexed _from, uint _value)
```
Logged upon receiving a deposit.

`_from` The sender address

`_value` The value of ether recieved

    
```
event Withdrawal(address indexed _by, address indexed _to, uint _value)
```
Logged upon a withdrawal.

`_by` The caller of the withdrawl

`_to` The addres to which funds were sent

`_value` The value of ether sent



## WithdrawableAbstract

### ABI
```
[{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"etherBalanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawTo","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"withdraw","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_for","type":"address"}],"name":"withdrawAllFor","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"withdrawAll","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_accept","type":"bool"}],"name":"acceptDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_kAddr","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_for","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFor","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"acceptingDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_kAddr","type":"address"}],"name":"withdrawAllFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_accept","type":"bool"}],"name":"AcceptingDeposits","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_by","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Withdrawal","type":"event"}]
```
### acceptingDeposits
```
function acceptingDeposits() public view returns(bool)
```
Optional

Returns true if the contract is accepting deposits.
  
### etherBalanceOf
```
function etherBalanceOf(address _addr) public view returns (uint)
```
Recommended

Returns the balance of ether held in the contract for `_addr`

`_addr` An ethereum address

### withdrawAll
```
function withdrawAll() public returns (bool);
```
Required

Withdraws entire balance of sender to the sender or other internally specified
address.

Returns success boolean

### withdraw
```
function withdraw(uint _value) public returns (bool)
```
Optional

Withdraws a value of ether from the contract. Returns success boolean.

`_value` the value to withdraw

### withdrawTo
```
function withdrawTo(address _to, uint _value) public returns (bool)
```
Optional

Withdraws a value of ether from the contract sending it to a thirdparty address.

`_to` a recipient address

`_value` the value to withdraw

Returns success boolean

### withdrawAllFor
```
function withdrawAllFor(address _addr) public returns (bool)
```
Sends entire balance of the supplied address to the supplied address

`_addr` a holder address in the contract

Returns success boolean
    
### withdrawFor
```
function withdrawFor(address _addr, uint _value) public returns (bool)
```
Optional

Sends a value of ether held for an address to that address.

`_addr` a holder address in the contract

`_value` the value to withdraw

Return success boolean

### withdrawAllFrom
```
function withdrawAllFrom(address _kAddr) public returns (bool)
```
Optional

Withdraws all awarded ether from an external `Withdrawable` contract in
which the current contract address may hold value. This function calls the
`withdrawAll()` function of the thirdparty contract.

`_kAddr` The address of a third party `Withdrawable` contract.'

`_value` The value to withdraw into the current contract.

Returns success boolean

### withdrawFrom
```
function withdrawFrom(address _kAddr, uint _value) public returns (bool)
```
Optional

Withdraws a value of ether from an external `Withdrawable` contract in
which the current contract address may hold value. This function calls the
`withdraw(value)` function of the thirdparty contract.

`_kAddr` The address of a third party `Withdrawable` contract.'

`_value` The value to withdraw into the current contract.

Returns success boolean

### acceptDeposits
```
function acceptDeposits(bool _accept) public returns (bool)
```
Optional

Changes the deposit acceptance state.

`_accept` An accept (`true`) or decline (`false`) boolean.

Returns success boolean

### Events
```
event AcceptingDeposits(bool indexed _accept)
```
Logged upon change to deposit acceptance state.

`_accept` A boolean value indicating acceptance state.

```
event Deposit(address indexed _from, uint _value)
```
Logged upon receiving a deposit.

`_from` The sender address

`_value` The value of ether recieved

    
```
event Withdrawal(address indexed _by, address indexed _to, uint _value)
```
Logged upon a withdrawal.

`_by` The caller of the withdrawl

`_to` The addres to which funds were sent

`_value` The value of ether sent

## Yank
### ABI
```
[{"constant":false,"inputs":[{"name":"_kAddrs","type":"address[]"},{"name":"_addrs","type":"address[]"}],"name":"yank","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"regName","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_kAddr","type":"address"}],"name":"WithdrawnAll","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_kAddr","type":"address"},{"indexed":true,"name":"_for","type":"address"}],"name":"WithdrawnAllFor","type":"event"}]
```

### VERSION
```
function VERSION() public constant returns (bytes32)
```
Returns the UTF8 encoded version as a bytes32

### regName
```
function regName() public constant returns (bytes32)
```
Returns 'yank' as a bytes32 type for registration with SandalStraps

### yank
```
function yank(address[] _kAddrs, address[] _addrs) public returns (bool);
```
Performs clearing house pull payments across an array of withdrawable contracts.
`_kAddrs` and `_addrs` must be of equal length with `_addrs` values being `0x0` where
not recipient address is required.

`_kAddrs[]` An array of withdrawable contracts

`_addrs[]` An array of recipient addresses