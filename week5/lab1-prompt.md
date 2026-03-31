# Lab 1: HelloWorld & HelloNumber - Solidity Lab Simulator 제작 프롬프트

## 개요

5주차 블록체인 수업용 **Solidity Lab Simulator**의 Lab 1을 단일 HTML 파일로 제작해주세요.
Remix IDE를 모방한 웹 기반 시뮬레이터로, 학생들이 브라우저에서 직접 Solidity 코드를 작성하고 컴파일/배포/함수 호출을 체험할 수 있어야 합니다.

---

## 전체 구조

### SPA (Single Page Application) 구조
- **런처 페이지**: Lab 1 카드를 클릭하면 Lab 페이지로 이동
- **Lab 1 페이지**: 3개 서브탭으로 구성
  - 탭 1: HelloWorld 기본 (public 변수)
  - 탭 2: HelloWorld 확장 (private 변수 + getter/setter)
  - 탭 3: HelloNumber (int 타입 + 도전과제)
- Hash 기반 라우팅 (`#launcher`, `#lab1`)
- 키보드 단축키: `1`키로 Lab 1 이동, `Escape`으로 런처 복귀

### 3단 레이아웃 (Lab 페이지)
1. **좌측 - 코드 에디터**: Solidity 구문 하이라이팅, 줄 번호, 자동 저장 (localStorage)
2. **중앙 - 컨트롤 패널**: 컴파일/배포 버튼, 계정 정보, 블록체인 상태, 실습 가이드
3. **우측 - 인터랙션 패널**: 배포된 컨트랙트의 함수 호출 UI

---

## 디자인 테마

### 블록체인 네온 다크 테마
- 배경: `#0a0e27` (딥 다크), `#111633` (서피스), `#1a1f4a` (엘리베이티드)
- 네온 색상: 시안(`#00d4ff`), 퍼플(`#7c3aed`), 그린(`#10b981`), 오렌지(`#f59e0b`), 레드(`#ef4444`)
- 폰트: 코드용 `Consolas/Fira Code`, UI용 `Segoe UI/Malgun Gothic`
- 애니메이션: fadeIn, slideUp, neonPulse, miningPulse, shimmer 등

### 런처 카드
- 블록체인 체인 링크 아이콘으로 카드 연결
- 호버 시 위로 떠오르는 효과 + 네온 보더
- 클릭 시 마이닝 펄스 애니메이션 후 페이지 전환
- 진행률 바 표시 (localStorage 기반)
- 메타 정보: 난이도(`기초 ★☆☆`), 소요시간(`~15분`), 태그(`string`, `public`, `view`, `int`)

---

## 코드 에디터 기능

### 구문 하이라이팅 (토크나이저 직접 구현)
- **키워드**: `pragma`, `solidity`, `contract`, `function`, `returns`, `public`, `private`, `view`, `pure`, `if`, `else`, `return`, `require`, `revert` 등
- **타입**: `string`, `int`, `uint`, `uint256`, `int256`, `bool`, `address`, `bytes`
- **수정자**: `memory`, `storage`, `calldata`, `payable`
- **색상**: 키워드=시안, 타입=퍼플, 문자열=그린, 숫자=오렌지, 주석=회색, 함수명=블루

### 에디터 기능
- 줄 번호 동기 스크롤
- 커서 위치 표시 (`줄 X, 열 Y`)
- Tab 키로 2칸 들여쓰기
- 코드 초기화/복사 버튼
- localStorage 자동 저장

---

## 블록체인 시뮬레이션 엔진

