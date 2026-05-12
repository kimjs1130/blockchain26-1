# Week 10 KSD Chicken Delivery DApp

## 1. 과제 개요

이번 과제는 직접 만든 ERC-20 기반 스테이블코인을 사용해서 치킨을 주문하는 간단한 DApp을 구현한 것이다.

기존 실습이 Remix에서 컨트랙트 함수를 직접 실행하는 형태였다면, 이번에는 사용자가 브라우저 화면에서 지갑을 연결하고 버튼을 눌러 결제를 진행하는 DApp 형태로 구성했다.

구현한 흐름은 다음과 같다.

```text
지갑 연결
-> MyStableCoin / StableCoinPayment 컨트랙트 연결
-> KSD 잔액 확인
-> 치킨 주문하기 클릭
-> ERC-20 approve 실행
-> StableCoinPayment.pay 실행
-> 결제 후 잔액 확인
```

## 2. 사용 기술

- Solidity `^0.8.28`
- OpenZeppelin `ERC20`, `IERC20`, `Ownable`
- Remix IDE
- MetaMask
- ethers.js
- HTML / CSS / JavaScript
- GIWA Sepolia Testnet

## 3. 파일 구성

```text
week10/
├─ MyStableCoin.sol
├─ StableCoinPayment.sol
├─ index.html
├─ README.md
└─ images/
```

- `MyStableCoin.sol`: 직접 발행할 수 있는 ERC-20 스테이블코인 컨트랙트
- `StableCoinPayment.sol`: 사용자가 KSD로 결제하면 merchant에게 토큰을 보내는 결제 컨트랙트
- `index.html`: 치킨 배달 주문 화면으로 만든 DApp 프론트엔드

## 4. 컨트랙트 설명

### MyStableCoin.sol

`MyStableCoin`은 ERC-20 기반 토큰이다. 배포자가 owner가 되고, owner만 `mint()`를 통해 원하는 주소에 토큰을 발행할 수 있다.

배포 시 사용한 값은 다음과 같다.

```text
name: KSD Chicken
symbol: KSD 또는 MST
decimals: 6
```

`decimals`를 6으로 설정했기 때문에 실제 입력값은 다음처럼 계산한다.

```text
1 KSD = 1,000,000
10 KSD = 10,000,000
100 KSD = 100,000,000
```

### StableCoinPayment.sol

`StableCoinPayment`는 치킨 주문 결제를 처리하는 컨트랙트이다.

생성자에는 다음 값을 넣어 배포한다.

```text
stableCoin_: MyStableCoin 컨트랙트 주소
merchant_: 결제 금액을 받을 지갑 주소
feeRate_: 수수료율
```

이번 DApp에서는 단순한 치킨 주문 예시를 위해 `feeRate_`를 `0`으로 설정했다.

결제할 때 사용자는 먼저 `approve()`로 결제 컨트랙트에 토큰 사용 권한을 주고, 이후 `pay()`를 실행한다.

## 5. DApp 실행 방법

`index.html`은 MetaMask와 연결되어야 하므로 파일을 직접 여는 방식보다 로컬 서버로 실행하는 것이 좋다.

```powershell
cd C:\Users\inplu\blockchain\week10
python -m http.server 5500
```

브라우저에서 다음 주소로 접속한다.

```text
http://localhost:5500
```

이후 화면에서 다음 순서로 진행한다.

1. `지갑 연결` 버튼을 눌러 MetaMask 계정을 연결한다.
2. Remix에서 배포한 `MyStableCoin` 컨트랙트 주소를 입력한다.
3. Remix에서 배포한 `StableCoinPayment` 컨트랙트 주소를 입력한다.
4. `컨트랙트 연결` 버튼을 누른다.
5. `잔액 확인` 버튼으로 내 KSD 잔액을 확인한다.
6. `치킨 주문하기` 버튼을 눌러 결제를 진행한다.

## 6. 실행 화면

### 6-1. MyStableCoin 배포

![MyStableCoin 배포](<images/스크린샷 2026-05-12 154301.png>)

