# VS Code로 GitHub 올리고 받기 — 초보자용 안내서

이 문서는 Git과 GitHub를 처음 사용하는 팀원이 그대로 따라 할 수 있도록 작성했다.

## 1. 먼저 알아둘 말

| 용어 | 쉬운 뜻 |
|---|---|
| 저장소(Repository) | 프로젝트가 보관되는 GitHub 공간 |
| Clone | GitHub 프로젝트를 내 컴퓨터에 처음 내려받기 |
| Commit | 내가 변경한 내용을 하나의 작업 기록으로 저장하기 |
| Push | 내 컴퓨터의 Commit을 GitHub에 올리기 |
| Pull | GitHub의 최신 내용을 내 컴퓨터로 받기 |
| Branch | 다른 팀원과 섞이지 않게 나만 작업하는 공간 |
| Merge | 서로 다른 Branch의 작업을 합치기 |
| Conflict | 같은 부분을 여러 명이 수정해서 자동으로 합칠 수 없는 상태 |

가장 중요한 흐름은 다음과 같다.

```text
작업 시작: Pull → 내 Branch 확인 → 코딩
작업 종료: 저장 → Commit → Push
```

---

## 2. 최초 한 번만 준비하기

### 2.1 Git 설치 확인

VS Code에서 위쪽 메뉴의 `Terminal → New Terminal`을 선택하고 입력한다.

```powershell
git --version
```

다음처럼 버전이 표시되면 설치된 상태다.

```text
git version 2.x.x
```

명령어를 찾을 수 없다고 나오면 Git을 설치한 다음 VS Code를 완전히 종료했다가 다시 실행한다.

### 2.2 GitHub 계정 준비

1. GitHub 계정을 만든다.
2. 팀장이 보내준 저장소 주소를 연다.
3. 저장소가 보이는지 확인한다.
4. 보이지 않으면 팀장에게 GitHub 아이디를 알려주고 저장소 초대를 요청한다.
5. GitHub 알림 또는 이메일에서 초대를 수락한다.

### 2.3 이름과 이메일 설정

VS Code 터미널에서 아래 명령어를 한 번 실행한다.

```powershell
git config --global user.name "본인 이름"
git config --global user.email "GitHub 가입 이메일"
```

예시:

```powershell
git config --global user.name "홍길동"
git config --global user.email "hong@example.com"
```

설정 확인:

```powershell
git config --global user.name
git config --global user.email
```

---

## 3. GitHub 프로젝트 처음 받기(Clone)

이미 프로젝트를 Clone했다면 이 단계는 다시 하지 않는다.

### VS Code 화면으로 받는 방법

1. VS Code를 실행한다.
2. 왼쪽의 `Source Control` 아이콘을 누른다.
3. `Clone Repository`를 누른다.
4. 팀장이 알려준 GitHub 저장소 주소를 붙여 넣는다.
5. 프로젝트를 저장할 상위 폴더를 선택한다.
6. 다운로드가 끝나면 `Open`을 누른다.
7. 신뢰 여부를 물으면 팀 저장소가 맞는지 확인하고 `Yes, I trust the authors`를 선택한다.

저장소 주소 예시:

```text
https://github.com/팀계정/저장소이름.git
```

### 로그인 창이 나타나는 경우

1. `Sign in with your browser` 또는 GitHub 로그인을 선택한다.
2. 브라우저에서 GitHub에 로그인한다.
3. VS Code 접근 허용 버튼을 누른다.
4. VS Code로 돌아온다.

비밀번호를 터미널에 직접 입력하는 방식은 사용하지 않는다.

### Clone 후 확인

VS Code 터미널에서 실행한다.

```powershell
git status
```

오류 없이 현재 Branch가 표시되면 정상이다.

---

## 4. 처음 작업할 때 내 Branch 만들기

팀원은 `main`에서 직접 작업하지 않는다.

### VS Code 화면으로 Branch 만들기

