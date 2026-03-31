// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Faucet {
    // 상태 변수
    address payable public owner;
    uint256 public constant WITHDRAWAL_AMOUNT = 0.1 ether;
    uint256 public constant LOCK_TIME = 1 days;

    // 각 주소의 마지막 출금 시간 기록
    mapping(address => uint256) public lastWithdrawalTime;

    // 이벤트
    event Withdrawal(address indexed to, uint256 amount);
    event Deposit(address indexed from, uint256 amount);

    // Constructor
    constructor() {
        owner = payable(msg.sender);
    }

    // Modifier: owner만 호출 가능
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // 출금 함수 (핵심 기능)
    function withdraw() public {
        // 1. 마지막 출금 이후 24시간이 지났는지 확인
        require(
            block.timestamp >= lastWithdrawalTime[msg.sender] + LOCK_TIME,
            "You must wait 24 hours between withdrawals"
        );

        // 2. 계약이 충분한 잔액을 가졌는지 확인
        require(
            address(this).balance >= WITHDRAWAL_AMOUNT,
            "Faucet is empty"
        );

        // 3. 출금 시간 기록
        lastWithdrawalTime[msg.sender] = block.timestamp;

        // 4. ETH 전송
        payable(msg.sender).transfer(WITHDRAWAL_AMOUNT);

        // 5. 이벤트 발생
        emit Withdrawal(msg.sender, WITHDRAWAL_AMOUNT);
    }

    // 입금 함수
    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 전액 회수 함수 (owner 전용)
    function withdrawAll() public onlyOwner {
        uint256 amount = address(this).balance;
        owner.transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // 직접 ETH 전송 시 자동 호출
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 계약의 현재 잔액 조회
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
