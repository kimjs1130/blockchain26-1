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

## 📚 추가 실습 정리
아래 이미지는 이번 채팅에서 진행한 실습 과정을 정리한 캡처입니다.

### 1. Counter.sol 컴파일 완료
![Counter 실습 1](image2.png)

`Counter.sol`을 선택한 뒤 컴파일을 먼저 진행한 화면입니다.  
이 단계에서는 함수 3개와 변수 1개가 정상적으로 인식되는지 확인했습니다.

### 2. Counter.sol 배포 후 함수 확인
![Counter 실습 2](image3.png)

배포가 완료된 뒤 오른쪽 패널에 `counter()`, `get()`, `count()`가 생성된 화면입니다.  
읽기 함수와 상태 변경 함수가 구분되어 표시되는 구조를 확인했습니다.

### 3. Counter.sol 상태 변경 성공
![Counter 실습 3](image4.png)

`count()`를 실행한 뒤 `counter` 값이 `0 -> 1`로 변경된 화면입니다.  
이 과정을 통해 Counter 컨트랙트의 상태값이 실제로 증가하는 흐름을 실습했습니다.

### 4. Counter.sol 결과 카드 확인
![Counter 실습 4](image5.png)

배포된 Counter 컨트랙트의 큰 상태 카드에 값 `1`이 반영된 화면입니다.  
즉, `count()` 실행 결과가 상태 패널과 가스 히스토리에 함께 반영되는 것을 확인했습니다.

### 5. CounterNumber.sol 배포 화면
![CounterNumber 실습 1](image6.png)

`CounterNumber.sol`을 배포한 직후의 화면입니다.  
초기 숫자 값 `10`이 상태 카드에 표시되는 구조를 확인했습니다.

### 6. CounterNumber.sol 함수 입력 영역 확인
![CounterNumber 실습 2](image7.png)

`getNumber()`와 `setNumber()` 함수가 생성되고, `setNumber()`에 입력칸이 함께 표시되는 화면입니다.  
이 구조를 통해 `private` 변수는 getter / setter를 직접 구현해야 한다는 점을 실습했습니다.

### 7. Faucet.sol 배포 직후 화면
![Faucet 실습 1](image8.png)

`Faucet.sol`을 컴파일하고 배포한 직후의 화면입니다.  
배포 시 선택된 계정이 `owner`가 되고, 초기 컨트랙트 잔액은 `0.0000 ETH`인 상태로 시작하는 것을 확인했습니다.

### 8. Faucet 기능 버튼 전체 구조
![Faucet 실습 2](image9.png)

오른쪽 패널에 `getBalance()`, `deposit / receive`, `withdraw()`, `withdrawAll()` 버튼이 모두 생성된 화면입니다.  
즉, Faucet은 배포 후 이 4가지 흐름으로 사용된다는 점을 한 화면에서 정리할 수 있습니다.

### 9. Faucet 전체 흐름 정리 화면
![Faucet 실습 3](image10.png)

Faucet의 주요 버튼과 상태 확인 영역이 한 번 더 정리되어 보이는 화면입니다.  
실습 중에는 이 구조를 기준으로 `배포 -> 입금 -> 출금 -> 회수` 순서로 테스트를 진행했습니다.

### 10. Faucet 초기 잔액 조회
![Faucet 실습 4](image11.png)

`getBalance()`를 실행했을 때 초기 컨트랙트 잔액이 `0.0000 ETH`로 표시된 화면입니다.  
입금 전에는 출금이 불가능하므로, 먼저 잔액 상태를 확인하는 용도로 사용했습니다.

### 11. Faucet 입금 후 잔액 확인
![Faucet 실습 5](image12.png)

입금 금액 `1 ETH`를 입력한 뒤 `deposit()` 또는 `receive()`를 사용한 후, `getBalance()` 결과가 `1.0000 ETH`로 표시된 화면입니다.  
이 과정을 통해 Faucet은 먼저 컨트랙트 잔액을 채운 뒤 사용해야 한다는 점을 확인했습니다.

### 12. Faucet 재출금 제한 확인
![Faucet 실습 6](image13.png)

출금 직후 다시 `withdraw()`를 실행했을 때 `24시간 대기 필요` 메시지가 뜨는 화면입니다.  
이 과정을 통해 `LOCK_TIME = 1 days` 제한이 실제로 적용되는 구조를 확인했습니다.

### 13. Faucet 출금 후 잔액 변화
![Faucet 실습 7](image14.png)

`withdraw()`를 한 번 실행한 뒤 큰 상태 카드가 `0.9000 ETH`로 바뀐 화면입니다.  
즉, 1 ETH를 충전한 뒤 0.1 ETH를 출금하면 남은 컨트랙트 잔액이 0.9 ETH가 된다는 흐름을 확인했습니다.

### 14. Faucet owner 전용 회수 확인
![Faucet 실습 8](image15.png)

`withdrawAll()`을 owner가 아닌 계정에서 시도했을 때 실패 메시지가 표시된 화면입니다.  
즉, `withdrawAll()`은 owner 전용 함수이며 일반 계정은 사용할 수 없다는 점을 확인했습니다.