1. VS Code 왼쪽 아래의 Branch 이름(`main`)을 누른다.
2. `Create new branch...`를 선택한다.
3. 자기 담당 Branch 이름을 입력한다.
4. Branch가 바뀌었는지 왼쪽 아래에서 확인한다.

권장 Branch 이름:

```text
feature/admin
feature/development-production
feature/purchase
feature/material-supplier
```

담당별 예시:

| 담당 | Branch |
|---|---|
| 공통·관리자 | `feature/admin` |
| 개발·생산 | `feature/development-production` |
| 구매 | `feature/purchase` |
| 자재·협력회사 | `feature/material-supplier` |

### Branch를 GitHub에 처음 올리기

1. 왼쪽 `Source Control`을 연다.
2. `Publish Branch`를 누른다.
3. GitHub 저장소에 해당 Branch가 생겼는지 확인한다.

---

## 5. 매일 작업 시작할 때

코드를 수정하기 전에 GitHub의 최신 내용을 먼저 받는다.

### 가장 쉬운 방법

1. VS Code 왼쪽 아래에서 자기 Branch인지 확인한다.
2. 위쪽 메뉴에서 `Source Control`을 연다.
3. `···` 버튼을 누른다.
4. `Pull, Push → Pull`을 선택한다.
5. 오류가 없는지 확인한다.

또는 VS Code 아래쪽의 동기화 화살표 아이콘을 사용할 수 있다.

### 터미널로 확인하는 방법

```powershell
git branch --show-current
git pull
```

첫 번째 명령어 결과가 자기 Branch 이름이어야 한다.

---

## 6. 파일을 수정한 후 GitHub에 올리기

### 6.1 파일 저장

먼저 `Ctrl + S`로 수정한 파일을 저장한다.

### 6.2 변경 파일 확인

1. 왼쪽 `Source Control` 아이콘을 누른다.
2. `Changes` 목록을 확인한다.
3. 본인이 수정하지 않은 파일이 있다면 바로 올리지 말고 팀원에게 확인한다.
4. 파일을 누르면 수정 전·후 차이를 볼 수 있다.

### 6.3 Stage 하기

올릴 파일 오른쪽의 `+` 버튼을 누른다.

그러면 파일이 `Staged Changes`로 이동한다.

`Changes` 제목 옆의 `+`를 누르면 모든 변경 파일이 한 번에 Stage되므로, 처음에는 파일별로 확인하고 누르는 것을 권장한다.

### 6.4 Commit 하기

위쪽 메시지 입력칸에 작업 내용을 적는다.

좋은 Commit 메시지:

```text
구매 발주 목록 화면 추가
품목 등록 오류 수정
협력회사 견적 조회 기능 구현
```

좋지 않은 Commit 메시지:

```text
수정
작업함
aaa
```

메시지를 작성한 후 `Commit` 버튼을 누른다.

### 6.5 Push 하기

Commit 후 다음 중 하나를 실행한다.

- `Sync Changes` 버튼 누르기
- `Source Control → ··· → Pull, Push → Push` 선택

처음 Push할 때 로그인 또는 권한 허용 창이 나타나면 GitHub 계정으로 승인한다.

### 6.6 GitHub에서 확인

1. 웹 브라우저에서 GitHub 저장소를 연다.
2. Branch 선택 버튼을 누른다.
3. 자기 Branch를 선택한다.
4. 방금 수정한 파일과 Commit 메시지가 보이는지 확인한다.

---

## 7. 다른 팀원의 최신 작업 받기

팀원이 `main`에 병합한 내용을 내 Branch에 가져오는 방법이다.

### 안전한 순서

먼저 작업 중인 내용을 Commit하고 Push한다. 저장하지 않은 변경이 남은 상태에서 Branch를 이동하지 않는다.

VS Code 터미널에서 실행한다.

```powershell
git switch main
git pull origin main
git switch 본인브랜치
git merge main
```

구매 담당 예시:

```powershell
git switch main
git pull origin main
git switch feature/purchase
git merge main
```

충돌이 없다면 마지막으로 내 Branch를 Push한다.

