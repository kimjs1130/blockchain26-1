# Solidity Lab Simulator - Lab 1

## 📌 프로젝트 개요

브라우저에서 Solidity 스마트 컨트랙트를 작성하고, 컴파일/배포/함수 실행을 체험할 수 있는 간단한 **Solidity Lab Simulator**입니다.

---

## ⚙️ 실행 방법

### 1. 파일 실행

아래 방법 중 하나 선택

#### 방법 1 (추천)

```bash
start lab1.html
```

#### 방법 2 (python 서버)

```bash
python -m http.server 8000
```

브라우저 접속:

```
http://localhost:8000/lab1.html
```

---

## 🧪 실습 내용

### ✔ Combined Contract

* `greeting` (string)
* `number` (int)

### ✔ 구현 기능

* getter 함수

  * `getGreeting()`
  * `getNumber()`
* setter 함수

  * `setGreeting()`
  * `setNumber()`

---

## 🔍 실습 목표

### 1. public vs private 비교

* `public` → 자동 getter 생성
* `private` → 직접 getter 필요

### 2. 상태 변경 확인

* setter 실행 후 값 변경 확인

---

## 🖥️ 실행 화면

아래는 실행 결과 화면입니다.

![실행 화면](![alt text](image.png))

※ 위 이미지 위치에 캡처한 화면을 넣어주세요.

---

## 🧩 기능 설명

### ✔ 컴파일

* Solidity 코드 검증

### ✔ 배포

* 컨트랙트 상태 초기화

### ✔ 인터랙션

* getter 버튼 → 값 조회
* setter 함수 → 값 변경

---

## 🔥 체크리스트

* [x] greeting 조회 가능
* [x] number 조회 가능
* [x] setter로 값 변경 가능
* [x] public → private 변경 실험 완료

---

## 🚀 추가 과제

### Faucet Contract 구현

* ETH를 요청하면 일정량 지급하는 스마트 컨트랙트 작성

---

## 📎 파일 구조

```
lab1.html
README.md
screenshot.png
```

---

## ✅ 결론

Solidity의 상태 변수 접근 방식(public/private)과
getter/setter 개념을 실습으로 이해하는 것이 목표입니다.
