-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: mbc-sw.iptime.org    Database: angsamo
-- ------------------------------------------------------
-- Server version	8.0.43

-- 팀원 로컬 개발용 데이터베이스 초기화 스크립트
-- 각자 MySQL에서 이 파일 전체를 실행하면 angsamo DB와 모든 엔터티가 생성된다.
CREATE DATABASE IF NOT EXISTS `angsamo`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE `angsamo`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- -----------------------------------------------------------------------------
-- [엔터티: app_user] 사용자 엔터티: 로그인 계정, 소속 부서, 협력업체 및 권한을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `login_id` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `department_id` bigint DEFAULT NULL,
  `vendor_id` varchar(30) DEFAULT NULL,
  `role` varchar(30) NOT NULL DEFAULT 'MEMBER',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_app_user_login_id` (`login_id`),
  KEY `fk_app_user_department` (`department_id`),
  KEY `fk_app_user_vendor` (`vendor_id`),
  CONSTRAINT `fk_app_user_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`),
  CONSTRAINT `fk_app_user_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user`
--

LOCK TABLES `app_user` WRITE;
/*!40000 ALTER TABLE `app_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: bom] BOM 엔터티: 완제품과 구성 자재의 소요 수량을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `bom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bom` (
  `bom_id` bigint NOT NULL AUTO_INCREMENT,
  `parent_item_code` varchar(30) NOT NULL,
  `component_item_code` varchar(30) NOT NULL,
  `required_qty` decimal(15,3) NOT NULL,
  `unit` varchar(20) NOT NULL DEFAULT 'EA',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`bom_id`),
  UNIQUE KEY `uq_bom_item_component` (`parent_item_code`,`component_item_code`),
  KEY `fk_bom_component_item` (`component_item_code`),
  CONSTRAINT `fk_bom_component_item` FOREIGN KEY (`component_item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_bom_parent_item` FOREIGN KEY (`parent_item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `chk_bom_required_qty` CHECK ((`required_qty` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bom`
--

LOCK TABLES `bom` WRITE;
/*!40000 ALTER TABLE `bom` DISABLE KEYS */;
/*!40000 ALTER TABLE `bom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: contract] 계약 엔터티: 선정 견적과 협력업체 간 계약 내용을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract` (
  `contract_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` bigint unsigned NOT NULL,
  `vendor_id` varchar(30) NOT NULL,
  `order_company_info` varchar(500) DEFAULT NULL,
  `agreed_terms` text,
  `is_registered` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_id`),
  KEY `idx_contract_quote` (`quote_id`),
  KEY `idx_contract_vendor` (`vendor_id`),
  CONSTRAINT `fk_contract_quote` FOREIGN KEY (`quote_id`) REFERENCES `quote` (`quote_id`),
  CONSTRAINT `fk_contract_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: department] 부서 엔터티: 시스템에서 사용하는 부서 기준 정보를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` bigint NOT NULL AUTO_INCREMENT,
  `department_code` varchar(30) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `uq_department_code` (`department_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: inspection] 진척검사 엔터티: 구매 발주별 제작 진척과 납기 진행률을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `inspection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection` (
  `inspection_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id` bigint unsigned NOT NULL,
  `inspection_seq` int DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `make_progress` varchar(100) DEFAULT NULL,
  `delivery_progress` varchar(100) DEFAULT NULL,
  `delivery_progress_rate` decimal(5,2) DEFAULT NULL,
  `supplement_note` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inspection_id`),
  KEY `idx_inspection_po` (`po_id`),
  CONSTRAINT `fk_inspection_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspection`
--

LOCK TABLES `inspection` WRITE;
/*!40000 ALTER TABLE `inspection` DISABLE KEYS */;
/*!40000 ALTER TABLE `inspection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: inventory] 재고 엔터티: 품목별 기준 재고, 가용 재고 및 재고 금액을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `item_code` varchar(30) NOT NULL,
  `base_date` date DEFAULT NULL,
  `base_qty` int NOT NULL DEFAULT '0',
  `available_qty` int NOT NULL DEFAULT '0',
  `release_ready_status` varchar(100) DEFAULT NULL,
  `calc_qty` int NOT NULL DEFAULT '0',
  `stock_value` decimal(18,2) NOT NULL DEFAULT '0.00',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_code`),
  CONSTRAINT `fk_inventory_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: issue] 출고 엔터티: 생산 요청에 따라 자재를 불출·출고한 내역을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue` (
  `issue_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(30) NOT NULL,
  `request_id` bigint unsigned DEFAULT NULL,
  `release_qty` int DEFAULT NULL,
  `issue_qty` int DEFAULT NULL,
  `issued_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`issue_id`),
  KEY `idx_issue_item` (`item_code`),
  KEY `idx_issue_request` (`request_id`),
  CONSTRAINT `fk_issue_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_issue_request` FOREIGN KEY (`request_id`) REFERENCES `production_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue`
--

LOCK TABLES `issue` WRITE;
/*!40000 ALTER TABLE `issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: item] 품목 엔터티: 자재와 제품의 코드, 명칭, 규격 및 제작 정보를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `item_code` varchar(30) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `spec` varchar(200) DEFAULT NULL,
  `material` varchar(100) DEFAULT NULL,
  `make_spec` varchar(200) DEFAULT NULL,
  `drawing_ref` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: procurement_plan] 조달계획 엔터티: 생산계획에 필요한 품목, 수량 및 조달 일정을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `procurement_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procurement_plan` (
  `plan_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `production_plan_id` bigint DEFAULT NULL,
  `item_code` varchar(30) NOT NULL,
  `process_needed` varchar(100) DEFAULT NULL,
  `required_schedule` date DEFAULT NULL,
  `required_qty` int DEFAULT NULL,
  `procurement_due` date DEFAULT NULL,
  `is_registered` tinyint(1) NOT NULL DEFAULT '0',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`plan_id`),
  KEY `idx_plan_item` (`item_code`),
  KEY `fk_procurement_plan_production` (`production_plan_id`),
  KEY `fk_procurement_plan_user` (`created_by`),
  CONSTRAINT `fk_plan_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_procurement_plan_production` FOREIGN KEY (`production_plan_id`) REFERENCES `production_plan` (`production_plan_id`),
  CONSTRAINT `fk_procurement_plan_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procurement_plan`
--

LOCK TABLES `procurement_plan` WRITE;
/*!40000 ALTER TABLE `procurement_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `procurement_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: production_plan] 생산계획 엔터티: 품목별 생산 수량과 시작일·완료예정일을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `production_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_plan` (
  `production_plan_id` bigint NOT NULL AUTO_INCREMENT,
  `item_code` varchar(30) NOT NULL,
  `production_qty` int NOT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'PLANNED',
  `created_by` bigint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`production_plan_id`),
  KEY `fk_production_plan_item` (`item_code`),
  KEY `fk_production_plan_user` (`created_by`),
  CONSTRAINT `fk_production_plan_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_production_plan_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_production_plan_dates` CHECK (((`start_date` is null) or (`start_date` <= `due_date`))),
  CONSTRAINT `chk_production_plan_qty` CHECK ((`production_qty` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_plan`
--

LOCK TABLES `production_plan` WRITE;
/*!40000 ALTER TABLE `production_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `production_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: production_request] 생산요청 엔터티: 생산부서의 자재 소요 및 투입 요청을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `production_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_request` (
  `request_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `production_plan_id` bigint DEFAULT NULL,
  `item_code` varchar(30) NOT NULL,
  `input_process` varchar(100) DEFAULT NULL,
  `required_qty` int DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'REQUESTED',
  `requested_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `idx_request_item` (`item_code`),
  KEY `fk_production_request_plan` (`production_plan_id`),
  KEY `fk_production_request_user` (`requested_by`),
  CONSTRAINT `fk_production_request_plan` FOREIGN KEY (`production_plan_id`) REFERENCES `production_plan` (`production_plan_id`),
  CONSTRAINT `fk_production_request_user` FOREIGN KEY (`requested_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `fk_request_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_request`
--

LOCK TABLES `production_request` WRITE;
/*!40000 ALTER TABLE `production_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `production_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: purchase_order] 구매발주 엔터티: 조달계획에 따른 협력업체 발주와 진행 상태를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `po_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plan_id` bigint unsigned NOT NULL,
  `item_code` varchar(30) NOT NULL,
  `vendor_id` varchar(30) NOT NULL,
  `order_qty` int DEFAULT NULL,
  `procurement_due` date DEFAULT NULL,
  `supply_price` decimal(15,2) DEFAULT NULL,
  `po_status` enum('PLANNED','ORDERED','IN_PROGRESS','CLOSED') NOT NULL DEFAULT 'PLANNED',
  `is_notified` tinyint(1) NOT NULL DEFAULT '0',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`po_id`),
  KEY `idx_po_plan` (`plan_id`),
  KEY `idx_po_item` (`item_code`),
  KEY `idx_po_vendor` (`vendor_id`),
  CONSTRAINT `fk_po_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_po_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_po_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: quote] 견적 엔터티: 협력업체가 제출한 가격, 납기 및 거래 조건을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote` (
  `quote_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plan_id` bigint unsigned NOT NULL,
  `vendor_id` varchar(30) NOT NULL,
  `lead_time` varchar(50) DEFAULT NULL,
  `supply_price` decimal(15,2) DEFAULT NULL,
  `trade_terms` varchar(500) DEFAULT NULL,
  `validity_result` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`quote_id`),
  KEY `idx_quote_plan` (`plan_id`),
  KEY `idx_quote_vendor` (`vendor_id`),
  CONSTRAINT `fk_quote_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_quote_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote`
--

LOCK TABLES `quote` WRITE;
/*!40000 ALTER TABLE `quote` DISABLE KEYS */;
/*!40000 ALTER TABLE `quote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: quote_request] 견적요청 엔터티: 조달계획별 견적 요청 수량과 제출 마감일을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `quote_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_request` (
  `quote_request_id` bigint NOT NULL AUTO_INCREMENT,
  `plan_id` bigint unsigned NOT NULL,
  `item_code` varchar(30) NOT NULL,
  `request_qty` int NOT NULL,
  `request_date` date NOT NULL,
  `deadline` date NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'REQUESTED',
  `created_by` bigint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`quote_request_id`),
  KEY `fk_quote_request_plan` (`plan_id`),
  KEY `fk_quote_request_item` (`item_code`),
  KEY `fk_quote_request_user` (`created_by`),
  CONSTRAINT `fk_quote_request_item` FOREIGN KEY (`item_code`) REFERENCES `item` (`item_code`),
  CONSTRAINT `fk_quote_request_plan` FOREIGN KEY (`plan_id`) REFERENCES `procurement_plan` (`plan_id`),
  CONSTRAINT `fk_quote_request_user` FOREIGN KEY (`created_by`) REFERENCES `app_user` (`user_id`),
  CONSTRAINT `chk_quote_request_dates` CHECK ((`request_date` <= `deadline`)),
  CONSTRAINT `chk_quote_request_qty` CHECK ((`request_qty` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote_request`
--

LOCK TABLES `quote_request` WRITE;
/*!40000 ALTER TABLE `quote_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `quote_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: receiving] 입고검사 엔터티: 협력업체 출하품의 입고 수량과 검사 결과를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `receiving`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receiving` (
  `receiving_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint unsigned NOT NULL,
  `po_id` bigint unsigned NOT NULL,
  `result` enum('ACCEPTED','RETURNED') NOT NULL,
  `received_qty` int DEFAULT NULL,
  `inspected_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`receiving_id`),
  KEY `idx_receiving_shipment` (`shipment_id`),
  KEY `idx_receiving_po` (`po_id`),
  CONSTRAINT `fk_receiving_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`),
  CONSTRAINT `fk_receiving_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipment` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receiving`
--

LOCK TABLES `receiving` WRITE;
/*!40000 ALTER TABLE `receiving` DISABLE KEYS */;
/*!40000 ALTER TABLE `receiving` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: shipment] 출하 엔터티: 구매 발주에 대한 협력업체의 출하 상태와 일시를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `shipment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `po_id` bigint unsigned NOT NULL,
  `make_status` varchar(100) DEFAULT NULL,
  `on_time_flag` tinyint(1) DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`shipment_id`),
  KEY `idx_shipment_po` (`po_id`),
  CONSTRAINT `fk_shipment_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment`
--

LOCK TABLES `shipment` WRITE;
/*!40000 ALTER TABLE `shipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: transaction_statement] 거래명세서 엔터티: 입고 확정 수량과 공급가액을 기준으로 발행 내역을 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `transaction_statement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_statement` (
  `stmt_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `receiving_id` bigint unsigned NOT NULL,
  `prep_id` bigint unsigned NOT NULL,
  `vendor_id` varchar(30) NOT NULL,
  `qty` int DEFAULT NULL,
  `supply_price` decimal(15,2) DEFAULT NULL,
  `is_notified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`stmt_id`),
  KEY `idx_stmt_receiving` (`receiving_id`),
  KEY `idx_stmt_prep` (`prep_id`),
  KEY `idx_stmt_vendor` (`vendor_id`),
  CONSTRAINT `fk_stmt_prep` FOREIGN KEY (`prep_id`) REFERENCES `transaction_statement_prep` (`prep_id`),
  CONSTRAINT `fk_stmt_receiving` FOREIGN KEY (`receiving_id`) REFERENCES `receiving` (`receiving_id`),
  CONSTRAINT `fk_stmt_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_statement`
--

LOCK TABLES `transaction_statement` WRITE;
/*!40000 ALTER TABLE `transaction_statement` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_statement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- -----------------------------------------------------------------------------
-- [엔터티: transaction_statement_prep] 거래명세서 준비 엔터티: 계약을 바탕으로 명세서 발행 전 정보를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `transaction_statement_prep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_statement_prep` (
  `prep_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint unsigned NOT NULL,
  `order_company_info` varchar(500) DEFAULT NULL,
  `vendor_info` varchar(200) DEFAULT NULL,
  `agreed_terms` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`prep_id`),
  KEY `idx_prep_contract` (`contract_id`),
  CONSTRAINT `fk_prep_contract` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_statement_prep`
--

LOCK TABLES `transaction_statement_prep` WRITE;
/*!40000 ALTER TABLE `transaction_statement_prep` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_statement_prep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_inventory_value_report`
--

DROP TABLE IF EXISTS `v_inventory_value_report`;
/*!50001 DROP VIEW IF EXISTS `v_inventory_value_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_inventory_value_report` AS SELECT 
 1 AS `item_code`,
 1 AS `item_name`,
 1 AS `calc_qty`,
 1 AS `stock_value`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_po_status_report`
--

DROP TABLE IF EXISTS `v_po_status_report`;
/*!50001 DROP VIEW IF EXISTS `v_po_status_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_po_status_report` AS SELECT 
 1 AS `po_id`,
 1 AS `item_code`,
 1 AS `vendor_id`,
 1 AS `po_status`,
 1 AS `procurement_due`,
 1 AS `order_date`*/;
SET character_set_client = @saved_cs_client;

--
-- -----------------------------------------------------------------------------
-- [엔터티: vendor] 협력업체 엔터티: 외주·납품 업체의 기본 정보를 관리한다.
-- -----------------------------------------------------------------------------
--

DROP TABLE IF EXISTS `vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendor` (
  `vendor_id` varchar(30) NOT NULL,
  `vendor_name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendor`
--

LOCK TABLES `vendor` WRITE;
/*!40000 ALTER TABLE `vendor` DISABLE KEYS */;
/*!40000 ALTER TABLE `vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_inventory_value_report`
--

/*!50001 DROP VIEW IF EXISTS `v_inventory_value_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `v_inventory_value_report` AS select `inv`.`item_code` AS `item_code`,`it`.`item_name` AS `item_name`,`inv`.`calc_qty` AS `calc_qty`,`inv`.`stock_value` AS `stock_value`,`inv`.`updated_at` AS `updated_at` from (`inventory` `inv` join `item` `it` on((`it`.`item_code` = `inv`.`item_code`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_po_status_report`
--

/*!50001 DROP VIEW IF EXISTS `v_po_status_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY INVOKER */
/*!50001 VIEW `v_po_status_report` AS select `po`.`po_id` AS `po_id`,`po`.`item_code` AS `item_code`,`po`.`vendor_id` AS `vendor_id`,`po`.`po_status` AS `po_status`,`po`.`procurement_due` AS `procurement_due`,`po`.`created_at` AS `order_date` from `purchase_order` `po` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-03 11:05:40
