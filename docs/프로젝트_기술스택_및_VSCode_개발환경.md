# 앙사모 ERP 프로젝트 기술 스택 및 개발환경

## 1. 프로젝트 개요

- 프로젝트명: 앙사모 ERP
- 프로젝트 형태: 부서별 권한을 적용하는 조달·구매 ERP 웹 프로젝트
- 개발 방식: Spring Boot 기반 MVC 웹 애플리케이션
- 화면 방식: JSP에서 HTML, CSS, JavaScript 사용
- 협업 방식: Git 및 GitHub

## 2. 공통 기술 스택

| 구분 | 기술 | 버전 및 용도 |
|---|---|---|
| 개발 언어 | Java | JDK 25 |
| 백엔드 | Spring Boot | 4.0.7 |
| 웹 MVC | Spring MVC | Controller와 JSP 화면 연결 |
| 프론트엔드 | JSP, HTML, CSS, JavaScript | 별도 React/Vue 없이 기본 웹 화면 구현 |
| JSP 태그 | Jakarta JSTL | JSP 조건문, 반복문 등 사용 |
| DB 접근 | MyBatis | 4.0.1 |
| 데이터베이스 | MySQL | 8.0 계열 |
| DB 드라이버 | MySQL Connector/J | Spring Boot에서 MySQL 연결 |
| 입력값 검증 | Jakarta Validation | 요청값 필수 여부와 형식 검사 |
| 웹 서버 | Apache Tomcat | Spring Boot 내장 서버 사용 |
| 빌드 도구 | Maven Wrapper | 별도 Maven 설치 없이 `mvnw.cmd` 사용 |
| 패키징 | WAR | 내장 서버 실행 및 외부 Tomcat 배포 가능 |
| 테스트 | Spring Boot Test, JUnit | 애플리케이션 구동 및 기능 테스트 |
| 개발 도구 | VS Code | Java 및 Spring Boot 개발 |
| 형상관리 | Git | 소스 변경 이력 관리 |
| 원격 저장소 | GitHub | 팀 프로젝트 공유 및 협업 |

## 3. VS Code에 연결된 항목

VS Code에는 다음 Java 및 Spring 개발 확장이 설치되어 있다.

- Extension Pack for Java
- Language Support for Java
- Debugger for Java
- Maven for Java
- Test Runner for Java
- Project Manager for Java
- Spring Boot Extension Pack
- Spring Boot Dashboard
- Spring Initializr Java Support

`pom.xml`을 Maven이 읽으면 다음 프로젝트 라이브러리가 자동으로 다운로드되고 클래스패스에 연결된다.

- Spring Boot 4.0.7
- Spring MVC
- MyBatis 4.0.1
- MySQL Connector/J
- JSP/JSTL
- Tomcat
- Validation
- 테스트 라이브러리

## 4. VS Code와 별도로 PC에 필요한 프로그램

다음 프로그램은 VS Code 확장이 아니므로 팀원 PC에 별도로 설치해야 한다.

1. JDK 25
2. MySQL Server 8.0
3. MySQL Workbench
4. Git
5. VS Code
6. GitHub 계정

Maven은 프로젝트에 포함된 Maven Wrapper를 사용하므로 별도로 설치하지 않아도 된다.

## 5. 프로젝트 폴더 열기

VS Code에서는 `pom.xml`이 바로 들어 있는 다음 폴더를 열어야 한다.

```text
C:\class11_LJH\angsamoworkspaces\angsamo
```

탐색기 최상단에서 다음 항목이 바로 보이면 정상이다.

```text
pom.xml
mvnw.cmd
src
database
docs
```

상위 폴더인 `angsamoworkspaces`를 열면 Java 클래스패스 오류가 발생할 수 있다.

## 6. 기본 프로젝트 구조

```text
src/main/java/com/angsamo/erp
├─ controller  # 화면 요청 및 응답 처리
├─ service     # 업무 로직
├─ mapper      # MyBatis DB 접근 인터페이스
├─ domain      # DB 엔터티 대응 객체
├─ dto         # 화면과 API 요청·응답 객체
├─ config      # 공통 설정
└─ common      # 공통 기능

src/main/resources
├─ mapper      # MyBatis XML 쿼리
└─ application.properties

src/main/webapp/WEB-INF/views
└─ *.jsp       # JSP 화면
```

## 7. JSP 화면 연결

`application.properties`의 JSP 설정은 다음과 같다.

