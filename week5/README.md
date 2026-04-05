# Solidity Lab Simulator - Lab 1

## 📌 프로젝트 개요
브라우저에서 Solidity 스마트 컨트랙트를 작성하고, 컴파일/배포/함수 실행을 체험할 수 있는 간단한 Solidity Lab Simulator입니다.

## ⚙️ 실행 방법
### 1. 파일 실행
아래 방법 중 하나 선택

### 방법 1 (추천)
```bash
start lab1.html
```

### 방법 2 (python 서버)
```bash
python -m http.server 8000
```

브라우저 접속:

```text
http://localhost:8000/lab1.html
```

## 🧪 실습 내용
### ✔ Combined Contract
- `greeting` (string)
- `number` (int)

### ✔ 구현 기능
getter 함수
- `getGreeting()`
- `getNumber()`

setter 함수
- `setGreeting()`
- `setNumber()`

## 🔍 실습 목표
### 1. public vs private 비교
- `public` → 자동 getter 생성
- `private` → 직접 getter 필요

### 2. 상태 변경 확인
- setter 실행 후 값 변경 확인

## 🖥️ 실행 화면
아래는 실행 결과 화면입니다.

![실행 화면](image.png)

## 🧩 기능 설명
### ✔ 컴파일
- Solidity 코드 검증

### ✔ 배포
- 컨트랙트 상태 초기화

### ✔ 인터랙션
- getter 버튼 → 값 조회
- setter 함수 → 값 변경

## 🔥 체크리스트
- [x] greeting 조회 가능
- [x] number 조회 가능
- [x] setter로 값 변경 가능
- [x] public → private 변경 실험 완료

## 🚀 추가 과제
### Faucet Contract 구현
- ETH를 요청하면 일정량 지급하는 스마트 컨트랙트 작성

## 📎 파일 구조
```text
lab1.html
README.md
screenshot.png
```

## ✅ 결론
Solidity의 상태 변수 접근 방식(public/private)과 getter/setter 개념을 실습으로 이해하는 것이 목표입니다.

---

# Week 5 Solidity Practice Report

## 1. 과제 개요
본 과제는 5주차 프레젠테이션 기준 17페이지부터 25페이지까지의 내용을 바탕으로 다음 3개의 Solidity 주제를 직접 실습하고 정리하는 것을 목표로 한다.

- `Counter.sol`
- `CounterNumber.sol`
- `Faucet.sol`

과제 안내에 따라 별도의 회원가입이나 외부 API 연동 없이 브라우저에서 바로 실행할 수 있는 시뮬레이터를 만들어 실습을 진행하였다. 실습에는 `week5/lab1.html` 시뮬레이터와 Solidity 소스 파일을 함께 사용하였다.

## 2. 실행 방법
실습은 `week5/lab1.html` 파일을 실행하여 진행할 수 있다.

### 방법 1. 파일 직접 실행
```bash
start lab1.html
```

### 방법 2. Python 로컬 서버 실행
```bash
python -m http.server 8000
```

브라우저 접속 주소:

```text
http://localhost:8000/lab1.html
```

## 3. 실습 파일 구성
- `lab1.html`: Counter, CounterNumber, Faucet 실습용 시뮬레이터
- `CounterNumber.sol`: 숫자 상태값 조회 및 변경 실습
- `CombinedContract.sol`: 초기 실습용 결합 계약
- `Faucet.sol`: 입금, 출금, owner 권한 제어 실습
- `README.md`: 실습 보고서

## 4. 실습 목표
이번 실습에서 확인하고자 한 핵심 개념은 다음과 같다.

### 4-1. Counter.sol
- `public` 상태 변수가 자동 getter를 가진다는 점 확인
- `count()` 호출에 따라 상태값이 증가하는 흐름 확인
- 읽기 함수와 상태 변경 함수의 차이 확인

### 4-2. CounterNumber.sol
- `private` 상태 변수는 직접 getter / setter를 구현해야 한다는 점 확인
- 입력값에 따라 상태값이 변경되는 구조 확인

