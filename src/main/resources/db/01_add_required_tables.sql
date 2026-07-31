-- 앙사모 ERP 추가 테이블 및 컬럼
-- 기준: ERP.mwb의 기존 14개 테이블이 먼저 생성되어 있어야 한다.
-- MySQL 8.x에서 새 데이터베이스에 한 번만 실행한다.

SET NAMES utf8mb4;

-- =========================================================
-- 1. 부서와 사용자
-- =========================================================

CREATE TABLE department (
    department_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(30) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_department_code UNIQUE (department_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE app_user (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    login_id VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    department_id BIGINT NULL,
    vendor_id VARCHAR(30) NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'WORKER',
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_app_user_login_id UNIQUE (login_id),
    CONSTRAINT fk_app_user_department
        FOREIGN KEY (department_id) REFERENCES department(department_id),
    CONSTRAINT fk_app_user_vendor
        FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 2. BOM과 생산계획
-- =========================================================

CREATE TABLE bom (
    bom_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_item_code VARCHAR(30) NOT NULL,
    component_item_code VARCHAR(30) NOT NULL,
    required_qty DECIMAL(15,3) NOT NULL,
    unit VARCHAR(20) NOT NULL DEFAULT 'EA',
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_bom_item_component
        UNIQUE (parent_item_code, component_item_code),
    CONSTRAINT chk_bom_required_qty
        CHECK (required_qty > 0),
    CONSTRAINT fk_bom_parent_item
        FOREIGN KEY (parent_item_code) REFERENCES item(item_code),
    CONSTRAINT fk_bom_component_item
        FOREIGN KEY (component_item_code) REFERENCES item(item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE production_plan (
    production_plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_code VARCHAR(30) NOT NULL,
    production_qty INT NOT NULL,
    start_date DATE NULL,
    due_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PLANNED',
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_production_plan_qty
        CHECK (production_qty > 0),
    CONSTRAINT chk_production_plan_dates
        CHECK (start_date IS NULL OR start_date <= due_date),
    CONSTRAINT fk_production_plan_item
        FOREIGN KEY (item_code) REFERENCES item(item_code),
    CONSTRAINT fk_production_plan_user
        FOREIGN KEY (created_by) REFERENCES app_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE production_request
    ADD COLUMN production_plan_id BIGINT NULL AFTER request_id,
    ADD COLUMN status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED'
        AFTER schedule_date,
    ADD COLUMN requested_by BIGINT NULL AFTER status,
    ADD CONSTRAINT fk_production_request_plan
        FOREIGN KEY (production_plan_id)
        REFERENCES production_plan(production_plan_id),
    ADD CONSTRAINT fk_production_request_user
        FOREIGN KEY (requested_by)
        REFERENCES app_user(user_id);

ALTER TABLE procurement_plan
    ADD COLUMN production_plan_id BIGINT NULL AFTER plan_id,
    ADD COLUMN created_by BIGINT NULL AFTER is_completed,
    ADD CONSTRAINT fk_procurement_plan_production
        FOREIGN KEY (production_plan_id)
        REFERENCES production_plan(production_plan_id),
    ADD CONSTRAINT fk_procurement_plan_user
        FOREIGN KEY (created_by)
        REFERENCES app_user(user_id);

-- =========================================================
-- 3. 견적 요청과 담당자
-- =========================================================

CREATE TABLE quote_request (
    quote_request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_id BIGINT NOT NULL,
    item_code VARCHAR(30) NOT NULL,
    request_qty INT NOT NULL,
    request_date DATE NOT NULL,
    deadline DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED',
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_quote_request_qty
        CHECK (request_qty > 0),
    CONSTRAINT chk_quote_request_dates
        CHECK (request_date <= deadline),
    CONSTRAINT fk_quote_request_plan
        FOREIGN KEY (plan_id) REFERENCES procurement_plan(plan_id),
    CONSTRAINT fk_quote_request_item
        FOREIGN KEY (item_code) REFERENCES item(item_code),
    CONSTRAINT fk_quote_request_user
        FOREIGN KEY (created_by) REFERENCES app_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE quote
    ADD COLUMN quote_request_id BIGINT NULL AFTER quote_id,
    ADD COLUMN quote_status VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED'
        AFTER validity_result,
    ADD COLUMN submitted_at DATETIME NULL AFTER quote_status,
    ADD CONSTRAINT fk_quote_request
        FOREIGN KEY (quote_request_id)
        REFERENCES quote_request(quote_request_id);

ALTER TABLE purchase_order
    ADD COLUMN ordered_at DATETIME NULL AFTER supply_price,
    ADD COLUMN created_by BIGINT NULL AFTER is_closed,
    ADD CONSTRAINT fk_purchase_order_user
        FOREIGN KEY (created_by)
        REFERENCES app_user(user_id);

-- =========================================================
-- 4. 출하·입고·출고 보완
-- =========================================================

ALTER TABLE shipment
    ADD COLUMN shipment_qty INT NULL AFTER make_status,
    ADD COLUMN expected_arrival_date DATE NULL AFTER shipped_at,
    ADD CONSTRAINT chk_shipment_qty
        CHECK (shipment_qty IS NULL OR shipment_qty > 0);

ALTER TABLE receiving
    ADD COLUMN accepted_qty INT NOT NULL DEFAULT 0 AFTER received_qty,
    ADD COLUMN rejected_qty INT NOT NULL DEFAULT 0 AFTER accepted_qty,
    ADD COLUMN rejection_reason VARCHAR(500) NULL AFTER rejected_qty,
    ADD COLUMN inspected_by BIGINT NULL AFTER inspected_at,
    ADD CONSTRAINT chk_receiving_qty
        CHECK (
            accepted_qty >= 0
            AND rejected_qty >= 0
            AND received_qty = accepted_qty + rejected_qty
        ),
    ADD CONSTRAINT fk_receiving_user
        FOREIGN KEY (inspected_by)
        REFERENCES app_user(user_id);

-- 기존 release_qty는 요청 수량으로 사용한다.
ALTER TABLE `issue`
    ADD COLUMN status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED'
        AFTER issue_qty,
    ADD COLUMN requested_by BIGINT NULL AFTER status,
    ADD COLUMN issued_by BIGINT NULL AFTER requested_by,
    ADD COLUMN requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        AFTER issued_by,
    ADD CONSTRAINT fk_issue_requested_user
        FOREIGN KEY (requested_by)
        REFERENCES app_user(user_id),
    ADD CONSTRAINT fk_issue_issued_user
        FOREIGN KEY (issued_by)
        REFERENCES app_user(user_id);

-- =========================================================
-- 5. 반품과 재고 이력
-- =========================================================

CREATE TABLE purchase_return (
    return_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receiving_id BIGINT NOT NULL,
    vendor_id VARCHAR(30) NOT NULL,
    item_code VARCHAR(30) NOT NULL,
    return_qty INT NOT NULL,
    return_reason VARCHAR(500) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED',
    requested_by BIGINT NOT NULL,
    requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reshipment_id BIGINT NULL,
    completed_at DATETIME NULL,
    CONSTRAINT chk_purchase_return_qty
        CHECK (return_qty > 0),
    CONSTRAINT fk_purchase_return_receiving
        FOREIGN KEY (receiving_id) REFERENCES receiving(receiving_id),
    CONSTRAINT fk_purchase_return_vendor
        FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
    CONSTRAINT fk_purchase_return_item
        FOREIGN KEY (item_code) REFERENCES item(item_code),
    CONSTRAINT fk_purchase_return_user
        FOREIGN KEY (requested_by) REFERENCES app_user(user_id),
    CONSTRAINT fk_purchase_return_reshipment
        FOREIGN KEY (reshipment_id) REFERENCES shipment(shipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE inventory_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_code VARCHAR(30) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    transaction_qty INT NOT NULL,
    quantity_before INT NOT NULL,
    quantity_after INT NOT NULL,
    reference_type VARCHAR(30) NOT NULL,
    reference_id BIGINT NOT NULL,
    processed_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_inventory_history_qty
        CHECK (
            transaction_qty > 0
            AND quantity_before >= 0
            AND quantity_after >= 0
        ),
    CONSTRAINT fk_inventory_history_item
        FOREIGN KEY (item_code) REFERENCES item(item_code),
    CONSTRAINT fk_inventory_history_user
        FOREIGN KEY (processed_by) REFERENCES app_user(user_id),
    INDEX idx_inventory_history_item_date (item_code, created_at),
    INDEX idx_inventory_history_reference (reference_type, reference_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 6. 품목과 협력회사 기본정보 보완
-- =========================================================

ALTER TABLE item
    ADD COLUMN unit VARCHAR(20) NOT NULL DEFAULT 'EA' AFTER item_name,
    ADD COLUMN item_type VARCHAR(30) NOT NULL DEFAULT 'MATERIAL' AFTER unit,
    ADD COLUMN safety_stock INT NOT NULL DEFAULT 0 AFTER drawing_ref,
    ADD COLUMN active TINYINT(1) NOT NULL DEFAULT 1 AFTER safety_stock,
    ADD CONSTRAINT chk_item_safety_stock
        CHECK (safety_stock >= 0);

ALTER TABLE vendor
    ADD COLUMN business_number VARCHAR(20) NULL AFTER vendor_name,
    ADD COLUMN contact_name VARCHAR(100) NULL AFTER business_number,
    ADD COLUMN phone VARCHAR(30) NULL AFTER contact_name,
    ADD COLUMN address VARCHAR(300) NULL AFTER phone,
    ADD COLUMN active TINYINT(1) NOT NULL DEFAULT 1 AFTER address,
    ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP AFTER created_at,
    ADD CONSTRAINT uq_vendor_business_number
        UNIQUE (business_number);

-- =========================================================
-- 7. 다중 게시판
-- =========================================================

CREATE TABLE board (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    board_code VARCHAR(50) NOT NULL,
    board_name VARCHAR(100) NOT NULL,
    board_type VARCHAR(20) NOT NULL DEFAULT 'GENERAL',
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_by BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_board_code UNIQUE (board_code),
    CONSTRAINT fk_board_user
        FOREIGN KEY (created_by) REFERENCES app_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE board_department (
    board_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    can_read TINYINT(1) NOT NULL DEFAULT 1,
    can_write TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (board_id, department_id),
    CONSTRAINT fk_board_department_board
        FOREIGN KEY (board_id) REFERENCES board(board_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_board_department_department
        FOREIGN KEY (department_id) REFERENCES department(department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE board_post (
    post_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    board_id BIGINT NOT NULL,
    writer_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    notice_flag TINYINT(1) NOT NULL DEFAULT 0,
    view_count INT NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_board_post_view_count
        CHECK (view_count >= 0),
    CONSTRAINT fk_board_post_board
        FOREIGN KEY (board_id) REFERENCES board(board_id),
    CONSTRAINT fk_board_post_writer
        FOREIGN KEY (writer_id) REFERENCES app_user(user_id),
    INDEX idx_board_post_list (board_id, active, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 8. 최초 공통 데이터
-- =========================================================

INSERT INTO department
    (department_code, department_name)
VALUES
    ('ADMIN', '관리자'),
    ('DEVELOPMENT', '개발부서'),
    ('PRODUCTION', '생산부서'),
    ('PURCHASE', '구매부서'),
    ('MATERIAL', '자재부서');

-- 게시판은 관리자 사용자가 생성된 후 created_by를 실제 user_id로 바꿔 실행한다.
-- INSERT INTO board
--     (board_code, board_name, board_type, created_by)
-- VALUES
--     ('NOTICE', '전체 공지사항', 'NOTICE', 1),
--     ('PURCHASE', '구매부서 게시판', 'GENERAL', 1);

-- 구매부서 게시판 권한 예시:
-- INSERT INTO board_department
--     (board_id, department_id, can_read, can_write)
-- SELECT b.board_id, d.department_id, 1, 1
-- FROM board b
-- JOIN department d ON d.department_code = 'PURCHASE'
-- WHERE b.board_code = 'PURCHASE';