Remix에서 `MyStableCoin.sol`을 컴파일하고 GIWA Sepolia Testnet에 배포했다. 생성자 값으로 토큰 이름, 심볼, decimals 값을 입력했다.

### 6-2. StableCoinPayment 배포

![StableCoinPayment 배포](<images/스크린샷 2026-05-12 154435.png>)

`StableCoinPayment.sol`을 배포할 때 `stableCoin_`에는 앞에서 배포한 `MyStableCoin` 주소를 넣었다. `merchant_`에는 치킨값을 받을 지갑 주소를 넣었고, 수수료 없이 테스트하기 위해 `feeRate_`는 `0`으로 설정했다.

### 6-3. DApp에서 지갑 및 컨트랙트 연결

![DApp 컨트랙트 연결](<images/스크린샷 2026-05-12 154457.png>)

브라우저에서 `index.html`을 실행한 뒤 MetaMask 지갑을 연결했다. 이후 `MyStableCoin` 주소와 `StableCoinPayment` 주소를 입력하고 `컨트랙트 연결`을 실행했다.

화면에는 내 KSD 잔액이 표시된다. 이 예시에서는 `1000.0 MST`가 표시되어 결제 가능한 토큰 잔액을 확인할 수 있다.

### 6-4. 치킨 주문하기와 approve

![approve 요청](<images/스크린샷 2026-05-12 154511.png>)

`치킨 주문하기` 버튼을 누르면 먼저 ERC-20 `approve()`가 실행된다. MetaMask는 결제 컨트랙트가 내 토큰 10개를 사용할 수 있도록 지출 한도를 승인할지 물어본다.

ERC-20 토큰은 컨트랙트가 사용자 지갑의 토큰을 바로 가져갈 수 없기 때문에, 결제 전에 `approve()` 과정이 필요하다.

### 6-5. pay 함수 실행

![pay 요청](<images/스크린샷 2026-05-12 155049.png>)

approve가 완료되면 DApp은 이어서 `StableCoinPayment.pay()`를 실행한다. 이 단계에서 치킨값 10 KSD가 결제 컨트랙트를 통해 merchant 주소로 전송된다.

MetaMask에서 트랜잭션을 컨펌하면 실제 블록체인에 결제 트랜잭션이 전송된다.

## 7. 핵심 코드 흐름

`index.html`에서는 ethers.js를 사용해 MetaMask와 연결한다.

```javascript
provider = new ethers.BrowserProvider(window.ethereum);
await provider.send("eth_requestAccounts", []);
signer = await provider.getSigner();
account = await signer.getAddress();
```

치킨 주문 버튼을 누르면 먼저 `approve()`를 실행한다.

```javascript
const amount = ethers.parseUnits(CHICKEN_PRICE, decimals);
const approveTx = await token.approve(paymentAddress, amount);
await approveTx.wait();
```

approve가 끝나면 실제 결제 함수인 `pay()`를 실행한다.

```javascript
const payTx = await payment.pay(amount);
await payTx.wait();
```

결제가 끝난 뒤에는 `balanceOf()`로 잔액을 다시 읽어 화면에 표시한다.

```javascript
const balance = await token.balanceOf(account);
balanceElement.textContent = ethers.formatUnits(balance, decimals);
```

## 8. 결과

이번 실습을 통해 단순히 Remix에서 컨트랙트 함수를 직접 실행하는 것이 아니라, 사용자가 브라우저에서 지갑을 연결하고 실제 DApp처럼 결제를 진행하는 화면을 구현했다.

특히 ERC-20 결제에서 중요한 흐름인 `approve -> pay -> balanceOf` 구조를 치킨 배달 주문 예시로 확인했다.

정리하면 다음 기능을 구현했다.

- MetaMask 지갑 연결
- GIWA Sepolia Testnet에서 배포한 컨트랙트 연결
- ERC-20 스테이블코인 잔액 조회
- 치킨 주문 버튼을 통한 `approve()` 실행
- 결제 컨트랙트의 `pay()` 실행
- 결제 후 잔액 확인
