// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Faucet {
    address payable public owner;
    uint256 public constant WITHDRAWAL_AMOUNT = 0.01 ether;
    uint256 public constant LOCK_TIME = 1 days;

    mapping(address => uint256) public lastWithdrawalTime;

    event Withdrawal(address indexed user, uint256 amount);
    event Deposit(address indexed sender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    function withdraw() external {
        require(
            block.timestamp >= lastWithdrawalTime[msg.sender] + LOCK_TIME,
            "You must wait 24 hours between withdrawals."
        );
        require(
            address(this).balance >= WITHDRAWAL_AMOUNT,
            "Insufficient balance in the faucet."
        );

        lastWithdrawalTime[msg.sender] = block.timestamp;
        (bool success, ) = payable(msg.sender).call{value: WITHDRAWAL_AMOUNT}("");
        require(success, "ETH transfer failed.");

        emit Withdrawal(msg.sender, WITHDRAWAL_AMOUNT);
    }

    function deposit() external payable onlyOwner {
        require(msg.value > 0, "Send ETH to deposit.");
        emit Deposit(msg.sender, msg.value);
    }

    function withdrawAll() external onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Owner transfer failed.");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
