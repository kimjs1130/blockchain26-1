# Week 10 StableCoin Payment DApp

## 1. 과제 개요

이번 과제는 **Nodit RPC를 이용해 GIWA Sepolia Testnet에 접속**하고, 직접 만든 ERC-20 기반 스테이블코인으로 결제하는 DApp 구조를 구현하는 것이다.

구현한 컨트랙트는 두 가지이다.

- `MyStableCoin.sol`: 직접 발행할 수 있는 ERC-20 기반 스테이블코인
- `StableCoinPayment.sol`: 사용자가 스테이블코인으로 결제하면 가맹점에게 금액을 보내고, 일부 수수료를 컨트랙트에 적립하는 결제 컨트랙트

결제 흐름은 다음과 같다.

1. `MyStableCoin`을 GIWA Sepolia Testnet에 배포한다.
2. `StableCoinPayment`를 배포하면서 스테이블코인 주소, merchant 주소, 수수료율을 설정한다.
3. owner가 사용자에게 스테이블코인을 `mint`한다.
4. 사용자가 결제 컨트랙트에 `approve`로 토큰 사용 권한을 준다.
5. 사용자가 `pay`를 실행한다.
6. 결제 금액 중 일부는 수수료로 컨트랙트에 남고, 나머지는 merchant에게 전송된다.

## 2. 사용 기술

- Solidity `^0.8.28`
- OpenZeppelin `ERC20`, `IERC20`, `Ownable`
- Remix IDE
- MetaMask
- Nodit RPC
- GIWA Sepolia Testnet

## 3. Nodit과 GIWA 체인 사용

MetaMask에는 GIWA Sepolia Testnet을 추가하고, RPC URL은 Nodit에서 발급받은 GIWA Sepolia RPC를 사용했다.

```text
Network: GIWA Sepolia Testnet
RPC URL: https://giwa-sepolia.nodit.io/{API_KEY}
Chain ID: 91342
Currency Symbol: ETH
Explorer: https://sepolia-explorer.giwa.io/
```

즉, 직접 새로운 체인을 만드는 것이 아니라 **GIWA Sepolia Testnet 위에 컨트랙트를 배포**하고, 그 네트워크에 접근하는 통로로 **Nodit RPC**를 사용했다.

## 4. 컨트랙트 설명

### MyStableCoin.sol

`MyStableCoin`은 과제용 나만의 스테이블코인이다. OpenZeppelin의 ERC-20을 기반으로 만들었고, 배포자가 owner가 되어 `mint()`를 통해 원하는 주소에 토큰을 발행할 수 있다.

배포할 때 입력한 값은 다음과 같다.

```text
name: Korean Stable Dollar
symbol: KSD
decimals: 6
```

`decimals`를 6으로 설정했기 때문에 USDC처럼 계산한다.

```text
1 KSD = 1,000,000
10 KSD = 10,000,000
100 KSD = 100,000,000
```

### StableCoinPayment.sol

`StableCoinPayment`는 사용자가 KSD로 결제할 수 있게 하는 컨트랙트이다.

생성자에는 다음 값을 넣는다.

- `stableCoin_`: `MyStableCoin` 컨트랙트 주소
- `merchant_`: 결제 금액을 받을 가맹점 주소
- `feeRate_`: 수수료율

수수료율은 basis points 방식이다.

```text
10000 = 100%
300 = 3%
100 = 1%
```

이번 실습에서는 `feeRate`를 `300`으로 설정해 결제 금액의 3%가 수수료로 쌓이도록 했다.

## 5. 실습 이미지 설명

### 5-1. MyStableCoin 배포

![MyStableCoin 배포](<images/스크린샷 2026-05-11 154411.png>)

이 화면은 Remix에서 `MyStableCoin.sol`을 GIWA Sepolia Testnet에 배포하는 장면이다.  
왼쪽 Deploy 패널에서 `name`, `symbol`, `decimals` 값을 입력했고, 오른쪽 MetaMask에서는 GIWA Sepolia Testnet에서 컨트랙트 배포 트랜잭션을 승인하는 창이 떠 있다.

이 단계의 의미는 **나만의 스테이블코인 KSD를 GIWA 체인에 배포하는 것**이다.

### 5-2. StableCoinPayment 배포

![StableCoinPayment 배포](<images/스크린샷 2026-05-11 154639.png>)

이 화면은 `StableCoinPayment.sol`을 배포하는 장면이다.  
생성자 값으로 앞에서 배포한 `MyStableCoin` 주소, merchant 주소, 수수료율 `300`을 입력했다.

