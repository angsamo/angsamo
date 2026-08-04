-- 앙사모 ERP 게시판 테이블 추가 스크립트
-- 용도: 기존 angsamo DB에 최초 1회 실행

USE `angsamo`;
SET NAMES utf8mb4;

-- [엔터티: board] 관리자가 추가·수정할 수 있는 게시판 종류를 관리한다.
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
  CONSTRAINT `fk_board_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시판 엔터티: 게시판 종류와 사용 상태를 관리한다.';

-- [엔터티: board_department] 게시판별 부서의 읽기·쓰기 권한을 관리한다.
CREATE TABLE `board_department` (
  `board_id` bigint NOT NULL COMMENT '게시판 식별번호',
  `department_id` bigint NOT NULL COMMENT '접근 가능한 부서 식별번호',
  `can_read` tinyint(1) NOT NULL DEFAULT '1' COMMENT '게시글 조회 권한 여부',
  `can_write` tinyint(1) NOT NULL DEFAULT '0' COMMENT '게시글 작성 권한 여부',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
  PRIMARY KEY (`board_id`, `department_id`),
  KEY `idx_board_department_department` (`department_id`),
  CONSTRAINT `fk_board_department_board`
    FOREIGN KEY (`board_id`) REFERENCES `board` (`board_id`),
  CONSTRAINT `fk_board_department_department`
    FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `chk_board_department_permission`
    CHECK (`can_write` = 0 OR `can_read` = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시판 부서 권한 엔터티: 게시판별 부서의 조회·작성 권한을 관리한다.';

-- [엔터티: board_post] 각 게시판에 등록되는 공지와 일반 게시글을 관리한다.
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
  CONSTRAINT `fk_board_post_board`
    FOREIGN KEY (`board_id`) REFERENCES `board` (`board_id`),
  CONSTRAINT `fk_board_post_author`
    FOREIGN KEY (`author_id`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_board_post_view_count`
    CHECK (`view_count` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='게시글 엔터티: 게시판의 공지와 일반 게시글을 관리한다.';