### 가상 VM (Remix JavaScript VM 모방)
```javascript
const BlockchainEngine = {
  blockNumber: 1,
  timestamp: Math.floor(Date.now() / 1000),
  gasPrice: 20, // Gwei
  chainId: 1337,
  accounts: [
    { address: '0x5B38Da6a...', balance: 100, label: 'Account 1', nonce: 0 },
    { address: '0xAb8483F6...', balance: 100, label: 'Account 2', nonce: 0 },
    { address: '0x4B20993B...', balance: 100, label: 'Account 3', nonce: 0 },
    { address: '0x78731D3C...', balance: 100, label: 'Account 4', nonce: 0 },
    { address: '0x617F2E2f...', balance: 100, label: 'Account 5', nonce: 0 },
  ],
  // 각 Lab별 독립 컨트랙트 상태
  // 블록 번호 증가, 가스비 차감, 트랜잭션 해시 생성
};
```

### 계정 시스템
- 5개 테스트 계정 (Remix와 동일한 주소), 각 100 ETH
- 계정 전환 가능 (드롭다운)
- 잔액, msg.sender 표시
- 트랜잭션 시 가스비 자동 차감

---

## Solidity 코드 파서

### 정규식 기반 파싱 (실제 컴파일러 없이 시뮬레이션)
- **pragma/contract 검증**: 존재 여부, 중괄호 짝 확인
- **변수 추출**: `(타입) (visibility) (이름) = (초기값);` 패턴
  - public 변수 → 자동 getter 함수로 인터랙션 패널에 표시
  - private 변수 → 내부 storage에만 저장
- **함수 추출**: `function (이름)((파라미터)) (visibility) (mutability) returns ((반환타입)) { (본문) }`
  - view/pure → 초록색 버튼 (가스비 무료)
  - 상태 변경 → 주황색 버튼 (가스비 소모)

---

## 기본 Solidity 코드 (3개 서브탭)

### 탭 1: HelloWorld 기본
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloWorld {
    string public greet = "Hello World";
}
```

### 탭 2: HelloWorld 확장
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloWorld {
    string private _greeting = "Hello, World!";

    function greet() public view returns (string memory) {
        return _greeting;
    }

    function setGreeting(string memory newGreeting) public {
        _greeting = newGreeting;
    }
}
```

### 탭 3: HelloNumber
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloNumber {
    int public number = 10;
}
```

---

## 함수 실행 시뮬레이션

### View/Pure 함수 실행
- 패턴 1: `return _변수명;` → storage에서 해당 변수값 반환
- 패턴 2: `return "문자열리터럴";` → 문자열 직접 반환
- 패턴 3: `return 숫자;` → 숫자 직접 반환
- 패턴 4: `return true/false;` → 불리언 반환
- 결과 표시: `타입: 값` + "view/pure 함수 → 가스비 무료 (로컬에서 실행)"

### 상태 변경 함수 실행
- 패턴 A: `_변수 = 파라미터;` → 단순 setter (storage 업데이트)
- 패턴 B: `변수 = 복잡한_수식;` → 수식 평가 후 storage 업데이트
- 가스 소모: 21,000 + 랜덤(0~25,000) gas
- 가스비 차감: `gasUsed × 20 Gwei` → ETH로 변환하여 계정에서 차감
- 블록 번호 증가, 트랜잭션 해시 생성
- 결과 표시: 트랜잭션 성공 + 가스 사용량 + 상태 변경 내역 + Tx 해시

---

## 인터랙션 패널 UI

### 배포 전
- "컨트랙트를 배포하세요" 안내 메시지
- 1→코드 확인, 2→컴파일, 3→배포 단계 표시

### 배포 후
- **public 변수**: 초록색 버튼 → 클릭 시 현재 값 표시
- **view/pure 함수**: 초록색 버튼 → 파라미터 입력 → 결과 표시
- **상태 변경 함수**: 주황색 버튼 → 파라미터 입력 → 트랜잭션 결과 표시
- 상태 변수 시각화 섹션: 변수명, 타입, 가시성(public/private), 현재 값 표시 (변경 시 하이라이트 애니메이션)

---

## 실습 가이드 (각 탭별)

### 탭 1 가이드
1. 코드를 확인하세요. `string public greet`
2. **컴파일** 버튼을 누르세요
3. **배포** 버튼을 누르세요
4. 우측에서 **greet** 버튼 클릭!
- 힌트: `public` 변수는 자동으로 getter 함수가 생성됩니다.

### 탭 2 가이드
1. `private` 변수와 함수를 확인하세요
2. 컴파일 → 배포
3. `greet()`를 호출해보세요
4. `setGreeting`으로 값을 변경하세요
5. 다시 `greet()`를 호출하여 변경 확인!
- 힌트: 상태 변경 함수는 gas를 소모합니다. 잔액 변화를 확인해보세요.

### 탭 3 가이드
1. `int` 타입 변수를 확인하세요
2. 컴파일 → 배포 → `number` 확인
3. **도전과제**에 도전해보세요!
- 도전: `private`으로 바꾸고 getter/setter를 추가해보세요!

---

## 도전과제 (탭 3: HelloNumber)

### public vs private 비교표
| 특성 | public | private |
|------|--------|---------|
| 외부 접근 | 가능 | 불가 |
| 자동 getter | 자동 생성 | 직접 작성 |
| 컨트랙트 내부 | 접근 가능 | 접근 가능 |
| 상속 컨트랙트 | 접근 가능 | 접근 불가 |
| 사용 시나리오 | 공개 데이터 | 캡슐화/보안 |

### 도전과제 내용
- `int public number`를 `int private _number`로 변경
- `getNumber()`: public view 함수로 `_number` 반환
- `setNumber(int)`: public 함수로 `_number` 변경
- 힌트 코드 보기/적용 버튼 제공

### 힌트 코드 (도전과제 정답)
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloNumber {
    int private _number = 10;

    function getNumber() public view returns (int) {
        return _number;
    }

    function setNumber(int newNumber) public {
        _number = newNumber;
    }
}
```

