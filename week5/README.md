# Week 5 Solidity Practice

## 개요
5주차 프레젠테이션 범위를 기준으로 다음 3가지 주제를 실습했습니다.

- `Counter.sol`
- `CounterNumber.sol`
- `Faucet.sol`

이번 실습은 `week5/lab1.html` 시뮬레이터와 Solidity 소스 파일을 함께 사용해서 진행했습니다.

## 실행 방법
프로젝트 루트에서 아래 방법 중 하나로 실행할 수 있습니다.

### 방법 1
```powershell
cd C:\Users\inplu\blockchain\week5
start lab1.html
```

### 방법 2
```powershell
cd C:\Users\inplu\blockchain\week5
python -m http.server 8000
```

브라우저 접속 주소:

```text
http://localhost:8000/lab1.html
```

## 실습 파일
- `CounterNumber.sol`: 숫자 조회 및 변경 실습
- `CombinedContract.sol`: 초기 실습용 결합 계약
- `Faucet.sol`: 입금, 출금, owner 회수 흐름 실습
- `lab1.html`: 실습용 시뮬레이터 UI

## 실습 내용 정리

### 1. Counter.sol
카운터 값을 1씩 증가시키는 가장 기본적인 상태 변경 실습입니다.

실습 흐름:
- `컴파일`
- `배포`
- `counter()` 또는 `get()`으로 초기값 확인
- `count()` 실행
- 다시 값 조회해서 증가 여부 확인

확인한 개념:
- `public` 상태 변수
- `view` 함수
- 상태 변경 함수와 가스 사용

### 2. CounterNumber.sol
숫자 상태 변수를 읽고 직접 변경하는 실습입니다.

실습 흐름:
- `컴파일`
- `배포`
- `getNumber()`로 초기값 확인
- `setNumber()`로 새 값 입력
- 다시 `getNumber()`로 변경 확인

확인한 개념:
- `private` 상태 변수
- getter / setter 함수
- 입력값에 따른 상태 변경

### 3. Faucet.sol
Faucet 컨트랙트의 입금, 출금, owner 회수 흐름을 실습했습니다.

실습 흐름:
- `컴파일`
- `배포`
- 배포 시 선택된 계정을 `owner`로 설정
- `deposit()` 또는 `receive()`로 컨트랙트 잔액 충전
- `getBalance()`로 잔액 확인
- `withdraw()`로 0.1 ETH 출금
- `+24시간` 진행 후 재출금 확인
- `withdrawAll()`로 owner 계정 전액 회수 확인

확인한 개념:
- `owner`
- `onlyOwner`
- `msg.sender`
- `msg.value`
- `LOCK_TIME`
- `address(this).balance`

## 시뮬레이터에서 사용한 버튼 흐름

### Counter.sol
- `컴파일`
- `배포`
- `counter` 또는 `get`
- `count`
- 다시 `counter` 또는 `get`

### CounterNumber.sol
- `컴파일`
- `배포`
- `getNumber`
- 값 입력
- `setNumber`
- 다시 `getNumber`

### Faucet.sol
- `컴파일`
- `배포`
- `getBalance`
- 금액 입력
- `deposit` 또는 `receive`
- `withdraw`
- `+24시간`
- `withdraw`
- 계정 변경 후 `withdrawAll` 확인

## 캡처 이미지 정리
현재 `week5` 폴더에는 실습 과정 캡처 이미지가 저장되어 있습니다.

- `image.png`
- `image2.png`
- `image3.png`
- `image4.png`
- `image5.png`
- `image6.png`
- `image7.png`
- `image8.png`
- `image9.png`
- `image10.png`
- `image11.png`
- `image12.png`
- `image13.png`
- `image14.png`
- `image15.png`

이 이미지들은 지금까지 진행한 실습 화면을 순서대로 기록한 자료입니다.

정리 기준:
- Counter 배포 및 조회
- Counter 상태 변경
- CounterNumber 값 변경
- Faucet 배포
- Faucet 입금
- Faucet 출금
- Faucet owner 회수 및 상태 확인

## 제출용 요약
이번 과제에서는 5주차 프레젠테이션 범위에 맞춰 `Counter.sol`, `CounterNumber.sol`, `Faucet.sol`을 실습했고, 시뮬레이터 화면과 실행 과정을 캡처하여 함께 정리했습니다.

주요 확인 사항:
- 상태 변수 읽기와 변경
- `public` / `private`
- getter / setter
- `payable`
- `owner` 권한 제어
- 출금 제한 시간과 잔액 검증

## 폴더 구성
```text
week5/
├─ CombinedContract.sol
├─ CounterNumber.sol
├─ Faucet.sol
├─ lab1.html
├─ README.md
├─ image.png
├─ image2.png
├─ image3.png
├─ image4.png
├─ image5.png
├─ image6.png
├─ image7.png
├─ image8.png
├─ image9.png
├─ image10.png
├─ image11.png
├─ image12.png
├─ image13.png
├─ image14.png
└─ image15.png
```
