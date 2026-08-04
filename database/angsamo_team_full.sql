-- 앙사모 ERP 팀원용 전체 DB 생성 스크립트
-- 용도: 아무것도 없는 개인 MySQL에 최초 1회 실행
-- 주의: 기존 테이블을 삭제하지 않으므로 같은 DB에 재실행하면 이미 존재한다는 오류가 발생한다.

CREATE DATABASE IF NOT EXISTS `angsamo`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE `angsamo`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- [엔터티: app_user] 사용자 엔터티: 로그인 계정, 소속 부서, 협력업체 및 권한을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `app_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '사용자 식별번호',
  `login_id` varchar(50) NOT NULL COMMENT '로그인 아이디',
  `password` varchar(255) NOT NULL COMMENT '암호화된 비밀번호',
  `user_name` varchar(100) NOT NULL COMMENT '사용자 이름',
  `department_id` bigint DEFAULT NULL COMMENT '소속 부서 식별번호',
  `vendor_id` varchar(30) DEFAULT NULL COMMENT '협력업체 사용자 소속 업체 코드',
  `role` varchar(30) NOT NULL DEFAULT 'MEMBER' COMMENT '사용자 권한',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '사용 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_app_user_login_id` (`login_id`),
  KEY `fk_app_user_department` (`department_id`),
  KEY `fk_app_user_vendor` (`vendor_id`),
  CONSTRAINT `fk_app_user_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `fk_app_user_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`),
  CONSTRAINT `chk_app_user_role` CHECK (`role` IN ('ADMIN', 'MEMBER', 'VENDOR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='사용자 엔터티: 로그인 계정, 소속 부서, 협력업체 및 권한을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: bom] BOM 엔터티: 완제품과 구성 자재의 소요 수량을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `bom` (
  `bom_id` bigint NOT NULL AUTO_INCREMENT COMMENT 'BOM 식별번호',
  `parent_item_code` varchar(30) NOT NULL COMMENT '상위 완제품 품목코드',
  `component_item_code` varchar(30) NOT NULL COMMENT '구성 자재 품목코드',
  `required_qty` decimal(15,3) NOT NULL COMMENT '상위 품목 1개당 구성 자재 소요 수량',
  `unit` varchar(20) NOT NULL DEFAULT 'EA' COMMENT '수량 단위',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '사용 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`bom_id`),
  UNIQUE KEY `uq_bom_item_component` (`parent_item_code`,`component_item_code`),
  KEY `fk_bom_component_item` (`component_item_code`),
  CONSTRAINT `fk_bom_component_item` FOREIGN KEY (`component_item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_bom_parent_item` FOREIGN KEY (`parent_item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `chk_bom_required_qty` CHECK ((`required_qty` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='BOM 엔터티: 완제품과 구성 자재의 소요 수량을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: contract] 계약 엔터티: 선정 견적과 협력업체 간 계약 내용을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `contract` (
  `contract_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '계약 식별번호',
  `quote_id` bigint unsigned NOT NULL COMMENT '견적 식별번호',
  `vendor_id` varchar(30) NOT NULL COMMENT '계약 대상 협력업체 코드',
  `order_company_info` varchar(500) DEFAULT NULL COMMENT '발주회사 및 발주 정보',
  `agreed_terms` text COMMENT '계약 합의 조건',
  `is_registered` tinyint(1) NOT NULL DEFAULT '0' COMMENT '등록 완료 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`contract_id`),
  KEY `idx_contract_quote` (`quote_id`),
  KEY `idx_contract_vendor` (`vendor_id`),
  CONSTRAINT `fk_contract_quote` FOREIGN KEY (`quote_id`) REFERENCES `quote` (`quote_id`),
  CONSTRAINT `fk_contract_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='계약 엔터티: 선정 견적과 협력업체 간 계약 내용을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: department] 부서 엔터티: 시스템에서 사용하는 부서 기준 정보를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `department` (
  `department_id` bigint NOT NULL AUTO_INCREMENT COMMENT '소속 부서 식별번호',
  `department_code` varchar(30) NOT NULL COMMENT '부서 코드',
  `department_name` varchar(100) NOT NULL COMMENT '부서명',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '사용 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `uq_department_code` (`department_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='부서 엔터티: 시스템에서 사용하는 부서 기준 정보를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: inspection] 진척검사 엔터티: 구매 발주별 제작 진척과 납기 진행률을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `inspection` (
  `inspection_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '진척검사 식별번호',
  `po_id` bigint unsigned NOT NULL COMMENT '구매발주 식별번호',
  `inspection_seq` int DEFAULT NULL COMMENT '검사 차수',
  `scheduled_date` date DEFAULT NULL COMMENT '검사 예정일',
  `make_progress` varchar(100) DEFAULT NULL COMMENT '제작 진행 상태',
  `delivery_progress` varchar(100) DEFAULT NULL COMMENT '납기 진행 상태',
  `delivery_progress_rate` decimal(5,2) DEFAULT NULL COMMENT '납기 진행률',
  `supplement_note` text COMMENT '보완 요청 내용',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`inspection_id`),
  KEY `idx_inspection_po` (`po_id`),
  CONSTRAINT `fk_inspection_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='진척검사 엔터티: 구매 발주별 제작 진척과 납기 진행률을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: inventory] 재고 엔터티: 품목별 기준 재고, 가용 재고 및 재고 금액을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `inventory` (
  `item_code` varchar(30) NOT NULL COMMENT '재고 대상 품목 코드',
  `base_date` date DEFAULT NULL COMMENT '재고 기준일',
  `base_qty` int NOT NULL DEFAULT '0' COMMENT '기준 재고 수량',
  `available_qty` int NOT NULL DEFAULT '0' COMMENT '사용 가능한 재고 수량',
  `release_ready_status` varchar(100) DEFAULT NULL COMMENT '자재 불출 준비 상태',
  `calc_qty` int NOT NULL DEFAULT '0' COMMENT '계산된 현재 재고 수량',
  `stock_value` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '현재 재고 금액',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`item_code`),
  CONSTRAINT `fk_inventory_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='재고 엔터티: 품목별 기준 재고, 가용 재고 및 재고 금액을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: issue] 출고 엔터티: 생산 요청에 따라 자재를 불출·출고한 내역을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `issue` (
  `issue_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '자재 출고 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '출고 대상 품목 코드',
  `request_id` bigint unsigned DEFAULT NULL COMMENT '생산요청 식별번호',
  `release_qty` int DEFAULT NULL COMMENT '불출 수량',
  `issue_qty` int DEFAULT NULL COMMENT '출고 수량',
  `issued_at` datetime DEFAULT NULL COMMENT '출고 일시',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`issue_id`),
  KEY `idx_issue_item` (`item_code`),
  KEY `idx_issue_request` (`request_id`),
  CONSTRAINT `fk_issue_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_issue_request` FOREIGN KEY (`request_id`) REFERENCES `production_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='출고 엔터티: 생산 요청에 따라 자재를 불출·출고한 내역을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: item] 품목 엔터티: 자재와 제품의 코드, 명칭, 규격 및 제작 정보를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `item` (
  `item_code` varchar(30) NOT NULL COMMENT '품목 코드',
  `item_name` varchar(100) NOT NULL COMMENT '품목명',
  `spec` varchar(200) DEFAULT NULL COMMENT '품목 규격',
  `material` varchar(100) DEFAULT NULL COMMENT '품목 재질',
  `make_spec` varchar(200) DEFAULT NULL COMMENT '제작 사양',
  `drawing_ref` varchar(200) DEFAULT NULL COMMENT '도면 참조 정보',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='품목 엔터티: 자재와 제품의 코드, 명칭, 규격 및 제작 정보를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: procurement_plan] 조달계획 엔터티: 생산계획에 필요한 품목, 수량 및 조달 일정을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `procurement_plan` (
  `plan_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '조달계획 식별번호',
  `production_plan_id` bigint DEFAULT NULL COMMENT '생산계획 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '품목 코드',
  `process_needed` varchar(100) DEFAULT NULL COMMENT '자재가 필요한 공정',
  `required_schedule` date DEFAULT NULL COMMENT '자재 필요 일정',
  `required_qty` int DEFAULT NULL COMMENT '조달 필요 수량',
  `procurement_due` date DEFAULT NULL COMMENT '조달 납기일',
  `is_registered` tinyint(1) NOT NULL DEFAULT '0' COMMENT '등록 완료 여부',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '업무 완료 여부',
  `created_by` bigint DEFAULT NULL COMMENT '조달계획 등록 사용자 식별번호',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`plan_id`),
  KEY `idx_plan_item` (`item_code`),
  KEY `fk_procurement_plan_production` (`production_plan_id`),
  KEY `fk_procurement_plan_user` (`created_by`),
  CONSTRAINT `fk_plan_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_procurement_plan_production` FOREIGN KEY (`production_plan_id`) REFERENCES `production_plan` (`production_plan_id`),
  CONSTRAINT `fk_procurement_plan_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='조달계획 엔터티: 생산계획에 필요한 품목, 수량 및 조달 일정을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: production_plan] 생산계획 엔터티: 품목별 생산 수량과 시작일·완료예정일을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `production_plan` (
  `production_plan_id` bigint NOT NULL AUTO_INCREMENT COMMENT '생산계획 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '품목 코드',
  `production_qty` int NOT NULL COMMENT '생산 예정 수량',
  `start_date` date DEFAULT NULL COMMENT '생산 시작일',
  `due_date` date NOT NULL COMMENT '생산 완료 예정일',
  `status` varchar(30) NOT NULL DEFAULT 'PLANNED' COMMENT '생산계획 진행 상태',
  `created_by` bigint NOT NULL COMMENT '생산계획 등록 사용자 식별번호',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`production_plan_id`),
  KEY `fk_production_plan_item` (`item_code`),
  KEY `fk_production_plan_user` (`created_by`),
  CONSTRAINT `fk_production_plan_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_production_plan_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_production_plan_dates` CHECK (((`start_date` is null) or (`start_date` <= `due_date`))),
  CONSTRAINT `chk_production_plan_qty` CHECK ((`production_qty` > 0)),
  CONSTRAINT `chk_production_plan_status` CHECK (`status` IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='생산계획 엔터티: 품목별 생산 수량과 시작일·완료예정일을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: production_request] 생산요청 엔터티: 생산부서의 자재 소요 및 투입 요청을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `production_request` (
  `request_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '생산요청 식별번호',
  `production_plan_id` bigint DEFAULT NULL COMMENT '생산계획 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '품목 코드',
  `input_process` varchar(100) DEFAULT NULL COMMENT '자재 투입 공정',
  `required_qty` int DEFAULT NULL COMMENT '생산에 필요한 자재 수량',
  `schedule_date` date DEFAULT NULL COMMENT '자재 필요 예정일',
  `status` varchar(30) NOT NULL DEFAULT 'REQUESTED' COMMENT '생산요청 처리 상태',
  `requested_by` bigint DEFAULT NULL COMMENT '요청 사용자 식별번호',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`request_id`),
  KEY `idx_request_item` (`item_code`),
  KEY `fk_production_request_plan` (`production_plan_id`),
  KEY `fk_production_request_user` (`requested_by`),
  CONSTRAINT `fk_production_request_plan` FOREIGN KEY (`production_plan_id`) REFERENCES `production_plan` (`production_plan_id`),
  CONSTRAINT `fk_production_request_user` FOREIGN KEY (`requested_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `fk_request_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `chk_production_request_status` CHECK (`status` IN ('REQUESTED', 'PARTIAL', 'ISSUED', 'REJECTED', 'CANCELED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='생산요청 엔터티: 생산부서의 자재 소요 및 투입 요청을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: purchase_order] 구매발주 엔터티: 조달계획에 따른 협력업체 발주와 진행 상태를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `purchase_order` (
  `po_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '구매발주 식별번호',
  `plan_id` bigint unsigned NOT NULL COMMENT '조달계획 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '발주 대상 품목 코드',
  `vendor_id` varchar(30) NOT NULL COMMENT '발주 대상 협력업체 코드',
  `order_qty` int DEFAULT NULL COMMENT '발주 수량',
  `procurement_due` date DEFAULT NULL COMMENT '조달 납기일',
  `supply_price` decimal(15,2) DEFAULT NULL COMMENT '공급 가격',
  `po_status` enum('PLANNED','ORDERED','IN_PROGRESS','CLOSED') NOT NULL DEFAULT 'PLANNED' COMMENT '구매발주 진행 상태',
  `is_notified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '협력업체 통보 여부',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '발주 마감 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`po_id`),
  KEY `idx_po_plan` (`plan_id`),
  KEY `idx_po_item` (`item_code`),
  KEY `idx_po_vendor` (`vendor_id`),
  CONSTRAINT `fk_po_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_po_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_po_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='구매발주 엔터티: 조달계획에 따른 협력업체 발주와 진행 상태를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: quote] 견적 엔터티: 협력업체가 제출한 가격, 납기 및 거래 조건을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `quote` (
  `quote_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '견적 식별번호',
  `plan_id` bigint unsigned NOT NULL COMMENT '조달계획 식별번호',
  `vendor_id` varchar(30) NOT NULL COMMENT '견적 제출 협력업체 코드',
  `lead_time` varchar(50) DEFAULT NULL COMMENT '납품 소요 기간',
  `supply_price` decimal(15,2) DEFAULT NULL COMMENT '공급 가격',
  `trade_terms` varchar(500) DEFAULT NULL COMMENT '거래 조건',
  `validity_result` varchar(200) DEFAULT NULL COMMENT '견적 적정성 검토 결과',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`quote_id`),
  KEY `idx_quote_plan` (`plan_id`),
  KEY `idx_quote_vendor` (`vendor_id`),
  CONSTRAINT `fk_quote_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_quote_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='견적 엔터티: 협력업체가 제출한 가격, 납기 및 거래 조건을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: quote_request] 견적요청 엔터티: 조달계획별 견적 요청 수량과 제출 마감일을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `quote_request` (
  `quote_request_id` bigint NOT NULL AUTO_INCREMENT COMMENT '견적요청 식별번호',
  `plan_id` bigint unsigned NOT NULL COMMENT '조달계획 식별번호',
  `item_code` varchar(30) NOT NULL COMMENT '견적 요청 대상 품목 코드',
  `request_qty` int NOT NULL COMMENT '견적 요청 수량',
  `request_date` date NOT NULL COMMENT '견적 요청일',
  `deadline` date NOT NULL COMMENT '견적 제출 마감일',
  `status` varchar(30) NOT NULL DEFAULT 'REQUESTED' COMMENT '견적요청 진행 상태',
  `created_by` bigint NOT NULL COMMENT '견적요청 등록 사용자 식별번호',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`quote_request_id`),
  KEY `fk_quote_request_plan` (`plan_id`),
  KEY `fk_quote_request_item` (`item_code`),
  KEY `fk_quote_request_user` (`created_by`),
  CONSTRAINT `fk_quote_request_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_quote_request_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_quote_request_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_quote_request_dates` CHECK ((`request_date` <= `deadline`)),
  CONSTRAINT `chk_quote_request_qty` CHECK ((`request_qty` > 0)),
  CONSTRAINT `chk_quote_request_status` CHECK (`status` IN ('REQUESTED', 'CLOSED', 'CANCELED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='견적요청 엔터티: 조달계획별 견적 요청 수량과 제출 마감일을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: receiving] 입고검사 엔터티: 협력업체 출하품의 입고 수량과 검사 결과를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `receiving` (
  `receiving_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '입고검사 식별번호',
  `shipment_id` bigint unsigned NOT NULL COMMENT '출하 식별번호',
  `po_id` bigint unsigned NOT NULL COMMENT '구매발주 식별번호',
  `result` enum('ACCEPTED','RETURNED') NOT NULL COMMENT '입고검사 결과',
  `received_qty` int DEFAULT NULL COMMENT '입고 확인 수량',
  `inspected_at` datetime DEFAULT NULL COMMENT '입고검사 일시',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`receiving_id`),
  KEY `idx_receiving_shipment` (`shipment_id`),
  KEY `idx_receiving_po` (`po_id`),
  CONSTRAINT `fk_receiving_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`),
  CONSTRAINT `fk_receiving_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipment` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='입고검사 엔터티: 협력업체 출하품의 입고 수량과 검사 결과를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: shipment] 출하 엔터티: 구매 발주에 대한 협력업체의 출하 상태와 일시를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `shipment` (
  `shipment_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '출하 식별번호',
  `po_id` bigint unsigned NOT NULL COMMENT '구매발주 식별번호',
  `make_status` varchar(100) DEFAULT NULL COMMENT '제품 제작 상태',
  `on_time_flag` tinyint(1) DEFAULT NULL COMMENT '납기 준수 여부',
  `shipped_at` datetime DEFAULT NULL COMMENT '출하 일시',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`shipment_id`),
  KEY `idx_shipment_po` (`po_id`),
  CONSTRAINT `fk_shipment_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='출하 엔터티: 구매 발주에 대한 협력업체의 출하 상태와 일시를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: transaction_statement] 거래명세서 엔터티: 입고 확정 수량과 공급가액을 기준으로 발행 내역을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `transaction_statement` (
  `stmt_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '거래명세서 식별번호',
  `receiving_id` bigint unsigned NOT NULL COMMENT '입고검사 식별번호',
  `prep_id` bigint unsigned NOT NULL COMMENT '거래명세서 준비 식별번호',
  `vendor_id` varchar(30) NOT NULL COMMENT '거래 협력업체 코드',
  `qty` int DEFAULT NULL COMMENT '거래 수량',
  `supply_price` decimal(15,2) DEFAULT NULL COMMENT '공급 가격',
  `is_notified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '협력업체 통보 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`stmt_id`),
  KEY `idx_stmt_receiving` (`receiving_id`),
  KEY `idx_stmt_prep` (`prep_id`),
  KEY `idx_stmt_vendor` (`vendor_id`),
  CONSTRAINT `fk_stmt_prep` FOREIGN KEY (`prep_id`) REFERENCES `transaction_statement_prep` (`prep_id`),
  CONSTRAINT `fk_stmt_receiving` FOREIGN KEY (`receiving_id`) REFERENCES `receiving` (`receiving_id`),
  CONSTRAINT `fk_stmt_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='거래명세서 엔터티: 입고 확정 수량과 공급가액을 기준으로 발행 내역을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: transaction_statement_prep] 거래명세서 준비 엔터티: 계약을 바탕으로 명세서 발행 전 정보를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `transaction_statement_prep` (
  `prep_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '거래명세서 준비 식별번호',
  `contract_id` bigint unsigned NOT NULL COMMENT '계약 식별번호',
  `order_company_info` varchar(500) DEFAULT NULL COMMENT '발주회사 및 발주 정보',
  `vendor_info` varchar(200) DEFAULT NULL COMMENT '협력업체 정보',
  `agreed_terms` text COMMENT '계약 합의 조건',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`prep_id`),
  KEY `idx_prep_contract` (`contract_id`),
  CONSTRAINT `fk_prep_contract` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='거래명세서 준비 엔터티: 계약을 바탕으로 명세서 발행 전 정보를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: vendor] 협력업체 엔터티: 외주·납품 업체의 기본 정보를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `vendor` (
  `vendor_id` varchar(30) NOT NULL COMMENT '협력업체 코드',
  `vendor_name` varchar(100) NOT NULL COMMENT '협력업체명',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='협력업체 엔터티: 외주·납품 업체의 기본 정보를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: board] 관리자가 추가·수정할 수 있는 게시판 종류를 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `board` (
  `board_id` bigint NOT NULL AUTO_INCREMENT COMMENT '게시판 식별번호',
  `board_code` varchar(30) NOT NULL COMMENT 'URL과 프로그램에서 사용하는 게시판 코드',
  `board_name` varchar(100) NOT NULL COMMENT '화면에 표시할 게시판 이름',
  `description` varchar(500) DEFAULT NULL COMMENT '게시판 용도 설명',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '게시판 사용 여부',
  `created_by` bigint DEFAULT NULL COMMENT '게시판을 생성한 관리자 식별번호',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`board_id`),
  UNIQUE KEY `uq_board_code` (`board_code`),
  KEY `idx_board_created_by` (`created_by`),
  CONSTRAINT `fk_board_created_by` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시판 엔터티: 게시판 종류와 사용 상태를 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: board_department] 게시판별 부서의 읽기·쓰기 권한을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `board_department` (
  `board_id` bigint NOT NULL COMMENT '게시판 식별번호',
  `department_id` bigint NOT NULL COMMENT '접근 가능한 부서 식별번호',
  `can_read` tinyint(1) NOT NULL DEFAULT '1' COMMENT '게시글 조회 권한 여부',
  `can_write` tinyint(1) NOT NULL DEFAULT '0' COMMENT '게시글 작성 권한 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`board_id`, `department_id`),
  KEY `idx_board_department_department` (`department_id`),
  CONSTRAINT `fk_board_department_board` FOREIGN KEY (`board_id`) REFERENCES `board` (`board_id`),
  CONSTRAINT `fk_board_department_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `chk_board_department_permission` CHECK (`can_write` = 0 OR `can_read` = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시판 부서 권한 엔터티: 게시판별 부서의 조회·작성 권한을 관리한다.';

-- -----------------------------------------------------------------------------
-- [엔터티: board_post] 각 게시판에 등록되는 공지와 일반 게시글을 관리한다.
-- -----------------------------------------------------------------------------
CREATE TABLE `board_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '게시글 식별번호',
  `board_id` bigint NOT NULL COMMENT '게시판 식별번호',
  `title` varchar(200) NOT NULL COMMENT '게시글 제목',
  `content` text NOT NULL COMMENT '게시글 내용',
  `author_id` bigint NOT NULL COMMENT '작성 사용자 식별번호',
  `is_notice` tinyint(1) NOT NULL DEFAULT '0' COMMENT '공지글 여부',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '조회수',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '게시글 사용 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 수정 일시',
  PRIMARY KEY (`post_id`),
  KEY `idx_board_post_list` (`board_id`, `active`, `is_notice`, `created_at`),
  KEY `idx_board_post_author` (`author_id`),
  CONSTRAINT `fk_board_post_board` FOREIGN KEY (`board_id`) REFERENCES `board` (`board_id`),
  CONSTRAINT `fk_board_post_author` FOREIGN KEY (`author_id`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_board_post_view_count` CHECK (`view_count` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시글 엔터티: 게시판의 공지와 일반 게시글을 관리한다.';

-- 공통 부서 코드 초기 데이터
INSERT INTO `department` (`department_code`, `department_name`, `active`)
VALUES
  ('DEV', '개발부서', 1),
  ('PRODUCTION', '생산부서', 1),
  ('PURCHASE', '구매부서', 1),
  ('MATERIAL', '자재부서', 1);

SET FOREIGN_KEY_CHECKS = 1;

-- [뷰] 구매 발주 상태 조회
CREATE VIEW `v_po_status_report` AS
SELECT po.po_id, po.item_code, po.vendor_id, po.po_status,
       po.procurement_due, po.created_at AS order_date
FROM purchase_order po;

-- [뷰] 품목별 재고 수량 및 금액 조회
CREATE VIEW `v_inventory_value_report` AS
SELECT inv.item_code, it.item_name, inv.calc_qty,
       inv.stock_value, inv.updated_at
FROM inventory inv
JOIN item it ON it.item_code = inv.item_code;
