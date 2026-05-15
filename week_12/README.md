# Week 12 Smart Contract Security Lab Summary

## 1. 실습 개요

이번 실습은 Hardhat 로컬 시뮬레이션 환경에서 DAO와 Parity wallet 보안 사고를 재현하고, 각 취약점의 결과와 방어 방식을 확인하는 실습이다.

실습은 실제 이더리움 네트워크가 아니라 Hardhat in-memory simulated network에서만 진행되었다. 따라서 live RPC, 개인키, 실제 지갑, 실제 자금은 사용하지 않았다.

확인한 주제는 다음 3가지이다.

- DAO reentrancy 공격
- Parity Hack #1: unauthorized initialization
- Parity Hack #2: library self-destruct로 인한 funds freeze

## 2. 실행한 검증

`week_12` 폴더에서 전체 검증 명령을 실행했다.

```powershell
npm test
```

이 명령은 compile 후 DAO 공격, DAO 방어, Parity #1, Parity #2 시뮬레이션을 순서대로 실행한다.

실행 결과는 `logs/` 폴더에 저장되었다.

- `logs/dao_attack.log`
- `logs/dao_fixes.log`
- `logs/parity1_attack.log`
- `logs/parity2_freeze.log`

## 3. 로그가 생성되는 방식과 읽는 방법

`npm test`는 `package.json`에 정의된 script이다. 내부적으로 `npm run compile`을 먼저 실행하고, 그 다음 `npm run simulate:all`을 실행한다.

```json
"test": "npm run compile && npm run simulate:all"
```

`simulate:all`은 아래 4개 시뮬레이션을 순서대로 실행한다.

```powershell
npm run simulate:dao
npm run simulate:dao-fixes
npm run simulate:parity1
npm run simulate:parity2
```

각 script는 Hardhat 로컬 네트워크인 `hardhatMainnet`에서 실행된다. 이 이름은 실제 Ethereum mainnet이 아니라, `hardhat.config.js`에 설정된 local in-memory network alias이다.

각 로그 파일은 시뮬레이션 script가 실행되면서 생성된다.

| Log file | 생성한 script | 의미 |
| --- | --- | --- |
| `dao_attack.log` | `scripts/01_dao_attack.js` | 취약한 DAO가 reentrancy 공격으로 drain되는 과정 |
| `dao_fixes.log` | `scripts/02_dao_fixes.js` | CEI, guard, pull-payment 방식이 공격을 막는 과정 |
| `parity1_attack.log` | `scripts/03_parity1_attack.js` | 초기화되지 않은 proxy wallet이 attacker에게 takeover되는 과정 |
| `parity2_freeze.log` | `scripts/04_parity2_freeze.js` | shared library 제거로 wallet funds가 freeze되는 과정 |

로그에서 자주 나오는 표현의 의미는 다음과 같다.

- `Network: Hardhat in-memory simulated network only`: 실제 네트워크가 아니라 로컬 시뮬레이션에서 실행되었다는 의미이다.
- `balance before`: 공격 또는 실행 전 컨트랙트가 가진 ETH 잔액이다.
- `balance after`: 공격 또는 실행 후 컨트랙트가 가진 ETH 잔액이다.
- `[assertion ok]`: script 안에서 기대한 결과가 실제로 맞았다는 의미이다.
- `[expected revert]`: 실패해야 하는 호출이 의도대로 revert되었다는 의미이다. 에러가 아니라 방어 로직이 정상 작동했다는 증거이다.
- `Result`: 해당 시뮬레이션의 최종 결론을 요약한 줄이다.

따라서 로그는 단순 출력이 아니라, 각 공격과 방어가 의도한 결과를 냈는지 확인하는 evidence이다.

## 4. DAO Reentrancy 실습 결과

`dao_attack.log`에서는 취약한 `SimpleDAO` 컨트랙트가 재진입 공격으로 drain되는 것을 확인했다.

피해자는 DAO에 10 ETH를 예치했고, 공격자는 1 ETH를 seed한 뒤 `withdraw()`를 재귀적으로 호출했다. 그 결과 DAO 잔액은 0 ETH가 되었고, 공격자 컨트랙트 잔액은 11 ETH가 되었다.

로그에서 확인된 주요 결과는 다음과 같다.

- DAO balance after attack: 0.0 ETH
- Attacker contract balance after attack: 11.0 ETH
- Recursive calls observed by attacker contract: 10
- Result: vulnerable contract drained because `withdraw()` sends Ether before reducing the recorded balance.