```powershell
git push
```

---

## 8. 내가 올린 내용을 main에 합치기

초보 팀에서는 팀장 또는 병합 담당자 한 명이 `main`에 합치는 것을 권장한다.

### 작업자가 해야 할 일

1. 자기 Branch의 변경 내용을 모두 Commit한다.
2. `Push`한다.
3. GitHub 저장소를 연다.
4. `Compare & pull request` 버튼을 누른다.
5. 제목에 구현 내용을 적는다.
6. 설명에 작업 내용과 확인 방법을 적는다.
7. `Create pull request`를 누른다.
8. 팀장에게 Pull Request 확인을 요청한다.

Pull Request 설명 예시:

```text
작업 내용
- 구매 발주 목록과 등록 화면 구현
- 발주 상태 변경 기능 추가

확인 방법
- 구매부서 계정으로 로그인
- 구매부서 → 구매 발주 메뉴 접속
```

### 병합 담당자가 해야 할 일

1. 변경 파일을 확인한다.
2. 다른 파트의 파일이 불필요하게 수정되지 않았는지 확인한다.
3. 프로젝트 테스트를 실행한다.
4. 문제가 없으면 Pull Request를 Merge한다.
5. 팀 채팅에 `main 병합 완료`라고 알린다.

---

## 9. 같은 파일을 수정해 충돌이 발생한 경우

충돌 메시지가 나와도 파일을 삭제하거나 프로젝트를 다시 Clone하지 않는다.

### VS Code에서 해결

1. 왼쪽 `Source Control`을 연다.
2. `Merge Changes`에 표시된 파일을 누른다.
3. 충돌 부분을 확인한다.
4. 필요한 내용을 선택한다.

VS Code에 다음 선택지가 표시될 수 있다.

| 버튼 | 의미 |
|---|---|
| Accept Current Change | 내 Branch 내용 사용 |
| Accept Incoming Change | 새로 받아온 내용 사용 |
| Accept Both Changes | 두 내용을 모두 사용 |
| Compare Changes | 두 내용 비교 |

무조건 `Accept Both Changes`를 누르면 코드가 중복될 수 있다. 어떤 내용이 필요한지 확인하고 선택한다.

5. 충돌 표시가 모두 사라졌는지 확인한다.
6. 파일을 저장한다.
7. 프로젝트를 실행하거나 테스트한다.
8. 해결한 파일을 Stage한다.
9. Commit 후 Push한다.

충돌 부분은 보통 다음처럼 표시된다.

```text
<<<<<<< HEAD
내 Branch의 내용
=======
새로 받아온 내용
>>>>>>> main
```

최종 파일에는 `<<<<<<<`, `=======`, `>>>>>>>` 표시가 남아 있으면 안 된다.

어떤 코드를 선택해야 할지 모르겠다면 혼자 결정하지 말고 해당 파일을 수정한 팀원과 함께 확인한다.

---

## 10. 자주 발생하는 문제

### `Please commit your changes or stash them`

현재 수정한 내용이 저장되지 않은 상태에서 Branch를 바꾸려고 한 경우다.

해결:

1. 수정 내용을 확인한다.
2. 필요한 변경이면 Commit한다.
3. 필요 없는 변경인지 확실하지 않으면 삭제하지 말고 팀원에게 확인한다.
4. Commit 후 다시 Branch를 이동한다.

### `Your branch is behind`

GitHub에 더 최신 내용이 있다는 뜻이다.

해결:

```powershell
git pull
```

그다음 Push한다.

### Push가 거부되는 경우

먼저 최신 내용을 받은 후 다시 올린다.

```powershell
git pull
git push
```

충돌이 발생하면 충돌을 해결하고 Commit한 후 Push한다.

### GitHub 로그인이 계속 실패하는 경우

- VS Code 오른쪽 아래 또는 왼쪽 아래의 계정 아이콘을 확인한다.
- GitHub 계정에서 로그아웃 후 다시 로그인한다.
- 저장소 초대를 수락했는지 확인한다.
- 팀장에게 저장소 Collaborator로 등록됐는지 확인을 요청한다.