```properties
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

Controller에서 다음 값을 반환하면:

```java
return "dashboard";
```

다음 JSP 화면이 열린다.

```text
src/main/webapp/WEB-INF/views/dashboard.jsp
```

## 8. MyBatis 연결

MyBatis XML 파일 위치와 컬럼 변환 설정은 다음과 같다.

```properties
mybatis.mapper-locations=classpath:mapper/**/*.xml
mybatis.configuration.map-underscore-to-camel-case=true
```

DB 컬럼과 Java 필드는 다음처럼 자동 대응된다.

```text
department_id → departmentId
created_at    → createdAt
item_code     → itemCode
```

## 9. MySQL 설정

실제 DB 비밀번호는 GitHub에 올리지 않고 환경변수로 설정한다.

```properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

PowerShell 실행 예시:

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/angsamo?serverTimezone=Asia/Seoul&characterEncoding=UTF-8"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="본인_MySQL_비밀번호"
.\mvnw.cmd spring-boot:run
```

DB 생성용 전체 SQL:

```text
database/angsamo_team_full.sql
```

이 SQL은 아무것도 없는 개인 MySQL에 최초 한 번만 실행한다.

## 10. 빌드 및 실행 명령

프로젝트 폴더의 VS Code 터미널에서 실행한다.

테스트 및 빌드 확인:

```powershell
.\mvnw.cmd test
```

Spring Boot 실행:

```powershell
.\mvnw.cmd spring-boot:run
```

실행 후 접속 주소:

```text
http://localhost:8080/
```

정상 빌드 결과:

```text
BUILD SUCCESS
```

## 11. 백엔드 처리 흐름

```text
브라우저
  → Spring MVC Controller
  → Service
  → MyBatis Mapper
  → MySQL
  → Controller
  → JSP 화면
```

## 12. 현재 사용하지 않는 기술

팀원은 회의 없이 다음 기술을 임의로 추가하지 않는다.

- Thymeleaf
- Spring Data JPA
- Hibernate
- Spring Security
- Lombok
- React
- Vue
- Node.js
- Gradle
- Docker

새 기술을 임의로 추가하면 팀원별 코드 구조와 실행환경이 달라질 수 있다.

## 13. 팀원 공통 확인표

- [ ] JDK 버전이 25인지 확인
- [ ] VS Code에서 `angsamo` 프로젝트 폴더를 정확히 열었는지 확인
- [ ] Java 및 Spring Boot 확장을 설치했는지 확인
- [ ] Git을 설치하고 GitHub 로그인을 완료했는지 확인
- [ ] MySQL Server와 Workbench를 설치했는지 확인
- [ ] `angsamo_team_full.sql`을 개인 MySQL에 실행했는지 확인
- [ ] DB 접속정보를 환경변수로 설정했는지 확인
- [ ] `.\mvnw.cmd test` 결과가 `BUILD SUCCESS`인지 확인
- [ ] `.\mvnw.cmd spring-boot:run`으로 서버가 실행되는지 확인
- [ ] `http://localhost:8080/` 접속을 확인
- [ ] DB 비밀번호 파일을 GitHub에 올리지 않았는지 확인

## 14. 팀 공통 결정사항

```text
Java: 25
Spring Boot: 4.0.7
MyBatis: 4.0.1
MySQL: 8.0 계열
화면: JSP + HTML + CSS + JavaScript + JSTL
빌드: Maven Wrapper
서버: Spring Boot 내장 Tomcat
패키징: WAR
형상관리: Git/GitHub
개발도구: VS Code
문자 인코딩: UTF-8
DB 이름: angsamo
기본 서버 포트: 8080
```

## 15. VS Code에서 Spring Boot 최초 설정하기

### 15.1 프로젝트를 정확한 폴더로 열기

VS Code를 모두 닫고 다음 폴더를 새 창으로 연다.

```powershell
code -n "C:\class11_LJH\angsamoworkspaces\angsamo"
```

왼쪽 탐색기 최상단에서 `pom.xml`과 `mvnw.cmd`가 바로 보여야 한다. 상위 폴더인 `angsamoworkspaces`를 열면 다음 오류가 발생할 수 있다.

```text
is not on the classpath
Cannot resolve the modulepaths/classpaths automatically
```

이 오류가 발생하면 `Add to Source Path`를 누르지 말고 프로젝트 폴더를 다시 연다.

### 15.2 Java 25 선택하기

1. `Ctrl + Shift + P`를 누른다.
2. `Java: Configure Java Runtime`을 실행한다.
3. 프로젝트 JDK로 설치된 JDK 25를 선택한다.
4. 터미널에서 버전을 확인한다.

```powershell
java -version
```

결과에 `25`가 표시되어야 한다.

### 15.3 Maven 프로젝트 불러오기

1. `Ctrl + Shift + P`를 누른다.
2. `Maven: Reload Projects`를 실행한다.
3. 오른쪽 아래의 Java 및 Maven 로딩이 끝날 때까지 기다린다.
4. VS Code의 `JAVA PROJECTS`에 `erp`가 표시되는지 확인한다.