즉, 취약한 DAO는 외부로 Ether를 먼저 전송한 뒤 내부 balance를 줄였기 때문에 reentrancy 공격에 노출되었다.

이 로그에서 `Victim deposits 10 ETH`는 피해자가 DAO에 예치한 초기 자금을 의미하고, `Attacker seeds 1 ETH`는 공격자가 공격을 시작하기 위해 넣은 금액을 의미한다. `Recursive calls observed by attacker contract: 10`은 공격자 컨트랙트의 fallback 또는 receive 함수가 반복적으로 호출되면서 `withdraw()`가 재진입되었다는 뜻이다.

`DAO balance after attack: 0.0 ETH`는 DAO의 자금이 모두 빠져나갔다는 뜻이고, `Attacker contract balance after attack: 11.0 ETH`는 피해자의 10 ETH와 공격자의 seed 1 ETH가 공격자 컨트랙트에 모였다는 뜻이다.

마지막의 underflowed recorded balance는 옛 Solidity 동작을 보여주기 위한 실습용 artifact이다. 핵심은 recorded balance 숫자 자체가 아니라, 외부 전송을 먼저 수행한 잘못된 순서 때문에 DAO가 drain되었다는 점이다.

## 5. DAO Reentrancy 방어 실습 결과

`dao_fixes.log`에서는 DAO reentrancy를 막는 3가지 방식이 확인되었다.

첫 번째는 Checks-Effects-Interactions 패턴이다. `SimpleDAO_CEI`는 외부 호출 전에 balance를 먼저 변경하여 재진입 공격을 막았다. 공격 시도는 revert되었고 DAO 잔액은 10 ETH로 유지되었다.

두 번째는 reentrancy guard 방식이다. `SimpleDAO_Guard`는 재귀적인 `withdraw()` 호출을 guard로 차단했다. 공격 시도는 revert되었고 공격자는 Ether를 받지 못했다.

세 번째는 pull-over-push payment queue 방식이다. `SimpleDAO_PullPayment`는 `withdraw()` 중 Ether를 즉시 push하지 않고 pending payment로 기록했다. 이 방식에서는 callback이 발생하지 않아 공격자의 재진입 경로가 생기지 않았다.

로그에서 확인된 결론은 다음과 같다.

- CEI와 guard는 reentrant attack을 revert시켰다.
- Pull-payment 방식은 Ether를 직접 push하지 않고 claim 구조로 처리했다.
- 공격자 컨트랙트가 받은 Ether는 0 ETH였다.
- Result: fixed variants prevent the vulnerable drain path.

이 로그에서 `[expected revert]`는 실패가 아니라 성공적인 방어 결과이다. 공격자가 재진입을 시도했지만 CEI 또는 guard가 막았기 때문에 transaction이 revert된 것이다.

Pull-payment 결과에서는 `Attack transaction completed`라고 나오지만, 이것은 공격이 성공했다는 뜻이 아니다. Ether가 공격자에게 직접 push되지 않았고, pending payment로만 기록되었기 때문에 재진입 callback이 발생하지 않았다는 뜻이다.

`Pending pull payment`는 나중에 사용자가 직접 claim할 수 있는 출금 대기 금액이다. 따라서 pull-payment 방식은 출금을 즉시 보내는 대신, 사용자가 별도로 claim하게 만들어 재진입 위험을 줄인다.

## 6. Parity Hack #1: Unauthorized Initialization 실습 결과

`parity1_attack.log`에서는 초기화되지 않은 proxy wallet이 attacker에게 탈취될 수 있음을 확인했다.

Wallet 1은 정상 owner가 `initWallet()`을 호출하여 정상적으로 제어했다. 반면 Wallet 2와 Wallet 3은 초기화되지 않은 상태였고, attacker가 `initWallet()`을 호출하여 owner가 되었다.

그 결과 attacker는 Wallet 2와 Wallet 3의 자금을 모두 drain했다.

로그에서 확인된 주요 결과는 다음과 같다.

- Wallet 2 attacker became owner through unauthorized `initWallet`
- Wallet 2 balance after attacker execute(): 0.0 ETH
- Wallet 3 attacker became owner through unauthorized `initWallet`
- Wallet 3 balance after attacker execute(): 0.0 ETH
- Result: uninitialized proxy storage let the attacker become owner of Wallet 2 and Wallet 3.

