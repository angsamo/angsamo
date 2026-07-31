# 앙사모 ERP DB부터 화면까지 연계 설계

## 1. 문서 목적

이 문서는 데이터베이스 테이블이 Spring Boot 백엔드를 거쳐 부서별 화면에서 어떻게 사용되는지 정리한다.

```text
MySQL 테이블
    ↓ MyBatis Mapper
Service
    ↓
Controller
    ↓ Model
JSP 화면
    ↓ 사용자 입력
Controller → Service → Mapper → MySQL
```

각 팀원은 자기 화면을 만들기 전에 다음 세 가지를 확인한다.

1. 화면에서 사용할 테이블
2. 로그인 사용자가 실행할 수 있는 CRUD
3. 다른 부서와 연결되는 외래키

## 2. 공통 데이터 흐름

### 목록 조회

```text
사용자가 메뉴 선택
    → Controller가 로그인 사용자 확인
    → Service가 조회 권한 확인
    → Mapper가 부서·협력회사 조건으로 SELECT
    → Controller가 조회 결과를 Model에 저장
    → JSP가 표로 출력
```

### 등록

```text
사용자가 등록 화면 입력
    → Controller가 입력값 수신
    → Service가 입력값과 권한 검사
    → Mapper가 INSERT
    → 등록된 번호로 상세 화면 이동
```

### 수정

```text
사용자가 수정 버튼 선택
    → 로그인 부서와 데이터 담당 부서 확인
    → 권한이 있을 때만 UPDATE
    → 권한이 없으면 403 또는 접근 불가 화면
```

화면에서 버튼을 숨기는 것만으로는 안전하지 않다. Controller, Service, Mapper 조회 조건에서도 사용자의 부서 또는 협력회사 번호를 확인한다. 다른 부서의 원본 테이블은 직접 열람하지 않고 승인 워크플로우, 공유 대시보드용 조회, 자동 API 결과만 사용한다.

## 3. 공통 로그인·권한

### 사용하는 테이블

| 테이블 | 사용 목적 |
|---|---|
| `app_user` | 로그인 아이디, 비밀번호, 사용자명, 권한 |
| `department` | 내부 사용자의 소속 부서 |
| `vendor` | 협력회사 기본정보 |

### 로그인 후 세션에 저장할 값

```text
loginUser.userId
loginUser.userName
loginUser.departmentId
loginUser.departmentCode
loginUser.vendorId
loginUser.role
```

### 화면 표시 기준

| 사용자 | 표시 메뉴 |
|---|---|
| 관리자 | 모든 메뉴 |
| 개발부서 | 개발 메뉴와 허용된 조회 메뉴 |
| 생산부서 | 생산 메뉴와 품목·재고 조회 |
| 구매부서 | 구매 메뉴와 생산·재고 연계 조회 |
| 자재부서 | 자재 메뉴와 발주·출하 연계 조회 |
| 협력회사 | 자기 회사 견적·발주·출하 메뉴 |

### 권한 검사 위치

```text
JSP: 메뉴와 버튼 표시 여부
Controller/Service: URL 직접 접근과 변경 요청 차단
Mapper: department_id 또는 vendor_id 조회 조건
```

관리자는 전체 조회가 가능하지만 일반 업무 수정은 담당 부서 중심으로 제한한다.

### 기준 권한 코드

```text
MASTER               최고 관리자
DEPARTMENT_MANAGER   부서 관리자
WORKER               일반 업무자
SUPPLIER             외부 협력회사
```

### 부서 간 공식 연결 방식

| 방식 | 사용 예 |
|---|---|
| 승인 워크플로우 | 자재 지원·불출 요청과 승인 |
| 공유 대시보드 | 전달받은 부족 자재와 출고 결과 |
| 자동 인터페이스(API) | 입고 완료 시 발주 마감 가능 신호 |

## 4. 관리자 화면과 DB

### 전체 현황

| 화면 영역 | 사용하는 테이블 | 표시 내용 |
|---|---|---|
| 사용자 수 | `app_user` | 활성 사용자 수 |
| 부서 현황 | `department`, `app_user` | 부서별 인원 |
| 진행 생산 | `production_plan` | 진행 중 생산계획 |
| 구매 발주 | `purchase_order` | 상태별 발주 건수 |
| 입고 현황 | `receiving` | 정상·불량 입고 건수 |
| 협력회사 | `vendor` | 활성 협력회사 수 |

