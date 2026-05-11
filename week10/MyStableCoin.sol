// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyStableCoin
 * @notice 과제용 나만의 스테이블코인
 * @dev ERC-20 기반 토큰이며, owner만 mint 가능
 */
contract MyStableCoin is ERC20, Ownable {
    uint8 private immutable _customDecimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        _customDecimals = decimals_;
    }

    /**
     * @notice USDC처럼 6 decimals를 쓰고 싶으면 배포할 때 decimals_에 6 입력
     */
    function decimals() public view override returns (uint8) {
        return _customDecimals;
    }

    /**
     * @notice owner만 토큰 발행 가능
     * @param to 토큰을 받을 주소
     * @param amount 발행할 양
     */
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid receiver");
        require(amount > 0, "Amount must be greater than zero");

        _mint(to, amount);
    }
}