Java 프로젝트 인식이 계속 잘못되면 다음 명령을 사용한다.

1. `Ctrl + Shift + P`
2. `Java: Clean Java Language Server Workspace`
3. `Restart and delete` 선택
4. 재시작 후 Maven 로딩이 끝날 때까지 대기

`launch.json`이나 Java Source Path는 직접 만들지 않는다. Maven이 클래스패스를 관리한다.

## 16. Spring Boot 핵심 설정 파일

설정 파일 위치:

```text
src/main/resources/application.properties
```

팀 공통 설정은 다음과 같이 작성한다.

```properties
spring.application.name=angsamo-erp

# JSP 화면 경로
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp

# MySQL: 실제 접속정보는 환경변수로 전달
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# MyBatis XML 위치 및 DB 컬럼명 변환
mybatis.mapper-locations=classpath:mapper/**/*.xml
mybatis.configuration.map-underscore-to-camel-case=true

# 요청과 응답의 한글 인코딩
server.servlet.encoding.charset=UTF-8
server.servlet.encoding.enabled=true
server.servlet.encoding.force=true
```

다음처럼 실제 비밀번호를 기본값으로 작성하면 안 된다.

```properties
# 금지 예시
spring.datasource.password=${DB_PASSWORD:12345}
```

이 값은 환경변수가 없을 때 `12345`를 사용하므로 GitHub에 비밀번호가 노출된다.

## 17. DB 환경변수 설정과 Spring Boot 실행

VS Code에서 `터미널 → 새 터미널`을 열고 프로젝트 경로인지 확인한다.

```powershell
Get-Location
```

PowerShell 터미널에서 각자 자신의 MySQL 접속정보를 설정한다.

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/angsamo?serverTimezone=Asia/Seoul&characterEncoding=UTF-8"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="본인의_MySQL_비밀번호"
```

환경변수가 설정됐는지 확인할 때 비밀번호는 출력하지 않는다.

```powershell
$env:DB_URL
$env:DB_USERNAME
```

테스트 후 서버를 실행한다.

```powershell
.\mvnw.cmd test
.\mvnw.cmd spring-boot:run
```

다음 로그가 표시되면 정상 실행이다.

```text
Tomcat started on port 8080
Started AngsamoErpApplication
```

브라우저 접속 주소:

```text
http://localhost:8080/
```

서버 종료는 실행 중인 터미널에서 `Ctrl + C`를 누른다.

PowerShell에서 설정한 `$env:` 값은 해당 터미널을 닫으면 사라진다. 새 터미널을 열 때 다시 설정해야 한다.

## 18. Spring Boot 시작 클래스

시작 클래스 위치:

```text
src/main/java/com/angsamo/erp/AngsamoErpApplication.java
```

기본 내용:

```java
package com.angsamo.erp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AngsamoErpApplication {

    public static void main(String[] args) {
        SpringApplication.run(AngsamoErpApplication.class, args);
    }
}
```

`@SpringBootApplication`은 `com.angsamo.erp` 아래의 Controller, Service, Mapper 설정 등을 탐색한다. 따라서 팀원 코드는 기본적으로 다음 패키지 아래에 작성한다.

```text
com.angsamo.erp
```

`ServletInitializer.java`는 WAR 파일을 외부 Tomcat에 배포할 때 사용하는 클래스이므로 삭제하지 않는다.

## 19. 기본 화면을 추가하는 방법

### 19.1 Controller 작성

예시 위치:

```text
src/main/java/com/angsamo/erp/common/HomeController.java
```

```java
package com.angsamo.erp.common;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("projectName", "앙사모 ERP");
        return "home";
    }
}
```

### 19.2 JSP 작성

Controller가 `home`을 반환하면 다음 파일을 사용한다.

```text
src/main/webapp/WEB-INF/views/home.jsp
```

JSP 기본 예시:

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${projectName}</title>
</head>
<body>
    <h1>${projectName}</h1>
</body>
</html>
```

### 19.3 CSS와 JavaScript 위치

현재 프로젝트의 공통 정적 파일 위치:

```text
src/main/webapp/resources/css/common.css
src/main/webapp/resources/js/common.js
```

JSP 연결 예시:

```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<script src="${pageContext.request.contextPath}/resources/js/common.js" defer></script>
```

## 20. MyBatis 기능을 추가하는 순서

한 기능은 다음 순서로 작성한다.

```text
domain 또는 dto
  → mapper 인터페이스
  → mapper XML
  → service
  → controller
  → JSP
```

예시 파일 위치:

