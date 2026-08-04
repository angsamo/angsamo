-- 앙사모 ERP 공통 코드값 적용 스크립트
-- 용도: 기존 angsamo DB에 최초 1회 실행

USE `angsamo`;
SET NAMES utf8mb4;

-- 부서 코드 초기 데이터
INSERT INTO `department` (`department_code`, `department_name`, `active`)
VALUES
  ('DEV', '개발부서', 1),
  ('PRODUCTION', '생산부서', 1),
  ('PURCHASE', '구매부서', 1),
  ('MATERIAL', '자재부서', 1)
ON DUPLICATE KEY UPDATE
  `department_name` = VALUES(`department_name`),
  `active` = VALUES(`active`);

-- 사용자 권한: ADMIN, MEMBER, VENDOR만 허용
ALTER TABLE `app_user`
  ADD CONSTRAINT `chk_app_user_role`
  CHECK (`role` IN ('ADMIN', 'MEMBER', 'VENDOR'));

-- 생산계획 상태 코드
ALTER TABLE `production_plan`
  ADD CONSTRAINT `chk_production_plan_status`
  CHECK (`status` IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELED'));

-- 생산요청 상태 코드
ALTER TABLE `production_request`
  ADD CONSTRAINT `chk_production_request_status`
  CHECK (`status` IN ('REQUESTED', 'PARTIAL', 'ISSUED', 'REJECTED', 'CANCELED'));

-- 견적요청 상태 코드
ALTER TABLE `quote_request`
  ADD CONSTRAINT `chk_quote_request_status`
  CHECK (`status` IN ('REQUESTED', 'CLOSED', 'CANCELED'));

-- purchase_order.po_status와 receiving.result는 CREATE TABLE의 ENUM으로 제한되어 있다.

