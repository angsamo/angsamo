# 앙사모 ERP

부서별 권한을 사용하는 조달·구매 관리 팀 프로젝트입니다.

## 기술 구성

- Spring Boot
- JSP / JSTL / Bootstrap / JavaScript
- MyBatis
- MySQL
- Maven

## VS Code 실행

1. Java Extension Pack과 Spring Boot Extension Pack을 설치합니다.
2. MySQL에 `angsamo_erp` 데이터베이스를 생성합니다.
3. 필요하면 `DB_USERNAME`, `DB_PASSWORD` 환경 변수를 설정합니다.
4. 프로젝트 루트에서 실행합니다.

```powershell
.\mvnw.cmd spring-boot:run
```

5. 브라우저에서 `http://localhost:8080`에 접속합니다.

## 기본 패키지

부서별 기능은 다음 패키지 아래에 추가합니다.

```text
com.angsamo.erp
├─ common
├─ admin
├─ development
├─ production
├─ purchase
├─ material
└─ supplier
```
