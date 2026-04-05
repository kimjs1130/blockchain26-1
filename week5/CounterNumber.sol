// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CounterNumber {
    int private _number = 10;

    function getNumber() public view returns (int) {
        return _number;
    }

    function setNumber(int newNumber) public {
        _number = newNumber;
    }
}
