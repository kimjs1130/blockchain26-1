// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CombinedContract {
    // 상태 변수 (private)
    string private _greeting = "Hello, World!";
    int private _number = 10;

    // Greeting 관련 함수
    function getGreeting() public view returns (string memory) {
        return _greeting;
    }

    function setGreeting(string memory newGreeting) public {
        _greeting = newGreeting;
    }

    // Number 관련 함수
    function getNumber() public view returns (int) {
        return _number;
    }

    function setNumber(int newNumber) public {
        _number = newNumber;
    }
}