---

## 콘솔 패널 (하단)

### 기능
- 모든 액션을 타임스탬프와 함께 로깅
- 로그 타입: success(✅), error(❌), info(ℹ️), warning(⚠️), tx(🔶)
- 각 로그 클릭 시 상세 정보 펼침 (타입, Lab, from 주소, 블록 번호, 시간)
- 콘솔 클리어, 최소화/최대화 토글
- `Ctrl+\`` 단축키로 토글

---

## 토스트 알림

- 4가지 타입: success, error, info, warning
- 우측 상단에서 슬라이드인 → 3초 후 자동 사라짐
- 아이콘 + 메시지 형식

---

## 진행률 시스템 (localStorage)

- 각 서브탭별 완료 여부 추적
- 함수 호출 성공 시 해당 탭 완료 표시 (체크마크)
- 런처 카드에 진행률 바 표시
- 전체 진행률 표시 (0/3 Labs)
- 진행률 초기화 버튼

---

## 배경 효과

### Canvas 파티클 애니메이션
- 어두운 배경에 작은 빛 입자들이 떠다니는 효과
- 페이지 비활성화 시 애니메이션 일시정지 (성능 최적화)

---

## 키보드 단축키

| 단축키 | 기능 |
|--------|------|
| `1` | Lab 1 이동 |
| `Escape` | 런처로 복귀 |
| `Ctrl+Enter` | 현재 Lab 컴파일 |
| `Ctrl+Shift+D` | 현재 Lab 배포 |
| `Ctrl+/` | 단축키 도움말 모달 |
| `Ctrl+\`` | 콘솔 토글 |

---

## 기술 요구사항

- **단일 HTML 파일**: 외부 라이브러리 없이 순수 HTML/CSS/JavaScript
- **언어**: 한국어 UI
- **반응형**: 최소 1024px 이상 (데스크톱 최적화)
- **브라우저**: 크롬/엣지 최신 버전
- **저장**: localStorage로 코드와 진행률 자동 저장
- **성능**: 배경 애니메이션 requestAnimationFrame 사용, 비활성 탭 일시정지