Fixed wallet 확인에서는 attacker가 `initWallet()`을 다시 실행하려고 했지만 `already initialized`로 revert되었다. 또한 attacker의 `execute()` 호출도 `owner only`로 revert되었다.

따라서 constructor 또는 초기화 보호 로직을 통해 wallet이 미초기화 상태로 남지 않도록 하는 것이 중요하다는 점을 확인했다.

이 로그에서 `Attacker is owner before initWallet: false`는 공격 전에는 attacker가 owner가 아니었다는 뜻이다. 이후 `Attacker is owner after unauthorized initWallet: true`는 초기화되지 않은 wallet에 attacker가 직접 `initWallet()`을 호출하여 owner 권한을 얻었다는 뜻이다.

`Wallet 2 balance after attacker execute(): 0.0 ETH`와 `Wallet 3 balance after attacker execute(): 0.0 ETH`는 attacker가 owner 권한을 얻은 뒤 `execute()`로 두 wallet의 잔액을 빼냈다는 의미이다.

Fixed wallet check의 `already initialized`와 `owner only` revert는 각각 재초기화 방지와 owner 권한 검사가 정상적으로 동작했다는 의미이다.

## 7. Parity Hack #2: Library Self-Destruct 실습 결과

`parity2_freeze.log`에서는 shared library가 selfdestruct되었을 때 wallet funds가 탈취되는 것이 아니라 freeze되는 상황을 확인했다.

세 개의 `SharedWallet` proxy는 모두 legitimate owner로 초기화되어 있었고 각각 5 ETH를 보유하고 있었다. 이후 attacker가 library 자체의 storage를 직접 초기화하여 library owner가 되었고, `killLibrary()`를 실행했다.

그 결과 library code bytes는 2063에서 0으로 바뀌었다. 즉, shared library code가 제거되었다.

이후 각 wallet owner가 `execute()`를 호출하려고 했지만, shared library code가 사라져 모두 revert되었다. 그러나 wallet balance는 attacker에게 이동하지 않고 각각 5 ETH로 그대로 남았다.

로그에서 확인된 주요 결과는 다음과 같다.

- Library code bytes before kill: 2063
- Library code bytes after kill: 0
- Wallet 1 funds remain frozen, not stolen: 5.0 ETH
- Wallet 2 funds remain frozen, not stolen: 5.0 ETH
- Wallet 3 funds remain frozen, not stolen: 5.0 ETH
- Result: funds are frozen, not stolen.

Fixed shared library 확인에서는 attacker가 fixed library를 직접 초기화하려고 했지만 `already initialized`로 revert되었다. 또한 fixed library는 kill function을 제공하지 않았고, legitimate owner는 wallet을 계속 사용할 수 있었다.

이 로그에서 `Library code bytes before kill: 2063`은 selfdestruct 전 library address에 코드가 존재했다는 뜻이다. `Library code bytes after kill: 0`은 `killLibrary()` 이후 해당 주소의 코드가 제거되었다는 뜻이다.

각 wallet의 `owner cannot execute because shared library code is gone`은 wallet 자체의 ETH가 없어졌다는 뜻이 아니라, wallet이 delegatecall할 library code를 잃어서 기능을 실행할 수 없게 되었다는 뜻이다.

그래서 `funds remain frozen, not stolen`이 중요하다. Parity #2에서는 attacker가 wallet balance를 가져간 것이 아니라, wallet들이 자금을 보유한 채로 사용할 수 없는 freeze 상태가 되었다.

## 8. 실습 결론

이번 실습을 통해 스마트 컨트랙트에서 다음 보안 원칙이 중요하다는 것을 확인했다.

- 외부 호출 전에 내부 상태를 먼저 변경해야 한다.
- 재진입 공격을 막기 위해 CEI 패턴이나 reentrancy guard를 사용할 수 있다.
- Ether를 직접 push하는 구조보다 pull-payment 구조가 안전할 수 있다.
- proxy wallet은 반드시 안전하게 초기화되어야 한다.
- `delegatecall`은 호출 대상 코드가 proxy storage를 변경할 수 있으므로 매우 주의해야 한다.
- shared library에 selfdestruct 같은 위험한 기능이 있으면 여러 wallet이 동시에 freeze될 수 있다.

최종적으로 `npm test` 실행을 통해 모든 시뮬레이션이 정상적으로 수행되었고, 각 결과는 `logs/` 폴더에 기록되었다.