### 4-3. Faucet.sol
- `owner`와 `onlyOwner`를 통한 권한 제어 확인
- `deposit()` / `receive()`를 통한 입금 구조 확인
- `withdraw()`를 통한 일정량 출금 확인
- `LOCK_TIME = 1 days` 제한 확인
- `withdrawAll()`이 owner 전용 함수임을 확인

## 5. 시뮬레이터 사용 흐름
이번 과제에서는 각 컨트랙트별로 다음 순서로 실습을 진행하였다.

### Counter.sol
1. `컴파일`
2. `배포`
3. `counter()` 또는 `get()`으로 초기값 확인
4. `count()` 실행
5. 다시 값 조회하여 증가 여부 확인

### CounterNumber.sol
1. `컴파일`
2. `배포`
3. `getNumber()`로 초기값 확인
4. 새 숫자 입력
5. `setNumber()` 실행
6. 다시 `getNumber()`로 결과 확인

### Faucet.sol
1. `컴파일`
2. `배포`
3. `getBalance()`로 초기 잔액 확인
4. `deposit()` 또는 `receive()`로 ETH 입금
5. 다시 `getBalance()`로 잔액 확인
6. `withdraw()` 실행
7. 필요 시 `+24시간`으로 시간 경과 후 재출금 확인
8. `withdrawAll()`로 owner 권한 확인

## 6. 실습 결과 정리
아래 이미지는 과제 범위인 17페이지부터 25페이지까지의 내용을 실제로 실습한 결과를 정리한 캡처이다.

### 6-1. Counter.sol 실습

#### Counter.sol 컴파일 완료
![Counter 실습 1](image2.png)

`Counter.sol`을 선택한 뒤 컴파일을 진행한 화면이다.  
이 단계에서 함수와 상태 변수가 정상적으로 인식되는지 먼저 확인하였다.

#### Counter.sol 배포 후 함수 확인
![Counter 실습 2](image3.png)

배포가 완료된 뒤 `counter()`, `get()`, `count()` 버튼이 생성된 화면이다.  
이 화면을 통해 읽기 전용 함수와 상태 변경 함수가 구분되어 제공되는 구조를 확인할 수 있었다.

#### Counter.sol 상태 변경 성공
![Counter 실습 3](image4.png)

`count()`를 실행한 뒤 `counter` 값이 `0 -> 1`로 증가한 화면이다.  
이를 통해 Counter 컨트랙트의 기본 동작인 상태값 증가를 직접 확인하였다.

#### Counter.sol 결과 확인
![Counter 실습 4](image5.png)

큰 상태 카드에 값 `1`이 반영된 화면이다.  
즉, 함수 실행 결과가 상태 표시 영역과 가스 히스토리에 함께 반영되는 것을 확인하였다.

### 6-2. CounterNumber.sol 실습

#### CounterNumber.sol 배포 화면
![CounterNumber 실습 1](image6.png)

`CounterNumber.sol`을 배포한 직후의 화면이다.  
초기 숫자 값 `10`이 표시되며, 배포 직후 상태값을 바로 확인할 수 있었다.

#### CounterNumber.sol 함수 입력 영역 확인
![CounterNumber 실습 2](image7.png)

`getNumber()`와 `setNumber()` 함수, 그리고 입력칸이 함께 표시된 화면이다.  
이를 통해 `private` 변수는 자동 getter가 없기 때문에 직접 getter / setter를 구현해야 한다는 점을 실습으로 확인하였다.

### 6-3. Faucet.sol 실습

#### Faucet.sol 배포 직후 화면
![Faucet 실습 1](image8.png)

`Faucet.sol`을 컴파일하고 배포한 직후의 화면이다.  
배포 시 선택한 계정이 `owner`로 지정되고, 초기 잔액은 `0.0000 ETH`로 시작하는 구조를 확인하였다.

#### Faucet 기능 버튼 확인
![Faucet 실습 2](image9.png)