```text
src/main/java/com/angsamo/erp/purchase/domain/PurchaseOrder.java
src/main/java/com/angsamo/erp/purchase/mapper/PurchaseOrderMapper.java
src/main/resources/mapper/purchase/PurchaseOrderMapper.xml
src/main/java/com/angsamo/erp/purchase/service/PurchaseOrderService.java
src/main/java/com/angsamo/erp/purchase/controller/PurchaseOrderController.java
src/main/webapp/WEB-INF/views/purchase/order-list.jsp
```

Mapper XML의 `namespace`는 Mapper 인터페이스의 전체 패키지명과 같아야 한다.

```xml
<mapper namespace="com.angsamo.erp.purchase.mapper.PurchaseOrderMapper">
</mapper>
```

## 21. VS Code에서 실행하는 세 가지 방법

### 방법 1: Maven 명령 사용 — 권장

```powershell
.\mvnw.cmd spring-boot:run
```

Java 확장의 클래스패스 상태와 관계없이 Maven 프로젝트 기준으로 실행되어 가장 확실하다.

### 방법 2: Java 시작 클래스에서 실행

`AngsamoErpApplication.java`를 열고 `Run`을 누른다. `JAVA PROJECTS`에 `erp`가 정상 표시될 때만 사용한다.

### 방법 3: Spring Boot Dashboard 사용

1. 왼쪽 Spring Boot Dashboard 아이콘 선택
2. `angsamo-erp` 확인
3. 실행 버튼 선택

DB 환경변수가 전달되지 않는 실행 방식에서는 접속 오류가 발생할 수 있으므로 처음에는 Maven 명령을 권장한다.

## 22. 자주 발생하는 오류

### 클래스패스 오류

```text
is not on the classpath
Cannot resolve the modulepaths/classpaths automatically
```

해결:

- `pom.xml`이 바로 있는 `angsamo` 폴더를 다시 연다.
- `Java: Clean Java Language Server Workspace`를 실행한다.
- `Maven: Reload Projects`를 실행한다.
- `Add to Source Path`를 누르거나 `launch.json`을 직접 만들지 않는다.

### MySQL 접속 거부

```text
Access denied for user
```

해결:

- `DB_USERNAME`, `DB_PASSWORD`를 확인한다.
- 비밀번호를 명령어나 Git 파일에 직접 기록하지 않는다.

### MySQL 연결 실패

```text
Communications link failure
```

해결:

- MySQL Server가 실행 중인지 확인한다.
- 포트가 `3306`인지 확인한다.
- `DB_URL`의 서버 주소와 DB 이름을 확인한다.

### 8080 포트 사용 중

```text
Port 8080 was already in use
```

기존 Spring Boot 실행 터미널에서 `Ctrl + C`로 서버를 종료한다. 임시로 다른 포트를 사용하려면 실행할 때 지정할 수 있다.

```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.arguments=--server.port=8081"
```

### Mapper를 찾지 못함

```text
No MyBatis mapper was found
```

아직 Mapper를 만들지 않은 초기 상태라면 안내 경고일 수 있다. Mapper를 만든 뒤에는 다음을 확인한다.

- Mapper 인터페이스 위치
- Mapper XML의 `namespace`
- XML 파일이 `src/main/resources/mapper` 아래에 있는지

## 23. GitHub에 올려도 되는 설정과 금지 파일

GitHub에 올려도 되는 파일:

```text
pom.xml
application.properties (환경변수 이름만 포함)
src/
database/angsamo_team_full.sql
docs/
.vscode/extensions.json
```

GitHub에 올리면 안 되는 내용:

```text
실제 DB 비밀번호
.env
application-local.properties
개인 인증서와 API 키
target/
```

비밀번호가 이미 GitHub에 올라갔다면 파일만 지우는 것으로 끝내지 않고 해당 비밀번호도 변경한다.

## 24. Spring Boot 설정 완료 확인표

- [ ] `pom.xml`이 바로 보이는 프로젝트 폴더를 열었다.
- [ ] VS Code Java 및 Spring Boot 확장을 설치했다.
- [ ] JDK 25를 프로젝트 Runtime으로 선택했다.
- [ ] `JAVA PROJECTS`에 `erp`가 표시된다.
- [ ] `Maven: Reload Projects`가 완료됐다.
- [ ] 개인 MySQL에 `angsamo` DB를 생성했다.
- [ ] `application.properties`에 실제 비밀번호가 없다.
- [ ] 터미널에 DB 환경변수를 설정했다.
- [ ] `.\mvnw.cmd test`가 `BUILD SUCCESS`로 끝난다.
- [ ] `.\mvnw.cmd spring-boot:run`이 정상 실행된다.
- [ ] `http://localhost:8080/`에 접속된다.
- [ ] 서버 종료 방법 `Ctrl + C`를 확인했다.
