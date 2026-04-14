# Week 7 ERC-20 Staking Lab Report

## 1. 과제 개요
이번 과제의 목표는 ERC-20 토큰을 대상으로 하는 스테이킹 스마트 컨트랙트를 작성하고, Sepolia 테스트넷에 배포한 뒤 실제로 `stake`, `withdraw`, 잔액 조회를 수행하는 것이다.  
개발 도구는 Remix IDE와 MetaMask를 사용했고, 배포 및 트랜잭션 확인은 Sepolia Etherscan에서 진행했다.

이번 실습에서는 다음 두 가지를 구현했다.

- 기본 과제: `stake`, `withdraw`, `stakedBalance`
- 추가 기능: `reward calculation`, `time-locked staking`, `emergency withdrawal`

## 2. 사용 파일
- `myToken.sol`: 테스트용 ERC-20 토큰 컨트랙트
- `SimpleStaking.sol`: 스테이킹 컨트랙트
- `faucet.html`: ERC-20 스테이킹 시뮬레이터 화면
- `image/`: 실습 진행 캡처 화면

## 3. 구현한 기본 기능
`SimpleStaking.sol`에는 아래 기본 기능을 구현했다.

### 3-1. stake
사용자가 ERC-20 토큰을 스테이킹 컨트랙트에 예치하는 함수이다.  
사전에 토큰 컨트랙트에서 `approve()`가 실행되어 있어야 하며, 승인 수량이 부족하면 실행되지 않도록 했다.

### 3-2. withdraw
사용자가 스테이킹한 토큰을 다시 출금하는 함수이다.  
예치 수량보다 많은 양을 출금할 수 없도록 검사했고, 정상 출금 시 사용자 잔액과 전체 스테이킹 수량이 함께 감소하도록 구현했다.

### 3-3. stakedBalance
특정 주소의 현재 스테이킹 잔액을 조회하는 함수이다.  
이 함수를 통해 사용자가 얼마나 예치했는지 확인할 수 있도록 했다.

## 4. ERC-20 토큰 준비 및 배포
스테이킹 대상 토큰이 필요하므로 먼저 `myToken.sol`에 작성한 간단한 ERC-20 토큰을 Remix에서 배포했다.  
초기 발행량을 생성자 인자로 넣어 배포했고, 배포 직후 내 지갑이 초기 토큰을 보유한 상태를 확인했다.

`myToken.sol`은 아래 요소를 포함하도록 작성했다.

- 토큰 이름: `My Staking Token`
- 심볼: `MST`
- 소수점: `18`
- 기본 ERC-20 동작: `transfer`, `approve`, `transferFrom`

즉, 이번 실습에서는 외부 토큰을 가져오지 않고 직접 만든 `myToken.sol`을 스테이킹 대상 토큰으로 사용했다.

## 5. SimpleStaking 배포 과정
기존에 배포한 ERC-20 토큰 주소를 `SimpleStaking` 생성자 인자로 넣고 Sepolia 테스트넷에 배포했다.  
MetaMask는 `Browser Extension` 환경으로 Remix와 연결했고, 실제 지갑 계정으로 배포를 진행했다.

### 스테이킹 컨트랙트 배포 화면 예시
![SimpleStaking Deploy](image/스크린샷%202026-04-14%20154302.png)

위 화면에서는 Remix에서 `SimpleStaking`을 선택하고, 생성자 `tokenAddress`에 ERC-20 토큰 주소를 넣은 뒤 MetaMask에서 배포를 승인하는 흐름을 확인할 수 있다.

## 6. 시뮬레이터 화면 구현
Week 6에서 만들었던 `faucet.html`을 재활용해 Week 7용 스테이킹 시뮬레이터로 수정했다.  
재사용한 부분은 MetaMask 연결, 네트워크 상태 표시, 트랜잭션 해시 출력, 잔액 차트, 상태 메시지 UI이다.  
수정한 부분은 Faucet 전용 기능을 제거하고 ERC-20 기반 `approve`, `stake`, `withdraw` 흐름으로 바꾼 것이다.

시뮬레이터에서 입력받는 정보는 아래와 같다.

- ERC-20 토큰 주소
- 스테이킹 컨트랙트 주소
- 실행 수량

시뮬레이터 버튼 구성은 다음과 같다.

- `approve()`
- `stake()`
- `withdraw()`

### 시뮬레이터 화면 예시 - MetaMask 연결 전
![Simulator Before Connect](image/스크린샷%202026-04-14%20154432.png)

MetaMask 연결 전에는 주소와 잔액 정보가 비어 있고, 지갑이 아직 연결되지 않았다는 상태 메시지가 표시된다.

### 시뮬레이터 화면 예시 - MetaMask 연결 후
![Simulator After Connect](image/스크린샷%202026-04-14%20154504.png)

MetaMask 연결 후에는 지갑 주소, 네트워크 상태, 내 토큰 잔액 등이 표시되며 실제 트랜잭션을 실행할 수 있는 상태가 된다.

## 7. 실제 트랜잭션 수행 과정
실습은 아래 순서로 진행했다.

1. ERC-20 토큰 주소와 스테이킹 컨트랙트 주소 입력
2. MetaMask 연결
3. `approve()` 실행
4. `stake()` 실행
5. `stakedBalance` 및 잔액 변화 확인
6. `withdraw()` 실행
7. 트랜잭션 해시를 복사해 Etherscan에서 확인

### approve 실행 요청
![Approve Request](image/스크린샷%202026-04-14%20154527.png)

MetaMask에서 스테이킹 컨트랙트가 내 토큰을 사용할 수 있도록 지출 한도를 승인하는 요청 화면이다.

