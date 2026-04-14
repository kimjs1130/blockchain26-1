# Week 7 Homework

## 주제
ERC-20 토큰과 스테이킹 스마트 컨트랙트

## 오늘 해야 할 일
1. Sepolia 또는 Giwa 테스트넷을 선택한다.
2. ERC-20 토큰을 대상으로 스테이킹 컨트랙트를 작성한다.
3. 아래 기능을 구현한다.
   - `stake(uint256 amount)`
   - `withdraw(uint256 amount)`
   - `stakedBalance(address account)`
4. 컨트랙트를 테스트넷에 배포한다.
5. 배포 후 아래 트랜잭션을 최소 1회씩 실행한다.
   - 스테이킹
   - 출금
6. 블록 익스플로러에서 배포 및 트랜잭션을 확인한다.

## 선택 기능
- Reward calculation
- Time-locked staking
- Emergency withdrawal

## 제출물
- 스마트 컨트랙트 소스코드 또는 GitHub URL
- 배포 트랜잭션 해시
- stake 트랜잭션 해시 1개 이상
- withdraw 트랜잭션 해시 1개 이상

## 권장 진행 순서
1. 테스트넷과 MetaMask 연결
2. 테스트용 ERC-20 토큰 준비
3. `SimpleStaking.sol` 컴파일
4. 컨트랙트 배포
5. 토큰 컨트랙트에서 `approve()` 실행
6. 스테이킹 컨트랙트에서 `stake()` 실행
7. `stakedBalance()`로 잔액 확인
8. `withdraw()` 실행
9. 익스플로러에서 해시 저장

## 참고 파일
- `SimpleStaking.sol`
- `TODO.md`
- `CLI.md`