관리자 대시보드는 각 테이블의 CRUD를 직접 실행하는 화면이 아니라 집계 결과를 조회하는 화면이다.

### 사용자 관리

| 기능 | 테이블 작업 |
|---|---|
| 사용자 목록 | `app_user`와 `department` JOIN |
| 사용자 등록 | `app_user` INSERT |
| 사용자 수정 | `app_user` UPDATE |
| 사용 중지 | `app_user.active` UPDATE |
| 부서 배정 | `app_user.department_id` UPDATE |
| 협력회사 계정 배정 | `app_user.vendor_id` UPDATE |

### 부서 관리

| 기능 | 테이블 작업 |
|---|---|
| 부서 목록 | `department` SELECT |
| 부서 등록 | `department` INSERT |
| 부서 수정 | `department` UPDATE |
| 사용 중지 | `department.active` UPDATE |

### 협력회사 관리

| 기능 | 테이블 작업 |
|---|---|
| 협력회사 목록 | `vendor` SELECT |
| 협력회사 등록 | `vendor` INSERT |
| 담당 계정 생성 | `app_user` INSERT |
| 사용 중지 | `vendor.active` UPDATE |

## 5. 개발부서 화면과 DB

### 품목 관리

| 기능 | 사용하는 테이블 | DB 작업 |
|---|---|---|
| 품목 목록 | `item` | SELECT |
| 품목 상세 | `item` | SELECT |
| 품목 등록 | `item` | INSERT |
| 품목 수정 | `item` | UPDATE |
| 사용 중지 | `item.active` | UPDATE |

화면 주요 항목:

```text
품목코드, 품목명, 단위, 품목구분, 규격,
재질, 제작사양, 도면, 안전재고, 사용상태
```

### BOM 관리

| 기능 | 사용하는 테이블 | DB 작업 |
|---|---|---|
| 완제품 선택 | `item` | SELECT |
| 구성 자재 목록 | `bom`, `item` | JOIN SELECT |
| 구성 자재 추가 | `bom` | INSERT |
| 필요 수량 수정 | `bom` | UPDATE |
| 구성 자재 삭제 | `bom` | DELETE 또는 상태 변경 |

화면 표시 예시:

```text
완제품 A
├── 모터 / 1 EA
├── 프레임 / 2 EA
└── 볼트 / 4 EA
```

연결:

```text
bom.parent_item_code → 생산계획의 완제품
bom.component_item_code → 생산에 필요한 자재
```

## 6. 생산부서 화면과 DB

### 생산계획

| 기능 | 사용하는 테이블 | DB 작업 |
|---|---|---|
| 생산계획 목록 | `production_plan`, `item` | JOIN SELECT |
| 생산계획 등록 | `production_plan` | INSERT |
| 생산계획 수정 | `production_plan` | UPDATE |
| 진행 상태 변경 | `production_plan.status` | UPDATE |

화면 주요 항목:

```text
생산계획번호, 생산품목, 생산수량,
시작일, 완료예정일, 상태, 작성자
```

### 자재 소요량

사용 테이블:

```text
production_plan
    → bom
    → item
    → inventory
```

계산:

```text
필요 수량 = BOM 기준 수량 × 생산 수량
부족 수량 = 필요 수량 - 사용 가능 재고
```

화면 표시:

| 자재 | BOM 수량 | 생산수량 | 필요수량 | 현재고 | 부족수량 |
|---|---:|---:|---:|---:|---:|
| 모터 | 1 | 10 | 10 | 4 | 6 |
| 볼트 | 4 | 10 | 40 | 100 | 0 |

### 구매 요청

재고가 부족한 항목을 선택하면 다음 데이터가 `procurement_plan`에 저장된다.

```text
production_plan_id
item_code
required_qty
required_schedule
procurement_due
created_by
```

### 불출 요청

재고가 있는 항목은 `production_request`와 `issue`에 연결한다.

```text
production_plan
    → production_request
    → issue
```

생산부서가 요청하고 자재부서가 실제 출고 수량과 상태를 변경한다.

## 7. 구매부서 화면과 DB

### 조달계획