`300`은 3% 수수료를 의미한다. 사용자가 10 KSD를 결제하면 0.3 KSD는 수수료로 결제 컨트랙트에 남고, 9.7 KSD는 merchant에게 전송된다.

### 5-3. 사용자에게 KSD mint

![KSD mint 요청](<images/스크린샷 2026-05-11 155115.png>)

이 화면은 `MyStableCoin`의 `mint(address to, uint256 amount)` 함수를 실행하는 장면이다.  
받는 주소에는 사용자 지갑 주소를 입력했고, 발행량은 `100000000`을 입력했다.

`decimals`가 6이므로 `100000000`은 실제로 **100 KSD**를 의미한다.

```text
100000000 / 10^6 = 100 KSD
```

오른쪽 MetaMask 창은 이 mint 트랜잭션을 GIWA Sepolia Testnet에 전송하기 전 확인하는 화면이다.

### 5-4. approve 실행

![approve 실행](<images/스크린샷 2026-05-11 155209.png>)

이 화면은 사용자가 `approve()`를 실행해 결제 컨트랙트가 자신의 KSD를 사용할 수 있도록 허락하는 장면이다.

입력값은 다음과 같다.

```text
spender: StableCoinPayment 컨트랙트 주소
amount: 10000000
```

`10000000`은 10 KSD이다.  
ERC-20 토큰은 컨트랙트가 사용자 지갑의 토큰을 바로 가져갈 수 없기 때문에, 결제 전에 반드시 `approve()`로 사용 권한을 먼저 줘야 한다.

### 5-5. pay 실행

![pay 실행](<images/스크린샷 2026-05-11 155254.png>)

이 화면은 `StableCoinPayment`의 `pay(10000000)`을 실행하는 장면이다.

`10000000`은 10 KSD 결제를 의미한다. 결제 컨트랙트는 이 금액을 기준으로 수수료를 계산한다.

```text
결제 금액: 10 KSD
수수료율: 3%
수수료: 0.3 KSD
merchant 수령액: 9.7 KSD
```

트랜잭션이 성공하면 `Paid` 이벤트가 발생하고, 토큰 이동이 실제로 처리된다.

### 5-6. balanceOf 결과 확인

![balanceOf 결과](<images/스크린샷 2026-05-11 155353.png>)

이 화면은 `MyStableCoin`의 `balanceOf()`로 지갑 잔액을 확인한 결과이다.

출력값은 다음과 같다.

```text
99700000
```

`decimals`가 6이므로 이는 **99.7 KSD**를 의미한다.

이번 실습에서는 customer 주소와 merchant 주소를 같은 지갑으로 사용했기 때문에, 잔액 변화가 다음처럼 계산된다.

```text
초기 잔액: 100 KSD
결제 금액: -10 KSD
merchant 수령액: +9.7 KSD
최종 잔액: 99.7 KSD
```

따라서 `99700000`이 나온 것은 결제 금액 중 0.3 KSD만 수수료로 빠져나가고, 9.7 KSD는 같은 지갑으로 다시 들어왔다는 뜻이다.  
즉, 결제 컨트랙트의 수수료 분리 로직이 정상적으로 동작했음을 확인할 수 있다.

## 6. 전체 실습 결과

실습에서 확인한 내용은 다음과 같다.

- Nodit RPC를 통해 GIWA Sepolia Testnet에 연결했다.
- Remix와 MetaMask를 이용해 `MyStableCoin`을 배포했다.
- 직접 만든 KSD 토큰을 사용자 지갑에 `mint`했다.
- `StableCoinPayment` 컨트랙트를 배포하고 3% 수수료율을 설정했다.
- ERC-20 결제에 필요한 `approve` 과정을 수행했다.
- `pay`를 실행해 KSD 결제와 수수료 분리 처리를 확인했다.
- `balanceOf` 결과로 최종 잔액 `99.7 KSD`를 확인했다.

## 7. 결론

이번 과제를 통해 GIWA Sepolia Testnet에서 직접 만든 스테이블코인과 결제 컨트랙트가 상호작용하는 흐름을 구현했다.

핵심 흐름은 다음과 같다.

```text
Nodit RPC 연결
-> MyStableCoin 배포
-> StableCoinPayment 배포
-> mint
-> approve
-> pay
-> balanceOf로 결과 확인
```

이를 통해 ERC-20 기반 스테이블코인 결제에서는 `approve`와 `transferFrom` 구조가 중요하며, 결제 컨트랙트를 통해 merchant 정산 금액과 플랫폼 수수료를 분리할 수 있다는 점을 확인했다.
