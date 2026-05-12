// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title StableCoinPayment
 * @notice 나만의 스테이블코인으로 결제하는 컨트랙트
 * @dev 사용자는 approve 후 pay 함수를 호출하여 merchant에게 토큰 결제
 */
contract StableCoinPayment is Ownable {
    IERC20 public stableCoin;
    address public merchant;

    uint256 public feeRate;
    uint256 public constant FEE_DENOMINATOR = 10000;
    uint256 public constant MAX_FEE_RATE = 1000; // 최대 10%

    event Paid(
        address indexed payer,
        address indexed token,
        uint256 amount,
        uint256 fee,
        uint256 merchantAmount,
        uint256 timestamp
    );

    event MerchantUpdated(address indexed oldMerchant, address indexed newMerchant);
    event FeeRateUpdated(uint256 oldFeeRate, uint256 newFeeRate);
    event Withdrawn(address indexed token, uint256 amount);

    constructor(
        address stableCoin_,
        address merchant_,
        uint256 feeRate_
    ) Ownable(msg.sender) {
        require(stableCoin_ != address(0), "Invalid stablecoin address");
        require(merchant_ != address(0), "Invalid merchant address");
        require(feeRate_ <= MAX_FEE_RATE, "Fee too high");

        stableCoin = IERC20(stableCoin_);
        merchant = merchant_;
        feeRate = feeRate_;
    }

    /**
     * @notice 스테이블코인으로 결제
     * @dev 사용자는 이 함수를 호출하기 전에 stableCoin.approve(paymentContract, amount)를 먼저 해야 함
     * @param amount 결제 금액
     */
    function pay(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        uint256 fee = (amount * feeRate) / FEE_DENOMINATOR;
        uint256 merchantAmount = amount - fee;

        if (fee > 0) {
            require(
                stableCoin.transferFrom(msg.sender, address(this), fee),
                "Fee transfer failed"
            );
        }

        require(
            stableCoin.transferFrom(msg.sender, merchant, merchantAmount),
            "Payment transfer failed"
        );

        emit Paid(
            msg.sender,
            address(stableCoin),
            amount,
            fee,
            merchantAmount,
            block.timestamp
        );
    }

    /**
     * @notice merchant 주소 변경
     */
    function setMerchant(address newMerchant) external onlyOwner {
        require(newMerchant != address(0), "Invalid merchant address");

        address oldMerchant = merchant;
        merchant = newMerchant;

        emit MerchantUpdated(oldMerchant, newMerchant);
    }

    /**
     * @notice 수수료율 변경
     * @dev 10000 = 100%, 300 = 3%
     */
    function setFeeRate(uint256 newFeeRate) external onlyOwner {
        require(newFeeRate <= MAX_FEE_RATE, "Fee too high");

        uint256 oldFeeRate = feeRate;
        feeRate = newFeeRate;

        emit FeeRateUpdated(oldFeeRate, newFeeRate);
    }

    /**
     * @notice 컨트랙트에 쌓인 수수료를 owner에게 인출
     */
    function withdrawFees() external onlyOwner {
        uint256 balance = stableCoin.balanceOf(address(this));
        require(balance > 0, "No fees to withdraw");

        require(
            stableCoin.transfer(owner(), balance),
            "Withdraw failed"
        );

        emit Withdrawn(address(stableCoin), balance);
    }

    /**
     * @notice 현재 결제 컨트랙트에 쌓인 수수료 조회
     */
    function feeBalance() external view returns (uint256) {
        return stableCoin.balanceOf(address(this));
    }
}