| 기능 | 사용하는 테이블 | DB 작업 |
|---|---|---|
| 부족 자재 목록 | `procurement_plan`, `production_plan`, `item` | JOIN SELECT |
| 조달계획 등록 | `procurement_plan` | INSERT |
| 일정·수량 수정 | `procurement_plan` | UPDATE |
| 완료 처리 | `is_completed` | UPDATE |

생산계획 번호를 함께 보여주어 어떤 생산 업무 때문에 구매하는지 확인한다.

### 견적 관리

```text
procurement_plan
    → quote_request
    → quote
    → vendor
```

| 화면 | 사용하는 테이블 | 처리 |
|---|---|---|
| 견적 요청 목록 | `quote_request`, `item` | 조회 |
| 견적 요청 등록 | `quote_request` | 등록 |
| 업체별 제출 견적 | `quote`, `vendor` | 비교 |
| 업체 선정 | `quote.quote_status` | 상태 변경 |

화면 비교 항목:

```text
협력회사, 공급가, 납기, 거래조건, 유효성, 제출일
```

### 계약 관리

```text
quote
    → contract
    → transaction_statement_prep
```

| 기능 | 사용하는 테이블 | 처리 |
|---|---|---|
| 거래조건 확정 | `quote` | 선정 견적과 협상 결과 확인 |
| 계약 등록 | `contract` | 계약 당사자·합의사항 저장 |
| 거래명세서 준비 | `transaction_statement_prep` | 계약 기준 정보 생성 |

### 구매 발주

선정된 견적 정보를 이용해 `purchase_order`를 등록한다.

```text
quote
    → purchase_order
    → vendor
```

화면 주요 항목:

```text
발주번호, 품목, 협력회사, 발주수량,
공급가, 요구납기일, 발주상태
```

### 진척 관리

```text
purchase_order
    → inspection
    → shipment
    → receiving
```

구매부서는 검사·제작·출하·입고 상태를 조회하지만 실제 입고 처리는 자재부서가 수행한다.

진척검수 화면에는 검수 차수, 예정일, 제작 진척, 납기 진도, 진도율, 보완사항을 표시한다. 검수 보완사항은 협력회사에 전달하며 협력회사가 처리 결과를 등록한다.

### 발주 마감과 현황 리포트

- 정상 입고 완료 신호가 있어야 발주를 마감한다.
- 상태는 `발주 예정 → 발주서 발행 → 조달 진행 중 → 마감 완료`를 기준으로 한다.
- 기간별 현황은 `purchase_order`, `shipment`, `receiving` 집계 조회로 제공한다.

## 8. 협력회사 화면과 DB

협력회사 쿼리에는 항상 로그인 사용자의 `vendor_id` 조건이 들어가야 한다.

```sql
WHERE vendor_id = #{loginVendorId}
```

### 견적 관리

| 기능 | 사용하는 테이블 | 처리 |
|---|---|---|
| 요청받은 견적 | `quote_request`, `quote`, `vendor` | 자기 회사 요청 조회 |
| 견적 제출 | `quote` | INSERT |
| 견적 수정 | `quote` | 마감 전 UPDATE |

### 발주 관리

| 기능 | 사용하는 테이블 | 처리 |
|---|---|---|
| 발주 목록 | `purchase_order` | 자기 회사 발주 조회 |
| 발주 확인 | `po_status` | UPDATE |
| 계약 확인 | `contract` | SELECT 또는 UPDATE |

### 제작·출하

| 기능 | 사용하는 테이블 | 처리 |
|---|---|---|
| 제작 상태 | `shipment.make_status` | UPDATE |
| 검사 진행 | `inspection` | 조회·결과 입력 |
| 출하 등록 | `shipment` | INSERT 또는 UPDATE |
| 거래명세서 | `transaction_statement` | 등록·조회 |

### 반품·재출하

```text
purchase_return
    → 협력회사 보완
    → shipment 재출하
    → purchase_return.reshipment_id 연결
```

협력회사는 자기 `vendor_id`와 일치하는 반품만 조회한다.

## 9. 자재부서 화면과 DB

### 입고 관리

```text
shipment
    → receiving
    → inventory
    → inventory_history
```