### 수정한 파일이 Source Control에 안 보이는 경우

- 파일을 `Ctrl + S`로 저장했는지 확인한다.
- VS Code에서 올바른 프로젝트 폴더를 열었는지 확인한다.
- 터미널에서 `git status`를 실행한다.

### 잘못된 Branch에서 작업한 경우

파일을 삭제하거나 강제로 되돌리지 말고 즉시 작업을 멈춘 뒤 팀장에게 알린다. 아직 Commit하지 않았다면 변경 파일을 확인한 후 안전하게 옮기는 방법을 함께 결정한다.

---

## 11. 절대 하지 말아야 할 것

- `main` Branch에서 직접 기능 개발
- 다른 팀원의 폴더나 파일을 허락 없이 수정
- 오류가 난다는 이유로 프로젝트 폴더 삭제
- DB 테이블이나 컬럼 이름을 혼자 변경
- 충돌 내용을 확인하지 않고 모두 선택
- 테스트하지 않고 Pull Request 병합
- `.git` 폴더 삭제
- 비밀번호, DB 비밀번호, API 키를 GitHub에 업로드
- 의미를 모르는 Git 명령어를 인터넷에서 복사해 실행

특히 다음 명령어는 팀장의 확인 없이 실행하지 않는다.

```text
git reset --hard
git push --force
git clean -fd
```

작업 내용을 잃거나 다른 팀원의 Git 기록에 영향을 줄 수 있다.

---

## 12. 매일 사용하는 초간단 체크리스트

### 작업 시작

- [ ] VS Code에서 올바른 프로젝트 폴더를 열었다.
- [ ] 왼쪽 아래에서 내 Branch인지 확인했다.
- [ ] Pull로 최신 내용을 받았다.
- [ ] 오늘 수정할 파일이 내 담당 영역인지 확인했다.

### 작업 종료

- [ ] 파일을 저장했다.
- [ ] 변경 파일을 하나씩 확인했다.
- [ ] 프로젝트 실행 또는 테스트에 성공했다.
- [ ] 필요한 파일만 Stage했다.
- [ ] 알아볼 수 있는 메시지로 Commit했다.
- [ ] Push했다.
- [ ] GitHub에서 내 Branch에 올라갔는지 확인했다.

### main 병합 요청

- [ ] 최신 `main`을 내 Branch에 반영했다.
- [ ] 충돌을 해결했다.
- [ ] 다시 테스트했다.
- [ ] Pull Request를 만들었다.
- [ ] 팀장 또는 병합 담당자에게 알렸다.

---

## 13. 우리 프로젝트 권장 작업 예시

구매 담당 팀원이 하루 동안 작업하는 예시다.

```text
1. VS Code 실행
2. feature/purchase Branch 확인
3. Pull 실행
4. 구매 발주 목록 기능 작성
5. 서버 실행 및 화면 확인
6. Source Control에서 변경 파일 확인
7. 변경한 구매 관련 파일만 Stage
8. "구매 발주 목록 기능 구현"으로 Commit
9. Push
10. GitHub에서 업로드 확인
```

기능이 완성되어 `main`에 합칠 때:

```text
1. main의 최신 내용을 내 Branch에 반영
2. 충돌 해결
3. 프로젝트 테스트
4. 내 Branch Push
5. Pull Request 생성
6. 병합 담당자에게 검토 요청
```

## 14. 도움을 요청할 때 같이 보내야 하는 정보

`안 돼요`라고만 보내면 원인을 찾기 어렵다. 다음 내용을 함께 보낸다.

- 어떤 버튼 또는 명령어를 실행했는지
- VS Code에 표시된 오류 문장 전체
- 현재 Branch 이름
- `git status` 실행 결과
- Source Control 화면 캡처
- 오류가 발생하기 직전에 한 작업

비밀번호나 개인 인증 정보는 캡처에 포함하지 않는다.