### approve 실행 결과
![Approve Result](image/스크린샷%202026-04-14%20154546.png)

승인 요청 이후 MetaMask 활동 내역에 `MST 지출 한도 승인`이 기록되고, 시뮬레이터에도 approve 관련 상태 메시지와 최근 트랜잭션 해시가 표시된다.

### stake 실행 요청
![Stake Request](image/스크린샷%202026-04-14%20154608.png)

`stake(10)` 실행 시 MetaMask에서 사용자 지갑에서 스테이킹 컨트랙트로 10 MST가 이동하는 트랜잭션 요청 화면을 확인할 수 있다.

### stake 실행 결과
![Stake Result](image/스크린샷%202026-04-14%20154645.png)

`stake()` 실행 이후 내 토큰 잔액이 감소하고, 스테이킹 잔액과 컨트랙트 보유 토큰이 증가한 것을 확인할 수 있다.  
또한 최근 트랜잭션 해시가 화면에 표시되고, 하단 차트에도 스테이킹 잔액 변화가 반영된다.

### withdraw 실행 요청
![Withdraw Request](image/스크린샷%202026-04-14%20154802.png)

`withdraw(10)` 실행 시 MetaMask에서 스테이킹 컨트랙트가 사용자에게 10 MST를 다시 전송하는 트랜잭션 요청 화면을 확인할 수 있다.

### withdraw 실행 결과
![Withdraw Result](image/스크린샷%202026-04-14%20154828.png)

출금이 완료되면 MetaMask 활동 내역에 `Withdraw`가 기록되고, 시뮬레이터에서도 withdraw 완료 메시지와 출금 트랜잭션 해시가 표시된다.

### 블록 탐색기 확인 예시
![Etherscan Verify](image/스크린샷%202026-04-14%20154902.png)

Sepolia Etherscan에서 실제 트랜잭션 해시를 열어, 토큰 전송과 컨트랙트 상호작용이 정상적으로 기록되었는지 확인했다.

## 8. 추가 기능 구현
이번에는 기본 기능 외에도 과제의 선택 기능 3가지를 추가로 구현했다.  
이 부분은 이후 확장 버전의 `SimpleStaking.sol`에 반영했으며, 캡처 대신 구현 내용 위주로 정리한다.

### 8-1. Reward Calculation
`pendingReward(address account)` 함수를 추가해 사용자의 스테이킹 시간에 따라 보상이 누적되도록 구현했다.  
보상은 `stakeTimestamps`를 기준으로 계산하며, `REWARD_RATE_PER_SECOND` 값을 이용해 초 단위로 증가하도록 만들었다.

또한 보상 지급을 위해 `rewardPool`을 두고, owner가 `fundRewards(uint256 amount)`로 보상용 토큰을 미리 넣을 수 있게 구성했다.

### 8-2. Time-Locked Staking
`LOCK_DURATION` 상수를 두고, 일반 `withdraw()`는 예치 후 일정 시간이 지나야 실행되도록 제한했다.  
현재 구현에서는 `LOCK_DURATION = 60`초로 두어 테스트넷에서 빠르게 동작 확인이 가능하도록 설정했다.

`unlockTime(address account)` 함수로 사용자의 언락 시각을 조회할 수 있게 했다.

### 8-3. Emergency Withdrawal
`emergencyWithdraw()` 함수를 추가해, 락이 끝나지 않았더라도 사용자가 즉시 원금을 회수할 수 있도록 구현했다.  
다만 긴급 출금은 보상 없이 원금만 회수하는 구조로 두어, 일반 출금과 차이를 명확히 했다.

## 9. 과제 요구사항 대조
과제 PDF의 요구사항과 실제 수행 내용을 대조하면 다음과 같다.

1. Sepolia 테스트넷에 staking contract 생성 및 배포: 완료
2. stake / withdraw / staked balance 기능 구현: 완료
3. 추가 기능 구현: reward calculation, time-locked staking, emergency withdrawal 구현
4. 테스트넷 배포: 완료
5. Remix IDE 사용: 완료
6. stake / withdraw 트랜잭션 수행: 완료
7. MetaMask 연결: 완료
8. 테스트용 토큰 준비: 자체 ERC-20 토큰 배포로 해결
9. 제출물 준비: 소스코드와 트랜잭션 해시 확보

## 10. 제출 시 정리할 항목
최종 제출 시 아래 항목을 함께 정리하면 된다.

- `myToken.sol` 소스코드
- `SimpleStaking.sol` 소스코드
- 배포 트랜잭션 해시 :  0x7776bc1790b33a19dd99be13fcd08f3e4bf99eef82ed982ebed56e0f1ece6f07
- stake 트랜잭션 해시:  0xa8728bd370dd3fbdfb9d7781437a06081278e0335057a88675126f88f847bb70
- withdraw 트랜잭션 해시 : 0xc514d67ecd3a0ce7debe58d6fb816954b113b99eef97f882bb8232e464e9cd72

## 11. 결론
이번 실습을 통해 ERC-20 토큰을 스테이킹 컨트랙트에 예치하고 다시 출금하는 기본 흐름을 직접 구현하고 테스트했다.  
또한 Remix, MetaMask, Etherscan을 함께 사용해 스마트 컨트랙트 배포부터 실제 트랜잭션 검증까지 전체 과정을 수행했다.

추가로 보상 계산, 락업, 긴급 출금 기능까지 확장하면서 기본 스테이킹 컨트랙트를 보다 실제 서비스 형태에 가깝게 확장해볼 수 있었다.