| 처리 | DB 변화 |
|---|---|
| 입고 예정 조회 | 출하 완료 `shipment` SELECT |
| 검수 등록 | `receiving` INSERT |
| 정상 수량 반영 | `inventory.available_qty` 증가 |
| 입고 이력 | `inventory_history` INSERT |
| 불량 발생 | `purchase_return` INSERT |

재고에는 `received_qty` 전체가 아니라 `accepted_qty`만 증가시킨다.

### 재고 관리

| 화면 정보 | 사용하는 컬럼 |
|---|---|
| 품목 | `inventory.item_code` |
| 현재고 | `available_qty` |
| 기준 수량 | `base_qty` |
| 안전재고 | `item.safety_stock` |
| 입출고 내역 | `inventory_history` |

### 출고 관리

```text
production_request
    → issue
    → inventory 감소
    → inventory_history 기록
```

출고 처리 시 한 트랜잭션에서 다음 작업을 함께 수행한다.

1. 현재고가 출고 수량 이상인지 확인
2. `issue.issue_qty`와 상태 변경
3. `inventory.available_qty` 감소
4. `inventory_history` 등록

중간에 오류가 발생하면 전체 작업을 취소해야 한다.

### 반품 관리

| 기능 | 사용하는 테이블 |
|---|---|
| 불량 입고 확인 | `receiving` |
| 반품 등록 | `purchase_return` |
| 협력회사 처리 조회 | `purchase_return.status` |
| 재출하 확인 | `shipment` |
| 재입고 검수 | `receiving` |

## 10. 다중 게시판 화면과 DB

게시판은 구매·발주 같은 업무 테이블과 분리된 공지·자료 공유 기능이다.

```text
board
    ├── board_department
    └── board_post
```

### 관리자 게시판 관리

| 기능 | 사용하는 테이블 |
|---|---|
| 게시판 목록 | `board` |
| 게시판 추가 | `board` INSERT |
| 접근 부서 지정 | `board_department` INSERT |
| 읽기·쓰기 권한 변경 | `board_department` UPDATE |
| 게시판 사용 중지 | `board.active` UPDATE |

새 게시판은 Java 파일이나 테이블을 새로 만들지 않고 `board`에 데이터만 추가한다.

### 게시판 목록

로그인 부서가 읽을 수 있는 게시판만 표시한다.

```text
app_user.department_id
    → board_department.department_id
    → board
```

### 게시글 목록·상세

```text
board
    → board_post
    → app_user 작성자
```

### 작성 버튼 표시

`board_department.can_write = 1`인 부서만 작성 버튼을 보여준다. 실제 등록 API에서도 같은 조건을 다시 검사한다.

### 권한 예시

| 게시판 | 부서 | 읽기 | 쓰기 |
|---|---|---:|---:|
| 전체 공지 | 모든 내부 부서 | 가능 | 관리자만 |
| 구매 게시판 | 구매부서 | 가능 | 가능 |
| 구매 게시판 | 생산부서 | 가능 | 불가 |
| 구매 게시판 | 개발부서 | 불가 | 불가 |

## 11. 화면별 테이블 요약

| 부서 | 화면 | 주요 테이블 |
|---|---|---|
| 관리자 | 전체 현황 | 모든 주요 업무 테이블 |
| 관리자 | 사용자 관리 | `app_user`, `department`, `vendor` |
| 개발 | 품목 관리 | `item` |
| 개발 | BOM 관리 | `bom`, `item` |
| 생산 | 생산계획 | `production_plan`, `item` |
| 생산 | 자재 소요량 | `production_plan`, `bom`, `inventory` |
| 생산 | 불출 요청 | `production_request`, `issue` |
| 구매 | 조달계획 | `procurement_plan`, `production_plan` |
| 구매 | 견적 관리 | `quote_request`, `quote`, `vendor` |
| 구매 | 계약 관리 | `contract`, `transaction_statement_prep` |
| 구매 | 구매 발주 | `purchase_order`, `vendor`, `item` |
| 구매 | 진척 관리 | `inspection`, `shipment`, `receiving` |
| 구매 | 발주 마감·리포트 | `purchase_order`, `receiving` |
| 협력회사 | 견적 제출 | `quote_request`, `quote` |
| 협력회사 | 제작·출하 | `purchase_order`, `shipment` |
| 협력회사 | 반품 보완 | `purchase_return`, `shipment` |
| 자재 | 입고 관리 | `shipment`, `receiving` |
| 자재 | 재고 관리 | `inventory`, `inventory_history` |
| 자재 | 출고 관리 | `production_request`, `issue` |
| 자재 | 반품 관리 | `receiving`, `purchase_return` |
| 공통 | 게시판 | `board`, `board_department`, `board_post` |

