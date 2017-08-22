# Withdrawable
v0.3.0

A contract API and implimentation to privision *withdrawable* functionality for Solidity smart contracts.

## ABI
```
[{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"etherBalanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawTo","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"withdraw","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_accept","type":"bool"}],"name":"acceptDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_for","type":"address"},{"name":"_value","type":"uint256"}],"name":"withdrawFor","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"acceptingDeposits","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_accept","type":"bool"}],"name":"AcceptingDeposits","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Withdrawal","type":"event"}]
```

## WithdrawableAbstract

### acceptingDeposits

`function acceptingDeposits() public constant returns(bool)`

Returns true if the contract is accepting deposits.
  
### etherBalanceOf

`function etherBalanceOf(address _addr) constant returns (uint)`

Returns the balance of ether held in the contract for `_addr`

`_addr` An ethereum address

### withdraw

`function withdraw(uint _value) returns (bool)`

Withdraws a value of ether from the contract. Returns success boolean.

### withdrawTo

`function withdrawTo(address _to, uint _value) returns (bool)`

Withdraws a value of ether from the contract sending it to a thirdparty address.

`_to` a recipient address
`_value` the value to withdraw
Returns success boolean
    
### withdrawFor

`function withdrawFor(address _addr, uint _value) returns (bool)`

Sends a value of ether held for an address to that address.

`_addr` a holder address in the contract

`_value` the value to withdraw

Return success boolean

### withdrawFrom

`function withdrawFrom(address _addr, uint _value) returns (bool)`

Withdraws a value of ether from an external `Withdrawable` contract in
which the current contract address holds value. This function calls the
`withdraw(value)` function of the thirdparty contract.

`_addr` The address of a third party `Withdrawable` contract.'

`_value` The value to withdraw into the current contract.

Returns success boolean

### acceptDeposits

`function acceptDeposits(bool _accept) public returns (bool)`

Changes the deposit acceptance state.

`_accept` An accept (`true`) or decline (`false`) boolean.

Returns success boolean

### Events

`event AcceptingDeposits(bool indexed _accept)`

Triggered upon change to deposit acceptance state

`event Deposit(address indexed _from, uint _value)`

Triggered upon receiving a deposit
    
`event Withdrawal(address indexed _from, address indexed _to, uint _value)`

Triggered upon a withdrawal