오른쪽 패널에 `getBalance()`, `deposit / receive`, `withdraw()`, `withdrawAll()` 버튼이 모두 생성된 화면이다.  
이 화면을 통해 Faucet 실습의 전체 기능 구성을 한 번에 확인할 수 있었다.

#### Faucet 전체 흐름 확인
![Faucet 실습 3](image10.png)

Faucet의 상태 확인 영역과 주요 함수 버튼이 정리되어 보이는 화면이다.  
실습은 이 구조를 기준으로 `배포 -> 입금 -> 출금 -> 회수 확인` 순서로 진행하였다.

#### Faucet 초기 잔액 확인
![Faucet 실습 4](image11.png)

`getBalance()` 실행 결과 초기 잔액이 `0.0000 ETH`로 표시된 화면이다.  
입금 전에는 출금할 수 없기 때문에 먼저 컨트랙트 잔액 상태를 확인하였다.

#### Faucet 입금 후 잔액 확인
![Faucet 실습 5](image12.png)

입금 금액 `1 ETH`를 입력한 뒤 `deposit()` 또는 `receive()`를 사용하고, 다시 `getBalance()`를 확인한 결과이다.  
컨트랙트 잔액이 `1.0000 ETH`로 증가하여 입금이 정상적으로 처리되었음을 확인하였다.

#### Faucet 출금 제한 확인
![Faucet 실습 6](image13.png)

한 번 출금한 직후 다시 `withdraw()`를 실행했을 때 `24시간 대기 필요` 메시지가 표시된 화면이다.  
이를 통해 `LOCK_TIME = 1 days` 제한이 실제로 적용되는 것을 확인하였다.

#### Faucet 출금 후 잔액 변화
![Faucet 실습 7](image14.png)

`withdraw()`를 한 번 실행한 뒤 컨트랙트 잔액이 `0.9000 ETH`로 바뀐 화면이다.  
즉, 1 ETH 입금 후 0.1 ETH가 출금되어 남은 잔액이 0.9 ETH가 되는 흐름을 확인하였다.

#### Faucet owner 권한 확인
![Faucet 실습 8](image15.png)

`withdrawAll()`을 owner가 아닌 계정에서 실행했을 때 실패 메시지가 표시된 화면이다.  
이를 통해 `withdrawAll()`은 owner만 호출할 수 있는 함수라는 점을 확인하였다.

## 7. 과제 수행 내용 요약
이번 과제에서는 5주차 프레젠테이션 17페이지부터 25페이지 범위에 해당하는 `Counter.sol`, `CounterNumber.sol`, `Faucet.sol`을 직접 실습하였다. 또한 브라우저에서 바로 동작하는 `lab1.html` 시뮬레이터를 사용하여 컴파일, 배포, 상태 조회, 상태 변경, 입금, 출금, owner 권한 제어까지 단계적으로 확인하였다.

특히 이번 실습을 통해 다음 내용을 직접 확인할 수 있었다.

- `public` 상태 변수는 자동 getter가 생성된다.
- `private` 상태 변수는 직접 getter / setter를 구현해야 한다.
- 상태 변경 함수는 트랜잭션과 가스를 사용한다.
- `payable` 함수는 ETH를 받을 수 있다.
- `owner`와 `onlyOwner`를 통해 권한 제어를 구현할 수 있다.
- Faucet은 잔액, 출금량, 시간 제한을 함께 고려하여 동작한다.

## 8. 제출 파일
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

## 9. 결론
이번 과제를 통해 Solidity 기본 문법과 스마트 컨트랙트 상태 변경 구조를 직접 실습할 수 있었다.  
Counter와 CounterNumber를 통해 상태 변수와 getter / setter 개념을 익혔고, Faucet을 통해 `payable`, `msg.sender`, `msg.value`, `onlyOwner`, 출금 제한 시간과 같은 실제 스마트 컨트랙트 동작 요소를 함께 확인하였다.