## 12. Spring Boot 파트별 기본 파일 구조

각 기능은 다음 정도로 구성한다.

```text
purchase
├── controller
│   └── PurchaseOrderController.java
├── service
│   └── PurchaseOrderService.java
├── mapper
│   └── PurchaseOrderMapper.java
├── dto
│   └── PurchaseOrder.java
└── resources/mapper
    └── PurchaseOrderMapper.xml
```

JSP:

```text
WEB-INF/views/purchase
├── order-list.jsp
├── order-detail.jsp
└── order-form.jsp
```

학생 프로젝트에서는 기능마다 불필요하게 인터페이스와 구현 클래스를 분리하지 않아도 된다. Controller, Service, Mapper, DTO, JSP 정도로 통일한다.

## 13. CRUD URL 규칙

팀원별 URL 충돌을 막기 위해 같은 규칙을 사용한다.

```text
GET  /items                 품목 목록
GET  /items/{id}            품목 상세
GET  /items/new             품목 등록 화면
POST /items                 품목 등록
GET  /items/{id}/edit       품목 수정 화면
POST /items/{id}/edit       품목 수정

GET  /purchase/orders       발주 목록
GET  /purchase/orders/{id}  발주 상세
POST /purchase/orders       발주 등록
```

부서별 경로 예시:

```text
/admin
/development
/production
/purchase
/material
/supplier
/boards
```

## 14. 구현 순서

DB와 화면을 다음 순서로 연결한다.

1. `department`, `app_user`, `vendor`로 로그인·권한 구현
2. `item`, `bom`으로 품목·BOM 화면 구현
3. `production_plan`으로 생산계획 구현
4. BOM과 재고로 자재 소요량 계산
5. 부족 자재를 `procurement_plan`으로 전달
6. `quote_request`, `quote`로 견적 진행
7. `purchase_order`로 발주
8. `shipment`, `receiving`으로 출하·입고
9. `inventory`, `inventory_history`로 재고 반영
10. `issue`로 생산 자재 출고
11. `purchase_return`으로 반품·재출하
12. 마지막에 관리자 대시보드와 게시판 연결

## 15. 통합기획서의 후속 확장 범위

스마트 안전 관리 통합기획서의 스마트 안전, 설비·자산, 인사·조직 기능은 현재 조달 ERP 1차 구현 범위에 포함하지 않는다. 이후 확장할 때도 같은 DB를 사용하되, 타 부서는 원본 데이터를 직접 열람하지 않고 승인 워크플로우, 공유 대시보드, 자동 API로 연결한다.

- 스마트 안전: 날씨 위험 예측, CCTV 안전모 감지, 조치 티켓
- 생산·공정 연계: 위험 경보에 따른 작업 지연·중지 신호
- 자재 연계: 보호구 지원 요청과 승인
- 설비·자산: 장비 이력과 정기점검
- 인사·조직: 조직도와 비상연락망

## 16. 최종 화면 연결 테스트

1. 관리자가 사용자와 협력회사를 등록한다.
2. 개발부서가 품목과 BOM을 등록한다.
3. 생산부서가 생산계획을 등록한다.
4. 화면에서 필요 수량과 부족 수량이 계산된다.
5. 구매부서가 부족 자재를 조달계획으로 가져온다.
6. 구매부서가 협력회사에 견적을 요청한다.
7. 협력회사가 자기 회사 계정으로 견적을 제출한다.
8. 구매부서가 업체를 선정하고 발주한다.
9. 협력회사가 제작 상태를 변경하고 출하한다.
10. 자재부서가 검수하고 정상 수량만 재고에 반영한다.
11. 생산부서가 불출을 요청하고 자재부서가 출고한다.
12. 입고 불량 건은 반품·재출하·재입고로 처리한다.
13. 게시판은 지정된 부서에서만 조회·작성한다.

이 시나리오가 끝까지 동작하면 DB, 백엔드, 화면과 부서 권한이 정상적으로 연결된 것이다.
