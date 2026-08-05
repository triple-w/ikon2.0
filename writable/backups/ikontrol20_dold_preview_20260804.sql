-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: ikontrol20_dold_preview
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ikontrol_activity_logs`
--

DROP TABLE IF EXISTS `ikontrol_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_activity_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `action` enum('created','updated','deleted','bitbucket_notification_received','github_notification_received') NOT NULL,
  `log_type` varchar(30) NOT NULL,
  `log_type_title` mediumtext NOT NULL,
  `log_type_id` int(11) NOT NULL DEFAULT 0,
  `changes` mediumtext DEFAULT NULL,
  `log_for` varchar(30) NOT NULL DEFAULT '0',
  `log_for_id` int(11) NOT NULL DEFAULT 0,
  `log_for2` varchar(30) DEFAULT NULL,
  `log_for_id2` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `log_for` (`log_for`,`log_for_id`),
  KEY `log_for2` (`log_for2`,`log_for_id2`),
  KEY `log_type` (`log_type`,`log_type_id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_activity_logs`
--

LOCK TABLES `ikontrol_activity_logs` WRITE;
/*!40000 ALTER TABLE `ikontrol_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_announcements`
--

DROP TABLE IF EXISTS `ikontrol_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` mediumtext NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `share_with` mediumtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `files` text NOT NULL,
  `read_by` mediumtext DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_announcements`
--

LOCK TABLES `ikontrol_announcements` WRITE;
/*!40000 ALTER TABLE `ikontrol_announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_app_schema_versions`
--

DROP TABLE IF EXISTS `ikontrol_app_schema_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_app_schema_versions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `applied_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_app_schema_versions`
--

LOCK TABLES `ikontrol_app_schema_versions` WRITE;
/*!40000 ALTER TABLE `ikontrol_app_schema_versions` DISABLE KEYS */;
INSERT INTO `ikontrol_app_schema_versions` VALUES (1,'rise-administrative-baseline-1','Verified baseline for the existing RISE administrative schema.','2026-08-04 11:58:41');
/*!40000 ALTER TABLE `ikontrol_app_schema_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_article_helpful_status`
--

DROP TABLE IF EXISTS `ikontrol_article_helpful_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_article_helpful_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `status` enum('yes','no') NOT NULL,
  `created_by` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_article_helpful_status`
--

LOCK TABLES `ikontrol_article_helpful_status` WRITE;
/*!40000 ALTER TABLE `ikontrol_article_helpful_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_article_helpful_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_attendance`
--

DROP TABLE IF EXISTS `ikontrol_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('incomplete','pending','approved','rejected','deleted') NOT NULL DEFAULT 'incomplete',
  `user_id` int(11) NOT NULL,
  `in_time` datetime NOT NULL,
  `out_time` datetime DEFAULT NULL,
  `checked_by` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `reject_reason` text DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `checked_by` (`checked_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_attendance`
--

LOCK TABLES `ikontrol_attendance` WRITE;
/*!40000 ALTER TABLE `ikontrol_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_automation_settings`
--

DROP TABLE IF EXISTS `ikontrol_automation_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_automation_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `matching_type` enum('match_any','match_all') NOT NULL,
  `event_name` text NOT NULL,
  `conditions` text NOT NULL,
  `actions` text NOT NULL,
  `related_to` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_automation_settings`
--

LOCK TABLES `ikontrol_automation_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_automation_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_automation_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_checklist_groups`
--

DROP TABLE IF EXISTS `ikontrol_checklist_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_checklist_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `checklists` mediumtext NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_checklist_groups`
--

LOCK TABLES `ikontrol_checklist_groups` WRITE;
/*!40000 ALTER TABLE `ikontrol_checklist_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_checklist_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_checklist_items`
--

DROP TABLE IF EXISTS `ikontrol_checklist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_checklist_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `is_checked` int(11) NOT NULL DEFAULT 0,
  `task_id` int(11) NOT NULL DEFAULT 0,
  `sort` double NOT NULL DEFAULT 1,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_checklist_items`
--

LOCK TABLES `ikontrol_checklist_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_checklist_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_checklist_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_checklist_template`
--

DROP TABLE IF EXISTS `ikontrol_checklist_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_checklist_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_checklist_template`
--

LOCK TABLES `ikontrol_checklist_template` WRITE;
/*!40000 ALTER TABLE `ikontrol_checklist_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_checklist_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_ci_sessions`
--

DROP TABLE IF EXISTS `ikontrol_ci_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_ci_sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `data` blob NOT NULL,
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_ci_sessions`
--

LOCK TABLES `ikontrol_ci_sessions` WRITE;
/*!40000 ALTER TABLE `ikontrol_ci_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_ci_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_client_groups`
--

DROP TABLE IF EXISTS `ikontrol_client_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_client_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_client_groups`
--

LOCK TABLES `ikontrol_client_groups` WRITE;
/*!40000 ALTER TABLE `ikontrol_client_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_client_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_client_wallet`
--

DROP TABLE IF EXISTS `ikontrol_client_wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_client_wallet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `payment_date` date NOT NULL,
  `note` text DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `created_by` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_client_wallet`
--

LOCK TABLES `ikontrol_client_wallet` WRITE;
/*!40000 ALTER TABLE `ikontrol_client_wallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_client_wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_clients`
--

DROP TABLE IF EXISTS `ikontrol_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(150) NOT NULL,
  `type` enum('organization','person') NOT NULL DEFAULT 'organization',
  `address` text DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `website` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `currency_symbol` varchar(20) DEFAULT NULL,
  `starred_by` mediumtext NOT NULL,
  `group_ids` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `is_lead` tinyint(1) NOT NULL DEFAULT 0,
  `lead_status_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `lead_source_id` int(11) NOT NULL,
  `last_lead_status` text NOT NULL,
  `client_migration_date` date DEFAULT NULL,
  `vat_number` text DEFAULT NULL,
  `gst_number` text DEFAULT NULL,
  `stripe_customer_id` text NOT NULL,
  `stripe_card_ending_digit` int(11) NOT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `disable_online_payment` tinyint(1) NOT NULL DEFAULT 0,
  `labels` text DEFAULT NULL,
  `managers` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `created_by` (`created_by`),
  KEY `lead_source_id` (`lead_source_id`),
  KEY `is_lead` (`is_lead`)
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_clients`
--

LOCK TABLES `ikontrol_clients` WRITE;
/*!40000 ALTER TABLE `ikontrol_clients` DISABLE KEYS */;
INSERT INTO `ikontrol_clients` VALUES (1,'Rial marketing , S.A de C.V','organization','19 x 20 y 22 #106 Col. Mexico Merida Yucatan','Merida','Yucatan','97125','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'RMA110113DF8',NULL,'',0,NULL,0,NULL,''),(2,'FINANCIERA BEPENSA','organization','56 B 452 Itzimna Merida Merida Yucatan','Merida','Yucatan','97100','México','2026-08-04 19:24:09',NULL,'982-2827',NULL,'','',0,0,0,0,1,0,0,'',NULL,'FBE930202QFA',NULL,'',0,NULL,0,NULL,''),(3,'UNIVERSIDAD DEL MAYAB','organization','KM 15.5 CARRET. MERIDA A PROGRESO KM2 CARRT A CHABLEKAL MERIDA MERIDA','MERIDA','MERIDA','97308','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'UMA870531DG9',NULL,'',0,NULL,0,NULL,''),(4,'COMERCIALIZADORA DE PILAS DEL SURESTE SA DE CV','organization','21  entre 16 y 18 91a YUCATAN MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97050','MEXICO','2026-08-04 19:24:09',NULL,'9991119279',NULL,'','',0,0,0,0,1,0,0,'',NULL,'CPS030331E56',NULL,'',0,NULL,0,NULL,''),(5,'DESTROYER MEXICANA DE TAMPICO SA DE CV','organization','BENITO JUAREZ 117 A SUR CENTRO TAMPICO TAMPICO TAMPICO','TAMPICO','TAMPICO','89000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'DMT8308307R4',NULL,'',0,NULL,0,NULL,''),(6,'SECRETARIA DE ADMINISTRACION Y FINANZAS','organization','59 S/N CENTRO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SHA840512SX1',NULL,'',0,NULL,0,NULL,''),(7,'INSTITUTO YUCATECO DE EMPRENDEDORES','organization','AV PRINCIPAL INDUSTRIAS NO CONTAMINANTES 13613 SODZIL NORTE SR MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97110','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'IIC991117V18',NULL,'',0,NULL,0,NULL,''),(8,'ARRIGUNAGA CANO SC','organization','Calle 29  por 34 y 36 #348 Fraccionamiento Montecarlo MERIDA YUCATAN','MERIDA','YUCATAN','97130','MEXICO','2026-08-04 19:24:09',NULL,'9991759330',NULL,'','',0,0,0,0,1,0,0,'',NULL,'ACA080812GZ0',NULL,'',0,NULL,0,NULL,''),(9,'SUM SHOP SAPI DE CV','organization','COLIMA 107 2 ROMA NORTE CD. DE MEXICO MEXICO','CD. DE MEXICO','MEXICO','06700','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SSH160210AP0',NULL,'',0,NULL,0,NULL,''),(10,'SOLDAI SAPI  DE CV','organization','VARSOVIA 44 1202 JUAREZ CUAUHTEMOC CUAUHTEMOC CIUDAD DE MEXICO','CUAUHTEMOC','CIUDAD DE MEXICO','06600','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SOL151021P60',NULL,'',0,NULL,0,NULL,''),(11,'GRUPO EDITORIAL DEL SURESTE SA DE CV','organization','CALLE 42 454 JESUS CARRANZA MERIDA YUCATAN','MERIDA','YUCATAN','97109','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GES090320UU3',NULL,'',0,NULL,0,NULL,''),(12,'CERAMICA Y MATERIALES CONTINENTAL  SAPI DE CV','organization','CALLE 11 122 SANTA GERTRUDIS COPO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97300','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMC970224II2',NULL,'',0,NULL,0,NULL,''),(13,'MARIA CRISTINA GAMBOA MOLINA','organization','CALLE 13 219 X 30 GARCIA GINERES MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97070','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GAMC921219965',NULL,'',0,NULL,0,NULL,''),(14,'QUINTATINTA S. DE R.L. DE C. V.','organization','CALLE 30,  ENTRE 17 Y 19 92 A LOCAL 3, MEXICO NORTE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97125','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'QUI160629CA8',NULL,'',0,NULL,0,NULL,''),(15,'IMPULSA Y APS EMPRESARIOS','organization','CALLE 20 X CALLE 21 96 LOC-7 MEXICO NORTE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97128','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'IAE160919NH8',NULL,'',0,NULL,0,NULL,''),(16,'IVAN JESUS QUIÑONES GONZALEZ','organization','CALLE 30, ENTRE 29 Y Esquina 122A DEPTO 4 MEXICO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97125','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'QUGI900928G99',NULL,'',0,NULL,0,NULL,''),(17,'VIANNEY DEL ROCIO LOPEZ REBOLLEDO','organization','CALLE 50 LOTE 2 . PLAYA NORTE CD DEL CARMEN CD DEL CARMEN CAMPECHE','CD DEL CARMEN','CAMPECHE','24120','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'LORV880624PZ2',NULL,'',0,NULL,0,NULL,''),(18,'FUNDACION PARQUE TECNOLOGICO ANAHUAC MAYAB, SC','organization','CARR PROGRESO CHABLEKAL K . / MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97302','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'FPT130410GG8',NULL,'',0,NULL,0,NULL,''),(19,'QUINTATINTA S. DE R.L. DE C.V.','organization','30 num 92 entre loc3 17-19 mexico norte MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97125','México','2026-08-04 19:24:09',NULL,'-',NULL,'','',0,0,0,0,1,0,0,'',NULL,'QUI160629CA8',NULL,'',0,NULL,0,NULL,''),(20,'GOVA COMUNICACIONES S.A. C.V.','organization','C. 12 NO. 335 . . CAMARA DE COMERCIO NORTE MÉRIDA MÉRIDA YUCATÁN','MÉRIDA','YUCATÁN','97133','México','2026-08-04 19:24:09',NULL,'-',NULL,'','',0,0,0,0,1,0,0,'',NULL,'GCO050824UQ4',NULL,'',0,NULL,0,NULL,''),(21,'ESENCIA MAYA S.A. DE C.V.','organization','C. 47 X 60 424 DEPTO. 4 CENTRO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97000','MEXICO','2026-08-04 19:24:09',NULL,'9230040',NULL,'','',0,0,0,0,1,0,0,'',NULL,'EMA150119IT9',NULL,'',0,NULL,0,NULL,''),(22,'CAMARA NACIONAL DE LA INDUSTRIA DEL CALZADO','organization','ALVARO OBREGON 250 ROMA CUAUHTEMOC CUAUHTEMOC CIUDAD DE MEXICO','CUAUHTEMOC','CIUDAD DE MEXICO','06700','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CNI420306BI0',NULL,'',0,NULL,0,NULL,''),(23,'GLADYS MARIA LUJAN CANTO','organization','59 842 8 LAS AMERICAS MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97302','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'LUCG4303229B7',NULL,'',0,NULL,0,NULL,''),(24,'CERN INMOBILIARIA','organization','LOMAS DEL VALLE 430 2-7 LOMAS DEL VALLE SAN PEDRO GARA CARGIA N.L NUEVO LEON NUEVO LEON','SAN PEDRO GARA CARGIA N.L','NUEVO LEON','66240','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CIN1710067L9',NULL,'',0,NULL,0,NULL,''),(25,'Fideicomiso F/4075','organization','Guillermo gonzalez camarena 1200 Piso 10 Santa Fe Alvaro Obregon Alvaro Obregon Ciudad de México','Alvaro Obregon','Ciudad de México','01210','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'FFX190926AL1',NULL,'',0,NULL,0,NULL,''),(26,'Inmoyuca peninsular S.A de C.V','organization','21 125 A Col Mex Merida Yucatan Yucatan','Merida','Yucatan','97125','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'IPE140806TB5',NULL,'',0,NULL,0,NULL,''),(27,'LESSMOREGROUP CONSULTORIA DE DISEÑO','organization','1 G 310 CAMPESTRE MERIDA YUCATAN YUCATAN','MERIDA','YUCATAN','97120','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'LCD180511FI0',NULL,'',0,NULL,0,NULL,''),(28,'Valeria Arellano Delgado','organization','Siracusa 133 Mediterraneo Celaya Guanajuato','Celaya','Guanajuato','38050','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AEDV881025982',NULL,'',0,NULL,0,NULL,''),(29,'TP ORTHODONTICS MEXICO S DE RL DE CV','organization','INSURGENTES SUR 1809 PISO 8 GUADALUPE INN BENITO JUAREZ Ciudad de México','BENITO JUAREZ','Ciudad de México','01020','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TOM950524U51',NULL,'',0,NULL,0,NULL,''),(30,'COMPAÑIA FERNANDEZ DE MERIDA, S,A DE C.V','organization','70 535-A CENTRO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'FME860201IT5',NULL,'',0,NULL,0,NULL,''),(31,'C MARINE SAPI DE CV','organization','Blvd. Kukulkan Km 3.5 Mz. 30 Lote D-9-7 Ed Zona Hotelera, Cancún Q. Roo','Cancún','Q. Roo','77500','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMA140627651',NULL,'',0,NULL,0,NULL,''),(32,'Cámara de la industria del calzado del Estado de Guanajuato','organization','Blvd. Adolfo Lopez Mateos 3401 OTE Fracc. Julián de Obregón Leon Guanajuato Guanajuato','Leon','Guanajuato','37290','mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CIC6910143B5',NULL,'',0,NULL,0,NULL,''),(33,'POLIMERIDA SA DE CV','organization','KM 8 CARRETERA UMAN AMPLIACION CD INDUSTRIAL MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97390','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'POL900418IF3',NULL,'',0,NULL,0,NULL,''),(34,'Cree Ama y Espera AC','organization','Calle 7A-1 325 12 Sta. Gertrudis Copó Merida Yucatan','Merida','Yucatan','97305','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CAE1203229T0',NULL,'',0,NULL,0,NULL,''),(35,'EXPERIENCIAS XCARET PARQUES','organization','CARRET CHETUMAL PUERTO JUAREZ KILOMETRO 282 INTERIOR B RANCHO XCARET SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OTC080114C30',NULL,'',0,NULL,0,NULL,''),(36,'AVENTURAS MAYAS SA DE CV','organization','CARRET FEDERAL PYA DEL CARMEN TULUM KM 2.5 PARCEL 17 MZA 337 LO PARCEL 17 MZA 337 LOTE 027 PLAYA DEL CARMEN Q.ROO','PLAYA DEL CARMEN','Q.ROO','77712','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AMA030617SN8',NULL,'',0,NULL,0,NULL,''),(37,'PRODUCCIONES TRAMANDO LAB','organization','SAN FRANCISCO 226 103 DEL VALLE BENITO JUAREZ BENITO JUAREZ CIUDAD DE MEXICO','BENITO JUAREZ','CIUDAD DE MEXICO','03100','MEXICO','2026-08-04 19:24:09',NULL,'55 2521 8891',NULL,'','',0,0,0,0,1,0,0,'',NULL,'PTL170410UC7',NULL,'',0,NULL,0,NULL,''),(38,'SERVICIOS TURISTICOS COSTA TURQUESA, S.A DE C.V','organization','DE ACCESO L28 MANZANA 16 L37 EDIFICIO C LOCAL S SM 309 CANCUN BENITO JUAREZ QUINTANA ROO','CANCUN BENITO JUAREZ','QUINTANA ROO','77560','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'STC861023CMA',NULL,'',0,NULL,0,NULL,''),(39,'FB DISTRIBUCIONES','organization','LUIS DONALDO COLOSIO MANZANA 4 LOTE 5 BODEGA 519 SM 301 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77560','MEXICO','2026-08-04 19:24:09',NULL,'9981112267',NULL,'','',0,0,0,0,1,0,0,'',NULL,'FDI1502063M0',NULL,'',0,NULL,0,NULL,''),(40,'C MARINE SAPI DE CV','organization','Blvd. Kukulkan Km 3.5 Mz. 30 Lote D-9-7 Edificio 1 Local PB Zona Hotelera CANCUN BENITO JUAREZ CANCUN QUINTANA ROO','CANCUN BENITO JUAREZ','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,'9987043717',NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMA140627651',NULL,'',0,NULL,0,NULL,''),(41,'Mosquitos Hospitality Group S. de R.L de C.V','organization','Av. Paseo de Reforma 2620 Piso 16 Lomas Altas Cuidad de México Cuidad de México Cuidad de México','Cuidad de México','Cuidad de México','11950','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MHG121130EK5',NULL,'',0,NULL,0,NULL,''),(42,'AQUI TODO ES DIVERSION, SA DE CV','organization','MONTE ARABI 262 SANTA FE LEON LEON GUANAJUATO','LEON','GUANAJUATO','37299','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ATE1608256AA',NULL,'',0,NULL,0,NULL,''),(43,'GRUPO POLE','organization','KM 282 CARRETERA CHETUMAL PTO JUAREZ SN LOC A RANCHO XCARET SOLIDARIDAD QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GPO040428SE8',NULL,'',0,NULL,0,NULL,''),(44,'SOCIEDAD DE ERGONOMISTAS DE MEXICO','organization','SAN ANTONIO 4370 425 PISO 4 PARTIDO IGLESIAS JUAREZ CD JUAREZ CHIHUAHUA','JUAREZ','CHIHUAHUA','32618','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'EME0001285E0',NULL,'',0,NULL,0,NULL,''),(45,'CORPORATIVO DE SERVICIOS TURISTICOS AMIGO','organization','6 508 C 1 GARCIA GINERES MERIDA YUCATAN','MERIDA','YUCATAN','97070','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CST1402219G5',NULL,'',0,NULL,0,NULL,''),(46,'Logística de Comercio Internacional S.A. de C.V.','organization','Pablo Livas 2540 9 y 10 Mirador de la Silla Guadalupe Nuevo León','Guadalupe','Nuevo León','67176','México','2026-08-04 19:24:09',NULL,'(81) 8479-8731',NULL,'','',0,0,0,0,1,0,0,'',NULL,'LCI071009UX4',NULL,'',0,NULL,0,NULL,''),(47,'SUEÑOS DE ANGEL','organization','tablaje 31041 Conkal Conkal Yucatan','Conkal','Yucatan','97345','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SAN060614SQ4',NULL,'',0,NULL,0,NULL,''),(48,'PUBLICO GENERAL','organization','S/N S/N S/N N/A N/A N/A','N/A',NULL,'97130',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XAXX010101000',NULL,'',0,NULL,0,NULL,''),(49,'CARETAS REV','organization','CERILLERA 43 CENTRO JIUTEPEC JIUTEPEC JIUTEPEC MORELOS','JIUTEPEC','MORELOS','62550','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CRE7712179M5',NULL,'',0,NULL,0,NULL,''),(50,'20 NUDOS','organization','44 423 MERIDA CENTRO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'VNU1605041J1',NULL,'',0,NULL,0,NULL,''),(51,'OCEAN TOURS PLAYA','organization','55 PONIENTE X 18 NORTE MANZANA 168 LOTE 006 EJIDO NORTE SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712','MÉXICO','2026-08-04 19:24:09',NULL,'984 2061444',NULL,'','',0,0,0,0,1,0,0,'',NULL,'OTP110225PK3',NULL,'',0,NULL,0,NULL,''),(52,'CARLOS REYNALDO ALDANA HERRERA','organization','23 126 CHOCHOLA CHOCHOLA CHOCHOLA YUCATAN','CHOCHOLA','YUCATAN','97816','MÉXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AAHC690729U64',NULL,'',0,NULL,0,NULL,''),(53,'XERVIGAS','organization','CARRETERA CHETUMAL PUERTO JUAREZ KILOMETRO 282 RANCHO XCARET SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XER170125R18',NULL,'',0,NULL,0,NULL,''),(54,'ANGEL ARTURO MAXIMILIANO','organization','ALTAMIRANO 17 CENTRO XALAPA XALAPA VERACRUZ DE IGNACIO DE LA LLAVE','XALAPA','VERACRUZ DE IGNACIO DE LA LLAVE','91000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'VEGA781012N61',NULL,'',0,NULL,0,NULL,''),(55,'MARIEL LAVALLE ALONZO','organization','CALLE 1H 192 MEXICO NORTE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97128','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'LAAM9101286G3',NULL,'',0,NULL,0,NULL,''),(56,'PIAPRODUCCIONES','organization','16 332 EMILIANO ZAPATA OTE MERIDA YUCATAN','MERIDA','YUCATAN','97144','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PIA1308285X1',NULL,'',0,NULL,0,NULL,''),(57,'CENTRO INMOBILIARIO DEL BAJIO','organization','5 DE MAYO 75 S/N CENTRO QUERETARO QUERETARO','QUERETARO','QUERETARO','76000','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CIB920312FS2',NULL,'',0,NULL,0,NULL,''),(58,'INOVACREATIVA','organization','SABINO DELGADO S/N ZAPOPA CENTRO ZAPOPAN ZAPOPAN JALISCO','ZAPOPAN','JALISCO','45100','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'INO130128JF7',NULL,'',0,NULL,0,NULL,''),(59,'DESARROLLOS AMARILLOS DE LA PENINSULA','organization','24 356 1,2,3,4,A,B,C,D Altabrisa Merida OTRA NO ESPECIFICADA EN EL CATALOGO Yucatan','Merida','Yucatan','97130','Mexico','2026-08-04 19:24:09',NULL,'9992625557',NULL,'','',0,0,0,0,1,0,0,'',NULL,'DAP170822SE1',NULL,'',0,NULL,0,NULL,''),(60,'SPAR TODOPROMO','organization','Avenida Insurgentes sur y Calle Jose Ma. Ibarran 101 ´Planta Baja SAN JOSE INSURGENTES BENITO JUAREZ CIUDAD DE MEXICO','BENITO JUAREZ','CIUDAD DE MEXICO','03900','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'STO110826RS0',NULL,'',0,NULL,0,NULL,''),(61,'MARINA PEREA GONZALEZ','organization','LAUREL Y ALTAR DE SAN PABLO 218 A SAN JOSE EN ALTO LEON GUANAJUATO','LEON','GUANAJUATO','37545','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PEGM591214V78',NULL,'',0,NULL,0,NULL,''),(62,'AB&C LEASING DE MEXICO','organization','11 Y 13 452 ITZIMNA MERIDA MERIDA Yucatan','MERIDA','Yucatan','97100','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ALM9910114D6',NULL,'',0,NULL,0,NULL,''),(63,'MULTISUR','organization','CALLE 75 ENTRE CALLE 72 147 CENTRO PROGRESO PROGRESO YUCATAN','PROGRESO','YUCATAN','97320','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MUL8508057S7',NULL,'',0,NULL,0,NULL,''),(64,'RIO SECRETO','organization','EJIDO SUR SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'RSE0811123T6',NULL,'',0,NULL,0,NULL,''),(65,'GRADYREC DE MEXICO','organization','20 89-B ITZIMNA MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97100','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GME201228743',NULL,'',0,NULL,0,NULL,''),(66,'VALENTIN TRAVEL MEXICO','organization','KM 311-500 PA PLAYA DEL SECRETO SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'VTM181204M49',NULL,'',0,NULL,0,NULL,''),(67,'OPESA OPERADORA DE PROYECTOS ESPECIALES','organization','TLACOPAC 6 CAMPESTRE ALVARO OBREGON ALVARO OBREGON CIUDAD DE MEXICO','ALVARO OBREGON','CIUDAD DE MEXICO','01040','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OOP230428NM3',NULL,'',0,NULL,0,NULL,''),(68,'CURIA DE MEXICO','organization','28 401 MERCED GOMEZ ALVARO OBREGON ALVARO OBREGON CIUDAD DE MEXICO','ALVARO OBREGON','CIUDAD DE MEXICO','01600','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CME210922CA5',NULL,'',0,NULL,0,NULL,''),(69,'DESTINO XCARET','organization','CARR CHE PTO JUARZ KM 282 RANCHO XCARET SOLIDARIDAD QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'DXC9912292N7',NULL,'',0,NULL,0,NULL,''),(70,'EXPERIENCIAS XCARET HOTELES','organization','CARRETERA FEDERAL CHETUMAL PUERTO JUAREZ KILOMETRO 282 L T 023 2 RANCHO XCARET SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'EXH160510UW8',NULL,'',0,NULL,0,NULL,''),(71,'AARON DIAZ LOPEZ','organization','CALLE 17 Colonia Mexico MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97125','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'DILA760201TE7',NULL,'',0,NULL,0,NULL,''),(72,'GUNTER VILLA URBINA','organization','CALLE SN LA VENTANA LA VENTANA LA PAZ BAJA CALIFORNIA SUR','LA VENTANA','BAJA CALIFORNIA SUR','23232','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'VIUG740608D82',NULL,'',0,NULL,0,NULL,''),(73,'LUIS GERARDO COSGAYA SOSA','organization','CALLE 645 HOGARES CAUCEL MERIDA CAUCEL YUCATAN','MERIDA','YUCATAN','97314','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'COSL980112VB9',NULL,'',0,NULL,0,NULL,''),(74,'INVESTIGACIONES Y ESTUDIOS SUPERIORES','organization','AVENIDA UNIVERSIDAD ANAHUAC 46 LOMAS ANAHUAC HUIXQUILUCAN MEXICO','HUIXQUILUCAN','MEXICO','52786','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'IES870531FU5',NULL,'',0,NULL,0,NULL,''),(75,'XCUMPICH TRAVEL','organization','20-A 297 SUITE101 X-CUMPICH MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97204','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XTR150821KR1',NULL,'',0,NULL,0,NULL,''),(76,'MARIA EUGENIA MEDINA RINCON','organization','CALLE 29 261-A SANTA MARIA CHUBURNA MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97138','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MERE581009AS2',NULL,'',0,NULL,0,NULL,''),(77,'UNITED PARCEL SERVICE DE MEXICO','organization','EUGENIA 189 NARVARTE ORIENTE BENITO JUAREZ CIUDAD DE MEXICO','BENITO JUAREZ','CIUDAD DE MEXICO','03020','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'UPS891122HV8',NULL,'',0,NULL,0,NULL,''),(78,'SCUBA CHIPOTLE','organization','10 NORTE MANZANA 100 LOTE 01 CENTRO SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SCI1708074W4',NULL,'',0,NULL,0,NULL,''),(79,'SCUBA PLAYA','organization','CALLE 10 NORTE MZA 21 LOTE 8 LOCAL 9 CENTRO SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SPL090616B95',NULL,'',0,NULL,0,NULL,''),(80,'TODO PREFABRICADOS 5','organization','46 8 SN SUPERMANZANA 91 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77516','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TPC1902211T2',NULL,'',0,NULL,0,NULL,''),(81,'MEGA TRAVEL OPERADORA','organization','TRINIDAD 7 LAS AMERICAS NAUCALPAN NAUCALPAN DE JUAREZ ESTADO DE MEXICO','NAUCALPAN','ESTADO DE MEXICO','53040','MEXICO','2026-08-04 19:24:09',NULL,'9993492736',NULL,'','',0,0,0,0,1,0,0,'',NULL,'MTO171211CN7',NULL,'',0,NULL,0,NULL,''),(82,'TODO PREFABRICADOS 5','organization','Central Vallarta KM 7.5 P SN Puerto Morelos Puerto Morelos Puerto Morelos QUINTANA ROO','Puerto Morelos','QUINTANA ROO','77580','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TPC1902211T2',NULL,'',0,NULL,0,NULL,''),(83,'CONSTRUCCIONES Y SUMINISTROS MAHAUAL','organization','ADOLFO LOPEZ MATEOS 363 ITALIA OTHON P BLANCO CHETUMAL QUINTANA ROO','OTHON P BLANCO','QUINTANA ROO','77035','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CSM9906236F7',NULL,'',0,NULL,0,NULL,''),(84,'KATY EMILIA RIVERO DIAZ','organization','101 357 SANTA ROSA MERIDA YUCATAN','MERIDA','YUCATAN','97279',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'RIDK710519827',NULL,'',0,NULL,0,NULL,''),(85,'BOSTIK MEXICANA','organization','ESFUERZO NACIONAL 2 INDUSTRIAL ALCE BLANCO NAUCALPAN DE  JUAREZ MEXICO','NAUCALPAN DE  JUAREZ','MEXICO','53370','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'BME631003N72',NULL,'',0,NULL,0,NULL,''),(86,'INFLIGHT SERVICES MEXICO','organization','CARRETERA CANCUN AEREOPUERTO KM 14.5 BODEGA 67 68 85 Y 86 CARRETERA CANCUN AEROPUERTO ORIENTE BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ISM9803269C1',NULL,'',0,NULL,0,NULL,''),(87,'TAFER RESORTS MANAGEMENT','organization','MIGUEL LAREDO DE TEJEDA 2108 AMERICANA GUADALAJARA GUADALAJARA JALISCO','GUADALAJARA','JALISCO','44160','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TRM180530UU8',NULL,'',0,NULL,0,NULL,''),(88,'RESERVA BENGALA','organization','KM 19 PARCELA 213 Z1P1 CTRAVALL PUERTO MORELOS PUERTO MORELOS PUERTO MORELOS QUINTANA ROO','PUERTO MORELOS','QUINTANA ROO','77580','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'RBE140303BUA',NULL,'',0,NULL,0,NULL,''),(89,'EJECUTIVOS DE TURISMO SUSTENTABLE','organization','BANCO CHINCHORRO MZ 1 LT 8 SUPER MANZANA 13 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77504',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ETS181205CA4',NULL,'',0,NULL,0,NULL,''),(90,'CONTROLADORA DOLPHIN','organization','KABAH MANZANA 04 LOTE 1 301 SUPERMANZANA 55 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77533','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CDO070410V77',NULL,'',0,NULL,0,NULL,''),(91,'MARIO ALBERTO LUCHINI','organization','AVENIDA 95 SUR LOTE 04 MANZANA 398 EJIDO SUR SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'LUMA661114IS8',NULL,'',0,NULL,0,NULL,''),(92,'XULTA SOLUCIONES','organization','17 661 LOCAL 4 JARDINES DE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97135','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XSO200728TK4',NULL,'',0,NULL,0,NULL,''),(93,'XULTA INGENIERIA DE COSTOS','organization','17 661 LOCAL 4 JARDINES DE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97135',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XIC211221FB9',NULL,'',0,NULL,0,NULL,''),(94,'GINO CONTROL EMPRESARIAL','organization','BONAMPAK MANZANA 1 LOTE 1 PISO 5 SM 6 CANCUN BENITO JUAREZ QUINTANA ROO','CANCUN','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GCE190724KT7',NULL,'',0,NULL,0,NULL,''),(95,'GULF MARINE DE MEXICO','organization','BOULEVARD (BLVD) ADOLFO RUIZ CORTINES 3321 FRACC DE LAS AMERICAS BOCA DEL RIO BOCA DEL RIO VERACRUZ DE IGNACIO DE LA  LLAVE','BOCA DEL RIO','VERACRUZ DE IGNACIO DE LA  LLAVE','94299','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GMM0706299H8',NULL,'',0,NULL,0,NULL,''),(96,'AGL PRODUCE','organization','TAXISTAS MZA 786 LT 002-3 B FRACCION 1 A-3 DE EJIDO SUR SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'APR180905RC8',NULL,'',0,NULL,0,NULL,''),(97,'SERVICIOS CORPORATIVOS SAC BE','organization','CALLE 18 Y CALLE 20 108 13 ITZIMNA MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97100','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SCS040225SR6',NULL,'',0,NULL,0,NULL,''),(98,'ADELANTE DISTRIBUCIONES','organization','LUIS DONALDO COLOSIO 520 MANZANA 4 LOTE 5 SUPERMANZANA 301 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77536','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ADI120203QF5',NULL,'',0,NULL,0,NULL,''),(99,'KERSHE','organization','Cancun Aeropuerto Manzana 4 Lote 5 SM Bodega 518 BT-1 Central de Abastos Benito Juarez Cancun Quintana Roo','Benito Juarez','Quintana Roo','77560','Mexico','2026-08-04 19:24:09',NULL,'9981300181',NULL,'','',0,0,0,0,1,0,0,'',NULL,'KER150619642',NULL,'',0,NULL,0,NULL,''),(100,'RESIDENCIAL SALAMANCA PDC','organization','Caracoles MZ 20 LT 008 SN Encuentro Solidaridad Playa del Carmen Quintana Roo','Solidaridad','Quintana Roo','77726','México','2026-08-04 19:24:09',NULL,'5521289728',NULL,'','',0,0,0,0,1,0,0,'',NULL,'RSP240521T12',NULL,'',0,NULL,0,NULL,''),(101,'GLOBAL CRUISES MX','organization','65 SN 6,7,8 ZONA INDUSTRIA COZUMEL COZUMEL QUINTANA ROO','COZUMEL','QUINTANA ROO','77670','MEXIXCO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GCM220406SM5',NULL,'',0,NULL,0,NULL,''),(102,'DAMARIS ELIDED VILLAVICENCIO VERA','organization','MARIANO ABASOLO 19 S N INSURGENTES NORTE MINATITLAN MINATITLAN VERACRUZ DE IGNACIO DE LA LLAVE','MINATITLAN','VERACRUZ DE IGNACIO DE LA LLAVE','96710','MEXICO','2026-08-04 19:24:09',NULL,'9842658670',NULL,'','',0,0,0,0,1,0,0,'',NULL,'VIVD010805513',NULL,'',0,NULL,0,NULL,''),(103,'SURTIDORA DE FRIOS DE LA PENINSULA','organization','CARRETERA FEDERAL CANCUN -  AEROPUERTO MANZANA 61 LOTE 61 18 A Y 18 B SUPERMANZANA 301 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77536','MEXICO','2026-08-04 19:24:09',NULL,'9982030245',NULL,'','',0,0,0,0,1,0,0,'',NULL,'SFP190612IK7',NULL,'',0,NULL,0,NULL,''),(104,'EXPERIENCIAS XCARET CORPORATIVO','organization','CARRETERA CHETUMAL PUERTO JUAREZ PREDIO XCARET MZ 12 TORRE 1 PARQUE XCARE RANCHO XCARET SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MUL1102229J0',NULL,'',0,NULL,0,NULL,''),(105,'M INDUSTRIA','organization','AVENIDA LOPEZ PORTILLO MANZANA 46 LOTE 1 SN SMZA 64 CANCUN BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77524','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MIN120224147',NULL,'',0,NULL,0,NULL,''),(106,'COMERCIALIZADORA DE MAQUINARIA INDUSTRIAL MAQUIMEX','organization','20 A 298 MONTEBELLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97113','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMI2305097A3',NULL,'',0,NULL,0,NULL,''),(107,'SWITCH SOLUCIONES DIGITALES','organization','',NULL,NULL,'97115',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SSD201106LI9',NULL,'',0,NULL,0,NULL,''),(108,'OPERADORA DE ALDEAS VACACIONALES','organization','AV INSURGENTES SUR 1647 SAN JOSE INSURGENTES BENITO JUAREZ BENITO JUAREZ CIUDAD DE MEXICO','BENITO JUAREZ','CIUDAD DE MEXICO','03900','MEXICO','2026-08-04 19:24:09',NULL,'9981811461',NULL,'','',0,0,0,0,1,0,0,'',NULL,'OAV730502NZ8',NULL,'',0,NULL,0,NULL,''),(109,'VL GESTION CONDOMINAL','organization','PRIVADA PAPUA MZN 40 LT 001-011 VIV 12 SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,'9841409161',NULL,'','',0,0,0,0,1,0,0,'',NULL,'VGC231128HE5',NULL,'',0,NULL,0,NULL,''),(110,'OPERADORA HOTELERA ETRO','organization','CARRETERA FEDERAL 307 CANCUN TULUM KILOMETRO 302 340 LO UNIDAD DE PROP EXCLU OTRA NO ESPECIFICADA EN EL CATALOGO SOLIDARIDAD OTRA NO ESPECIFICADA EN EL CATALOGO QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77730','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PEN010212DU9',NULL,'',0,NULL,0,NULL,''),(111,'OPERADORA XUNA','organization','Carlos Nader Mz 1 Lt28 Super Manzana 2 Centro Benito Juarez Cancun Quintana Roo','Benito Juarez','Quintana Roo','77500','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OXU080111NS1',NULL,'',0,NULL,0,NULL,''),(112,'OPERADORA HOTELERA DEL CORREDOR MAYAKOBA','organization','CARRETERA FEDERAL PLAYA - CANCUN A UN COSTADO DE CAPITAN LAFITTE 298 EJIDO SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OHC030508CA2',NULL,'',0,NULL,0,NULL,''),(113,'STARBREAKER','organization','CENTEOTL Y CALLE TOCHTLI ENTRE ACATL 267 B INDUSTRIAL SAN ANTONIO AZCAPOTZALCO AZCAPOTZALCO CIUDAD DE MEXICO','AZCAPOTZALCO','CIUDAD DE MEXICO','02760','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'STA230830MX9',NULL,'',0,NULL,0,NULL,''),(114,'AULA 24 HORAS','organization','IGNACIO MORONES PRIETO 791 8 CENTRO SAN PEDRO GARZA GARCIA SAN PEDRO GARZA GARCIA NUEVO LEON','SAN PEDRO GARZA GARCIA','NUEVO LEON','66230','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AVH0107164T2',NULL,'',0,NULL,0,NULL,''),(115,'PROMOTORA RANCHO SAN MIGUEL','organization','SUPER MANZANA 41 MZ 01 LOTE 1 - 01 SN BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77569','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PRS050126FW2',NULL,'',0,NULL,0,NULL,''),(116,'ARQUIDIOCESIS DE YUCATAN','organization','CALLE 10 96 GARCIA GINERES MERIDA YUCATAN','MERIDA','YUCATAN','97070','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AYU930608I73',NULL,'',0,NULL,0,NULL,''),(117,'PROYECTOS EJECUTIVOS SUSTENTABLES','organization','KUKULCAN MANZANA 60 LOTE 5-02 SECCION D TERCERA ET ZONA HOTELERA BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PES181205470',NULL,'',0,NULL,0,NULL,''),(118,'TOTAL GUSTO','organization','56 POR 30 Y 31 A NO 336J ITZIMNA MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97100','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TGU011113CR6',NULL,'',0,NULL,0,NULL,''),(119,'LL MEX','organization','BONAMPAK MANZANA 1 LOTE 4C ED LOC 1504 SM 4A BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MOB191114KL6',NULL,'',0,NULL,0,NULL,''),(120,'OHA SOLUCIONES EN INGENIERIA','organization','69 649 LIBERTAD MERIDA YUCATAN','MERIDA','YUCATAN','97256','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OSI180904QB3',NULL,'',0,NULL,0,NULL,''),(121,'ALINA OROZCO MARQUEZ','organization','CALLE SAN PEDRO 1421 SAN MARTIN GUADALAJARA','GUADALAJARA',NULL,'44380','México','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OOMA860315A49',NULL,'',0,NULL,0,NULL,''),(122,'GERMAN AUGUSTO MARIN UC','organization','20 323 Fraccionamiento Mulsay Merida','Merida',NULL,'97246','Mexico','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MAUG731023JH8',NULL,'',0,NULL,0,NULL,''),(123,'YUCATAN SEAS','organization','VIALIDAD 14 ENTRE CALLE 13 Y 15 290 121 MONTEBELLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97113',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'YSE210430F8A',NULL,'',0,NULL,0,NULL,''),(124,'RICARDO MIMENZA ARCE','organization','63 97 AME MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97115','MÈXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MIAR000721EP3',NULL,'',0,NULL,0,NULL,''),(125,'PERFORMANCE BOATS USA LLC','organization','1441 Brickell avenue Suite 1400 Miami Florida Estados unidos de america','Miami','Estados unidos de america','97130','Estados unidos de america','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XEXX010101000',NULL,'',0,NULL,0,NULL,''),(126,'KEM SPORTS','organization','16 402 A MONTEBELLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97113','MÉXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'KSP210209RS2',NULL,'',0,NULL,0,NULL,''),(127,'PROVEEDORA Y CONSTRUCTORA MEXICANA','organization','AVENIDA KABAH MANZANA 6 LOTE 25 LETRA D SM 31 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77508','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PCM960301681',NULL,'',0,NULL,0,NULL,''),(128,'COMERCIALIZADORA STERN','organization','HUGO DELGADO LOMELI SN OTRA NO ESPECIFICADA EN EL CATALOGO GUAYMAS SAN CARLOS (SAN CARLOS NUEVO GUAYMAS) SONORA','GUAYMAS','SONORA','85506','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CST0806167Z8',NULL,'',0,NULL,0,NULL,''),(129,'VA CATAMARANES','organization','AV.  PERIFERICO SUR 4421 402 OTRA NO ESPECIFICADA EN EL CATALOGO TLALPAN OTRA NO ESPECIFICADA EN EL CATALOGO CIUDAD DE MEXICO','TLALPAN','CIUDAD DE MEXICO','14018','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'VCA171116HMA',NULL,'',0,NULL,0,NULL,''),(130,'JERICO NAVARRO PAREDES','organization','49 321-A CENTRO TIZIMIN TIZIMIN YUCATAN','TIZIMIN','YUCATAN','97700','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'NAPJ930117PG6',NULL,'',0,NULL,0,NULL,''),(131,'LA MEDITERRANEA PREMIUM SPIRITS','organization','JAUN PALOMAR Y ARIAS 567 57 MONRAZ GUADALAJARA GUADALAJARA JALISCO','GUADALAJARA','JALISCO','44670','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MPS210324TY0',NULL,'',0,NULL,0,NULL,''),(132,'MOTORTECH','organization','ACANCEH MANZANA 2 LOTE 3 PISO 3 3B SUPERMANZANA 11 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77504','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MOT210924UWA',NULL,'',0,NULL,0,NULL,''),(133,'JULIO CESAR MARIN GALERA','organization','49 230 208 SAN ANTONIO CUCUL MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97116','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MAGJ561127ET5',NULL,'',0,NULL,0,NULL,''),(134,'GCS GRUPOS E INCENTIVOS','organization','PUERTO VALLARTA 21 M 8 L 1 SUPERMANZANA 528 BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77535','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GGI160805HQ6',NULL,'',0,NULL,0,NULL,''),(135,'ANDREA IVONNE OJEDA LIZAMA','organization','17 286 LOCAL 1 MONTECARLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97130','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OELA9208172S1',NULL,'',0,NULL,0,NULL,''),(136,'EOXMID','organization','32 298 PISO 3 MONTEBELLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97113','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'EOX240722CA0',NULL,'',0,NULL,0,NULL,''),(137,'OPERADORA DE FRANQUICIAS MALABARES','organization','COLIMA 23 LOCAL B ROMA NORTE CUAUHTEMOC CUAUHTEMOC CIUDAD DE MEXICO','CUAUHTEMOC','CIUDAD DE MEXICO','06700','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OFM060920RJ8',NULL,'',0,NULL,0,NULL,''),(138,'EXPERIENCIAS XCARET NAVIERA','organization','BLVD KUKULKAN KM 4.5 KM 4.5 D7 ZONA TURISTICA 1A ZONA HOTELERA BENITO JUAREZ CANCUN QUINTANA ROO','BENITO JUAREZ','QUINTANA ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'NCM210618RE0',NULL,'',0,NULL,0,NULL,''),(139,'TESORO VIVO','organization','CARRETERA FEDERAL CANCUN A PUERTO MORELOS KM 27.5 SM 32 MZ 01 L 1-11 C LOC 20 PUERTO MORELOS PUERTO MORELOS PUERTO MORELOS QUINTANA ROO','PUERTO MORELOS','QUINTANA ROO','77580','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TVI190618F79',NULL,'',0,NULL,0,NULL,''),(140,'PROTECTOGARD','organization','MARINA 34 OBSERVATORIO MIGUEL HIDALGO MIGUEL HIDALGO CIUDAD DE MEXICO','MIGUEL HIDALGO','CIUDAD DE MEXICO','11860','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PRO090819GQ3',NULL,'',0,NULL,0,NULL,''),(141,'FUNDACION ORIGINAL','organization','BLVD KUKULCAN KM 3.5 CAMINO AL HOTEL VERA CAMINO AL HOTEL OCEA ZONA HOTELERA BENITO JUAREZ CANCUN','BENITO JUAREZ',NULL,'77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'FOR100930BF7',NULL,'',0,NULL,0,NULL,''),(142,'GOLF DE MAYAKOBA','organization','CARR FEDERAL CHETUMAL PTO. JUAREZ KM 298 EJIDO PLAYA DEL CARMEN SOLIDARIDAD PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'77710',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GMA040326F27',NULL,'',0,NULL,0,NULL,''),(143,'PROMOTORA HOTELERA ORIGINAL','organization','AVENIDA BONAMPAK ENTRE AVENIDA COBA MANZANA 9 LOTE 17 01 SUPERMANZANA 3 CENTRO BENITO JUAREZ CANCUN Q,ROO','BENITO JUAREZ','Q,ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'HBP031220MQ4',NULL,'',0,NULL,0,NULL,''),(144,'PH ORIGINAL','organization','AVENIDA BONAMPAK ENTRE AVENIDA COBA MANZANA 9 LOTE 17 01 SUPERMANZANA 3 CENTRO BENITO JUAREZ CANCUN Q,ROO','BENITO JUAREZ','Q,ROO','77500','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'POR2209074V0',NULL,'',0,NULL,0,NULL,''),(145,'OGV CLUB','organization','AVENIDA BONAMPAK ENTRE AVENIDA COBA MANZANA 9 LOTE 17 01 SUPERMANZANA 3 CENTRO BENITO JUAREZ CANCUN Q,ROO','BENITO JUAREZ','Q,ROO','77500',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'OCL220907748',NULL,'',0,NULL,0,NULL,''),(146,'HIX ADVENTURE','organization','BLVD. BELISARIO DOMINGUEZ ENTRE CALLE PRIMO DE VERDAD 602 B HERNANDEZ DURANGO VICTORIA DE DURANGO','DURANGO',NULL,'34138','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'HAD190206KX7',NULL,'',0,NULL,0,NULL,''),(147,'EXPLORA CARIBE TOURS','organization','7 SUR EXT 5 DEPTO B CENTRO COZUMEL COZUMEL','COZUMEL',NULL,'77600',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ECT060203GB9',NULL,'',0,NULL,0,NULL,''),(148,'PARAISO LOS CABOS','organization','KM 19.5 CARRETERA TRANSPENINSULAR SAN JOSE DEL CABO LOS CABOS BAJA CALIFORNIA SUR','LOS CABOS','BAJA CALIFORNIA SUR','23405','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PCA9601303TA',NULL,'',0,NULL,0,NULL,''),(149,'ALMACENES PALACE RESORTS','organization','ANDRES GARCIA LAVIN CALLE 32 298 PISO 11 MONTEBELLO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97113',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'APR180808CP0',NULL,'',0,NULL,0,NULL,''),(150,'HOTELERA PALACE RESORTS','organization','TOLSTOI Y VICTOR HUGO 10 ANZURES MIGUEL HIDALGO CUIDAD DE MEXICO','MIGUEL HIDALGO','CUIDAD DE MEXICO','11590',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PIN131210PG9',NULL,'',0,NULL,0,NULL,''),(151,'SCUBABLU COZUMEL','organization','15 SUR ENTRE 13 SUR 940 LOCAL 2 COZUMEL COZUMEL QUINTANA ROO','COZUMEL','QUINTANA ROO','77664','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SCO201209GN8',NULL,'',0,NULL,0,NULL,''),(152,'PROMOCIONES AMERICA LATINA','organization','INSURGENTES SUR 1814 601 FLORIDA ALVARO OBREGON ALVARO OBREGON CUIDAD DE MEXICO','ALVARO OBREGON','CUIDAD DE MEXICO','01030',NULL,'2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PAL030731427',NULL,'',0,NULL,0,NULL,''),(153,'ADMINISTRADORA DE CONDOMINIOS VALLE AURORA TORRE 1','organization','125 AV NORTE U.P.E. 003 MZ 4 FRACC LA GRAN PLAZA DE LA RIVIERA II LT 3 OFNA ADMTVA \"A\" SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712',NULL,'2026-08-04 19:24:09',NULL,'9981168226',NULL,'','',0,0,0,0,1,0,0,'',NULL,'ACV211210I41',NULL,'',0,NULL,0,NULL,''),(154,'ALFREDO ALEJANDRO MORALES HERRERA','organization','RAFAEL E MELGAR ENTRE HOTEL CASA DEL MAR KM 4 02 S/N ZONA HOTELERA SUR COZUMEL COZUMEL COZUMEL QUINTANANA ROO','COZUMEL','QUINTANANA ROO','77600','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MOHA750529DF1',NULL,'',0,NULL,0,NULL,''),(155,'MARINA SILCER','organization','S/N TABLAJE CATASTRAL 62 S/N YUCALPETEN PROGRESO PROGRESO YUCATAN','PROGRESO','YUCATAN','97320','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MSI0906164TA',NULL,'',0,NULL,0,NULL,''),(156,'SERVICIOS Y PROMOCIONES NAUTICAS DEL SURESTE','organization','24 ENTRE 7B 291 S/N SANTA GERTUDRIS COPO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97305','MEXICO','2026-08-04 19:24:09',NULL,'9993680002',NULL,'','',0,0,0,0,1,0,0,'',NULL,'SPN221205P86',NULL,'',0,NULL,0,NULL,''),(157,'EXPERIENCIAS XCARET LOYALTY','organization','CAMINO DE ACCESO PARQUE XENSES ENTRE CAMINO ACCESO AL PARQUE XCARET KILÃ“METRO 282 INTERIOR B RANCHO XCARET SOLIDARIDAD PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'77710','MEXICO','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'EXL1705186P6',NULL,'',0,NULL,0,NULL,''),(158,'SOLUCIONES NAUTICAS','organization','11 N° 344 S/N SANTA GERTUDRIS COPO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97305','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SNA100424V72',NULL,'',0,NULL,0,NULL,''),(159,'ISAAC ANZURES TORRES','organization','JARDIN 257 TORRE 5 DEPTO 1205 AMPLIACION DEL GAS AZCAPOTZALCO AZCAPOTZALCO','AZCAPOTZALCO',NULL,'02970','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'AUTI030620V18',NULL,'',0,NULL,0,NULL,''),(160,'EDIFICACIONES Y CONSTRUCCIONES RCUATRO','organization','CALLE 12-A 310 LOCAL A4, PISO 7 SANTA GERTUDRIS COPO MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97305','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'ECR120910SL2',NULL,'',0,NULL,0,NULL,''),(161,'MARITIMOS DE FRANCIA AG','organization','SAN JERONIMO 310 PISO 12 SAN JERONIMO MONTERREY MONTERREY NUEVO LEON','MONTERREY','NUEVO LEON','64640','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MFA220308FJ0',NULL,'',0,NULL,0,NULL,''),(162,'ANA KARINA DOMINGUEZ DE LOS SANTOS','organization','55 A ENTRE CALLE 120 987 LAS AMERICAS II MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97302','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'DOSA8906034D4',NULL,'',0,NULL,0,NULL,''),(163,'PUNTO SUB','organization','CARRETERA FEDERAL CHETUMAL -PUERTO JUAREZ KM 299+500 MZA 10 LTE 01 BODEGA 4 SOLIDARIDAD PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'77710','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'PSU091130I16',NULL,'',0,NULL,0,NULL,''),(164,'XEDIS QROO','organization','TAXISTAS LOTE 1 S/N EJIDO SUR SOLIDARIDAD PLAYA DEL CARMEN QUINTANA ROO','SOLIDARIDAD','QUINTANA ROO','77712','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'XQR190529BA7',NULL,'',0,NULL,0,NULL,''),(165,'COMERCIALIZADORA AGROTERRA DEL SURESTE','organization','DIAGONAL 85 NORTE MANZANA 72 LOTE 11 A S/N EJIDAL SOLIDARIDAD PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'77712','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CAS150616285',NULL,'',0,NULL,0,NULL,''),(166,'MERIMOTO','organization','86 473 F S/N INALAMBRICA MERIDA YUCATAN','MERIDA','YUCATAN','97069','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MER881110EM0',NULL,'',0,NULL,0,NULL,''),(167,'GLAMPINGCO','organization','RIO AMACUZAC, CALLE LOMAS DEL MAR 216 PISO 4 OFICINA 2 RESIDENCIAL SAN AGUSTIN PRIMER SECTOR SAN PEDRO GARZA GARCIA SAN PEDRO GARZA GARCIA NUEVO LEON','SAN PEDRO GARZA GARCIA','NUEVO LEON','66260','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GLA241031Q48',NULL,'',0,NULL,0,NULL,''),(168,'RIOS WATER SOLUTIONS','organization','FLAMBOYANES CALLE CIRICOTE 22 SN MIAMI CARMEN CUIDAD DEL CARMEN CAMPECHE','CARMEN','CAMPECHE','24115','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'RWS250901UI1',NULL,'',0,NULL,0,NULL,''),(169,'DAVID JACOB DE LA GARZA VILLARREAL','organization','EFRAIN HUERTA 1703 SN COUNTRY SOL GUADALUPE GUADALUPE NUEVO LEON','GUADALUPE','NUEVO LEON','67174','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'GAVD881024FBA',NULL,'',0,NULL,0,NULL,''),(170,'ROXANA PATRICIA GUZMAN LICONA','organization','19 ENTRE CALLE 14 79 SN COSTA AZUL PROGRESO PROGRESO YUCATAN','PROGRESO','YUCATAN','97320','MEX','2026-08-04 19:24:09',NULL,'9381248173',NULL,'','',0,0,0,0,1,0,0,'',NULL,'GULR8108285HA',NULL,'',0,NULL,0,NULL,''),(171,'MARINA SURESTE','organization','84 SN ITZIMNA MERIDA YUCATAN','MERIDA','YUCATAN','97100','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MSU020604TW8',NULL,'',0,NULL,0,NULL,''),(172,'MARIA CECILIA MAFUD SALUM','organization','CALLE 8 ENTRE CALLE 15 417 SN DIAZ ORDAZ MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97130','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MASC6203093NA',NULL,'',0,NULL,0,NULL,''),(173,'DESARROLLOS NORTEMID','organization','1D CALE 36 ENTRE CALLE 38 258 SN CAMPESTRE MERIDA YUCATAN','MERIDA','YUCATAN','97120','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'DNO1712074D8',NULL,'',0,NULL,0,NULL,''),(174,'URBAN SOLAR','organization','40 CALLE 7 ENTRE CALLE 5 321 SAN PEDRO UXMAL MERIDA YUCATAN','MERIDA','YUCATAN','97203','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'USO190214I21',NULL,'',0,NULL,0,NULL,''),(175,'ISLAS DE MAYAKOBA','organization','CARRETERA FEDERAL KM 298 KM 298 SOLIDARIDAD PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'77710','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'IMA030814G16',NULL,'',0,NULL,0,NULL,''),(176,'LIGIA MACIEL GARCIA','organization','SIN CRUZAMIENTO KM3 1 TEMOZON NORTE MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97302','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'MAGL830429FI6',NULL,'',0,NULL,0,NULL,''),(177,'SOMOS BLUERS','organization','CALLE 26 185 S/N GARCIA GINERES MERIDA YUCATAN','MERIDA','YUCATAN','97070','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'SBL2601076E3',NULL,'',0,NULL,0,NULL,''),(178,'CONSTRUCCIONES MOYUC','organization','CALLE 122 ENTRE 120 A 1003 SN NUEVA MULSAY MERIDA MERIDA YUCATAN','MERIDA','YUCATAN','97249','MEX','2026-08-04 19:24:09',NULL,'999 163 9125',NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMO000128Q59',NULL,'',0,NULL,0,NULL,''),(179,'TAKE FLIGHT VENTURES','organization','JILGUEROS ENTRE CARRET. GUADALAJARA-TEPIC 1204 24 SAN JUAN DE OCOTAN ZAPOPAN ZAPOPAN JALISCO','ZAPOPAN','JALISCO','45019','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'TFV220408B62',NULL,'',0,NULL,0,NULL,''),(180,'CONDOMINIO MAYAKOBA','organization','CARR FEDERAL CHETUMAL PTO. JUAREZ KM 298 SN SAN PEDRO GARZA GARCIA PLAYA DEL CARMEN','SAN PEDRO GARZA GARCIA',NULL,'77710','MEX','2026-08-04 19:24:09',NULL,NULL,NULL,'','',0,0,0,0,1,0,0,'',NULL,'CMA0408246P1',NULL,'',0,NULL,0,NULL,'');
/*!40000 ALTER TABLE `ikontrol_clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_commercial_lifecycle_audit`
--

DROP TABLE IF EXISTS `ikontrol_commercial_lifecycle_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_commercial_lifecycle_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(20) NOT NULL,
  `entity_id` bigint(20) unsigned NOT NULL,
  `event` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_type_entity_id` (`entity_type`,`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_commercial_lifecycle_audit`
--

LOCK TABLES `ikontrol_commercial_lifecycle_audit` WRITE;
/*!40000 ALTER TABLE `ikontrol_commercial_lifecycle_audit` DISABLE KEYS */;
INSERT INTO `ikontrol_commercial_lifecycle_audit` VALUES (1,'sale',56,'integration_candidate_classified',NULL,NULL,'C2.3 candidate; not stamped.',1,'2026-08-04 17:58:43');
/*!40000 ALTER TABLE `ikontrol_commercial_lifecycle_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_company`
--

DROP TABLE IF EXISTS `ikontrol_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `address` text NOT NULL,
  `phone` text NOT NULL,
  `email` text NOT NULL,
  `website` text NOT NULL,
  `vat_number` text NOT NULL,
  `gst_number` text NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `logo` mediumtext NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_company`
--

LOCK TABLES `ikontrol_company` WRITE;
/*!40000 ALTER TABLE `ikontrol_company` DISABLE KEYS */;
INSERT INTO `ikontrol_company` VALUES (1,'DENNISSE MILDRETH DOMINGUEZ LOPEZ','2 230 VISTA ALEGRE NORTE MERIDA MERIDA YUCATAN 97130 México','','','','DOLD860620EW7','',1,'',0);
/*!40000 ALTER TABLE `ikontrol_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_contract_items`
--

DROP TABLE IF EXISTS `ikontrol_contract_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_contract_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `contract_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_contract_items`
--

LOCK TABLES `ikontrol_contract_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_contract_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_contract_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_contract_templates`
--

DROP TABLE IF EXISTS `ikontrol_contract_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_contract_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `template` mediumtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_contract_templates`
--

LOCK TABLES `ikontrol_contract_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_contract_templates` DISABLE KEYS */;
INSERT INTO `ikontrol_contract_templates` VALUES (1,'Template 3.7','<p>&nbsp;</p>\r\n<table class=\"table\" style=\"background-color: #3d3d3d; color: #ffffff; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"text-align: center; width: 100%;\">\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<div><span style=\"font-size: 40px;\"><strong>{CONTRACT_TITLE}</strong></span></div>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">This contract states the terms and conditions that shall govern the contractual agreement between {COMPANY_NAME} (the Service Provider) and {CONTRACT_TO_COMPANY_NAME} (the Client) who agrees to be bound by the terms of the contract.</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">{CONTRACT_ID}</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<div>Contract Date: {CONTRACT_DATE}<br>Expiry Date: {CONTRACT_EXPIRY_DATE}</div>\r\n<table style=\"width: 100%; padding-top: 30px; margin-top: 0px;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 50%; padding-left: 0; padding-right: 10px;\">\r\n<p>Client</p>\r\n{CONTRACT_TO_INFO}</td>\r\n<td style=\"width: 50%; padding-left: 10px;\">\r\n<p>Service Provider</p>\r\n{COMPANY_INFO}</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">Service Details</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.4239%;\">&nbsp;</td>\r\n<td style=\"width: 14.4239%;\">&nbsp;</td>\r\n<td style=\"width: 14.4239%;\">&nbsp;</td>\r\n<td style=\"width: 14.4239%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.4239%;\">&nbsp;</td>\r\n<td style=\"width: 14.4239%;\">&nbsp;</td>\r\n<td style=\"width: 12.8504%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">The specific scope, timeline, and any additional requirements related to the services shall be detailed in a separate document or statement of work, which shall form an integral part of this contract.</p>\r\n<p>&nbsp;</p>\r\n<p>{CONTRACT_ITEMS}</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">1. Service Policy</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">The Service Policy outlines the terms and conditions governing the provision of services by Service Provider to the Client. It encompasses guidelines regarding service delivery, quality standards, support mechanisms, and dispute resolution procedures. The Service Provider is committed to upholding the highest level of professionalism, responsiveness, and customer satisfaction in delivering the agreed upon services.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">Any deviations from the Service Policy shall be communicated promptly and resolved in a timely manner to ensure seamless collaboration and adherence to the mutual objectives outlined in the contract.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">2. Delivery</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">The Service Provider will commence delivery of services upon receipt of a signed contract and any necessary initial payments as specified. Delivery timelines and milestones will be outlined in the project schedule or statement of work provided to the Client. The Service Provider will make reasonable efforts to meet agreed-upon deadlines and milestones, keeping the Client informed of any delays or changes to the delivery schedule. Delivery methods may vary depending on the nature of the services and may include in-person meetings, electronic communication, or physical shipment of goods.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">Upon completion of the services, the Client will be provided with deliverables as outlined in the project scope or statement of work, with any necessary documentation or training materials included as specified.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">3. Intellectual property rights</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">All intellectual property rights, including but not limited to copyrights, patents, trademarks, and trade secrets, associated with the services provided under this contract shall remain the exclusive property of the originating party unless otherwise agreed upon in writing. The Service Provider retains ownership of any proprietary methodologies, technologies, or materials utilized in delivering the services, and the Client agrees not to reproduce, distribute, or disclose such intellectual property without prior written consent.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">Any intellectual property created or developed during the course of providing the services shall be jointly owned by both parties unless otherwise specified in a separate agreement. Any use or exploitation of intellectual property rights beyond the scope of this contract requires the express written consent of the owning party.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">4. Confidentiality</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">Both parties agree to maintain strict confidentiality regarding any proprietary or sensitive information disclosed during the course of this contract. This includes but is not limited to trade secrets, business strategies, financial information, and client data. The Service Provider shall take all necessary precautions to prevent unauthorized access or disclosure of confidential information and shall only share such information with authorized personnel directly involved in fulfilling the obligations of this contract.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">The Client agrees not to disclose any confidential information obtained from the Service Provider to any third parties without prior written consent. This confidentiality obligation shall survive the termination of this contract and continue indefinitely thereafter.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<table style=\"margin-top: 0px; margin-bottom: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"padding: 0px; width: 100%;\">\r\n<div style=\"margin-top: 20px;\">\r\n<div style=\"text-align: center;\">\r\n<div style=\"font-size: 30px;\">5. Support</div>\r\n<table style=\"margin-top: 10px; width: 100%;\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">\r\n<div style=\"border-bottom: 5px solid #ff9800;\">&nbsp;</div>\r\n</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n<td style=\"width: 14.5125%;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n</div>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p style=\"text-align: justify;\">The Service Provider agrees to provide reasonable support and assistance to the Client during the term of this contract. Support may include but is not limited to troubleshooting, technical assistance, and guidance related to the services provided. The Service Provider will make commercially reasonable efforts to respond promptly to inquiries and requests for support from the Client, within the parameters specified in the service level agreement (SLA) or support agreement. Support will be provided during normal business hours unless otherwise agreed upon. Any additional support beyond the scope outlined in this contract may be subject to additional fees or terms as mutually agreed upon by both parties.</p>\r\n<p style=\"text-align: justify;\">&nbsp;</p>\r\n<p style=\"text-align: justify;\">{CONTRACT_NOTE}</p>',0);
/*!40000 ALTER TABLE `ikontrol_contract_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_contracts`
--

DROP TABLE IF EXISTS `ikontrol_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `client_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `contract_date` date NOT NULL,
  `valid_until` date NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `last_email_sent_date` date DEFAULT NULL,
  `status` enum('draft','sent','accepted','declined') NOT NULL DEFAULT 'draft',
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `discount_type` enum('before_tax','after_tax') NOT NULL,
  `discount_amount` double NOT NULL,
  `discount_amount_type` enum('percentage','fixed_amount') NOT NULL,
  `content` mediumtext NOT NULL,
  `public_key` varchar(10) NOT NULL,
  `accepted_by` int(11) NOT NULL DEFAULT 0,
  `staff_signed_by` int(11) NOT NULL DEFAULT 0,
  `meta_data` text NOT NULL,
  `files` mediumtext NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_contracts`
--

LOCK TABLES `ikontrol_contracts` WRITE;
/*!40000 ALTER TABLE `ikontrol_contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_custom_field_values`
--

DROP TABLE IF EXISTS `ikontrol_custom_field_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_custom_field_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `related_to_type` varchar(50) NOT NULL,
  `related_to_id` int(11) NOT NULL,
  `custom_field_id` int(11) NOT NULL,
  `value` longtext NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `related_to_type` (`related_to_type`),
  KEY `related_to_id` (`related_to_id`),
  KEY `custom_field_id` (`custom_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_custom_field_values`
--

LOCK TABLES `ikontrol_custom_field_values` WRITE;
/*!40000 ALTER TABLE `ikontrol_custom_field_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_custom_field_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_custom_fields`
--

DROP TABLE IF EXISTS `ikontrol_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `title_language_key` text NOT NULL,
  `placeholder_language_key` text NOT NULL,
  `show_in_embedded_form` tinyint(4) NOT NULL DEFAULT 0,
  `placeholder` text NOT NULL,
  `template_variable_name` text DEFAULT NULL,
  `options` mediumtext NOT NULL,
  `field_type` varchar(50) NOT NULL,
  `related_to` varchar(50) NOT NULL,
  `sort` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT 0,
  `add_filter` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_table` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_invoice` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_estimate` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_contract` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_order` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_proposal` tinyint(1) NOT NULL DEFAULT 0,
  `visible_to_admins_only` tinyint(1) NOT NULL DEFAULT 0,
  `hide_from_clients` tinyint(1) NOT NULL DEFAULT 0,
  `disable_editing_by_clients` tinyint(1) NOT NULL DEFAULT 0,
  `show_on_kanban_card` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `show_in_subscription` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `related_to` (`related_to`),
  KEY `field_type` (`field_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_custom_fields`
--

LOCK TABLES `ikontrol_custom_fields` WRITE;
/*!40000 ALTER TABLE `ikontrol_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_custom_widgets`
--

DROP TABLE IF EXISTS `ikontrol_custom_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_custom_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` text DEFAULT NULL,
  `content` mediumtext DEFAULT NULL,
  `show_title` tinyint(1) NOT NULL DEFAULT 0,
  `show_border` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_custom_widgets`
--

LOCK TABLES `ikontrol_custom_widgets` WRITE;
/*!40000 ALTER TABLE `ikontrol_custom_widgets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_custom_widgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_dashboards`
--

DROP TABLE IF EXISTS `ikontrol_dashboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_dashboards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  `color` varchar(15) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_dashboards`
--

LOCK TABLES `ikontrol_dashboards` WRITE;
/*!40000 ALTER TABLE `ikontrol_dashboards` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_dashboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_e_invoice_templates`
--

DROP TABLE IF EXISTS `ikontrol_e_invoice_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_e_invoice_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` tinytext NOT NULL,
  `template` mediumtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_e_invoice_templates`
--

LOCK TABLES `ikontrol_e_invoice_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_e_invoice_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_e_invoice_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_email_templates`
--

DROP TABLE IF EXISTS `ikontrol_email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(50) NOT NULL,
  `email_subject` text NOT NULL,
  `default_message` mediumtext NOT NULL,
  `custom_message` mediumtext DEFAULT NULL,
  `template_type` enum('default','custom') NOT NULL DEFAULT 'default',
  `language` varchar(50) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_email_templates`
--

LOCK TABLES `ikontrol_email_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_email_templates` DISABLE KEYS */;
INSERT INTO `ikontrol_email_templates` VALUES (1,'login_info','Login details','<div style=\"background-color: #eeeeef; padding: 50px 0; \"><div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">  <h1>Login Details</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\"> Hello {USER_FIRST_NAME} {USER_LAST_NAME},<br><br>An account has been created for you.</p>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\"> Please use the following info to login your dashboard:</p>            <hr>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\">Dashboard URL:&nbsp;<a href=\"{DASHBOARD_URL}\" target=\"_blank\">{DASHBOARD_URL}</a></p>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\"></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Email: {USER_LOGIN_EMAIL}</span><br></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Password:&nbsp;{USER_LOGIN_PASSWORD}</span></p>            <p style=\"color: rgb(85, 85, 85);\"><br></p>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>        </div>    </div></div>','','default','',0),(2,'reset_password','Reset password','<div style=\"background-color: #eeeeef; padding: 50px 0; \"><div style=\"max-width:640px; margin:0 auto; \"><div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Reset Password</h1>\n </div>\n <div style=\"padding: 20px; background-color: rgb(255, 255, 255); color:#555;\">                    <p style=\"font-size: 14px;\"> Hello {ACCOUNT_HOLDER_NAME},<br><br>A password reset request has been created for your account.&nbsp;</p>\n                    <p style=\"font-size: 14px;\"> To initiate the password reset process, please click on the following link:</p>\n                    <p style=\"font-size: 14px;\"><a href=\"{RESET_PASSWORD_URL}\" target=\"_blank\">Reset Password</a></p>\n                    <p style=\"font-size: 14px;\"></p>\n                    <p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\"><br></span></p>\n<p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\">If you\'ve received this mail in error, it\'s likely that another user entered your email address by mistake while trying to reset a password.</span><br></p>\n<p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\">If you didn\'t initiate the request, you don\'t need to take any further action and can safely disregard this email.</span><br></p>\n<p style=\"font-size: 14px;\"><br></p>\n<p style=\"font-size: 14px;\">{SIGNATURE}</p>\n                </div>\n            </div>\n        </div>','','default','',0),(3,'team_member_invitation','You are invited','<div style=\"background-color: #eeeeef; padding: 50px 0; \"><div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Account Invitation</h1>   </div>  <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello,</span><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"font-weight: bold;\"><br></span></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"font-weight: bold;\">{INVITATION_SENT_BY}</span> has sent you an invitation to join with a team.</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVITATION_URL}\" target=\"_blank\">Accept this Invitation</a></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">If you don not want to accept this invitation, simply ignore this email.</span><br><br></p>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>        </div>    </div></div>','','default','',0),(4,'send_invoice','New invoice','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>INVOICE</h1>\n<h3>&nbsp;{INVOICE_FULL_ID}</h3>\n</div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello {CONTACT_FIRST_NAME},</p>\n<p>Thank you for your business cooperation.</p>\n<p>Your invoice for the project {PROJECT_TITLE} has been generated and is attached here.</p>\n<p>&nbsp;</p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Invoice</a></p>\n<p>&nbsp;</p>\n<p>Invoice balance due is {BALANCE_DUE}</p>\n<p>Please pay this invoice within {DUE_DATE}.&nbsp;</p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(5,'signature','Signature','Powered By: <a href=\"https://fairsketch.com/\" target=\"_blank\">fairsketch </a>','','default','',0),(6,'client_contact_invitation','You are invited','<div style=\"background-color: #eeeeef; padding: 50px 0; \">    <div style=\"max-width:640px; margin:0 auto; \">  <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Account Invitation</h1> </div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello,</span><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"font-weight: bold;\"><br></span></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"font-weight: bold;\">{INVITATION_SENT_BY}</span> has sent you an invitation to a client portal.</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVITATION_URL}\" target=\"_blank\">Accept this Invitation</a></span></p>            <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">If you don not want to accept this invitation, simply ignore this email.</span><br><br></p>            <p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>        </div>    </div></div>','','default','',0),(7,'ticket_created','Ticket  #{TICKET_ID} - {TICKET_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Ticket #{TICKET_ID} Opened</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px; font-weight: bold;\">Title: {TICKET_TITLE}</span><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"line-height: 18.5714px;\">{TICKET_CONTENT}</span><br></p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TICKET_URL}\" target=\"_blank\">Show Ticket</a></span></p> <p style=\"\"><br></p><p style=\"\">Regards,</p><p style=\"\"><span style=\"line-height: 18.5714px;\">{USER_NAME}</span><br></p>   </div>  </div> </div>','','default','',0),(8,'ticket_commented','Ticket  #{TICKET_ID} - {TICKET_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Ticket #{TICKET_ID} Replies</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px; font-weight: bold;\">Title: {TICKET_TITLE}</span><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"line-height: 18.5714px;\">{TICKET_CONTENT}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TICKET_URL}\" target=\"_blank\">Show Ticket</a></span></p></div></div></div>','','default','',0),(9,'ticket_closed','Ticket  #{TICKET_ID} - {TICKET_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Ticket #{TICKET_ID}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">The Ticket #{TICKET_ID} has been closed by&nbsp;</span><span style=\"line-height: 18.5714px;\">{USER_NAME}</span></p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TICKET_URL}\" target=\"_blank\">Show Ticket</a></span></p>   </div>  </div> </div>','','default','',0),(10,'ticket_reopened','Ticket  #{TICKET_ID} - {TICKET_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Ticket #{TICKET_ID}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">The Ticket #{TICKET_ID} has been reopened by&nbsp;</span><span style=\"line-height: 18.5714px;\">{USER_NAME}</span></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TICKET_URL}\" target=\"_blank\">Show Ticket</a></span></p>  </div> </div></div>','','default','',0),(11,'general_notification','{EVENT_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>{APP_TITLE}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">{EVENT_TITLE}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\">{EVENT_DETAILS}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{NOTIFICATION_URL}\" target=\"_blank\">View Details</a></span></p>  </div> </div></div>','','default','',0),(12,'invoice_payment_confirmation','Payment received','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>Payment Confirmation</h1>\n</div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello,<br>We have received your payment of {PAYMENT_AMOUNT} for {INVOICE_FULL_ID} <br>Thank you for your business cooperation.</p>\n<p>&nbsp;</p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">View Invoice</a></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(13,'message_received','{SUBJECT}','<meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"> <meta content=\"width=device-width, initial-scale=1.0\" name=\"viewport\"> <style type=\"text/css\"> #message-container p {margin: 10px 0;} #message-container h1, #message-container h2, #message-container h3, #message-container h4, #message-container h5, #message-container h6 { padding:10px; margin:0; } #message-container table td {border-collapse: collapse;} #message-container table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; } #message-container a span{padding:10px 15px !important;} </style> <table id=\"message-container\" align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background:#eee; margin:0; padding:0; width:100% !important; line-height: 100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0; font-family:Helvetica,Arial,sans-serif; color: #555;\"> <tbody> <tr> <td valign=\"top\"> <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"> <tbody> <tr> <td height=\"50\" width=\"600\">&nbsp;</td> </tr> <tr> <td style=\"background-color:#33333e; padding:25px 15px 30px 15px; font-weight:bold; \" width=\"600\"><h2 style=\"color:#fff; text-align:center;\">{USER_NAME} sent you a message</h2></td> </tr> <tr> <td bgcolor=\"whitesmoke\" style=\"background:#fff; font-family:Helvetica,Arial,sans-serif\" valign=\"top\" width=\"600\"> <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"> <tbody> <tr> <td height=\"10\" width=\"560\">&nbsp;</td> </tr> <tr> <td width=\"560\"><p><span style=\"background-color: transparent;\">{MESSAGE_CONTENT}</span></p> <p style=\"display:inline-block; padding: 10px 15px; background-color: #00b393;\"><a href=\"{MESSAGE_URL}\" style=\"text-decoration: none; color:#fff;\" target=\"_blank\">Reply Message</a></p> </td> </tr> <tr> <td height=\"10\" width=\"560\">&nbsp;</td> </tr> </tbody> </table> </td> </tr> <tr> <td height=\"60\" width=\"600\">&nbsp;</td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(14,'invoice_due_reminder_before_due_date','Invoice due reminder','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>Invoice Due Reminder</h1></div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello,<br>We would like to remind you that invoice {INVOICE_FULL_ID} is due on {DUE_DATE}. Please pay the invoice within due date.&nbsp;</p>\n<p><span>If you have already submitted the payment, please ignore this email.</span></p><p><span><br></span></p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Invoice</a></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(15,'invoice_overdue_reminder','Invoice overdue reminder','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>Invoice Overdue Reminder</h1></div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello,<br>We would like to remind you that you have an unpaid invoice {INVOICE_FULL_ID}. We kindly request you to pay the invoice as soon as possible.&nbsp;</p>\n<p><span>If you have already submitted the payment, please ignore this email.</span></p><p><span><br></span></p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Invoice</a></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(16,'recurring_invoice_creation_reminder','Recurring invoice creation reminder','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>Invoice Creation Reminder</h1></div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello,<br>We would like to remind you that a recurring invoice will be created on {NEXT_RECURRING_DATE}.&nbsp;</p>\n<p><span><br></span></p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Invoice</a></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(17,'project_task_deadline_reminder','Project task deadline reminder','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>{APP_TITLE}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello,</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">This is to remind you that there are some tasks which deadline is {DEADLINE}.</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">{TASKS_LIST}</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>  </div> </div></div>','','default','',0),(18,'estimate_sent','New estimate','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>ESTIMATE #{ESTIMATE_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding-top: 20px;padding-right: 18px;padding-bottom: 0;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><p> Hello {CONTACT_FIRST_NAME},<br></p><p>Here is the estimate. Please check the attachment.</p><p></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{ESTIMATE_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Estimate</a></td></tr></tbody></table></td></tr></tbody></table> <p></p></td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> {SIGNATURE} </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(19,'estimate_request_received','Estimate request received','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>ESTIMATE REQUEST #{ESTIMATE_REQUEST_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 20px 18px 0px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"><p style=\"color: rgb(96, 96, 96); font-family: Arial; font-size: 15px;\"><span style=\"background-color: transparent;\">A new estimate request has been received from {CONTACT_FIRST_NAME}.</span><br></p><p style=\"color: rgb(96, 96, 96); font-family: Arial; font-size: 15px;\"></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{ESTIMATE_REQUEST_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Estimate Request</a></td></tr></tbody></table></td></tr></tbody></table> <p></p></td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> {SIGNATURE} </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(20,'estimate_rejected','Estimate rejected','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>ESTIMATE #{ESTIMATE_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 20px 18px 0px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"><p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">The estimate #{ESTIMATE_ID} has been rejected.</span></font><br></p><p style=\"color: rgb(96, 96, 96); font-family: Arial; font-size: 15px;\"></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{ESTIMATE_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Estimate</a></td></tr></tbody></table></td></tr></tbody></table> <p></p></td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> {SIGNATURE} </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(21,'estimate_accepted','Estimate accepted','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>ESTIMATE #{ESTIMATE_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 20px 18px 0px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"><p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">The estimate #{ESTIMATE_ID} has been accepted.</span></font><br></p><p style=\"color: rgb(96, 96, 96); font-family: Arial; font-size: 15px;\"></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{ESTIMATE_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Estimate</a></td></tr></tbody></table></td></tr></tbody></table> <p></p></td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> {SIGNATURE} </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(22,'new_client_greetings','Welcome!','<div style=\"background-color: #eeeeef; padding: 50px 0; \">    <div style=\"max-width:640px; margin:0 auto; \">  <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Welcome to {COMPANY_NAME}</h1> </div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">            <p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello {CONTACT_FIRST_NAME},</span></p><p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Thank you for creating your account. </span></p><p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">We are happy to see you here.<br></span></p><hr><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">Dashboard URL:&nbsp;<a href=\"{DASHBOARD_URL}\" target=\"_blank\">{DASHBOARD_URL}</a></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\"></p><p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Email: {CONTACT_LOGIN_EMAIL}</span><br></p><p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Password:&nbsp;{CONTACT_LOGIN_PASSWORD}</span></p><p style=\"color: rgb(85, 85, 85);\"><br></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>        </div>    </div></div>','','default','',0),(23,'verify_email','Please verify your email','<div style=\"background-color: #eeeeef; padding: 50px 0; \"><div style=\"max-width:640px; margin:0 auto; \"><div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Account verification</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255); color:#555;\"><p style=\"font-size: 14px;\">To initiate the signup process, please click on the following link:<br></p><p style=\"font-size: 14px;\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{VERIFY_EMAIL_URL}\" target=\"_blank\">Verify Email</a></span></p>  <p style=\"font-size: 14px;\"><br></p><p style=\"\"><span style=\"font-size: 14px;\">If you did not initiate the request, you do not need to take any further action and can safely disregard this email.</span></p><p style=\"\"><span style=\"font-size: 14px;\"><br></span></p><p style=\"font-size: 14px;\">{SIGNATURE}</p></div></div></div>','','default','',0),(24,'new_order_received','New order received','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>ORDER #{ORDER_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">A new order has been received from&nbsp;</span><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">{CONTACT_FIRST_NAME} and is attached here.</span><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{ORDER_URL}\" target=\"_blank\">Show Order</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(25,'order_status_updated','Order status updated','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>ORDER #{ORDER_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello {CONTACT_FIRST_NAME},</span><br></p><p><span style=\"font-size: 14px; line-height: 20px;\">Thank you for your business cooperation.</span><br></p><p><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Your order&nbsp;</span><font color=\"#555555\"><span style=\"font-size: 14px;\">has been updated&nbsp;</span></font><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">and is attached here.</span></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{ORDER_URL}\" target=\"_blank\">Show Order</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(26,'proposal_sent','Proposal sent','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>PROPOSAL #{PROPOSAL_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding-top: 20px;padding-right: 18px;padding-bottom: 0;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><p> Hello {CONTACT_FIRST_NAME},<br></p><p>Here is a proposal for you.</p><p></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{PROPOSAL_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Proposal</a></td></tr></tbody></table></td></tr></tbody></table> <p></p></td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><p> </p><p>Public URL: {PUBLIC_PROPOSAL_URL}</p><p><br></p><p>{SIGNATURE} </p></td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(27,'project_completed','Project completed','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Project #{PROJECT_ID}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">The Project #{PROJECT_ID}&nbsp;has been closed by&nbsp;</span><span style=\"line-height: 18.5714px;\">{USER_NAME}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\">Title:&nbsp;</span>{PROJECT_TITLE}</p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{PROJECT_URL}\" target=\"_blank\">Show Project</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"color: rgb(78, 94, 106); font-size: 13.5px;\">{SIGNATURE}</span><br></span></p>   </div>  </div> </div>','','default','',0),(28,'proposal_accepted','Proposal accepted','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>PROPOSAL #{PROPOSAL_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">The proposal #{PROPOSAL_ID} has been accepted.</span><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{PROPOSAL_URL}\" target=\"_blank\">Show Proposal</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(29,'proposal_rejected','Proposal rejected','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>PROPOSAL #{PROPOSAL_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">The proposal #{PROPOSAL_ID} has been rejected.</span><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{PROPOSAL_URL}\" target=\"_blank\">Show Proposal</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(30,'estimate_commented','Estimate  #{ESTIMATE_ID}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Estimate #{ESTIMATE_ID} Replies</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">{COMMENT_CONTENT}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{ESTIMATE_URL}\" target=\"_blank\">Show Estimate</a></span></p></div></div></div>','','default','',0),(31,'contract_sent','Contract sent','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody><tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody><tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding: 40px 18px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <h2 style=\"display: block; margin: 0px; padding: 0px; line-height: 100%; text-align: center;\"><font color=\"#ffffff\" face=\"Arial\"><span style=\"letter-spacing: -1px;\"><b>CONTRACT #{CONTRACT_ID}</b></span></font><br></h2></td></tr></tbody></table></td></tr></tbody></table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody><tr> <td valign=\"top\" style=\"padding-top: 20px;padding-right: 18px;padding-bottom: 0;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><p> Hello {CONTACT_FIRST_NAME},<br></p><p>Here is a contract for you.</p><p></p></td></tr><tr><td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%; text-size-adjust: 100%;\"><tbody><tr><td style=\"padding-top: 15px; padding-bottom: 15px; text-size-adjust: 100%;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"><tbody><tr><td align=\"center\" valign=\"middle\" style=\"font-size: 16px; padding: 10px; text-size-adjust: 100%;\"><a href=\"{CONTRACT_URL}\" target=\"_blank\" style=\"font-weight: bold; line-height: 100%; color: rgb(255, 255, 255); text-size-adjust: 100%; display: block;\">Show Contract</a></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"><p>Public URL: {PUBLIC_CONTRACT_URL}<br></p><p><br></p><p>{SIGNATURE}<br></p></td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0),(32,'contract_accepted','Contract accepted','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>CONTRACT #{CONTRACT_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">The contract #{CONTRACT_ID} has been accepted.</span><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{CONTRACT_URL}\" target=\"_blank\">Show Contract</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(33,'contract_rejected','Contract rejected','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>CONTRACT #{CONTRACT_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px;\">The contract #{CONTRACT_ID} has been rejected.</span><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{CONTRACT_URL}\" target=\"_blank\">Show Contract</a></span></p><p style=\"\"><br></p>  </div> </div></div>','','default','',0),(34,'invoice_manual_payment_added','Manual payment added','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>Payment Added</h1></div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello,<br>A new payment has been added to {INVOICE_FULL_ID}.&nbsp;</p>\n<p>Payment amount: {PAYMENT_AMOUNT}&nbsp;</p>\n<p><span><br></span></p>\n<p><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Invoice</a></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(35,'subscription_request_sent','New subscription request','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h2>{SUBSCRIPTION_TITLE}</h2></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello {CONTACT_FIRST_NAME},</span><br></p><p style=\"\"><span style=\"font-size: 14px;\">You have a new subscription request. Please click here to see the subscription.</span></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{SUBSCRIPTION_URL}\" target=\"_blank\">Show Subscription</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>  </div> </div></div>','','default','',0),(36,'announcement_created','{ANNOUNCEMENT_TITLE}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Announcement: {ANNOUNCEMENT_TITLE}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">A new announcement has been created by {USER_NAME}.</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{ANNOUNCEMENT_URL}\" target=\"_blank\">Show Announcement</a></span></p></div></div></div>','','default','',0),(37,'task_general','{TASK_TITLE} (Task #{TASK_ID})','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>{EVENT_TITLE}</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>Task:</b> #</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_ID} -&nbsp;</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_TITLE}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>{CONTEXT_LABEL}:</b>&nbsp;</span>{CONTEXT_TITLE}</p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TASK_URL}\" target=\"_blank\">Show Task&nbsp;</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"color: rgb(78, 94, 106); font-size: 13.5px;\">{SIGNATURE}</span><br></span></p>   </div>  </div> </div>','','default','',0),(38,'task_assigned','{TASK_TITLE} (Task #{TASK_ID})','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Task assigned</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>{USER_NAME}</b>  Assigned a task to <b>{ASSIGNED_TO_USER_NAME}</b></span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>Task:</b> #</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_ID} -&nbsp;</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_TITLE}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>{CONTEXT_LABEL}:</b>&nbsp;</span>{CONTEXT_TITLE}</p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TASK_URL}\" target=\"_blank\">Show Task&nbsp;</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"color: rgb(78, 94, 106); font-size: 13.5px;\">{SIGNATURE}</span><br></span></p>   </div>  </div> </div>','','default','',0),(39,'task_commented','{TASK_TITLE} (Task #{TASK_ID})','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Task commented</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>{USER_NAME}</b>  Commented on a task.</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>Task:</b> #</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_ID} -&nbsp;</span><span style=\"font-weight: var(--bs-body-font-weight); text-align: var(--bs-body-text-align);\">{TASK_TITLE}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><b>{CONTEXT_LABEL}:</b>&nbsp;</span>{CONTEXT_TITLE}</p> <p style=\"\"><br></p> <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{TASK_URL}\" target=\"_blank\">Show Task&nbsp;</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><span style=\"color: rgb(78, 94, 106); font-size: 13.5px;\">{SIGNATURE}</span><br></span></p>   </div>  </div> </div>','','default','',0),(40,'subscription_started','Started a subscription','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h2>{SUBSCRIPTION_TITLE}</h2></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello {CONTACT_FIRST_NAME},</span><br></p><p style=\"\"><span style=\"font-size: 14px;\">A new subscription has been started.&nbsp;</span></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{SUBSCRIPTION_URL}\" target=\"_blank\">Show Subscription</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>  </div> </div></div>','','default','',0),(41,'subscription_invoice_created_via_cron_job','New invoice generated from subscription','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>INVOICE #{INVOICE_ID}</h1></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Hello {CONTACT_FIRST_NAME},</span><br></p><p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\">Thank you for your business cooperation.</span><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Your invoice for the subscription {SUBSCRIPTION_TITLE} has been generated and is attached here.</span></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{INVOICE_URL}\" target=\"_blank\">Show Invoice</a></span></p><p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"\"><span style=\"font-size: 14px; line-height: 20px;\">Invoice balance due is {BALANCE_DUE}</span><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\">Please pay this invoice within {DUE_DATE}.&nbsp;</span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>  </div> </div></div>','','default','',0),(42,'send_credit_note','New credit note','<div style=\"background-color: #eeeeef; padding: 50px 0;\">\n<div style=\"max-width: 640px; margin: 0 auto;\">\n<div style=\"color: #fff; text-align: center; background-color: #33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\">\n<h1>CREDIT NOTE #{CREDIT_NOTE_FULL_ID}</h1></div>\n<div style=\"padding: 20px; background-color: #ffffff; font-size: 14px;\">\n<p>Hello {CONTACT_FIRST_NAME},&nbsp;</p>\n<p>Your invoice {INVOICE_FULL_ID} has been credited.&nbsp;</p>\n<p>Here is the credit note.&nbsp;&nbsp;</p>\n<p><span><br></span></p>\n<p><span style=\"color: #555555; font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{CREDIT_NOTE_URL}\" target=\"_blank\" rel=\"noopener\" aria-invalid=\"true\">Show Credit Note</a></span></p>\n<p>&nbsp;</p>\n<p>{SIGNATURE}</p>\n</div>\n</div>\n</div>','','default','',0),(43,'subscription_cancelled','Subscription cancelled','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h2>{SUBSCRIPTION_TITLE}</h2></div> <div style=\"padding: 20px; background-color: rgb(255, 255, 255);\">  <p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">The subscription {SUBSCRIPTION_TITLE} has been cancelled by {CANCELLED_BY}.</span></font><br></p><p style=\"\"><br></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{SUBSCRIPTION_URL}\" target=\"_blank\">Show Subscription</a></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><br></span></p><p style=\"color: rgb(85, 85, 85); font-size: 14px;\">{SIGNATURE}</p>  </div> </div></div>','','default','',0),(44,'proposal_commented','Proposal #{PROPOSAL_ID}','<div style=\"background-color: #eeeeef; padding: 50px 0; \"> <div style=\"max-width:640px; margin:0 auto; \"> <div style=\"color: #fff; text-align: center; background-color:#33333e; padding: 30px; border-top-left-radius: 3px; border-top-right-radius: 3px; margin: 0;\"><h1>Proposal #{PROPOSAL_ID} Replies</h1></div><div style=\"padding: 20px; background-color: rgb(255, 255, 255);\"><p style=\"\"><span style=\"line-height: 18.5714px;\">{COMMENT_CONTENT}</span></p><p style=\"\"><span style=\"line-height: 18.5714px;\"><br></span></p><p style=\"\"><span style=\"color: rgb(85, 85, 85); font-size: 14px; line-height: 20px;\"><a style=\"background-color: #00b393; padding: 10px 15px; color: #ffffff;\" href=\"{PROPOSAL_URL}\" target=\"_blank\">Show Proposal</a></span></p></div></div></div>','','default','',0),(45,'subscription_renewal_reminder','Subscription Renewal Reminder','<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #EEEEEE;border-top: 0;border-bottom: 0;\"> <tbody> <tr> <td align=\"center\" valign=\"top\" style=\"padding-top: 30px;padding-right: 10px;padding-bottom: 30px;padding-left: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"600\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td align=\"center\" valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #33333e; max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody> <tr> <td valign=\"top\" style=\"padding-top: 40px;padding-right: 18px;padding-bottom: 40px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> <h2 style=\"display: block;margin: 0;padding: 0;font-family: Arial;font-size: 30px;font-style: normal;font-weight: bold;line-height: 100%;letter-spacing: -1px;text-align: center;color: #ffffff !important;\">Subscription Renewal Reminder</h2> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td valign=\"top\" style=\"mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width: 100%;min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\" width=\"100%\"> <tbody> <tr> <td valign=\"top\" style=\"padding: 20px 18px 0px; text-size-adjust: 100%; word-break: break-word; line-height: 150%; text-align: left;\"> <p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">This is a reminder that your subscription:&nbsp;<b>{SUBSCRIPTION_TITLE}</b></span></font><font color=\"#606060\" face=\"Arial\" style=\"font-weight: var(--bs-body-font-weight);\"><span style=\"font-size: 15px;\">&nbsp;</span></font><font color=\"#606060\" face=\"Arial\" style=\"font-weight: var(--bs-body-font-weight);\"><span style=\"font-size: 15px;\">will renew soon. Please ensure that your payment details are up to date to avoid any interruptions in your service.</span></font></p> <p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\"><br></span></font></p> <p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">If you have already renewed your subscription, please ignore this email. </span></font></p> <p style=\"\"><font color=\"#606060\" face=\"Arial\"><span style=\"font-size: 15px;\">Thank you for your continued support.</span></font><br></p> </td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"min-width: 100%;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td style=\"padding-top: 15px;padding-right: 0x;padding-bottom: 15px;padding-left: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: separate !important;border-radius: 2px;background-color: #00b393;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <tbody> <tr> <td align=\"center\" valign=\"middle\" style=\"font-family: Arial;font-size: 16px;padding: 10px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;\"> <a href=\"{SUBSCRIPTION_URL}\" target=\"_blank\" style=\"font-weight: bold;letter-spacing: normal;line-height: 100%;text-align: center;text-decoration: none;color: #FFFFFF;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;display: block;\">View Subscription</a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <p></p> </td> </tr> <tr> <td valign=\"top\" style=\"padding-top: 0px;padding-right: 18px;padding-bottom: 20px;padding-left: 18px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;word-break: break-word;color: #606060;font-family: Arial;font-size: 15px;line-height: 150%;text-align: left;\"> {SIGNATURE} </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table>','','default','',0);
/*!40000 ALTER TABLE `ikontrol_email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_estimate_comments`
--

DROP TABLE IF EXISTS `ikontrol_estimate_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_estimate_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `description` mediumtext NOT NULL,
  `estimate_id` int(11) NOT NULL DEFAULT 0,
  `files` longtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_estimate_comments`
--

LOCK TABLES `ikontrol_estimate_comments` WRITE;
/*!40000 ALTER TABLE `ikontrol_estimate_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_estimate_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_estimate_forms`
--

DROP TABLE IF EXISTS `ikontrol_estimate_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_estimate_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` longtext NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `public` tinyint(1) NOT NULL DEFAULT 0,
  `enable_attachment` tinyint(4) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_estimate_forms`
--

LOCK TABLES `ikontrol_estimate_forms` WRITE;
/*!40000 ALTER TABLE `ikontrol_estimate_forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_estimate_forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_estimate_items`
--

DROP TABLE IF EXISTS `ikontrol_estimate_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_estimate_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `estimate_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_estimate_items`
--

LOCK TABLES `ikontrol_estimate_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_estimate_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_estimate_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_estimate_requests`
--

DROP TABLE IF EXISTS `ikontrol_estimate_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_estimate_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `estimate_form_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `client_id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `status` enum('new','processing','hold','canceled','estimated') NOT NULL DEFAULT 'new',
  `files` mediumtext NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_estimate_requests`
--

LOCK TABLES `ikontrol_estimate_requests` WRITE;
/*!40000 ALTER TABLE `ikontrol_estimate_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_estimate_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_estimates`
--

DROP TABLE IF EXISTS `ikontrol_estimates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_estimates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `estimate_request_id` int(11) NOT NULL DEFAULT 0,
  `estimate_date` date NOT NULL,
  `valid_until` date NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `last_email_sent_date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `converted_sale_id` bigint(20) unsigned DEFAULT NULL,
  `converted_at` datetime DEFAULT NULL,
  `converted_by` bigint(20) unsigned DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancelled_by` bigint(20) unsigned DEFAULT NULL,
  `cancellation_reason` varchar(500) DEFAULT NULL,
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `discount_type` enum('before_tax','after_tax') NOT NULL,
  `discount_amount` double NOT NULL,
  `discount_amount_type` enum('percentage','fixed_amount') NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `accepted_by` int(11) NOT NULL DEFAULT 0,
  `meta_data` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `signature` text NOT NULL,
  `public_key` text NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_estimates`
--

LOCK TABLES `ikontrol_estimates` WRITE;
/*!40000 ALTER TABLE `ikontrol_estimates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_estimates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_event_tracker`
--

DROP TABLE IF EXISTS `ikontrol_event_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_event_tracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(255) NOT NULL,
  `context` varchar(255) NOT NULL,
  `context_id` int(11) NOT NULL,
  `read_count` int(11) DEFAULT NULL,
  `status` enum('new','read') DEFAULT 'new',
  `last_read_time` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `logs` text DEFAULT NULL,
  `random_id` varchar(10) NOT NULL,
  `deleted` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_event_tracker`
--

LOCK TABLES `ikontrol_event_tracker` WRITE;
/*!40000 ALTER TABLE `ikontrol_event_tracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_event_tracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_events`
--

DROP TABLE IF EXISTS `ikontrol_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` mediumtext NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `location` mediumtext DEFAULT NULL,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `labels` text NOT NULL,
  `share_with` mediumtext DEFAULT NULL,
  `editable_google_event` tinyint(1) NOT NULL DEFAULT 0,
  `google_event_id` text NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `lead_id` int(11) NOT NULL DEFAULT 0,
  `ticket_id` int(11) NOT NULL DEFAULT 0,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `task_id` int(11) NOT NULL DEFAULT 0,
  `proposal_id` int(11) NOT NULL DEFAULT 0,
  `contract_id` int(11) NOT NULL DEFAULT 0,
  `subscription_id` int(11) NOT NULL DEFAULT 0,
  `invoice_id` int(11) NOT NULL DEFAULT 0,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `estimate_id` int(11) NOT NULL DEFAULT 0,
  `related_user_id` int(11) NOT NULL DEFAULT 0,
  `next_recurring_time` datetime DEFAULT NULL,
  `no_of_cycles_completed` int(11) NOT NULL DEFAULT 0,
  `snoozing_time` datetime DEFAULT NULL,
  `reminder_status` enum('new','shown','done') NOT NULL DEFAULT 'new',
  `type` enum('event','reminder') NOT NULL DEFAULT 'event',
  `color` varchar(15) NOT NULL,
  `recurring` int(11) NOT NULL DEFAULT 0,
  `repeat_every` int(11) NOT NULL DEFAULT 0,
  `repeat_type` enum('days','weeks','months','years') DEFAULT NULL,
  `no_of_cycles` int(11) NOT NULL DEFAULT 0,
  `last_start_date` date DEFAULT NULL,
  `recurring_dates` longtext NOT NULL,
  `confirmed_by` text NOT NULL,
  `rejected_by` text NOT NULL,
  `files` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `project_id` (`project_id`),
  KEY `task_id` (`task_id`),
  KEY `recurring` (`recurring`),
  KEY `start_date` (`start_date`),
  KEY `end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_events`
--

LOCK TABLES `ikontrol_events` WRITE;
/*!40000 ALTER TABLE `ikontrol_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_expense_categories`
--

DROP TABLE IF EXISTS `ikontrol_expense_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_expense_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_expense_categories`
--

LOCK TABLES `ikontrol_expense_categories` WRITE;
/*!40000 ALTER TABLE `ikontrol_expense_categories` DISABLE KEYS */;
INSERT INTO `ikontrol_expense_categories` VALUES (1,'Miscellaneous expense',0);
/*!40000 ALTER TABLE `ikontrol_expense_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_expenses`
--

DROP TABLE IF EXISTS `ikontrol_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_date` date NOT NULL,
  `category_id` int(11) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `amount` double NOT NULL,
  `files` mediumtext NOT NULL,
  `title` text NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `recurring` tinyint(4) NOT NULL DEFAULT 0,
  `recurring_expense_id` tinyint(4) NOT NULL DEFAULT 0,
  `repeat_every` int(11) NOT NULL DEFAULT 0,
  `repeat_type` enum('days','weeks','months','years') DEFAULT NULL,
  `no_of_cycles` int(11) NOT NULL DEFAULT 0,
  `next_recurring_date` date DEFAULT NULL,
  `no_of_cycles_completed` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_expenses`
--

LOCK TABLES `ikontrol_expenses` WRITE;
/*!40000 ALTER TABLE `ikontrol_expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_file_category`
--

DROP TABLE IF EXISTS `ikontrol_file_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_file_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `type` enum('project') NOT NULL DEFAULT 'project',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_file_category`
--

LOCK TABLES `ikontrol_file_category` WRITE;
/*!40000 ALTER TABLE `ikontrol_file_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_file_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_cancellation_artifacts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_cancellation_artifacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_cancellation_artifacts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_cancellation_request_id` bigint(20) unsigned NOT NULL,
  `fiscal_cancellation_attempt_id` bigint(20) unsigned NOT NULL,
  `artifact_type` varchar(30) NOT NULL DEFAULT 'cancellation_ack',
  `content_encoding` varchar(20) NOT NULL DEFAULT 'base64',
  `content_base64` longtext NOT NULL,
  `decoded_mime_type` varchar(80) NOT NULL,
  `decoded_size_bytes` bigint(20) unsigned NOT NULL,
  `decoded_sha256` char(64) NOT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fiscal_cancellation_request_id_artifact_type` (`fiscal_cancellation_request_id`,`artifact_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_cancellation_artifacts`
--

LOCK TABLES `ikontrol_fiscal_cancellation_artifacts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_artifacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_artifacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_cancellation_attempts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_cancellation_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_cancellation_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_cancellation_request_id` bigint(20) unsigned NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'prepared',
  `provider_code` varchar(100) DEFAULT NULL,
  `provider_message` text DEFAULT NULL,
  `response_hash` char(64) DEFAULT NULL,
  `requires_reconciliation` tinyint(1) NOT NULL DEFAULT 0,
  `started_at` datetime NOT NULL,
  `responded_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fiscal_cancellation_request_id` (`fiscal_cancellation_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_cancellation_attempts`
--

LOCK TABLES `ikontrol_fiscal_cancellation_attempts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_cancellation_requests`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_cancellation_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_cancellation_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `fiscal_document_stamp_id` bigint(20) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `issuer_rfc` varchar(20) NOT NULL,
  `receiver_rfc` varchar(20) NOT NULL,
  `total` decimal(18,6) NOT NULL,
  `cancellation_reason` char(2) NOT NULL,
  `replacement_uuid` char(36) DEFAULT NULL,
  `provider` varchar(40) NOT NULL,
  `environment` varchar(20) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'requested',
  `provider_code` varchar(100) DEFAULT NULL,
  `provider_message` text DEFAULT NULL,
  `requested_at` datetime NOT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `idempotency_key` char(64) NOT NULL,
  `requires_reconciliation` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idempotency_key` (`idempotency_key`),
  KEY `fiscal_document_id_status` (`fiscal_document_id`,`status`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_cancellation_requests`
--

LOCK TABLES `ikontrol_fiscal_cancellation_requests` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_cancellation_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_artifacts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_artifacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_artifacts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `artifact_type` varchar(30) NOT NULL DEFAULT 'pre_xml',
  `storage_path` varchar(255) NOT NULL,
  `sha256` char(64) NOT NULL,
  `byte_size` bigint(20) unsigned NOT NULL,
  `builder_version` varchar(20) NOT NULL,
  `schema_version` varchar(20) NOT NULL,
  `schema_sha256` char(64) DEFAULT NULL,
  `validation_status` varchar(40) NOT NULL,
  `validation_payload` longtext DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `superseded_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_artifact_idempotency` (`fiscal_document_id`,`artifact_type`,`builder_version`,`sha256`),
  KEY `idx_fiscal_artifact_active` (`fiscal_document_id`,`artifact_type`,`superseded_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_artifacts`
--

LOCK TABLES `ikontrol_fiscal_document_artifacts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_artifacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_artifacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_audit`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned DEFAULT NULL,
  `invoice_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `action` varchar(40) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `previous_hash` char(64) DEFAULT NULL,
  `new_hash` char(64) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fiscal_document_id_created_at` (`fiscal_document_id`,`created_at`),
  KEY `invoice_id_created_at` (`invoice_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_audit`
--

LOCK TABLES `ikontrol_fiscal_document_audit` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_binary_artifacts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_binary_artifacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_binary_artifacts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `stamp_attempt_id` bigint(20) unsigned NOT NULL,
  `pdf_generation_attempt_id` bigint(20) unsigned DEFAULT NULL,
  `artifact_type` varchar(30) NOT NULL,
  `content_encoding` varchar(20) NOT NULL DEFAULT 'base64',
  `content_base64` longtext NOT NULL,
  `decoded_mime_type` varchar(80) NOT NULL,
  `decoded_size_bytes` bigint(20) unsigned NOT NULL,
  `decoded_sha256` char(64) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `template` varchar(80) DEFAULT NULL,
  `template_code` varchar(40) DEFAULT NULL,
  `uuid` char(36) NOT NULL,
  `validation_status` varchar(30) NOT NULL,
  `artifact_status` varchar(20) DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `superseded_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stamp_attempt_id` (`stamp_attempt_id`),
  KEY `uuid` (`uuid`),
  KEY `idx_fiscal_binary_active` (`fiscal_document_id`,`artifact_type`,`artifact_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_binary_artifacts`
--

LOCK TABLES `ikontrol_fiscal_document_binary_artifacts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_binary_artifacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_binary_artifacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_issuers`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_issuers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_issuers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `rfc` varchar(13) NOT NULL,
  `legal_name` varchar(254) NOT NULL,
  `tax_regime_code` varchar(5) NOT NULL,
  `fiscal_postal_code` varchar(5) NOT NULL,
  `expedition_postal_code` varchar(5) NOT NULL,
  `country_code` char(3) NOT NULL DEFAULT 'MEX',
  `street` varchar(255) DEFAULT NULL,
  `external_number` varchar(30) DEFAULT NULL,
  `internal_number` varchar(30) DEFAULT NULL,
  `neighborhood` varchar(150) DEFAULT NULL,
  `locality` varchar(150) DEFAULT NULL,
  `municipality` varchar(150) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_issuer` (`fiscal_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_issuers`
--

LOCK TABLES `ikontrol_fiscal_document_issuers` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_issuers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_issuers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_item_taxes`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_item_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_item_taxes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_item_id` bigint(20) unsigned NOT NULL,
  `administrative_tax_id` int(10) unsigned DEFAULT NULL,
  `tax_code` varchar(3) NOT NULL,
  `tax_type` varchar(20) NOT NULL,
  `factor_type` varchar(10) NOT NULL,
  `rate_or_quota` decimal(18,6) DEFAULT NULL,
  `taxable_base` decimal(18,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fiscal_document_item_id_sort_order` (`fiscal_document_item_id`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_item_taxes`
--

LOCK TABLES `ikontrol_fiscal_document_item_taxes` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_item_taxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_item_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_items`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `invoice_item_id` int(10) unsigned DEFAULT NULL,
  `item_id` int(10) unsigned DEFAULT NULL,
  `line_number` int(10) unsigned NOT NULL,
  `product_service_code` varchar(8) NOT NULL,
  `identification_number` varchar(100) DEFAULT NULL,
  `quantity` decimal(18,6) NOT NULL,
  `unit_code` varchar(5) NOT NULL,
  `unit_name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `unit_value` decimal(18,6) NOT NULL,
  `gross_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `tax_object_code` varchar(3) NOT NULL,
  `taxable_base` decimal(18,2) NOT NULL DEFAULT 0.00,
  `transferred_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `withheld_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_line` (`fiscal_document_id`,`line_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_items`
--

LOCK TABLES `ikontrol_fiscal_document_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_metadata`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_metadata` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `metadata_json` longtext NOT NULL,
  `warnings_json` longtext DEFAULT NULL,
  `rules_version` varchar(30) NOT NULL DEFAULT 'ikontrol-fiscal-draft-v1',
  `payment_total_snapshot` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_metadata` (`fiscal_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_metadata`
--

LOCK TABLES `ikontrol_fiscal_document_metadata` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_receivers`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_receivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_receivers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `rfc` varchar(13) NOT NULL,
  `legal_name` varchar(254) NOT NULL,
  `tax_regime_code` varchar(5) NOT NULL,
  `fiscal_postal_code` varchar(5) NOT NULL,
  `cfdi_use_code` varchar(5) NOT NULL,
  `fiscal_residence_country_code` char(3) DEFAULT NULL,
  `foreign_tax_registration` varchar(40) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `external_number` varchar(30) DEFAULT NULL,
  `internal_number` varchar(30) DEFAULT NULL,
  `neighborhood` varchar(150) DEFAULT NULL,
  `locality` varchar(150) DEFAULT NULL,
  `municipality` varchar(150) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_receiver` (`fiscal_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_receivers`
--

LOCK TABLES `ikontrol_fiscal_document_receivers` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_receivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_receivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_relations`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_relations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `source_document_id` bigint(20) unsigned NOT NULL,
  `related_document_id` bigint(20) unsigned NOT NULL,
  `relation_type` varchar(30) NOT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_relation` (`source_document_id`,`related_document_id`,`relation_type`),
  KEY `source_document_id` (`source_document_id`),
  KEY `related_document_id` (`related_document_id`),
  KEY `relation_type` (`relation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_relations`
--

LOCK TABLES `ikontrol_fiscal_document_relations` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_sales`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_sales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `sale_id` bigint(20) unsigned NOT NULL,
  `allocated_subtotal` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocated_tax` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocated_total` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocation_status` varchar(30) NOT NULL DEFAULT 'active',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_sale` (`fiscal_document_id`,`sale_id`),
  KEY `fiscal_document_id` (`fiscal_document_id`),
  KEY `sale_id` (`sale_id`),
  KEY `allocation_status` (`allocation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_sales`
--

LOCK TABLES `ikontrol_fiscal_document_sales` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_signatures`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_signatures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_signatures` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `pre_xml_artifact_id` bigint(20) unsigned NOT NULL,
  `certificate_id` bigint(20) unsigned NOT NULL,
  `original_chain_artifact_id` bigint(20) unsigned NOT NULL,
  `signed_xml_artifact_id` bigint(20) unsigned NOT NULL,
  `pre_xml_sha256` char(64) NOT NULL,
  `original_chain_sha256` char(64) NOT NULL,
  `signed_xml_sha256` char(64) NOT NULL,
  `signature_verified` tinyint(1) NOT NULL DEFAULT 0,
  `xsd_status` varchar(40) NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_signature` (`fiscal_document_id`,`pre_xml_sha256`,`certificate_id`),
  KEY `idx_fiscal_document_signature` (`fiscal_document_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_signatures`
--

LOCK TABLES `ikontrol_fiscal_document_signatures` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_signatures` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_signatures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_stamps`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_stamps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_stamps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `stamp_attempt_id` bigint(20) unsigned NOT NULL,
  `stamped_xml_artifact_id` bigint(20) unsigned NOT NULL,
  `pac_pdf_artifact_id` bigint(20) unsigned DEFAULT NULL,
  `pdf_status` varchar(30) DEFAULT 'pending',
  `pdf_template` varchar(80) DEFAULT NULL,
  `uuid` char(36) NOT NULL,
  `stamp_date` datetime NOT NULL,
  `pac_rfc` varchar(13) NOT NULL,
  `sat_certificate_number` varchar(40) NOT NULL,
  `cfd_seal` text NOT NULL,
  `sat_seal` text NOT NULL,
  `tfd_version` varchar(10) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `environment` varchar(20) NOT NULL,
  `stamped_xml_sha256` char(64) NOT NULL,
  `created_at` datetime NOT NULL,
  `provider_original_chain` mediumtext DEFAULT NULL,
  `sat_original_chain` mediumtext DEFAULT NULL,
  `qr_data` text DEFAULT NULL,
  `auxiliary_warnings` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stamp_document` (`fiscal_document_id`),
  UNIQUE KEY `uq_stamp_uuid` (`uuid`),
  UNIQUE KEY `uq_stamp_artifact` (`stamped_xml_artifact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_stamps`
--

LOCK TABLES `ikontrol_fiscal_document_stamps` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_stamps` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_stamps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_document_tax_totals`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_document_tax_totals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_document_tax_totals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `tax_code` varchar(3) NOT NULL,
  `tax_type` varchar(20) NOT NULL,
  `factor_type` varchar(10) NOT NULL,
  `rate_or_quota` decimal(18,6) DEFAULT NULL,
  `taxable_base` decimal(18,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_tax_total` (`fiscal_document_id`,`tax_code`,`tax_type`,`factor_type`,`rate_or_quota`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_document_tax_totals`
--

LOCK TABLES `ikontrol_fiscal_document_tax_totals` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_tax_totals` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_document_tax_totals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_documents`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` int(10) unsigned NOT NULL,
  `source_draft_id` bigint(20) unsigned DEFAULT NULL,
  `issuer_profile_id` int(10) unsigned NOT NULL,
  `receiver_profile_id` int(10) unsigned NOT NULL,
  `fiscal_series_id` int(10) unsigned NOT NULL,
  `pricing_preparation_id` bigint(20) unsigned DEFAULT NULL,
  `document_type` varchar(20) NOT NULL DEFAULT 'income',
  `status` varchar(30) NOT NULL DEFAULT 'draft',
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `series` varchar(25) NOT NULL DEFAULT '',
  `folio` bigint(20) unsigned NOT NULL,
  `issue_date` datetime NOT NULL,
  `expedition_postal_code` varchar(5) NOT NULL,
  `currency_code` char(3) NOT NULL,
  `exchange_rate` decimal(18,6) DEFAULT NULL,
  `payment_form_code` varchar(3) NOT NULL,
  `payment_method_code` varchar(3) NOT NULL,
  `cfdi_use_code` varchar(5) NOT NULL,
  `export_code` varchar(3) NOT NULL DEFAULT '01',
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `transferred_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `withheld_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `administrative_total_reference` decimal(18,2) NOT NULL DEFAULT 0.00,
  `pricing_mode` varchar(20) NOT NULL,
  `source_snapshot_hash` char(64) NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stamp_updated_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `environment` varchar(20) DEFAULT 'legacy',
  `data_origin` varchar(30) DEFAULT 'operational',
  `is_test_fixture` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_document_folio` (`issuer_profile_id`,`document_type`,`series`,`folio`),
  UNIQUE KEY `uq_fiscal_document_source_draft` (`source_draft_id`),
  KEY `idx_fiscal_document_invoice_status` (`invoice_id`,`status`,`deleted`),
  KEY `idx_fiscal_document_snapshot` (`invoice_id`,`source_snapshot_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_documents`
--

LOCK TABLES `ikontrol_fiscal_documents` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_draft_audit`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_draft_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_draft_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_draft_id` bigint(20) unsigned DEFAULT NULL,
  `sale_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `event` varchar(50) NOT NULL,
  `summary_json` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fiscal_draft_id` (`fiscal_draft_id`),
  KEY `sale_id` (`sale_id`),
  KEY `event` (`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_draft_audit`
--

LOCK TABLES `ikontrol_fiscal_draft_audit` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_draft_item_taxes`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_draft_item_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_draft_item_taxes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_draft_id` bigint(20) unsigned NOT NULL,
  `fiscal_draft_item_id` bigint(20) unsigned NOT NULL,
  `sale_id` bigint(20) unsigned DEFAULT NULL,
  `sale_item_id` bigint(20) unsigned DEFAULT NULL,
  `tax_type` varchar(20) NOT NULL,
  `tax_code` varchar(10) NOT NULL,
  `factor_type` varchar(20) NOT NULL,
  `rate_or_quota` decimal(18,6) DEFAULT NULL,
  `tax_base` decimal(18,6) NOT NULL,
  `tax_amount` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `is_exempt` tinyint(1) NOT NULL DEFAULT 0,
  `calculation_order` int(11) NOT NULL DEFAULT 0,
  `source` varchar(30) NOT NULL DEFAULT 'snapshot',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_draft_item_tax` (`fiscal_draft_item_id`,`tax_type`,`tax_code`,`factor_type`,`rate_or_quota`),
  KEY `fiscal_draft_id` (`fiscal_draft_id`),
  KEY `fiscal_draft_item_id` (`fiscal_draft_item_id`),
  KEY `sale_id` (`sale_id`),
  KEY `sale_item_id` (`sale_item_id`),
  KEY `tax_type` (`tax_type`),
  KEY `tax_code` (`tax_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_draft_item_taxes`
--

LOCK TABLES `ikontrol_fiscal_draft_item_taxes` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_item_taxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_item_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_draft_items`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_draft_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_draft_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_draft_id` bigint(20) unsigned NOT NULL,
  `sale_id` bigint(20) unsigned NOT NULL,
  `sale_item_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned DEFAULT NULL,
  `quantity` decimal(18,6) NOT NULL,
  `unit_price` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `discount` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `subtotal` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `tax` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `total` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `fiscal_snapshot` longtext NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_draft_sale_item` (`fiscal_draft_id`,`sale_item_id`),
  KEY `fiscal_draft_id` (`fiscal_draft_id`),
  KEY `sale_id` (`sale_id`),
  KEY `sale_item_id` (`sale_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_draft_items`
--

LOCK TABLES `ikontrol_fiscal_draft_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_draft_sales`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_draft_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_draft_sales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_draft_id` bigint(20) unsigned NOT NULL,
  `sale_id` bigint(20) unsigned NOT NULL,
  `allocated_subtotal` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocated_tax` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocated_total` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `allocation_status` varchar(30) NOT NULL DEFAULT 'reserved',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_draft_sale` (`fiscal_draft_id`,`sale_id`),
  KEY `fiscal_draft_id` (`fiscal_draft_id`),
  KEY `sale_id` (`sale_id`),
  KEY `allocation_status` (`allocation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_draft_sales`
--

LOCK TABLES `ikontrol_fiscal_draft_sales` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_draft_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_drafts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_drafts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned DEFAULT NULL,
  `issuer_id` bigint(20) unsigned NOT NULL,
  `customer_id` bigint(20) unsigned NOT NULL,
  `document_type` char(1) NOT NULL DEFAULT 'I',
  `provisional_series` varchar(25) NOT NULL DEFAULT '',
  `issue_date` datetime NOT NULL,
  `currency_code` char(3) NOT NULL DEFAULT 'MXN',
  `exchange_rate` decimal(18,6) NOT NULL DEFAULT 1.000000,
  `payment_form_code` varchar(3) DEFAULT NULL,
  `payment_method_code` varchar(3) DEFAULT NULL,
  `cfdi_use_code` varchar(5) NOT NULL,
  `receiver_tax_regime_code` varchar(5) NOT NULL,
  `receiver_postal_code` varchar(5) NOT NULL,
  `expedition_postal_code` varchar(5) NOT NULL,
  `subtotal` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `discount` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `tax_total` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `total` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `fiscal_payload` longtext NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'draft',
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `receiver_profile_id` bigint(20) unsigned DEFAULT NULL,
  `fiscal_series_id` bigint(20) unsigned DEFAULT NULL,
  `conditions` varchar(255) DEFAULT NULL,
  `observations` text DEFAULT NULL,
  `discarded_reason` varchar(500) DEFAULT NULL,
  `discarded_at` datetime DEFAULT NULL,
  `ready_at` datetime DEFAULT NULL,
  `snapshot_version` int(11) DEFAULT 1,
  `requires_snapshot_refresh` tinyint(1) DEFAULT 0,
  `snapshot_completed_at` datetime DEFAULT NULL,
  `environment` varchar(20) DEFAULT 'legacy',
  `data_origin` varchar(30) DEFAULT 'operational',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_draft_document` (`fiscal_document_id`),
  KEY `issuer_id_status` (`issuer_id`,`status`),
  KEY `customer_id_status` (`customer_id`,`status`),
  KEY `issue_date` (`issue_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_drafts`
--

LOCK TABLES `ikontrol_fiscal_drafts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_drafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_issuer_certificate_secret_audit`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_issuer_certificate_secret_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_issuer_certificate_secret_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_issuer_certificate_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `result` varchar(20) NOT NULL,
  `error_code` varchar(60) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fiscal_issuer_certificate_id_created_at` (`fiscal_issuer_certificate_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_issuer_certificate_secret_audit`
--

LOCK TABLES `ikontrol_fiscal_issuer_certificate_secret_audit` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificate_secret_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificate_secret_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_issuer_certificate_secrets`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_issuer_certificate_secrets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_issuer_certificate_secrets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_issuer_certificate_id` bigint(20) unsigned NOT NULL,
  `secret_type` varchar(40) NOT NULL DEFAULT 'private_key_password',
  `encrypted_payload` longtext NOT NULL,
  `encryption_version` varchar(30) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `validated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `rotated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_csd_certificate_secret_type` (`fiscal_issuer_certificate_id`,`secret_type`),
  KEY `fiscal_issuer_certificate_id_status` (`fiscal_issuer_certificate_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_issuer_certificate_secrets`
--

LOCK TABLES `ikontrol_fiscal_issuer_certificate_secrets` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificate_secrets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificate_secrets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_issuer_certificates`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_issuer_certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_issuer_certificates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issuer_profile_id` int(10) unsigned NOT NULL,
  `certificate_number` varchar(40) NOT NULL,
  `certificate_serial_hex` varchar(128) DEFAULT NULL,
  `certificate_subject` varchar(500) NOT NULL,
  `certificate_rfc` varchar(13) NOT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `certificate_sha256` char(64) NOT NULL,
  `public_certificate_path` varchar(255) NOT NULL,
  `encrypted_private_key_path` varchar(255) NOT NULL,
  `private_key_sha256` char(64) NOT NULL,
  `encryption_key_version` varchar(20) NOT NULL DEFAULT 'password-v1',
  `status` varchar(30) NOT NULL DEFAULT 'pending_validation',
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_issuer_certificate_hash` (`issuer_profile_id`,`certificate_sha256`),
  KEY `idx_issuer_certificate_status` (`issuer_profile_id`,`status`,`is_default`,`deleted`),
  KEY `idx_issuer_certificate_validity` (`valid_from`,`valid_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_issuer_certificates`
--

LOCK TABLES `ikontrol_fiscal_issuer_certificates` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_issuer_pdf_templates`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_issuer_pdf_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_issuer_pdf_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issuer_id` bigint(20) unsigned NOT NULL,
  `provider` varchar(40) NOT NULL,
  `document_type` char(1) NOT NULL,
  `template_code` varchar(40) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_pdf_template` (`issuer_id`,`provider`,`document_type`),
  KEY `issuer_id` (`issuer_id`),
  KEY `provider` (`provider`),
  KEY `document_type` (`document_type`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_issuer_pdf_templates`
--

LOCK TABLES `ikontrol_fiscal_issuer_pdf_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_pdf_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_issuer_pdf_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_pac_configurations`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_pac_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_pac_configurations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(40) NOT NULL,
  `environment` varchar(20) NOT NULL,
  `base_url` varchar(255) NOT NULL,
  `encrypted_api_key` text NOT NULL,
  `api_key_last_four` varchar(4) NOT NULL,
  `connection_timeout_seconds` int(10) unsigned NOT NULL DEFAULT 10,
  `request_timeout_seconds` int(10) unsigned NOT NULL DEFAULT 45,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_tested_at` datetime DEFAULT NULL,
  `last_test_status` varchar(30) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pac_provider_environment` (`provider`,`environment`),
  KEY `idx_pac_default` (`environment`,`is_active`,`is_default`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_pac_configurations`
--

LOCK TABLES `ikontrol_fiscal_pac_configurations` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_pac_configurations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_pac_configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_payment_method_mappings`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_payment_method_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_payment_method_mappings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_method_id` int(10) unsigned NOT NULL,
  `sat_payment_form_code` varchar(3) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_payment_method_mapping` (`payment_method_id`),
  KEY `idx_fiscal_payment_form_mapping` (`sat_payment_form_code`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_payment_method_mappings`
--

LOCK TABLES `ikontrol_fiscal_payment_method_mappings` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_payment_method_mappings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_payment_method_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_pdf_generation_attempts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_pdf_generation_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_pdf_generation_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` bigint(20) unsigned NOT NULL,
  `stamp_id` bigint(20) unsigned NOT NULL,
  `stamp_attempt_id` bigint(20) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `provider` varchar(40) NOT NULL,
  `environment` varchar(20) NOT NULL,
  `template_code` varchar(40) NOT NULL,
  `status` varchar(30) NOT NULL,
  `provider_code` varchar(50) DEFAULT NULL,
  `provider_message` text DEFAULT NULL,
  `request_sent` tinyint(1) NOT NULL DEFAULT 0,
  `retryable` tinyint(1) NOT NULL DEFAULT 0,
  `requires_reconciliation` tinyint(1) NOT NULL DEFAULT 0,
  `idempotency_key` char(64) NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_pdf_attempt_idempotency` (`idempotency_key`),
  KEY `document_id` (`document_id`),
  KEY `stamp_id` (`stamp_id`),
  KEY `stamp_attempt_id` (`stamp_attempt_id`),
  KEY `uuid` (`uuid`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_pdf_generation_attempts`
--

LOCK TABLES `ikontrol_fiscal_pdf_generation_attempts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_pdf_generation_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_pdf_generation_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_pdf_template_audit`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_pdf_template_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_pdf_template_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` bigint(20) unsigned NOT NULL,
  `issuer_id` bigint(20) unsigned NOT NULL,
  `action` varchar(40) NOT NULL,
  `old_template_code` varchar(40) DEFAULT NULL,
  `new_template_code` varchar(40) DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `template_id` (`template_id`),
  KEY `issuer_id` (`issuer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_pdf_template_audit`
--

LOCK TABLES `ikontrol_fiscal_pdf_template_audit` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_pdf_template_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_pdf_template_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_profiles`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_profiles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profile_type` varchar(20) NOT NULL DEFAULT 'receiver',
  `client_id` int(10) unsigned DEFAULT NULL,
  `company_id` int(10) unsigned DEFAULT NULL,
  `rfc` varchar(13) DEFAULT NULL,
  `legal_name` varchar(254) DEFAULT NULL,
  `tax_regime_id` int(10) unsigned DEFAULT NULL,
  `fiscal_postal_code` varchar(5) DEFAULT NULL,
  `default_cfdi_use_id` int(10) unsigned DEFAULT NULL,
  `tax_residency_country` char(3) DEFAULT NULL,
  `foreign_tax_registration` varchar(40) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `fiscal_street` varchar(255) DEFAULT NULL,
  `fiscal_external_number` varchar(40) DEFAULT NULL,
  `fiscal_internal_number` varchar(40) DEFAULT NULL,
  `fiscal_neighborhood` varchar(180) DEFAULT NULL,
  `fiscal_locality` varchar(180) DEFAULT NULL,
  `fiscal_municipality` varchar(180) DEFAULT NULL,
  `fiscal_state` varchar(180) DEFAULT NULL,
  `fiscal_country_code` char(3) DEFAULT NULL,
  `fiscal_address_reference` varchar(500) DEFAULT NULL,
  `trade_name` varchar(254) DEFAULT NULL,
  `expedition_postal_code` varchar(5) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `tax_pricing_mode` varchar(20) DEFAULT NULL,
  `allow_sale_tax_pricing_override` tinyint(1) DEFAULT 0,
  `environment` varchar(20) DEFAULT 'legacy',
  PRIMARY KEY (`id`),
  KEY `client_id_profile_type_status` (`client_id`,`profile_type`,`status`),
  KEY `client_id_is_default` (`client_id`,`is_default`),
  KEY `tax_regime_id` (`tax_regime_id`),
  KEY `default_cfdi_use_id` (`default_cfdi_use_id`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_profiles`
--

LOCK TABLES `ikontrol_fiscal_profiles` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_profiles` DISABLE KEYS */;
INSERT INTO `ikontrol_fiscal_profiles` VALUES (2,'issuer',NULL,1,'DOLD860620EW7','DENNISSE MILDRETH DOMINGUEZ LOPEZ',5,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','2','230',NULL,'VISTA ALEGRE NORTE','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,'97130',NULL,NULL,NULL,0,'preview'),(3,'receiver',1,NULL,'RMA110113DF8','Rial marketing , S.A de C.V',1,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','19 x 20 y 22','#106',NULL,'Col. Mexico',NULL,'Merida','Yucatan','MEX',NULL,NULL,NULL,'milcabrera05@hotmail.com',NULL,NULL,0,'preview'),(4,'receiver',2,NULL,'FBE930202QFA','FINANCIERA BEPENSA',NULL,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','56 B','452',NULL,'Itzimna','Merida','Merida','Yucatan','MEX',NULL,NULL,NULL,'aespadasp@bepensa.com','982-2827',NULL,0,'preview'),(5,'receiver',3,NULL,'UMA870531DG9','UNIVERSIDAD DEL MAYAB',2,'97308',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KM 15.5 CARRET. MERIDA A PROGRESO',NULL,'KM2','CARRT A CHABLEKAL',NULL,'MERIDA','MERIDA','MEX',NULL,NULL,NULL,'mariela.agruelles@anahuac.mx',NULL,NULL,0,'preview'),(6,'receiver',4,NULL,'CPS030331E56','COMERCIALIZADORA DE PILAS DEL SURESTE SA DE CV',NULL,'97050',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','21  entre 16 y 18','91a',NULL,'YUCATAN','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'capetoss@hotmail.com','9991119279',NULL,0,'preview'),(7,'receiver',5,NULL,'DMT8308307R4','DESTROYER MEXICANA DE TAMPICO SA DE CV',NULL,'89000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BENITO JUAREZ','117','A SUR','CENTRO','TAMPICO','TAMPICO','TAMPICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(8,'receiver',6,NULL,'SHA840512SX1','SECRETARIA DE ADMINISTRACION Y FINANZAS',NULL,'97000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','59','S/N',NULL,'CENTRO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(9,'receiver',7,NULL,'IIC991117V18','INSTITUTO YUCATECO DE EMPRENDEDORES',NULL,'97110',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AV PRINCIPAL INDUSTRIAS NO CONTAMINANTES','13613',NULL,'SODZIL NORTE SR','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(10,'receiver',8,NULL,'ACA080812GZ0','ARRIGUNAGA CANO SC',NULL,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Calle 29  por 34 y 36','#348',NULL,'Fraccionamiento Montecarlo',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'bolsadetrabajo@arrigunagacano.com.mx','9991759330',NULL,0,'preview'),(11,'receiver',9,NULL,'SSH160210AP0','SUM SHOP SAPI DE CV',NULL,'06700',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','COLIMA','107','2','ROMA NORTE',NULL,'CD. DE MEXICO','MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(12,'receiver',10,NULL,'SOL151021P60','SOLDAI SAPI  DE CV',NULL,'06600',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','VARSOVIA','44','1202','JUAREZ','CUAUHTEMOC','CUAUHTEMOC','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(13,'receiver',11,NULL,'GES090320UU3','GRUPO EDITORIAL DEL SURESTE SA DE CV',NULL,'97109',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 42','454',NULL,'JESUS CARRANZA',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(14,'receiver',12,NULL,'CMC970224II2','CERAMICA Y MATERIALES CONTINENTAL  SAPI DE CV',NULL,'97300',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 11','122',NULL,'SANTA GERTRUDIS COPO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(15,'receiver',13,NULL,'GAMC921219965','MARIA CRISTINA GAMBOA MOLINA',NULL,'97070',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 13','219 X 30',NULL,'GARCIA GINERES','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(16,'receiver',14,NULL,'QUI160629CA8','QUINTATINTA S. DE R.L. DE C. V.',NULL,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 30,  ENTRE 17 Y 19','92 A','LOCAL 3,','MEXICO NORTE','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(17,'receiver',15,NULL,'IAE160919NH8','IMPULSA Y APS EMPRESARIOS',NULL,'97128',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 20 X CALLE 21','96','LOC-7','MEXICO NORTE','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(18,'receiver',16,NULL,'QUGI900928G99','IVAN JESUS QUIÑONES GONZALEZ',NULL,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 30, ENTRE 29 Y Esquina','122A','DEPTO 4','MEXICO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(19,'receiver',17,NULL,'LORV880624PZ2','VIANNEY DEL ROCIO LOPEZ REBOLLEDO',NULL,'24120',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 50','LOTE 2','.','PLAYA NORTE','CD DEL CARMEN','CD DEL CARMEN','CAMPECHE','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(20,'receiver',18,NULL,'FPT130410GG8','FUNDACION PARQUE TECNOLOGICO ANAHUAC MAYAB, SC',NULL,'97302',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARR PROGRESO CHABLEKAL K','.',NULL,'/','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(21,'receiver',19,NULL,'QUI160629CA8','QUINTATINTA S. DE R.L. DE C.V.',NULL,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','30 num','92 entre','loc3 17-19','mexico norte','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'asistente.cafeconsultores@gmail.com','-',NULL,0,'preview'),(22,'receiver',20,NULL,'GCO050824UQ4','GOVA COMUNICACIONES S.A. C.V.',NULL,'97133',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','C. 12 NO. 335','.','.','CAMARA DE COMERCIO NORTE','MÉRIDA','MÉRIDA','YUCATÁN','MEX',NULL,NULL,NULL,'asistente.cafeconsultores@gmail.com','-',NULL,0,'preview'),(23,'receiver',21,NULL,'EMA150119IT9','ESENCIA MAYA S.A. DE C.V.',NULL,'97000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','C. 47 X 60','424','DEPTO. 4','CENTRO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,'9230040',NULL,0,'preview'),(24,'receiver',22,NULL,'CNI420306BI0','CAMARA NACIONAL DE LA INDUSTRIA DEL CALZADO',NULL,'06700',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ALVARO OBREGON','250',NULL,'ROMA','CUAUHTEMOC','CUAUHTEMOC','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,'carmen.castillo@ciceg.org',NULL,NULL,0,'preview'),(25,'receiver',23,NULL,'LUCG4303229B7','GLADYS MARIA LUJAN CANTO',NULL,'97302',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','59','842','8','LAS AMERICAS','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'octadis.contacto@gmail.com',NULL,NULL,0,'preview'),(26,'receiver',24,NULL,'CIN1710067L9','CERN INMOBILIARIA',NULL,'66240',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','LOMAS DEL VALLE','430','2-7','LOMAS DEL VALLE','NUEVO LEON','SAN PEDRO GARA CARGIA N.L','NUEVO LEON','MEX',NULL,NULL,NULL,'mundoferfi@hotmail.com',NULL,NULL,0,'preview'),(27,'receiver',25,NULL,'FFX190926AL1','Fideicomiso F/4075',NULL,'01210',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Guillermo gonzalez camarena','1200','Piso 10','Santa Fe','Alvaro Obregon','Alvaro Obregon','Ciudad de México','MEX',NULL,NULL,NULL,'contabilidad@enalto.mx',NULL,NULL,0,'preview'),(28,'receiver',26,NULL,'IPE140806TB5','Inmoyuca peninsular S.A de C.V',NULL,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','21','125','A','Col Mex','Yucatan','Merida','Yucatan','MEX',NULL,NULL,NULL,'leticia.herrera@rosavento.mx',NULL,NULL,0,'preview'),(29,'receiver',27,NULL,'LCD180511FI0','LESSMOREGROUP CONSULTORIA DE DISEÑO',NULL,'97120',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','1 G','310',NULL,'CAMPESTRE','YUCATAN','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'accounts@lessmore.group',NULL,NULL,0,'preview'),(30,'receiver',28,NULL,'AEDV881025982','Valeria Arellano Delgado',NULL,'38050',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Siracusa','133',NULL,'Mediterraneo',NULL,'Celaya','Guanajuato','MEX',NULL,NULL,NULL,'facturacionaedv@gmail.com',NULL,NULL,0,'preview'),(31,'receiver',29,NULL,'TOM950524U51','TP ORTHODONTICS MEXICO S DE RL DE CV',NULL,'01020',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','INSURGENTES SUR','1809','PISO 8','GUADALUPE INN',NULL,'BENITO JUAREZ','Ciudad de México','MEX',NULL,NULL,NULL,'ofelia.zarco@tportho.com',NULL,NULL,0,'preview'),(32,'receiver',30,NULL,'FME860201IT5','COMPAÑIA FERNANDEZ DE MERIDA, S,A DE C.V',NULL,'97000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','70','535-A',NULL,'CENTRO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'comprador2@fernandez.com.mx',NULL,NULL,0,'preview'),(33,'receiver',31,NULL,'CMA140627651','C MARINE SAPI DE CV',NULL,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Blvd. Kukulkan Km 3.5','Mz. 30 Lote D-9-7 Ed',NULL,'Zona Hotelera,',NULL,'Cancún','Q. Roo','MEX',NULL,NULL,NULL,'contabilidad@bluewaterlife.com.mx',NULL,NULL,0,'preview'),(34,'receiver',32,NULL,'CIC6910143B5','Cámara de la industria del calzado del Estado de Guanajuato',NULL,'37290',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Blvd. Adolfo Lopez Mateos','3401 OTE',NULL,'Fracc. Julián de Obregón','Guanajuato','Leon','Guanajuato','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(35,'receiver',33,NULL,'POL900418IF3','POLIMERIDA SA DE CV',NULL,'97390',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KM 8 CARRETERA UMAN',NULL,NULL,'AMPLIACION CD INDUSTRIAL','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'guadalupe.flores@polimerida.com',NULL,NULL,0,'preview'),(36,'receiver',34,NULL,'CAE1203229T0','Cree Ama y Espera AC',NULL,'97305',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Calle 7A-1','325','12','Sta. Gertrudis Copó',NULL,'Merida','Yucatan','MEX',NULL,NULL,NULL,'sergio@amorseguro.org',NULL,NULL,0,'preview'),(37,'receiver',35,NULL,'OTC080114C30','EXPERIENCIAS XCARET PARQUES',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRET CHETUMAL PUERTO JUAREZ KILOMETRO 282','INTERIOR B',NULL,'RANCHO XCARET','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,'fe.otc@xcaret.com',NULL,NULL,0,'preview'),(38,'receiver',36,NULL,'AMA030617SN8','AVENTURAS MAYAS SA DE CV',NULL,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRET FEDERAL PYA DEL CARMEN TULUM KM 2.5','PARCEL 17 MZA 337 LO',NULL,'PARCEL 17 MZA 337 LOTE 027','PLAYA DEL CARMEN',NULL,'Q.ROO','MEX',NULL,NULL,NULL,'alexis@aventurasmayas.com',NULL,NULL,0,'preview'),(39,'receiver',37,NULL,'PTL170410UC7','PRODUCCIONES TRAMANDO LAB',NULL,'03100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SAN FRANCISCO','226','103','DEL VALLE','BENITO JUAREZ','BENITO JUAREZ','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,'55 2521 8891',NULL,0,'preview'),(40,'receiver',38,NULL,'STC861023CMA','SERVICIOS TURISTICOS COSTA TURQUESA, S.A DE C.V',NULL,'77560',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','DE ACCESO L28 MANZANA 16 L37 EDIFICIO C','LOCAL S',NULL,'SM 309',NULL,'CANCUN BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'apinvoices@grupolomas.com',NULL,NULL,0,'preview'),(41,'receiver',39,NULL,'FDI1502063M0','FB DISTRIBUCIONES',NULL,'77560',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','LUIS DONALDO COLOSIO','MANZANA 4 LOTE 5','BODEGA 519','SM 301','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'mdaguilar@grupoavanti.com','9981112267',NULL,0,'preview'),(42,'receiver',40,NULL,'CMA140627651','C MARINE SAPI DE CV',NULL,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Blvd. Kukulkan Km 3.5','Mz. 30 Lote D-9-7','Edificio 1 Local PB','Zona Hotelera','CANCUN','CANCUN BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'contabilidad@bluewaterlife.com.mx','9987043717',NULL,0,'preview'),(43,'receiver',41,NULL,'MHG121130EK5','Mosquitos Hospitality Group S. de R.L de C.V',NULL,'11950',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Av. Paseo de Reforma','2620','Piso 16','Lomas Altas','Cuidad de México','Cuidad de México','Cuidad de México','MEX',NULL,NULL,NULL,'claudia.bautista@thompsonhotels.com',NULL,NULL,0,'preview'),(44,'receiver',42,NULL,'ATE1608256AA','AQUI TODO ES DIVERSION, SA DE CV',NULL,'37299',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','MONTE ARABI','262',NULL,'SANTA FE','LEON','LEON','GUANAJUATO','MEX',NULL,NULL,NULL,'marcohernandez21@hotmail.com',NULL,NULL,0,'preview'),(45,'receiver',43,NULL,'GPO040428SE8','GRUPO POLE',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KM 282 CARRETERA CHETUMAL PTO JUAREZ','SN','LOC A','RANCHO XCARET',NULL,'SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,'xcafisca@gxcaret.com.mx',NULL,NULL,0,'preview'),(46,'receiver',44,NULL,'EME0001285E0','SOCIEDAD DE ERGONOMISTAS DE MEXICO',NULL,'32618',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SAN ANTONIO','4370','425 PISO 4','PARTIDO IGLESIAS','CD JUAREZ','JUAREZ','CHIHUAHUA','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(47,'receiver',45,NULL,'CST1402219G5','CORPORATIVO DE SERVICIOS TURISTICOS AMIGO',NULL,'97070',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','6','508 C','1','GARCIA GINERES',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'cgranados62@hotmail.com',NULL,NULL,0,'preview'),(48,'receiver',46,NULL,'LCI071009UX4','Logística de Comercio Internacional S.A. de C.V.',NULL,'67176',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Pablo Livas','2540','9 y 10','Mirador de la Silla',NULL,'Guadalupe','Nuevo León','MEX',NULL,NULL,NULL,'facturacion@loci.com.mx','(81) 8479-8731',NULL,0,'preview'),(49,'receiver',47,NULL,'SAN060614SQ4','SUEÑOS DE ANGEL',NULL,'97345',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','tablaje','31041',NULL,NULL,'Conkal','Conkal','Yucatan','MEX',NULL,NULL,NULL,'sdeangel@yahoo.com.mx',NULL,NULL,0,'preview'),(50,'receiver',48,NULL,'XAXX010101000','PUBLICO GENERAL',6,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','S/N','S/N','S/N','N/A','N/A','N/A',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(51,'receiver',49,NULL,'CRE7712179M5','CARETAS REV',1,'62550',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CERILLERA','43',NULL,'CENTRO JIUTEPEC','JIUTEPEC','JIUTEPEC','MORELOS','MEX',NULL,NULL,NULL,'neri@gruporev.com',NULL,NULL,0,'preview'),(52,'receiver',50,NULL,'VNU1605041J1','20 NUDOS',1,'97000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','44','423',NULL,'MERIDA CENTRO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(53,'receiver',51,NULL,'OTP110225PK3','OCEAN TOURS PLAYA',NULL,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','55 PONIENTE X 18 NORTE','MANZANA 168','LOTE 006','EJIDO NORTE','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,'saskia@oceantoursmexico.com','984 2061444',NULL,0,'preview'),(54,'receiver',52,NULL,'AAHC690729U64','CARLOS REYNALDO ALDANA HERRERA',5,'97816',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','23','126',NULL,'CHOCHOLA','CHOCHOLA','CHOCHOLA','YUCATAN','MEX',NULL,NULL,NULL,'facturacion.cenotesanignacio@gmail.com',NULL,NULL,0,'preview'),(55,'receiver',53,NULL,'XER170125R18','XERVIGAS',NULL,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA CHETUMAL PUERTO JUAREZ','KILOMETRO 282',NULL,'RANCHO XCARET','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(56,'receiver',54,NULL,'VEGA781012N61','ANGEL ARTURO MAXIMILIANO',NULL,'91000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ALTAMIRANO','17',NULL,'CENTRO','XALAPA','XALAPA','VERACRUZ DE IGNACIO DE LA LLAVE','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(57,'receiver',55,NULL,'LAAM9101286G3','MARIEL LAVALLE ALONZO',5,'97128',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 1H','192',NULL,'MEXICO NORTE','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(58,'receiver',56,NULL,'PIA1308285X1','PIAPRODUCCIONES',9,'97144',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','16','332',NULL,'EMILIANO ZAPATA OTE',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(59,'receiver',57,NULL,'CIB920312FS2','CENTRO INMOBILIARIO DEL BAJIO',1,'76000',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','5 DE MAYO','75','S/N','CENTRO',NULL,'QUERETARO','QUERETARO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(60,'receiver',58,NULL,'INO130128JF7','INOVACREATIVA',1,'45100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SABINO DELGADO','S/N',NULL,'ZAPOPA CENTRO','ZAPOPAN','ZAPOPAN','JALISCO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(61,'receiver',59,NULL,'DAP170822SE1','DESARROLLOS AMARILLOS DE LA PENINSULA',1,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','24','356','1,2,3,4,A,B,C,D','Altabrisa','OTRA NO ESPECIFICADA EN EL CATALOGO','Merida','Yucatan','MEX',NULL,NULL,NULL,'almacen@grupocielo.com.mx','9992625557',NULL,0,'preview'),(62,'receiver',60,NULL,'STO110826RS0','SPAR TODOPROMO',1,'03900',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Avenida Insurgentes sur y Calle Jose Ma. Ibarran','101','´Planta Baja','SAN JOSE INSURGENTES',NULL,'BENITO JUAREZ','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,'jcmedina@spartodopromo.com',NULL,NULL,0,'preview'),(63,'receiver',61,NULL,'PEGM591214V78','MARINA PEREA GONZALEZ',5,'37545',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','LAUREL Y ALTAR DE SAN PABLO','218','A','SAN JOSE EN ALTO',NULL,'LEON','GUANAJUATO','MEX',NULL,NULL,NULL,'asenegocios2@gmail.com',NULL,NULL,0,'preview'),(64,'receiver',62,NULL,'ALM9910114D6','AB&C LEASING DE MEXICO',NULL,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','11 Y 13','452',NULL,'ITZIMNA','MERIDA','MERIDA','Yucatan','MEX',NULL,NULL,NULL,'notificacionesfiscal@bepensa.com',NULL,NULL,0,'preview'),(65,'receiver',63,NULL,'MUL8508057S7','MULTISUR',1,'97320',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 75 ENTRE CALLE 72','147',NULL,'CENTRO','PROGRESO','PROGRESO','YUCATAN','MEX',NULL,NULL,NULL,'fernando.rojas@logra.com.mx',NULL,NULL,0,'preview'),(66,'receiver',64,NULL,'RSE0811123T6','RIO SECRETO',1,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09',NULL,NULL,NULL,'EJIDO SUR','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(67,'receiver',65,NULL,'GME201228743','GRADYREC DE MEXICO',1,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','20','89-B',NULL,'ITZIMNA','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(68,'receiver',66,NULL,'VTM181204M49','VALENTIN TRAVEL MEXICO',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09',NULL,'KM 311-500','PA','PLAYA DEL SECRETO','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(69,'receiver',67,NULL,'OOP230428NM3','OPESA OPERADORA DE PROYECTOS ESPECIALES',1,'01040',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','TLACOPAC','6',NULL,'CAMPESTRE','ALVARO OBREGON','ALVARO OBREGON','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(70,'receiver',68,NULL,'CME210922CA5','CURIA DE MEXICO',1,'01600',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09',NULL,'28','401','MERCED GOMEZ','ALVARO OBREGON','ALVARO OBREGON','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(71,'receiver',69,NULL,'DXC9912292N7','DESTINO XCARET',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARR CHE PTO JUARZ','KM 282',NULL,'RANCHO XCARET',NULL,'SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(72,'receiver',70,NULL,'EXH160510UW8','EXPERIENCIAS XCARET HOTELES',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL CHETUMAL PUERTO JUAREZ','KILOMETRO 282','L T 023 2','RANCHO XCARET','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(73,'receiver',71,NULL,'DILA760201TE7','AARON DIAZ LOPEZ',5,'97125',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 17',NULL,NULL,'Colonia Mexico','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(74,'receiver',72,NULL,'VIUG740608D82','GUNTER VILLA URBINA',9,'23232',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE','SN',NULL,'LA VENTANA','LA PAZ','LA VENTANA','BAJA CALIFORNIA SUR','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(75,'receiver',73,NULL,'COSL980112VB9','LUIS GERARDO COSGAYA SOSA',5,'97314',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE','645',NULL,'HOGARES CAUCEL','CAUCEL','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(76,'receiver',74,NULL,'IES870531FU5','INVESTIGACIONES Y ESTUDIOS SUPERIORES',2,'52786',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA UNIVERSIDAD ANAHUAC','46',NULL,'LOMAS ANAHUAC',NULL,'HUIXQUILUCAN','MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(77,'receiver',75,NULL,'XTR150821KR1','XCUMPICH TRAVEL',1,'97204',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','20-A','297','SUITE101','X-CUMPICH','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(78,'receiver',76,NULL,'MERE581009AS2','MARIA EUGENIA MEDINA RINCON',5,'97138',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 29','261-A',NULL,'SANTA MARIA CHUBURNA','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(79,'receiver',77,NULL,'UPS891122HV8','UNITED PARCEL SERVICE DE MEXICO',1,'03020',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','EUGENIA','189',NULL,'NARVARTE ORIENTE',NULL,'BENITO JUAREZ','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(80,'receiver',78,NULL,'SCI1708074W4','SCUBA CHIPOTLE',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','10 NORTE','MANZANA 100 LOTE 01',NULL,'CENTRO','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(81,'receiver',79,NULL,'SPL090616B95','SCUBA PLAYA',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 10 NORTE MZA 21 LOTE 8','LOCAL 9',NULL,'CENTRO','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(82,'receiver',80,NULL,'TPC1902211T2','TODO PREFABRICADOS 5',1,'77516',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','46','8','SN','SUPERMANZANA 91','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(83,'receiver',81,NULL,'MTO171211CN7','MEGA TRAVEL OPERADORA',1,'53040',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','TRINIDAD','7',NULL,'LAS AMERICAS','NAUCALPAN DE JUAREZ','NAUCALPAN','ESTADO DE MEXICO','MEX',NULL,NULL,NULL,NULL,'9993492736',NULL,0,'preview'),(84,'receiver',82,NULL,'TPC1902211T2','TODO PREFABRICADOS 5',1,'77580',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Central Vallarta','KM 7.5 P','SN','Puerto Morelos','Puerto Morelos','Puerto Morelos','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(85,'receiver',83,NULL,'CSM9906236F7','CONSTRUCCIONES Y SUMINISTROS MAHAUAL',1,'77035',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ADOLFO LOPEZ MATEOS','363',NULL,'ITALIA','CHETUMAL','OTHON P BLANCO','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(86,'receiver',84,NULL,'RIDK710519827','KATY EMILIA RIVERO DIAZ',9,'97279',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','101','357',NULL,'SANTA ROSA',NULL,'MERIDA','YUCATAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(87,'receiver',85,NULL,'BME631003N72','BOSTIK MEXICANA',1,'53370',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ESFUERZO NACIONAL','2',NULL,'INDUSTRIAL ALCE BLANCO',NULL,'NAUCALPAN DE  JUAREZ','MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(88,'receiver',86,NULL,'ISM9803269C1','INFLIGHT SERVICES MEXICO',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA CANCUN AEREOPUERTO KM 14.5','BODEGA 67 68 85 Y 86',NULL,'CARRETERA CANCUN AEROPUERTO ORIENTE','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(89,'receiver',87,NULL,'TRM180530UU8','TAFER RESORTS MANAGEMENT',1,'44160',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','MIGUEL LAREDO DE TEJEDA','2108',NULL,'AMERICANA','GUADALAJARA','GUADALAJARA','JALISCO','MEX',NULL,NULL,NULL,'ROSA.GONZALEZ@TAFERRESORTS.COM',NULL,NULL,0,'preview'),(90,'receiver',88,NULL,'RBE140303BUA','RESERVA BENGALA',1,'77580',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KM 19 PARCELA 213','Z1P1 CTRAVALL',NULL,'PUERTO MORELOS','PUERTO MORELOS','PUERTO MORELOS','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(91,'receiver',89,NULL,'ETS181205CA4','EJECUTIVOS DE TURISMO SUSTENTABLE',1,'77504',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BANCO CHINCHORRO','MZ 1 LT 8',NULL,'SUPER MANZANA 13','CANCUN','BENITO JUAREZ','QUINTANA ROO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(92,'receiver',90,NULL,'CDO070410V77','CONTROLADORA DOLPHIN',1,'77533',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KABAH','MANZANA 04 LOTE 1','301','SUPERMANZANA 55','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(93,'receiver',91,NULL,'LUMA661114IS8','MARIO ALBERTO LUCHINI',5,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA 95 SUR','LOTE 04 MANZANA 398',NULL,'EJIDO SUR','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(94,'receiver',92,NULL,'XSO200728TK4','XULTA SOLUCIONES',9,'97135',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','17','661','LOCAL 4','JARDINES DE MERIDA','MERIDA',NULL,'YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(95,'receiver',93,NULL,'XIC211221FB9','XULTA INGENIERIA DE COSTOS',1,'97135',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','17','661','LOCAL 4','JARDINES DE MERIDA',NULL,'MERIDA','YUCATAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(96,'receiver',94,NULL,'GCE190724KT7','GINO CONTROL EMPRESARIAL',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BONAMPAK','MANZANA 1 LOTE 1','PISO 5','SM 6','BENITO JUAREZ','CANCUN','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(97,'receiver',95,NULL,'GMM0706299H8','GULF MARINE DE MEXICO',1,'94299',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BOULEVARD (BLVD)','ADOLFO RUIZ CORTINES','3321','FRACC DE LAS AMERICAS','BOCA DEL RIO','BOCA DEL RIO','VERACRUZ DE IGNACIO DE LA  LLAVE','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(98,'receiver',96,NULL,'APR180905RC8','AGL PRODUCE',NULL,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','TAXISTAS','MZA 786 LT 002-3','B FRACCION 1 A-3 DE','EJIDO SUR','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(99,'receiver',97,NULL,'SCS040225SR6','SERVICIOS CORPORATIVOS SAC BE',1,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 18 Y CALLE 20','108','13','ITZIMNA','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'rosario.amaya@logra.mx',NULL,NULL,0,'preview'),(100,'receiver',98,NULL,'ADI120203QF5','ADELANTE DISTRIBUCIONES',1,'77536',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','LUIS DONALDO COLOSIO','520 MANZANA 4 LOTE 5',NULL,'SUPERMANZANA 301','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(101,'receiver',99,NULL,'KER150619642','KERSHE',1,'77560',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Cancun Aeropuerto','Manzana 4 Lote 5 SM','Bodega 518 BT-1','Central de Abastos','Cancun','Benito Juarez','Quintana Roo','MEX',NULL,NULL,NULL,'nancygarcia@aldosgelato.com','9981300181',NULL,0,'preview'),(102,'receiver',100,NULL,'RSP240521T12','RESIDENCIAL SALAMANCA PDC',2,'77726',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Caracoles','MZ 20 LT 008','SN','Encuentro','Playa del Carmen','Solidaridad','Quintana Roo','MEX',NULL,NULL,NULL,NULL,'5521289728',NULL,0,'preview'),(103,'receiver',101,NULL,'GCM220406SM5','GLOBAL CRUISES MX',1,'77670',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','65','SN','6,7,8','ZONA INDUSTRIA','COZUMEL','COZUMEL','QUINTANA ROO',NULL,NULL,NULL,NULL,'rh@kuzapark.com',NULL,NULL,0,'preview'),(104,'receiver',102,NULL,'VIVD010805513','DAMARIS ELIDED VILLAVICENCIO VERA',5,'96710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','MARIANO ABASOLO','19','S N','INSURGENTES NORTE','MINATITLAN','MINATITLAN','VERACRUZ DE IGNACIO DE LA LLAVE','MEX',NULL,NULL,NULL,NULL,'9842658670',NULL,0,'preview'),(105,'receiver',103,NULL,'SFP190612IK7','SURTIDORA DE FRIOS DE LA PENINSULA',1,'77536',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL CANCUN -  AEROPUERTO','MANZANA 61 LOTE 61','18 A Y 18 B','SUPERMANZANA 301','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'BRIDIA.TRUJEQUE@UNORETRO.COM','9982030245',NULL,0,'preview'),(106,'receiver',104,NULL,'MUL1102229J0','EXPERIENCIAS XCARET CORPORATIVO',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA CHETUMAL PUERTO JUAREZ','PREDIO XCARET MZ 12','TORRE 1 PARQUE XCARE','RANCHO XCARET','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(107,'receiver',105,NULL,'MIN120224147','M INDUSTRIA',1,'77524',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA LOPEZ PORTILLO','MANZANA 46 LOTE 1','SN','SMZA 64 CANCUN','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'publicidad@millet.com.mx',NULL,NULL,0,'preview'),(108,'receiver',106,NULL,'CMI2305097A3','COMERCIALIZADORA DE MAQUINARIA INDUSTRIAL MAQUIMEX',9,'97113',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','20 A','298',NULL,'MONTEBELLO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'maquimexcomercializadora@gmail.com',NULL,NULL,0,'preview'),(109,'receiver',107,NULL,'SSD201106LI9','SWITCH SOLUCIONES DIGITALES',1,'97115',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(110,'receiver',108,NULL,'OAV730502NZ8','OPERADORA DE ALDEAS VACACIONALES',1,'03900',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AV INSURGENTES SUR','1647',NULL,'SAN JOSE INSURGENTES','BENITO JUAREZ','BENITO JUAREZ','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,'lisseth.isla@clubmed.com','9981811461',NULL,0,'preview'),(111,'receiver',109,NULL,'VGC231128HE5','VL GESTION CONDOMINAL',9,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','PRIVADA PAPUA','MZN 40 LT 001-011','VIV 12',NULL,'PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,'luca.marziano84@gmail.com','9841409161',NULL,0,'preview'),(112,'receiver',110,NULL,'PEN010212DU9','OPERADORA HOTELERA ETRO',1,'77730',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL 307 CANCUN TULUM','KILOMETRO 302 340 LO','UNIDAD DE PROP EXCLU','OTRA NO ESPECIFICADA EN EL CATALOGO','OTRA NO ESPECIFICADA EN EL CATALOGO','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(113,'receiver',111,NULL,'OXU080111NS1','OPERADORA XUNA',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','Carlos Nader','Mz 1 Lt28',NULL,'Super Manzana 2 Centro','Cancun','Benito Juarez','Quintana Roo','MEX',NULL,NULL,NULL,'daniel.carrillo@delphinus.com.mx',NULL,NULL,0,'preview'),(114,'receiver',112,NULL,'OHC030508CA2','OPERADORA HOTELERA DEL CORREDOR MAYAKOBA',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL PLAYA - CANCUN A UN COSTADO DE CAPITAN LAFITTE','298',NULL,'EJIDO','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,'ANDREA.PURECO@FAIRMONT.COM',NULL,NULL,0,'preview'),(115,'receiver',113,NULL,'STA230830MX9','STARBREAKER',1,'02760',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CENTEOTL Y CALLE TOCHTLI ENTRE ACATL','267 B',NULL,'INDUSTRIAL SAN ANTONIO','AZCAPOTZALCO','AZCAPOTZALCO','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,'alfonso.loza@pickup-coffee.com',NULL,NULL,0,'preview'),(116,'receiver',114,NULL,'AVH0107164T2','AULA 24 HORAS',1,'66230',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','IGNACIO MORONES PRIETO','791','8','CENTRO','SAN PEDRO GARZA GARCIA','SAN PEDRO GARZA GARCIA','NUEVO LEON','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(117,'receiver',115,NULL,'PRS050126FW2','PROMOTORA RANCHO SAN MIGUEL',1,'77569',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SUPER MANZANA 41 MZ 01','LOTE 1 - 01','SN',NULL,'CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(118,'receiver',116,NULL,'AYU930608I73','ARQUIDIOCESIS DE YUCATAN',2,'97070',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 10','96',NULL,'GARCIA GINERES',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(119,'receiver',117,NULL,'PES181205470','PROYECTOS EJECUTIVOS SUSTENTABLES',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KUKULCAN','MANZANA 60 LOTE 5-02','SECCION D TERCERA ET','ZONA HOTELERA','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,'boutique.selvatica@etsconsultores.com',NULL,NULL,0,'preview'),(120,'receiver',118,NULL,'TGU011113CR6','TOTAL GUSTO',1,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','56 POR 30 Y 31 A','NO 336J',NULL,'ITZIMNA','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'D.HUMANO@TOTALGUSTO.COM',NULL,NULL,0,'preview'),(121,'receiver',119,NULL,'MOB191114KL6','LL MEX',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BONAMPAK','MANZANA 1 LOTE 4C ED','LOC 1504','SM 4A','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(122,'receiver',120,NULL,'OSI180904QB3','OHA SOLUCIONES EN INGENIERIA',1,'97256',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','69','649',NULL,'LIBERTAD',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(123,'receiver',121,NULL,'OOMA860315A49','ALINA OROZCO MARQUEZ',5,'44380',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE SAN PEDRO','1421',NULL,'SAN MARTIN',NULL,'GUADALAJARA',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(124,'receiver',122,NULL,'MAUG731023JH8','GERMAN AUGUSTO MARIN UC',9,'97246',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','20','323',NULL,'Fraccionamiento Mulsay',NULL,'Merida',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(125,'receiver',123,NULL,'YSE210430F8A','YUCATAN SEAS',9,'97113',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','VIALIDAD 14 ENTRE CALLE 13 Y 15','290','121','MONTEBELLO','MERIDA','MERIDA','YUCATAN',NULL,NULL,NULL,NULL,'facturas@yucatanseas.com',NULL,NULL,0,'preview'),(126,'receiver',124,NULL,'MIAR000721EP3','RICARDO MIMENZA ARCE',5,'97115',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','63','97',NULL,'AME','MERIDA','MERIDA','YUCATAN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(127,'receiver',125,NULL,'XEXX010101000','PERFORMANCE BOATS USA LLC',6,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','1441 Brickell avenue','Suite 1400',NULL,NULL,'Florida','Miami','Estados unidos de america',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(128,'receiver',126,NULL,'KSP210209RS2','KEM SPORTS',1,'97113',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','16','402 A',NULL,'MONTEBELLO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(129,'receiver',127,NULL,'PCM960301681','PROVEEDORA Y CONSTRUCTORA MEXICANA',1,'77508',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA KABAH','MANZANA 6 LOTE 25','LETRA D','SM 31','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(130,'receiver',128,NULL,'CST0806167Z8','COMERCIALIZADORA STERN',1,'85506',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','HUGO DELGADO LOMELI','SN',NULL,'OTRA NO ESPECIFICADA EN EL CATALOGO','SAN CARLOS (SAN CARLOS NUEVO GUAYMAS)','GUAYMAS','SONORA','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(131,'receiver',129,NULL,'VCA171116HMA','VA CATAMARANES',1,'14018',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AV.  PERIFERICO SUR','4421','402','OTRA NO ESPECIFICADA EN EL CATALOGO','OTRA NO ESPECIFICADA EN EL CATALOGO','TLALPAN','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(132,'receiver',130,NULL,'NAPJ930117PG6','JERICO NAVARRO PAREDES',9,'97700',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','49','321-A',NULL,'CENTRO','TIZIMIN','TIZIMIN','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(133,'receiver',131,NULL,'MPS210324TY0','LA MEDITERRANEA PREMIUM SPIRITS',1,'44670',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','JAUN PALOMAR Y ARIAS','567','57','MONRAZ','GUADALAJARA','GUADALAJARA','JALISCO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(134,'receiver',132,NULL,'MOT210924UWA','MOTORTECH',9,'77504',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ACANCEH','MANZANA 2 LOTE 3','PISO 3 3B','SUPERMANZANA 11','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(135,'receiver',133,NULL,'MAGJ561127ET5','JULIO CESAR MARIN GALERA',9,'97116',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','49','230','208','SAN ANTONIO CUCUL','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'pcastillo.solm@gmail.com',NULL,NULL,0,'preview'),(136,'receiver',134,NULL,'GGI160805HQ6','GCS GRUPOS E INCENTIVOS',1,'77535',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','PUERTO VALLARTA','21','M 8 L 1','SUPERMANZANA 528','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(137,'receiver',135,NULL,'OELA9208172S1','ANDREA IVONNE OJEDA LIZAMA',7,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','17','286','LOCAL 1','MONTECARLO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(138,'receiver',136,NULL,'EOX240722CA0','EOXMID',2,'97113',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','32','298','PISO 3','MONTEBELLO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(139,'receiver',137,NULL,'OFM060920RJ8','OPERADORA DE FRANQUICIAS MALABARES',1,'06700',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','COLIMA','23','LOCAL B','ROMA NORTE','CUAUHTEMOC','CUAUHTEMOC','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(140,'receiver',138,NULL,'NCM210618RE0','EXPERIENCIAS XCARET NAVIERA',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BLVD KUKULKAN KM 4.5','KM 4.5','D7 ZONA TURISTICA 1A','ZONA HOTELERA','CANCUN','BENITO JUAREZ','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(141,'receiver',139,NULL,'TVI190618F79','TESORO VIVO',1,'77580',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL CANCUN A PUERTO MORELOS KM 27.5','SM 32 MZ 01 L 1-11 C','LOC 20','PUERTO MORELOS','PUERTO MORELOS','PUERTO MORELOS','QUINTANA ROO','MEX',NULL,NULL,NULL,'accounting@ishoppinggifts.com',NULL,NULL,0,'preview'),(142,'receiver',140,NULL,'PRO090819GQ3','PROTECTOGARD',1,'11860',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','MARINA','34',NULL,'OBSERVATORIO','MIGUEL HIDALGO','MIGUEL HIDALGO','CIUDAD DE MEXICO','MEX',NULL,NULL,NULL,'cxp@protectogard.com.mx',NULL,NULL,0,'preview'),(143,'receiver',141,NULL,'FOR100930BF7','FUNDACION ORIGINAL',2,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BLVD KUKULCAN KM 3.5','CAMINO AL HOTEL VERA','CAMINO AL HOTEL OCEA','ZONA HOTELERA','CANCUN','BENITO JUAREZ',NULL,'MEX',NULL,NULL,NULL,'logoshop@original-group.com',NULL,NULL,0,'preview'),(144,'receiver',142,NULL,'GMA040326F27','GOLF DE MAYAKOBA',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARR FEDERAL CHETUMAL PTO. JUAREZ','KM 298',NULL,'EJIDO PLAYA DEL CARMEN','PLAYA DEL CARMEN','SOLIDARIDAD',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(145,'receiver',143,NULL,'HBP031220MQ4','PROMOTORA HOTELERA ORIGINAL',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA BONAMPAK ENTRE AVENIDA COBA','MANZANA 9 LOTE 17 01',NULL,'SUPERMANZANA 3 CENTRO','CANCUN','BENITO JUAREZ','Q,ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(146,'receiver',144,NULL,'POR2209074V0','PH ORIGINAL',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA BONAMPAK ENTRE AVENIDA COBA','MANZANA 9 LOTE 17 01',NULL,'SUPERMANZANA 3 CENTRO','CANCUN','BENITO JUAREZ','Q,ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(147,'receiver',145,NULL,'OCL220907748','OGV CLUB',1,'77500',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','AVENIDA BONAMPAK ENTRE AVENIDA COBA','MANZANA 9 LOTE 17 01',NULL,'SUPERMANZANA 3 CENTRO','CANCUN','BENITO JUAREZ','Q,ROO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(148,'receiver',146,NULL,'HAD190206KX7','HIX ADVENTURE',1,'34138',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','BLVD. BELISARIO DOMINGUEZ ENTRE CALLE PRIMO DE VERDAD','602 B',NULL,'HERNANDEZ','VICTORIA DE DURANGO','DURANGO',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(149,'receiver',147,NULL,'ECT060203GB9','EXPLORA CARIBE TOURS',1,'77600',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','7 SUR','EXT 5','DEPTO B','CENTRO','COZUMEL','COZUMEL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(150,'receiver',148,NULL,'PCA9601303TA','PARAISO LOS CABOS',1,'23405',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','KM 19.5 CARRETERA TRANSPENINSULAR',NULL,NULL,'SAN JOSE DEL CABO',NULL,'LOS CABOS','BAJA CALIFORNIA SUR','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(151,'receiver',149,NULL,'APR180808CP0','ALMACENES PALACE RESORTS',1,'97113',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','ANDRES GARCIA LAVIN CALLE 32','298','PISO 11','MONTEBELLO','MERIDA','MERIDA','YUCATAN',NULL,NULL,NULL,NULL,'jvalladares@thepalacecompany.com',NULL,NULL,0,'preview'),(152,'receiver',150,NULL,'PIN131210PG9','HOTELERA PALACE RESORTS',1,'11590',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','TOLSTOI Y VICTOR HUGO','10',NULL,'ANZURES',NULL,'MIGUEL HIDALGO','CUIDAD DE MEXICO',NULL,NULL,NULL,NULL,'jvalladares@thepalacecompany.com',NULL,NULL,0,'preview'),(153,'receiver',151,NULL,'SCO201209GN8','SCUBABLU COZUMEL',1,'77664',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','15 SUR ENTRE 13 SUR','940','LOCAL 2',NULL,'COZUMEL','COZUMEL','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(154,'receiver',152,NULL,'PAL030731427','PROMOCIONES AMERICA LATINA',1,'01030',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','INSURGENTES SUR','1814','601','FLORIDA','ALVARO OBREGON','ALVARO OBREGON','CUIDAD DE MEXICO',NULL,NULL,NULL,NULL,'gilberto.acosta@actnow.mx',NULL,NULL,0,'preview'),(155,'receiver',153,NULL,'ACV211210I41','ADMINISTRADORA DE CONDOMINIOS VALLE AURORA TORRE 1',2,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','125 AV NORTE U.P.E. 003 MZ 4 FRACC LA GRAN PLAZA DE LA RIVIERA II','LT 3','OFNA ADMTVA \"A\"',NULL,'PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO',NULL,NULL,NULL,NULL,'admonvalleaurora@gmail.com','9981168226',NULL,0,'preview'),(156,'receiver',154,NULL,'MOHA750529DF1','ALFREDO ALEJANDRO MORALES HERRERA',5,'77600',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','RAFAEL E MELGAR ENTRE HOTEL CASA DEL MAR','KM 4 02','S/N','ZONA HOTELERA SUR COZUMEL','COZUMEL','COZUMEL','QUINTANANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(157,'receiver',155,NULL,'MSI0906164TA','MARINA SILCER',1,'97320',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','S/N','TABLAJE CATASTRAL 62','S/N','YUCALPETEN','PROGRESO','PROGRESO','YUCATAN','MEX',NULL,NULL,NULL,'Diego@marinasilcer.com',NULL,NULL,0,'preview'),(158,'receiver',156,NULL,'SPN221205P86','SERVICIOS Y PROMOCIONES NAUTICAS DEL SURESTE',1,'97305',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','24 ENTRE 7B','291','S/N','SANTA GERTUDRIS COPO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'jimena@nauticossureste.com','9993680002',NULL,0,'preview'),(159,'receiver',157,NULL,'EXL1705186P6','EXPERIENCIAS XCARET LOYALTY',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CAMINO DE ACCESO PARQUE XENSES ENTRE CAMINO ACCESO AL PARQUE XCARET','KILÃ“METRO 282','INTERIOR B','RANCHO XCARET','PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(160,'receiver',158,NULL,'SNA100424V72','SOLUCIONES NAUTICAS',1,'97305',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','11','N° 344','S/N','SANTA GERTUDRIS COPO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'Fsanchez@grupog.com.mx',NULL,NULL,0,'preview'),(161,'receiver',159,NULL,'AUTI030620V18','ISAAC ANZURES TORRES',5,'02970',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','JARDIN','257','TORRE 5 DEPTO 1205','AMPLIACION DEL GAS','AZCAPOTZALCO','AZCAPOTZALCO',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(162,'receiver',160,NULL,'ECR120910SL2','EDIFICACIONES Y CONSTRUCCIONES RCUATRO',1,'97305',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 12-A','310','LOCAL A4, PISO 7','SANTA GERTUDRIS COPO','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'jefatura.mkt@therealestatehub.mx',NULL,NULL,0,'preview'),(163,'receiver',161,NULL,'MFA220308FJ0','MARITIMOS DE FRANCIA AG',1,'64640',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SAN JERONIMO','310','PISO 12','SAN JERONIMO','MONTERREY','MONTERREY','NUEVO LEON','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(164,'receiver',162,NULL,'DOSA8906034D4','ANA KARINA DOMINGUEZ DE LOS SANTOS',5,'97302',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','55 A ENTRE CALLE 120','987',NULL,'LAS AMERICAS II','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(165,'receiver',163,NULL,'PSU091130I16','PUNTO SUB',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL CHETUMAL -PUERTO JUAREZ KM 299+500','MZA 10 LTE 01','BODEGA 4',NULL,'PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'MEX',NULL,NULL,NULL,'nohemi.delgado@bonassi.io',NULL,NULL,0,'preview'),(166,'receiver',164,NULL,'XQR190529BA7','XEDIS QROO',1,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','TAXISTAS','LOTE 1','S/N','EJIDO SUR','PLAYA DEL CARMEN','SOLIDARIDAD','QUINTANA ROO','MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(167,'receiver',165,NULL,'CAS150616285','COMERCIALIZADORA AGROTERRA DEL SURESTE',1,'77712',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','DIAGONAL 85 NORTE','MANZANA 72 LOTE 11 A','S/N','EJIDAL','PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(168,'receiver',166,NULL,'MER881110EM0','MERIMOTO',1,'97069',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','86','473 F','S/N','INALAMBRICA',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'merimoto_hondamarine@outlook.com',NULL,NULL,0,'preview'),(169,'receiver',167,NULL,'GLA241031Q48','GLAMPINGCO',1,'66260',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','RIO AMACUZAC, CALLE LOMAS DEL MAR','216','PISO 4 OFICINA 2','RESIDENCIAL SAN AGUSTIN PRIMER SECTOR','SAN PEDRO GARZA GARCIA','SAN PEDRO GARZA GARCIA','NUEVO LEON','MEX',NULL,NULL,NULL,'ventas@glampingco.mx',NULL,NULL,0,'preview'),(170,'receiver',168,NULL,'RWS250901UI1','RIOS WATER SOLUTIONS',1,'24115',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','FLAMBOYANES CALLE CIRICOTE','22','SN','MIAMI','CUIDAD DEL CARMEN','CARMEN','CAMPECHE','MEX',NULL,NULL,NULL,'rioswatersolutions.contacto@gmail.com',NULL,NULL,0,'preview'),(171,'receiver',169,NULL,'GAVD881024FBA','DAVID JACOB DE LA GARZA VILLARREAL',3,'67174',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','EFRAIN HUERTA','1703','SN','COUNTRY SOL','GUADALUPE','GUADALUPE','NUEVO LEON','MEX',NULL,NULL,NULL,'somosbluers@gmail.com',NULL,NULL,0,'preview'),(172,'receiver',170,NULL,'GULR8108285HA','ROXANA PATRICIA GUZMAN LICONA',5,'97320',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','19 ENTRE CALLE 14','79','SN','COSTA AZUL','PROGRESO','PROGRESO','YUCATAN','MEX',NULL,NULL,NULL,NULL,'9381248173',NULL,0,'preview'),(173,'receiver',171,NULL,'MSU020604TW8','MARINA SURESTE',1,'97100',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09',NULL,'84','SN','ITZIMNA',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'rserviran@marinasureste.com',NULL,NULL,0,'preview'),(174,'receiver',172,NULL,'MASC6203093NA','MARIA CECILIA MAFUD SALUM',5,'97130',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 8 ENTRE CALLE 15','417','SN','DIAZ ORDAZ','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'ventas@mantalifejackets.com',NULL,NULL,0,'preview'),(175,'receiver',173,NULL,'DNO1712074D8','DESARROLLOS NORTEMID',1,'97120',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','1D CALE 36 ENTRE CALLE 38','258','SN','CAMPESTRE','MERIDA',NULL,'YUCATAN','MEX',NULL,NULL,NULL,'jefatura.mkt@therealestatehub.mx',NULL,NULL,0,'preview'),(176,'receiver',174,NULL,'USO190214I21','URBAN SOLAR',9,'97203',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','40 CALLE 7 ENTRE CALLE 5','321',NULL,'SAN PEDRO UXMAL','MERIDA',NULL,'YUCATAN','MEX',NULL,NULL,NULL,'M.cortazar@urbansolar.io',NULL,NULL,0,'preview'),(177,'receiver',175,NULL,'IMA030814G16','ISLAS DE MAYAKOBA',1,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARRETERA FEDERAL KM 298','KM 298',NULL,NULL,'PLAYA DEL CARMEN','SOLIDARIDAD',NULL,'MEX',NULL,NULL,NULL,NULL,NULL,NULL,0,'preview'),(178,'receiver',176,NULL,'MAGL830429FI6','LIGIA MACIEL GARCIA',7,'97302',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','SIN CRUZAMIENTO','KM3','1','TEMOZON NORTE','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'alejandra@footballcoaching.com.mx',NULL,NULL,0,'preview'),(179,'receiver',177,NULL,'SBL2601076E3','SOMOS BLUERS',1,'97070',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 26','185','S/N','GARCIA GINERES',NULL,'MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'somosbluers@gmail.com',NULL,NULL,0,'preview'),(180,'receiver',178,NULL,'CMO000128Q59','CONSTRUCCIONES MOYUC',1,'97249',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CALLE 122 ENTRE 120 A','1003','SN','NUEVA MULSAY','MERIDA','MERIDA','YUCATAN','MEX',NULL,NULL,NULL,'facturacionmoyuc@yahoo.com.mx','999 163 9125',NULL,0,'preview'),(181,'receiver',179,NULL,'TFV220408B62','TAKE FLIGHT VENTURES',1,'45019',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','JILGUEROS ENTRE CARRET. GUADALAJARA-TEPIC','1204','24','SAN JUAN DE OCOTAN','ZAPOPAN','ZAPOPAN','JALISCO','MEX',NULL,NULL,NULL,'a.loza@vidabirdman.com',NULL,NULL,0,'preview'),(182,'receiver',180,NULL,'CMA0408246P1','CONDOMINIO MAYAKOBA',2,'77710',NULL,NULL,NULL,0,NULL,NULL,'incomplete',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:09','CARR FEDERAL CHETUMAL PTO. JUAREZ','KM 298','SN',NULL,'PLAYA DEL CARMEN','SAN PEDRO GARZA GARCIA',NULL,'MEX',NULL,NULL,NULL,'almacen@mayakoba-ac.com',NULL,NULL,0,'preview');
/*!40000 ALTER TABLE `ikontrol_fiscal_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_series`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_series` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `issuer_profile_id` int(10) unsigned NOT NULL,
  `document_type` varchar(20) NOT NULL,
  `series` varchar(25) NOT NULL DEFAULT '',
  `initial_folio` bigint(20) unsigned NOT NULL DEFAULT 1,
  `current_folio` bigint(20) unsigned NOT NULL DEFAULT 0,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `environment` varchar(20) DEFAULT 'legacy',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fiscal_series_issuer_type_series` (`issuer_profile_id`,`document_type`,`series`),
  KEY `idx_fiscal_series_default` (`issuer_profile_id`,`document_type`,`is_default`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_series`
--

LOCK TABLES `ikontrol_fiscal_series` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_series` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_fiscal_stamp_attempts`
--

DROP TABLE IF EXISTS `ikontrol_fiscal_stamp_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_fiscal_stamp_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_document_id` bigint(20) unsigned NOT NULL,
  `signed_xml_artifact_id` bigint(20) unsigned NOT NULL,
  `pac_configuration_id` bigint(20) unsigned DEFAULT NULL,
  `provider` varchar(40) NOT NULL,
  `environment` varchar(20) NOT NULL,
  `operation` varchar(30) NOT NULL DEFAULT 'timbrar',
  `request_hash` char(64) NOT NULL,
  `idempotency_key` char(64) NOT NULL,
  `attempt_number` int(10) unsigned NOT NULL DEFAULT 1,
  `status` varchar(40) NOT NULL DEFAULT 'pending',
  `started_at` datetime NOT NULL,
  `sent_at` datetime DEFAULT NULL,
  `responded_at` datetime DEFAULT NULL,
  `http_status` int(10) unsigned DEFAULT NULL,
  `provider_code` varchar(50) DEFAULT NULL,
  `provider_message` varchar(500) DEFAULT NULL,
  `error_category` varchar(50) DEFAULT NULL,
  `retryable` tinyint(1) NOT NULL DEFAULT 0,
  `pac_reference` varchar(120) DEFAULT NULL,
  `uuid` char(36) DEFAULT NULL,
  `response_hash` char(64) DEFAULT NULL,
  `contingency_path` varchar(255) DEFAULT NULL,
  `duration_ms` int(10) unsigned DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `recommended_action` varchar(500) DEFAULT NULL,
  `requires_reconciliation` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stamp_idempotency` (`idempotency_key`),
  KEY `idx_stamp_document_status` (`fiscal_document_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_fiscal_stamp_attempts`
--

LOCK TABLES `ikontrol_fiscal_stamp_attempts` WRITE;
/*!40000 ALTER TABLE `ikontrol_fiscal_stamp_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_fiscal_stamp_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_folders`
--

DROP TABLE IF EXISTS `ikontrol_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `folder_id` varchar(255) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `level` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `permissions` text DEFAULT NULL,
  `context` varchar(255) NOT NULL,
  `context_id` int(11) NOT NULL,
  `starred_by` mediumtext NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_folders`
--

LOCK TABLES `ikontrol_folders` WRITE;
/*!40000 ALTER TABLE `ikontrol_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_general_files`
--

DROP TABLE IF EXISTS `ikontrol_general_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_general_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` text NOT NULL,
  `file_id` text DEFAULT NULL,
  `service_type` varchar(20) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `file_size` double NOT NULL,
  `created_at` datetime NOT NULL,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `uploaded_by` int(11) NOT NULL,
  `folder_id` int(11) DEFAULT 0,
  `context` varchar(100) NOT NULL,
  `context_id` int(11) DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_general_files`
--

LOCK TABLES `ikontrol_general_files` WRITE;
/*!40000 ALTER TABLE `ikontrol_general_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_general_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_help_articles`
--

DROP TABLE IF EXISTS `ikontrol_help_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_help_articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` longtext NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `files` text NOT NULL,
  `total_views` int(11) NOT NULL DEFAULT 0,
  `sort` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `labels` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_help_articles`
--

LOCK TABLES `ikontrol_help_articles` WRITE;
/*!40000 ALTER TABLE `ikontrol_help_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_help_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_help_categories`
--

DROP TABLE IF EXISTS `ikontrol_help_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_help_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text NOT NULL,
  `type` enum('help','knowledge_base') NOT NULL,
  `sort` int(11) NOT NULL,
  `articles_order` varchar(3) NOT NULL DEFAULT '',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `related_articles` text DEFAULT NULL,
  `banner_image` mediumtext NOT NULL,
  `banner_url` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_help_categories`
--

LOCK TABLES `ikontrol_help_categories` WRITE;
/*!40000 ALTER TABLE `ikontrol_help_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_help_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_invoice_items`
--

DROP TABLE IF EXISTS `ikontrol_invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `invoice_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `taxable` tinyint(1) NOT NULL DEFAULT 1,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_invoice_items`
--

LOCK TABLES `ikontrol_invoice_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_invoice_payments`
--

DROP TABLE IF EXISTS `ikontrol_invoice_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_invoice_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `note` text DEFAULT NULL,
  `invoice_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `transaction_id` tinytext DEFAULT NULL,
  `created_by` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_invoice_payments`
--

LOCK TABLES `ikontrol_invoice_payments` WRITE;
/*!40000 ALTER TABLE `ikontrol_invoice_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_invoice_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_invoices`
--

DROP TABLE IF EXISTS `ikontrol_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('invoice','credit_note') NOT NULL DEFAULT 'invoice',
  `client_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `bill_date` date NOT NULL,
  `due_date` date NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `labels` text DEFAULT NULL,
  `last_email_sent_date` date DEFAULT NULL,
  `status` enum('draft','not_paid','cancelled','credited') NOT NULL DEFAULT 'draft',
  `commercial_status` varchar(20) DEFAULT 'open',
  `closed_at` datetime DEFAULT NULL,
  `closed_by` bigint(20) unsigned DEFAULT NULL,
  `closure_reason` varchar(500) DEFAULT NULL,
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `tax_id3` int(11) NOT NULL DEFAULT 0,
  `recurring` tinyint(4) NOT NULL DEFAULT 0,
  `recurring_invoice_id` int(11) NOT NULL DEFAULT 0,
  `repeat_every` int(11) NOT NULL DEFAULT 0,
  `repeat_type` enum('days','weeks','months','years') DEFAULT NULL,
  `no_of_cycles` int(11) NOT NULL DEFAULT 0,
  `next_recurring_date` date DEFAULT NULL,
  `no_of_cycles_completed` int(11) NOT NULL DEFAULT 0,
  `due_reminder_date` date DEFAULT NULL,
  `recurring_reminder_date` date DEFAULT NULL,
  `discount_amount` double NOT NULL,
  `discount_amount_type` enum('percentage','fixed_amount') NOT NULL,
  `discount_type` enum('before_tax','after_tax') NOT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancelled_by` int(11) NOT NULL,
  `cancellation_reason` varchar(500) DEFAULT NULL,
  `files` mediumtext NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `estimate_id` int(11) NOT NULL DEFAULT 0,
  `main_invoice_id` int(11) NOT NULL DEFAULT 0,
  `subscription_id` int(11) NOT NULL DEFAULT 0,
  `invoice_total` double NOT NULL,
  `invoice_subtotal` double NOT NULL,
  `discount_total` double NOT NULL,
  `tax` double NOT NULL,
  `tax2` double NOT NULL,
  `tax3` double NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `display_id` text NOT NULL,
  `number_year` int(11) DEFAULT NULL,
  `number_sequence` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `due_date` (`due_date`),
  KEY `client_id` (`client_id`),
  KEY `project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_invoices`
--

LOCK TABLES `ikontrol_invoices` WRITE;
/*!40000 ALTER TABLE `ikontrol_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_item_categories`
--

DROP TABLE IF EXISTS `ikontrol_item_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_item_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_item_categories`
--

LOCK TABLES `ikontrol_item_categories` WRITE;
/*!40000 ALTER TABLE `ikontrol_item_categories` DISABLE KEYS */;
INSERT INTO `ikontrol_item_categories` VALUES (1,'General item',0);
/*!40000 ALTER TABLE `ikontrol_item_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_item_fiscal_settings`
--

DROP TABLE IF EXISTS `ikontrol_item_fiscal_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_item_fiscal_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `item_type` varchar(20) NOT NULL,
  `sat_product_service_key_id` int(10) unsigned DEFAULT NULL,
  `sat_unit_key_id` int(10) unsigned DEFAULT NULL,
  `commercial_unit` varchar(120) DEFAULT NULL,
  `tax_object_code_id` int(10) unsigned DEFAULT NULL,
  `fiscal_description` text DEFAULT NULL,
  `identification_number` varchar(100) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 1,
  `status` varchar(20) NOT NULL DEFAULT 'incomplete',
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `item_id_deleted_is_default` (`item_id`,`deleted`,`is_default`),
  KEY `sat_product_service_key_id` (`sat_product_service_key_id`),
  KEY `sat_unit_key_id` (`sat_unit_key_id`),
  KEY `tax_object_code_id` (`tax_object_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_item_fiscal_settings`
--

LOCK TABLES `ikontrol_item_fiscal_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_item_fiscal_settings` DISABLE KEYS */;
INSERT INTO `ikontrol_item_fiscal_settings` VALUES (1,1,'product',4,2,'SERV.',NULL,'CAPACITACION DE EMPLEADOS','86101705',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(2,2,'product',5,4,'PRS',NULL,'ZAPATOS','zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(3,3,'product',6,5,'1',NULL,'Prestación de servicios profesionales en Yucatán','ciceg',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(4,4,'product',1,5,'1',NULL,'Prestación de servicios profesionales en Yucatán','ciceg',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(5,5,'product',7,1,'PIEZA',NULL,'bandera tela sublimada  con estructura metálica y flexible base cromada en x','STANDS PARA BANDERAS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(6,6,'product',8,1,'1',NULL,'Cartera tarjetero piel','cartera',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(7,7,'product',9,1,'1',NULL,'cosmetiquera sintetico','cosmetiquera',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(8,8,'product',10,1,'1',NULL,'Display Roll Up','ROLL up',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(9,9,'product',11,1,'1',NULL,'Muro expandible','Muro 305 x 2.27',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(10,10,'product',12,1,'Lib',NULL,'libreta personalizada espiral','esc 304-19',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(11,11,'product',1,6,'1',NULL,'SERVICIO DE FLETE','Flete',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(12,12,'product',13,1,'1',NULL,'Careta protectora','Careta',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(13,13,'product',14,7,'PIEZA',NULL,'FLAYERS 1/4 CARTA UNA VISTA','FLAYERS PUBLICIDAD',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(14,14,'product',15,1,'PIEZA',NULL,'TAPETE SANITIZANTE PVC','TAPETE SANITIZANTE PVC',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(15,15,'product',5,1,'1',NULL,'Tenis full plastic pvc reciclable','full plastic',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(16,16,'product',5,1,'1',NULL,'Tenis full plastic pvc reciclable','full plastic',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(17,17,'product',5,4,'PAR',NULL,'TENIS ANTIDERRAPANTE  XELS','TENIS XELS OPERACIONES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(18,18,'product',1,8,'1',NULL,'Bolsa malla sec, ahorcador','bolsa malla',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(19,19,'product',16,2,'1',NULL,'LogÃ­stica de Entrega','EnviÃ³ (LogÃ­stica)',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(20,20,'product',17,1,'1',NULL,'SET MAQUILLAJE CATRINA REV 40301100 GR','kit maquillaje',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(21,21,'product',17,1,'1',NULL,'MAQUILLAJE TUBO REV i9442C 40 GR NGO','kit maquillaje 3',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(22,22,'product',17,9,'1',NULL,'glow dark make up','kit 2 maquillaje',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(23,23,'product',18,1,'PIEZA',NULL,'Llavero plastisol personalizado, herraje sencillo','Llavero personalizado',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(24,24,'product',1,1,'1',NULL,'Uniformes borados Mia tulum','uniformes mia',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(25,25,'product',5,1,'1',NULL,'ANTICIPO ZAPATOS BB XELS','ACT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(26,26,'product',5,1,'1',NULL,'ANTICIPO ZAPATOS XELS FULL PLASTIC','ACT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(27,27,'product',19,1,'1',NULL,'Sandalia XELS Entrenadora Droppers Infantil 604 Azul Petroleo','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(28,28,'product',19,1,'1',NULL,'Sandalia XELS Entrenadora Kidori Infantil 9886 Rojo','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(29,29,'product',20,1,'1',NULL,'Sandalia XELS Entrenadora Droppers Infantil 603 Rosa Pastel','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(30,30,'product',20,1,'1',NULL,'Sandalia XELS Kids Para Niña Ice Cream 661','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(31,31,'product',20,1,'1',NULL,'Sandalia XELS Para Niña Con Forma De Unicornio 9878','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(32,32,'product',21,2,'1',NULL,'NOTA DE CRÉDITO POR ANTICIPO POR SERVICIOS PRESTADOS','Anticipo',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(33,33,'product',5,1,'1',NULL,'Zapato Acuático Unisex Negro','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(34,34,'product',5,4,'PAR',NULL,'Zapato Acuático Tela C/diseño Cab','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(35,35,'product',5,4,'PAR',NULL,'Zapato Acuático Tela C/diseño Dama','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(36,36,'product',5,1,'PIEZA',NULL,'Tennis suela runner antiderrapante  MODELO X10','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(37,37,'product',5,4,'1',NULL,'SANDALIA W60','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(38,38,'product',5,1,'1',NULL,'SANDALIA CHUNKY DAMA','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(39,39,'product',5,1,'1',NULL,'X10-UN-BLA','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(40,40,'product',5,1,'1',NULL,'SANDALIA W20','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(41,41,'product',5,1,'1',NULL,'SANDALIA TIRAS','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(42,42,'product',5,1,'1',NULL,'SANDALIA W70','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(43,43,'product',5,1,'1',NULL,'SANDALIA CHUNKY P DE GALLO','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(44,44,'product',5,1,'1',NULL,'SANDALIA W20C','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(45,45,'product',5,1,'1',NULL,'X10-UN-BLU','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(46,46,'product',22,1,'1',NULL,'Gancho Garza','Ganchos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(47,47,'product',22,1,'1',NULL,'Gancho Fussion','Ganchos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(48,48,'product',5,1,'1',NULL,'Zapato Xels Antiderrapante','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(49,49,'product',5,1,'1',NULL,'ANTICIPO ZAPATOS XELS AQUASHOES','ACT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(50,50,'product',5,1,'1',NULL,'Sandalia minimalista Modelo W50','Zapatos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(51,51,'product',23,5,'1',NULL,'Camisa Cuello Mao Color Blanco para Caballero','Camisa',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(52,52,'product',24,5,'1',NULL,'Camisa Cuello Mao Azul para Dama','Camisa',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(53,53,'product',25,1,'PIEZA',NULL,'Banderines tela sublimada Medidas 1.5 x 3.5 m','BANDERAS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(54,54,'product',1,2,'1',NULL,'Instalaciones','Instalacion',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(55,55,'product',26,10,'Rollo de tela',NULL,'TELA SUBLIMADA','TELA SUBLIMADA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(56,56,'product',23,1,'1',NULL,'Camisa de uniforme de seguridad','Camisa seguridad',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(57,57,'product',27,1,'1',NULL,'morrales artesanales','morral artesanal',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(58,58,'product',28,1,'1',NULL,'sandalia eva unisex w90 pro','w90 pro',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(59,59,'product',28,4,'1',NULL,'sandalia w20','w20',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(60,60,'product',29,1,'1',NULL,'playera Xels licra','PLAYERA LICRA MANGA LARGA XB',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(61,61,'product',5,1,'1',NULL,'sandalia eva cafe grande','Sandalia T-star Miki gr',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(62,62,'product',5,1,'1',NULL,'sandalia eva cafe chica','Sandalia T-star Miki ch',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(63,63,'product',30,1,'PIEZA',NULL,'STANDS EXHIBIDORES','STANDS EXHIBIDORES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(64,64,'product',25,1,'1',NULL,'Bandera sublimada de .90 x 1.50','Banderola',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(65,65,'product',11,1,'1',NULL,'Back estructura','Back estructura',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(66,66,'product',31,1,'1',NULL,'Base de acero para Bandera','Bases de Acero',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(67,67,'product',5,1,'1',NULL,'topsider rojo','topsider',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(68,68,'product',32,1,'1',NULL,'ANTICIPO.- INSUMOS DE BRANDING PARA TORNEO DE GOLF','ACT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(69,69,'product',32,7,'1',NULL,'INSUMOS DE BRANDING PARA TORNEO DE GOLF','ACT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(70,70,'product',23,1,'1',NULL,'Camisa de caballero','Camisa caballero',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(71,71,'product',24,1,'1',NULL,'Blusa dama','Blusa dama',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(72,72,'product',24,1,'1',NULL,'Blusa dama especial','Blusa dama',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(73,73,'product',33,1,'1',NULL,'Vestido para mujer','Vestido',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(74,74,'product',34,1,'PIEZA',NULL,'Pantalon hombre','Pantalon hombre',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(75,75,'product',35,1,'PIEZA',NULL,'Pantalon dama','Pantalon dama',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(76,76,'product',35,1,'PIEZA',NULL,'Pantalon dama especial','Pantalon dama especial',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(77,77,'product',36,7,'1',NULL,'SET DE COLLAR Y PEINETA PARA HOSTESS','SET DE COLLAR Y PEINETA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(78,78,'product',36,7,'1',NULL,'SET DE COLLAR Y ARETES PARA HOSTESS','SET DE COLLAR Y ARETES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(79,79,'product',37,1,'1',NULL,'CHALECO SEG GPO CINTA REF GRIS GRI G','CHALECO G',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(80,80,'product',37,1,'1',NULL,'CHALECO SEG GPO CINTA REF GRIS GRI XG','CHALECO XG',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(81,81,'product',37,1,'1',NULL,'CHALECO SEG GPO CINTA REF GRIS GRI M','CHALECO M',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(82,82,'product',38,1,'1',NULL,'Dona plastisol doble vista','Dona Plastisol',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(83,83,'product',39,1,'1',NULL,'Molde Aluminio','Molde Aluminio',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(84,84,'product',5,4,'1',NULL,'Aquashoes Unisex','Aquashoes',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(85,85,'product',40,1,'1',NULL,'Estaca','Estaca',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(86,86,'product',41,1,'1',NULL,'50 metros de cuerda','Cuerda',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(87,87,'product',42,1,'1',NULL,'Poste de madera','Poste',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(88,88,'product',29,1,'1',NULL,'XELS WET DAMA PACIFIC MNO','XELS WET DAMA PACIFIC MNO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(89,89,'product',43,1,'1',NULL,'XELS WET CAB PACIFIC MNO','XELS WET CAB PACIFIC MNO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(90,90,'product',5,1,'1',NULL,'Zapatos Aquashoes','Zapatos Aquashoes',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(91,91,'product',5,1,'1',NULL,'Sandalias','Sandalias',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(92,92,'product',5,1,'1',NULL,'X10-UN-BLA','Sandalias',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(93,93,'product',5,1,'1',NULL,'X10-UN-BLU','Sandalias',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(94,94,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 23','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(95,95,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 24','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(96,96,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 26','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(97,97,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 27','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(98,98,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 28','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(99,99,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 29','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(100,100,'product',5,11,'PARES',NULL,'Multicolor Negro/Amarillo/Naranja 30','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(101,101,'product',44,11,'PARES',NULL,'Caballero Negro/Azul 26','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(102,102,'product',44,11,'PARES',NULL,'Caballero Negro/Azul 27','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(103,103,'product',44,11,'PARES',NULL,'Caballero Negro/Azul 28','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(104,104,'product',44,11,'PARES',NULL,'Caballero Negro/Azul 29','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(105,105,'product',44,11,'PARES',NULL,'Caballero Negro/Azul 30','Aquashoes Xels Unisex',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(106,106,'product',23,12,'1',NULL,'Playera Polo 50 poliester y 50 algodon','Polo Uniforme',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(107,107,'product',45,1,'1',NULL,'SET DE ARETES - SET DE ARETES PARA HOSTESS','ARETES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(108,108,'product',46,1,'Pendones',NULL,'Pendones 1.5 x 4.00 M','Pendones',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(109,109,'product',1,2,'Servicio',NULL,'Reparacion Display','Reparacion Display',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(110,110,'product',47,4,'PAR',NULL,'BOTAS IMPERMEABLE S/CASCO','BOTAS IMPERMEABLE S/CASCO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(111,111,'product',47,4,'PAR',NULL,'BOTAS IMPERMEABLE C/CASCO','BOTAS IMPERMEABLE C/CASCO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(112,112,'product',1,6,'1',NULL,'Bolsas para laptop personalizada','Bolsas para laptop',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(113,113,'product',48,2,'1',NULL,'Placa de Acero Personalizada','Placa de Acero Personalizada',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(114,114,'product',1,1,'1',NULL,'Casaca','Casaca',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(115,115,'product',49,1,'1',NULL,'Mantel Licra Sublimado','Manteles Sublimados',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(116,116,'product',1,5,'1',NULL,'Crocs Modelo Classic','Crocs',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(117,117,'product',50,1,'1',NULL,'Pines','Pines',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(118,118,'product',18,5,'1',NULL,'IMAN PERSONALIZADO','IMAN PERSONALIZADO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(119,119,'product',51,12,'1',NULL,'Buffs','buffs',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(120,120,'product',52,1,'Lanyards',NULL,'LANYARDS','LANYARDS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(121,121,'product',53,1,'1',NULL,'COLCHON','COLCHON',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(122,122,'product',54,1,'1',NULL,'COMPU','Computadora escritorio',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(123,123,'product',37,1,'PIEZA',NULL,'Chaleco Elastico Reflejante Doble Vista','CHALECOUNI',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(124,124,'product',55,1,'1',NULL,'CHALECO VIAL MESH SUBLIMADO','CHALECO MESH',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(125,125,'product',5,4,'1',NULL,'BOTIN DAMA','BOTINAGUJETA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(126,126,'product',32,9,'pieza',NULL,'material promocional','Kit Promocionales',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(127,127,'product',32,1,'1',NULL,'COPETE SOBRE TROVISEL','TROVISEL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(128,128,'product',56,1,'1',NULL,'INFLABLE GIRATORIO PERSONALIZADO','INFLABLE GIRATORIO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(129,129,'product',57,2,'1',NULL,'impresion para casco','Impresion para casco',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(130,130,'product',58,1,'1',NULL,'SOMBRERO DRY FIT','SOM PREM',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(131,131,'product',59,1,'PIEZA',NULL,'LENTES DE SOL','LENTES DE SOL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(132,132,'product',60,1,'pieza',NULL,'mochila impermeable','mochila impermeable',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(133,133,'product',58,1,'pieza',NULL,'Gorra o sombrero','Gorra o Sombrero',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(134,134,'product',61,4,'pieza',NULL,'Bota de piel con casquillo','Bota de piel con casquillo',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(135,135,'product',62,1,'FAJA',NULL,'FAJAS','FAJA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(136,136,'product',48,2,'Unidad de Servicio',NULL,'Servicio de elaboración de placas con logo.','Placas con logo',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(137,137,'product',63,2,'Unidad de Servicio',NULL,'Elaboración de parche','Elaboracion de parche',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(138,138,'product',64,1,'1',NULL,'REDUCTOR DE VELOCIDAD PLASTICO INDUSTRIAL','BOYA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(139,139,'product',65,4,'par',NULL,'Calzado Deportivo Xels','Calzado Deportivo Xels',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(140,140,'product',66,1,'pieza',NULL,'cubeta 4 litros','Vasos personalizados',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(141,141,'product',67,1,'1',NULL,'Porta Latas de Neopreno','Porta latas',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(142,142,'product',68,1,'pieza',NULL,'Bolsa de manta','bolsa manta',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(143,143,'product',69,2,'Unidad de Servicio',NULL,'Regalias por derechos de autor','Derechos de autor',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(144,144,'product',70,1,'1',NULL,'Spaguetti flotador espuma','Spaguetti flotador espuma',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(145,145,'product',68,1,'1',NULL,'Bolsa de playa de malla','Bolsa de playa de malla',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(146,146,'product',71,1,'1',NULL,'Tabla natacion','Tabla natacion',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(147,147,'product',72,1,'1',NULL,'Aros flotadores','Aros flotadores',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(148,148,'product',1,5,'Pieza',NULL,'Careta Snorkel','Mascara Snorkel',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(149,149,'product',71,1,'pieza',NULL,'Spaguetti flotador','Spaguetti flotador',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(150,150,'product',71,1,'pieza',NULL,'Aros flotadores','Aros flotadores',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(151,151,'product',65,4,'1',NULL,'Tennis tejido antiderrapante','Calzado deportivo',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(152,152,'product',18,1,'PIEZA',NULL,'Llavero sublimado personalizable','Llavero Sublimado',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(153,153,'product',73,1,'1',NULL,'Bandana sublimada para mascota','Bandana de mascota con collar',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(154,154,'product',74,13,'1',NULL,'El precio se debe poner correspondiente al anticipo que se realizo','Facturación de anticipos',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(155,155,'product',43,1,'1',NULL,'DRY FIT REGULAR','PLAYERA DRY FIT',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(156,156,'product',75,1,'1',NULL,'LAPICEROS PERSONALIZADOS','LAPICEROS PERSONALIZADOS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(157,157,'product',76,1,'PIEZA',NULL,'IMPERMEABLE ADULTO','IMPERMEABLE',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(158,158,'product',77,4,'1',NULL,'PANTUNFLAS','Pantunflas',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(159,159,'product',78,1,'1',NULL,'Stiker','Stiker',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(160,160,'product',79,1,'PIEZA',NULL,'Hamacas para Alberca (Inflable)','Hamaca de alberca',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(161,161,'product',80,1,'PIEZA',NULL,'BOLSAS TEJIDAS','BOLSAS TEJIDAS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(162,162,'product',81,1,'PIEZA',NULL,'MANDIL AHULADO NEGRO','MANDIL AHULADO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(163,163,'product',82,1,'PIEZA',NULL,'TOALLAS DE GOLF PROMOCIONAL WAFLE CHICO','TOALLAS DE GOLF',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(164,164,'product',83,1,'PIEZA',NULL,'STICKERS','STICKERS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(165,165,'product',84,1,'PIEZA',NULL,'SEÃ‘ALETICA INTERCAMBIABLE DE ALUMINIO','SEÃ‘ALIZADORES INTERCAMBIABLES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(166,166,'product',85,4,'PAR',NULL,'BOTA CAMARA FRIA ESTILO  6-67 FLEXP01-D','Botas Camara Fria',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(167,167,'product',86,1,'PIEZA',NULL,'TIJERA ALUMINIO','TIJERA ALUMINIO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(168,168,'product',87,1,'PIEZA',NULL,'PRODUCTO FC2 #11755 SIN DESCRIPCIÓN','CONECTOR DE PLASTICO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(169,169,'product',61,4,'PAR',NULL,'BOTAS DE CONGELACION ALTA','BOTAS DE CONGELACION ALTA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(170,170,'product',88,1,'PIEZA',NULL,'FUNDAS SUN COVER','FUNDAS SUN COVER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(171,171,'product',89,1,'PIEZA',NULL,'BOLSA TEJIDO TEXTIL','BOLSA TEJIDO TEXTIL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(172,172,'product',90,1,'PIEZA',NULL,'BOLSAS DE MANTA','BOLSA DE MANTA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(173,173,'product',5,4,'PAR',NULL,'CALZADO P/ CAMARISTA DAMA COLOR CAFE','CALZADO P/ CAMARISTA DAMA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(174,174,'product',5,4,'PAR',NULL,'CALZADO P/ CAMARISTO CABALLERO COLOR CAFE','CALZADO P/ CAMARISTO CABALLERO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(175,175,'product',61,4,'PAR',NULL,'BOTA DIELECTRICA','BOTA DIELECTRICA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(176,176,'product',91,2,NULL,NULL,'EVENTO MONTELOBOS NAVIKA','EVENTO MONTELOBOS NAVIKA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(177,177,'product',92,1,'PIEZA',NULL,'Poste de Aluminio para Bandera','Postes de Aluminio',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(178,178,'product',93,1,'PIEZA',NULL,'Artesania Alebrijes','Artesania Alebrijes',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(179,179,'product',94,2,'Unidad de Servicio',NULL,'Servicio ReparaciÃ³n Playeras DTF','Servicio ReparaciÃ³n Playeras',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(180,180,'product',95,1,'PIEZA',NULL,'MONEDA FIGURA CACAO','MONEDA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(181,181,'product',96,1,'PIEZA',NULL,'Lon Mesh Medida 2X3','Lonas Publicitarias',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(182,182,'product',97,1,'PIEZA',NULL,'BOLSAS DE ROLL UP','BOLSAS DE ROLL UP',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(183,183,'product',97,1,'PIEZA',NULL,'BOLSAS DE MURO','BOLSAS DE MURO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(184,184,'product',98,1,'PIEZA',NULL,'Estructura Tubular Colgante con Tela','Estructura Tubular Colgante',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(185,185,'product',99,1,'PIEZA',NULL,'SHAKER ALUMINIO 350ML','SHAKER ALUMINIO 350ML',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(186,186,'product',100,1,'PIEZA',NULL,'COSTER DE PIEL SIN COSTURAS','COSTER DE PIEL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(187,187,'product',101,1,'PIEZA',NULL,'TROQUEL','TROQUEL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(188,188,'product',102,1,'PIEZA',NULL,'CAJA ESPECIAL','CAJA ESPECIAL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(189,189,'product',103,2,'Servicio',NULL,'Grabado Laser','Impresion Digital',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(190,190,'product',104,1,'PIEZA',NULL,'BASE DE MADERA RECONOCIMIENTO','BASE DE MADERA RECONOCIMIENTO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(191,191,'product',105,1,'PIEZA',NULL,'Folders Conferencia','Folders Conferencia',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(192,192,'product',106,2,'Servicio',NULL,'Servicio ponchado','Servicio Costura Industrial',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(193,193,'product',93,1,'PIEZA',NULL,'Cesto Palma','Cesto Palma',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(194,194,'product',107,1,'PIEZA',NULL,'YETI ORIGINAL CON GRABADO','YETI ORIGINAL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(195,195,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #23','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(196,196,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #24','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(197,197,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #25','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(198,198,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #26','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(199,199,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #27','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(200,200,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #28','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(201,201,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER BLANCOS #29','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(202,202,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #23','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(203,203,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #24','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(204,204,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #25','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(205,205,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #26','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(206,206,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #27','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(207,207,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #28','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(208,208,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER AZUL #29','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(209,209,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #23','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(210,210,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #24','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(211,211,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #25','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(212,212,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #26','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(213,213,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #27','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(214,214,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #28','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(215,215,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER ROJO #29','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(216,216,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #23','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(217,217,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #24','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(218,218,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #25','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(219,219,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #26','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(220,220,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #27','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(221,221,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #28','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(222,222,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER NEGRO #29','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(223,223,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #23','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(224,224,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #24','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(225,225,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #25','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(226,226,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #26','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(227,227,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #27','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(228,228,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #28','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(229,229,'product',65,4,'PAR',NULL,'TENIS XELS ACTION LEATHER CAFE #29','TENIS XELS ACTION LEATHER',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(230,230,'product',108,1,'PIEZA',NULL,'PAÑOS DE LENTES','PAÑOS MICROFIBRA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(231,231,'product',109,1,'PIEZA',NULL,'FAJAS INDUSTRIALES','FAJAS INDUSTRIALES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(232,232,'product',110,1,'PIEZA',NULL,'ESTRUCTURA TOLDO 3 X3','ESTRUCTURA TOLDO 3 X3',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(233,233,'product',111,1,'PIEZA',NULL,'PULSERAS CON AHORCADOR','PULSERAS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(234,234,'product',52,1,'PIEZA',NULL,'GAFETES ESTIRENO','GAFETES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(235,235,'product',112,1,'PIEZA',NULL,'SELLOS DE GOLF','SELLOS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(236,236,'product',113,1,'PIEZA',NULL,'PORTA COMANDAS','PORTACOMANDAS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(237,237,'product',114,2,'Unidad de Servicio',NULL,'RECONOCIMIENTOS TEXTURIZADOS','Servicio de Fabricación',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(238,238,'product',74,2,'Unidad de Servicio',NULL,'NOTAS DE CREDITO','NOTAS DE CREDITO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(239,239,'product',115,1,'PIEZA',NULL,'PALIACATES','PAÑUELOS- PALIACATES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(240,240,'product',116,1,'PIEZA',NULL,'ESTROPAJO LUFFA','ESTROPAJO LUFFA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(241,241,'product',117,1,'PIEZA',NULL,'ALUCOBOND ALUMINIO','ALUCOBOND ALUMINIO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(242,242,'product',118,1,'PIEZA',NULL,'TORTILLERO C/TAPA OVALADO 17CM','TORTILLERO OVALADO 17CM',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(243,243,'product',118,1,'PIEZA',NULL,'PANERA OVALADA 35X20CM','PANERA OVALADA 35X20CM',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(244,244,'product',119,14,'ROLLO',NULL,'SUMINISTRO DE PISO PVC PARA PISCINA','SUMINISTRO DE PISO PVC',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(245,245,'product',84,1,'PIEZA',NULL,'LETREROS DE ALUCOBOND','LETREROS DE ALUCOBOND',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(246,246,'product',120,1,'PIEZA',NULL,'PLAYERAS RASH UV','PLAYERAS RASH UV',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(247,247,'product',115,1,'PIEZA',NULL,'PARCHES XPLOR','PARCHES',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(248,248,'product',121,1,'PIEZA',NULL,'COLLAR ACCESORIO XELS','COLLAR ACCESORIO XELS',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(249,249,'product',122,1,'PIEZA',NULL,'CALCOMONIA TATUAJE','CALCOMONIA TATUAJE',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(250,250,'product',93,1,'PIEZA',NULL,'CESTO LARGO AZUL','CESTO LARGO AZUL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(251,251,'product',93,1,'PIEZA',NULL,'CESTO LARGO CORAL','CESTO LARGO CORAL',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(252,252,'product',61,4,'PAR',NULL,'BOTIN INDUSTRIAL BLANCO','BOTIN INDUSTRIAL BLANCO',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(253,253,'product',123,1,'PIEZA',NULL,'LETRERO MADERA','LETRERO MADERA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(254,254,'product',124,1,'PIEZA',NULL,'PANTALONES LIMPIEZA ALOTEC','PANTALONES LIMPIEZA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0),(255,255,'product',125,1,'PIEZA',NULL,'LEGGIN DAMA/CABALLERO LYCRA','LEGGIN DAMA/CABALLERO LYCRA',1,'incomplete',NULL,NULL,1,'2026-08-04 19:24:09','2026-08-04 19:31:16',0);
/*!40000 ALTER TABLE `ikontrol_item_fiscal_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_item_fiscal_taxes`
--

DROP TABLE IF EXISTS `ikontrol_item_fiscal_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_item_fiscal_taxes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_fiscal_setting_id` int(10) unsigned NOT NULL,
  `tax_id` int(10) unsigned NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_fiscal_setting_id_tax_id` (`item_fiscal_setting_id`,`tax_id`),
  KEY `item_fiscal_setting_id_is_active` (`item_fiscal_setting_id`,`is_active`),
  KEY `tax_id` (`tax_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_item_fiscal_taxes`
--

LOCK TABLES `ikontrol_item_fiscal_taxes` WRITE;
/*!40000 ALTER TABLE `ikontrol_item_fiscal_taxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_item_fiscal_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_items`
--

DROP TABLE IF EXISTS `ikontrol_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` decimal(18,6) NOT NULL DEFAULT 0.000000,
  `files` mediumtext NOT NULL,
  `show_in_client_portal` tinyint(1) NOT NULL DEFAULT 0,
  `category_id` int(11) NOT NULL,
  `taxable` tinyint(1) NOT NULL DEFAULT 0,
  `sort` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_items`
--

LOCK TABLES `ikontrol_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_items` DISABLE KEYS */;
INSERT INTO `ikontrol_items` VALUES (1,'CAPACITACION DE EMPLEADOS','.','SERV.',1.000000,'',0,1,0,0,0),(2,'ZAPATOS','.','PRS',1.000000,'',0,1,0,0,0),(3,'Prestación de servicios profesionales en Yucatán',NULL,'1',5000.000000,'',0,1,0,0,0),(4,'Prestación de servicios profesionales en Yucatán',NULL,'1',3000.000000,'',0,1,0,0,0),(5,'bandera tela sublimada  con estructura metálica y flexible base cromada en x',NULL,'PIEZA',3600.000000,'',0,1,0,0,0),(6,'Cartera tarjetero piel',NULL,'1',406.000000,'',0,1,0,0,0),(7,'cosmetiquera sintetico',NULL,'1',200.000000,'',0,1,0,0,0),(8,'Display Roll Up',NULL,'1',1800.000000,'',0,1,0,0,0),(9,'Muro expandible',NULL,'1',6832.400000,'',0,1,0,0,0),(10,'libreta personalizada espiral',NULL,'Lib',98.600000,'',0,1,0,0,0),(11,'SERVICIO DE FLETE',NULL,'1',700.000000,'',0,1,0,0,0),(12,'Careta protectora',NULL,'1',58.000000,'',0,1,0,0,0),(13,'FLAYERS 1/4 CARTA UNA VISTA',NULL,'PIEZA',590.000000,'',0,1,0,0,0),(14,'TAPETE SANITIZANTE PVC',NULL,'PIEZA',216.000000,'',0,1,0,0,0),(15,'Tenis full plastic pvc reciclable',NULL,'1',197.000000,'',0,1,0,0,0),(16,'Tenis full plastic pvc reciclable',NULL,'1',197.000000,'',0,1,0,0,0),(17,'TENIS ANTIDERRAPANTE  XELS',NULL,'PAR',189.000000,'',0,1,0,0,0),(18,'Bolsa malla sec, ahorcador',NULL,'1',14.000000,'',0,1,0,0,0),(19,'LogÃ­stica de Entrega',NULL,'1',250.000000,'',0,1,0,0,0),(20,'SET MAQUILLAJE CATRINA REV 40301100 GR',NULL,'1',43.020000,'',0,1,0,0,0),(21,'MAQUILLAJE TUBO REV i9442C 40 GR NGO',NULL,'1',19.740000,'',0,1,0,0,0),(22,'glow dark make up',NULL,'1',25.780000,'',0,1,0,0,0),(23,'Llavero plastisol personalizado, herraje sencillo',NULL,'PIEZA',49.600000,'',0,1,0,0,0),(24,'Uniformes borados Mia tulum',NULL,'1',381.600000,'',0,1,0,0,0),(25,'ANTICIPO ZAPATOS BB XELS',NULL,'1',14648.100000,'',0,1,0,0,0),(26,'ANTICIPO ZAPATOS XELS FULL PLASTIC',NULL,'1',1054806.000000,'',0,1,0,0,0),(27,'Sandalia XELS Entrenadora Droppers Infantil 604 Azul Petroleo',NULL,'1',136.363600,'',0,1,0,0,0),(28,'Sandalia XELS Entrenadora Kidori Infantil 9886 Rojo',NULL,'1',127.272700,'',0,1,0,0,0),(29,'Sandalia XELS Entrenadora Droppers Infantil 603 Rosa Pastel',NULL,'1',136.363600,'',0,1,0,0,0),(30,'Sandalia XELS Kids Para Niña Ice Cream 661',NULL,'1',154.545500,'',0,1,0,0,0),(31,'Sandalia XELS Para Niña Con Forma De Unicornio 9878',NULL,'1',181.818200,'',0,1,0,0,0),(32,'NOTA DE CRÉDITO POR ANTICIPO POR SERVICIOS PRESTADOS',NULL,'1',14648.100000,'',0,1,0,0,0),(33,'Zapato Acuático Unisex Negro',NULL,'1',89.000000,'',0,1,0,0,0),(34,'Zapato Acuático Tela C/diseño Cab',NULL,'PAR',115.000000,'',0,1,0,0,0),(35,'Zapato Acuático Tela C/diseño Dama',NULL,'PAR',115.000000,'',0,1,0,0,0),(36,'Tennis suela runner antiderrapante  MODELO X10',NULL,'PIEZA',266.000000,'',0,1,0,0,0),(37,'SANDALIA W60',NULL,'1',134.200000,'',0,1,0,0,0),(38,'SANDALIA CHUNKY DAMA',NULL,'1',134.200000,'',0,1,0,0,0),(39,'X10-UN-BLA',NULL,'1',599.000000,'',0,1,0,0,0),(40,'SANDALIA W20',NULL,'1',102.100000,'',0,1,0,0,0),(41,'SANDALIA TIRAS',NULL,'1',102.100000,'',0,1,0,0,0),(42,'SANDALIA W70',NULL,'1',134.200000,'',0,1,0,0,0),(43,'SANDALIA CHUNKY P DE GALLO',NULL,'1',134.200000,'',0,1,0,0,0),(44,'SANDALIA W20C',NULL,'1',112.800000,'',0,1,0,0,0),(45,'X10-UN-BLU',NULL,'1',450.000000,'',0,1,0,0,0),(46,'Gancho Garza',NULL,'1',3.500000,'',0,1,0,0,0),(47,'Gancho Fussion',NULL,'1',2.000000,'',0,1,0,0,0),(48,'Zapato Xels Antiderrapante',NULL,'1',230.000000,'',0,1,0,0,0),(49,'ANTICIPO ZAPATOS XELS AQUASHOES',NULL,'1',1268982.000000,'',0,1,0,0,0),(50,'Sandalia minimalista Modelo W50',NULL,'1',170.000000,'',0,1,0,0,0),(51,'Camisa Cuello Mao Color Blanco para Caballero',NULL,'1',370.000000,'',0,1,0,0,0),(52,'Camisa Cuello Mao Azul para Dama',NULL,'1',370.000000,'',0,1,0,0,0),(53,'Banderines tela sublimada Medidas 1.5 x 3.5 m',NULL,'PIEZA',2800.000000,'',0,1,0,0,0),(54,'Instalaciones',NULL,'1',990.000000,'',0,1,0,0,0),(55,'TELA SUBLIMADA',NULL,'Rollo de tela',3100.000000,'',0,1,0,0,0),(56,'Camisa de uniforme de seguridad',NULL,'1',360.000000,'',0,1,0,0,0),(57,'morrales artesanales',NULL,'1',149.000000,'',0,1,0,0,0),(58,'sandalia eva unisex w90 pro',NULL,'1',145.000000,'',0,1,0,0,0),(59,'sandalia w20',NULL,'1',99.000000,'',0,1,0,0,0),(60,'playera Xels licra',NULL,'1',320.000000,'',0,1,0,0,0),(61,'sandalia eva cafe grande',NULL,'1',154.000000,'',0,1,0,0,0),(62,'sandalia eva cafe chica',NULL,'1',143.000000,'',0,1,0,0,0),(63,'STANDS EXHIBIDORES',NULL,'PIEZA',955.000000,'',0,1,0,0,0),(64,'Bandera sublimada de .90 x 1.50',NULL,'1',655.550000,'',0,1,0,0,0),(65,'Back estructura',NULL,'1',5850.000000,'',0,1,0,0,0),(66,'Base de acero para Bandera',NULL,'1',1600.000000,'',0,1,0,0,0),(67,'topsider rojo',NULL,'1',190.000000,'',0,1,0,0,0),(68,'ANTICIPO.- INSUMOS DE BRANDING PARA TORNEO DE GOLF',NULL,'1',13360.340000,'',0,1,0,0,0),(69,'INSUMOS DE BRANDING PARA TORNEO DE GOLF',NULL,'1',26718.000000,'',0,1,0,0,0),(70,'Camisa de caballero',NULL,'1',270.000000,'',0,1,0,0,0),(71,'Blusa dama',NULL,'1',333.000000,'',0,1,0,0,0),(72,'Blusa dama especial',NULL,'1',423.000000,'',0,1,0,0,0),(73,'Vestido para mujer',NULL,'1',576.000000,'',0,1,0,0,0),(74,'Pantalon hombre',NULL,'PIEZA',315.000000,'',0,1,0,0,0),(75,'Pantalon dama',NULL,'PIEZA',315.000000,'',0,1,0,0,0),(76,'Pantalon dama especial',NULL,'PIEZA',405.000000,'',0,1,0,0,0),(77,'SET DE COLLAR Y PEINETA PARA HOSTESS',NULL,'1',317.720000,'',0,1,0,0,0),(78,'SET DE COLLAR Y ARETES PARA HOSTESS',NULL,'1',250.500000,'',0,1,0,0,0),(79,'CHALECO SEG GPO CINTA REF GRIS GRI G',NULL,'1',146.300000,'',0,1,0,0,0),(80,'CHALECO SEG GPO CINTA REF GRIS GRI XG',NULL,'1',146.300000,'',0,1,0,0,0),(81,'CHALECO SEG GPO CINTA REF GRIS GRI M',NULL,'1',146.300000,'',0,1,0,0,0),(82,'Dona plastisol doble vista',NULL,'1',13.000000,'',0,1,0,0,0),(83,'Molde Aluminio',NULL,'1',2600.000000,'',0,1,0,0,0),(84,'Aquashoes Unisex',NULL,'1',111.720000,'',0,1,0,0,0),(85,'Estaca',NULL,'1',400.000000,'',0,1,0,0,0),(86,'50 metros de cuerda',NULL,'1',18.270000,'',0,1,0,0,0),(87,'Poste de madera',NULL,'1',200.000000,'',0,1,0,0,0),(88,'XELS WET DAMA PACIFIC MNO',NULL,'1',401.360000,'',0,1,0,0,0),(89,'XELS WET CAB PACIFIC MNO',NULL,'1',346.840000,'',0,1,0,0,0),(90,'Zapatos Aquashoes',NULL,'1',129.600000,'',0,1,0,0,0),(91,'Sandalias',NULL,'1',450.000000,'',0,1,0,0,0),(92,'X10-UN-BLA',NULL,'1',599.000000,'',0,1,0,0,0),(93,'X10-UN-BLU',NULL,'1',599.000000,'',0,1,0,0,0),(94,'Multicolor Negro/Amarillo/Naranja 23',NULL,'PARES',274.500000,'',0,1,0,0,0),(95,'Multicolor Negro/Amarillo/Naranja 24',NULL,'PARES',274.500000,'',0,1,0,0,0),(96,'Multicolor Negro/Amarillo/Naranja 26',NULL,'PARES',274.500000,'',0,1,0,0,0),(97,'Multicolor Negro/Amarillo/Naranja 27',NULL,'PARES',274.500000,'',0,1,0,0,0),(98,'Multicolor Negro/Amarillo/Naranja 28',NULL,'PARES',274.500000,'',0,1,0,0,0),(99,'Multicolor Negro/Amarillo/Naranja 29',NULL,'PARES',274.500000,'',0,1,0,0,0),(100,'Multicolor Negro/Amarillo/Naranja 30',NULL,'PARES',274.500000,'',0,1,0,0,0),(101,'Caballero Negro/Azul 26',NULL,'PARES',274.500000,'',0,1,0,0,0),(102,'Caballero Negro/Azul 27',NULL,'PARES',274.500000,'',0,1,0,0,0),(103,'Caballero Negro/Azul 28',NULL,'PARES',274.500000,'',0,1,0,0,0),(104,'Caballero Negro/Azul 29',NULL,'PARES',274.500000,'',0,1,0,0,0),(105,'Caballero Negro/Azul 30',NULL,'PARES',274.500000,'',0,1,0,0,0),(106,'Playera Polo 50 poliester y 50 algodon',NULL,'1',344.000000,'',0,1,0,0,0),(107,'SET DE ARETES - SET DE ARETES PARA HOSTESS',NULL,'1',100.000000,'',0,1,0,0,0),(108,'Pendones 1.5 x 4.00 M',NULL,'Pendones',3045.000000,'',0,1,0,0,0),(109,'Reparacion Display',NULL,'Servicio',2000.000000,'',0,1,0,0,0),(110,'BOTAS IMPERMEABLE S/CASCO',NULL,'PAR',294.000000,'',0,1,0,0,0),(111,'BOTAS IMPERMEABLE C/CASCO',NULL,'PAR',318.000000,'',0,1,0,0,0),(112,'Bolsas para laptop personalizada',NULL,'1',536.000000,'',0,1,0,0,0),(113,'Placa de Acero Personalizada',NULL,'1',499.000000,'',0,1,0,0,0),(114,'Casaca',NULL,'1',251.440000,'',0,1,0,0,0),(115,'Mantel Licra Sublimado',NULL,'1',1777.430000,'',0,1,0,0,0),(116,'Crocs Modelo Classic',NULL,'1',820.000000,'',0,1,0,0,0),(117,'Pines',NULL,'1',70.000000,'',0,1,0,0,0),(118,'IMAN PERSONALIZADO',NULL,'1',44.000000,'',0,1,0,0,0),(119,'Buffs',NULL,'1',70.000000,'',0,1,0,0,0),(120,'LANYARDS',NULL,'Lanyards',121.700000,'',0,1,0,0,0),(121,'COLCHON',NULL,'1',4990.000000,'',0,1,0,0,0),(122,'COMPU',NULL,'1',15000.000000,'',0,1,0,0,0),(123,'Chaleco Elastico Reflejante Doble Vista',NULL,'PIEZA',210.000000,'',0,1,0,0,0),(124,'CHALECO VIAL MESH SUBLIMADO',NULL,'1',576.920000,'',0,1,0,0,0),(125,'BOTIN DAMA',NULL,'1',386.000000,'',0,1,0,0,0),(126,'material promocional',NULL,'pieza',58.490000,'',0,1,0,0,0),(127,'COPETE SOBRE TROVISEL',NULL,'1',240.000000,'',0,1,0,0,0),(128,'INFLABLE GIRATORIO PERSONALIZADO',NULL,'1',26000.000000,'',0,1,0,0,0),(129,'impresion para casco',NULL,'1',700.000000,'',0,1,0,0,0),(130,'SOMBRERO DRY FIT',NULL,'1',380.000000,'',0,1,0,0,0),(131,'LENTES DE SOL',NULL,'PIEZA',120.000000,'',0,1,0,0,0),(132,'mochila impermeable',NULL,'pieza',600.000000,'',0,1,0,0,0),(133,'Gorra o sombrero',NULL,'pieza',99.000000,'',0,1,0,0,0),(134,'Bota de piel con casquillo',NULL,'pieza',750.000000,'',0,1,0,0,0),(135,'FAJAS',NULL,'FAJA',240.000000,'',0,1,0,0,0),(136,'Servicio de elaboración de placas con logo.',NULL,'Unidad de Servicio',1000.000000,'',0,1,0,0,0),(137,'Elaboración de parche',NULL,'Unidad de Servicio',22.000000,'',0,1,0,0,0),(138,'REDUCTOR DE VELOCIDAD PLASTICO INDUSTRIAL',NULL,'1',145.000000,'',0,1,0,0,0),(139,'Calzado Deportivo Xels',NULL,'par',650.000000,'',0,1,0,0,0),(140,'cubeta 4 litros',NULL,'pieza',49.000000,'',0,1,0,0,0),(141,'Porta Latas de Neopreno',NULL,'1',34.000000,'',0,1,0,0,0),(142,'Bolsa de manta',NULL,'pieza',49.000000,'',0,1,0,0,0),(143,'Regalias por derechos de autor',NULL,'Unidad de Servicio',249504.000000,'',0,1,0,0,0),(144,'Spaguetti flotador espuma',NULL,'1',70.000000,'',0,1,0,0,0),(145,'Bolsa de playa de malla',NULL,'1',80.000000,'',0,1,0,0,0),(146,'Tabla natacion',NULL,'1',200.000000,'',0,1,0,0,0),(147,'Aros flotadores',NULL,'1',70.000000,'',0,1,0,0,0),(148,'Careta Snorkel',NULL,'Pieza',820.000000,'',0,1,0,0,0),(149,'Spaguetti flotador',NULL,'pieza',70.000000,'',0,1,0,0,0),(150,'Aros flotadores',NULL,'pieza',70.000000,'',0,1,0,0,0),(151,'Tennis tejido antiderrapante',NULL,'1',800.000000,'',0,1,0,0,0),(152,'Llavero sublimado personalizable',NULL,'PIEZA',20.000000,'',0,1,0,0,0),(153,'Bandana sublimada para mascota',NULL,'1',177.000000,'',0,1,0,0,0),(154,'El precio se debe poner correspondiente al anticipo que se realizo',NULL,'1',0.000000,'',0,1,0,0,0),(155,'DRY FIT REGULAR',NULL,'1',250.000000,'',0,1,0,0,0),(156,'LAPICEROS PERSONALIZADOS',NULL,'1',19.000000,'',0,1,0,0,0),(157,'IMPERMEABLE ADULTO',NULL,'PIEZA',150.000000,'',0,1,0,0,0),(158,'PANTUNFLAS',NULL,'1',280.000000,'',0,1,0,0,0),(159,'Stiker',NULL,'1',7.500000,'',0,1,0,0,0),(160,'Hamacas para Alberca (Inflable)',NULL,'PIEZA',100.000000,'',0,1,0,0,0),(161,'BOLSAS TEJIDAS',NULL,'PIEZA',190.000000,'',0,1,0,0,0),(162,'MANDIL AHULADO NEGRO',NULL,'PIEZA',150.000000,'',0,1,0,0,0),(163,'TOALLAS DE GOLF PROMOCIONAL WAFLE CHICO',NULL,'PIEZA',103.000000,'',0,1,0,0,0),(164,'STICKERS',NULL,'PIEZA',130.000000,'',0,1,0,0,0),(165,'SEÃ‘ALETICA INTERCAMBIABLE DE ALUMINIO',NULL,'PIEZA',1500.000000,'',0,1,0,0,0),(166,'BOTA CAMARA FRIA ESTILO  6-67 FLEXP01-D',NULL,'PAR',1100.000000,'',0,1,0,0,0),(167,'TIJERA ALUMINIO',NULL,'PIEZA',620.000000,'',0,1,0,0,0),(168,'PRODUCTO FC2 #11755 SIN DESCRIPCIÓN',NULL,'PIEZA',309.000000,'',0,1,0,0,0),(169,'BOTAS DE CONGELACION ALTA',NULL,'PAR',1100.000000,'',0,1,0,0,0),(170,'FUNDAS SUN COVER',NULL,'PIEZA',2300.000000,'',0,1,0,0,0),(171,'BOLSA TEJIDO TEXTIL',NULL,'PIEZA',240.000000,'',0,1,0,0,0),(172,'BOLSAS DE MANTA',NULL,'PIEZA',16.100000,'',0,1,0,0,0),(173,'CALZADO P/ CAMARISTA DAMA COLOR CAFE',NULL,'PAR',986.230000,'',0,1,0,0,0),(174,'CALZADO P/ CAMARISTO CABALLERO COLOR CAFE',NULL,'PAR',910.000000,'',0,1,0,0,0),(175,'BOTA DIELECTRICA',NULL,'PAR',699.000000,'',0,1,0,0,0),(176,'EVENTO MONTELOBOS NAVIKA',NULL,'',0.000000,'',0,1,0,0,0),(177,'Poste de Aluminio para Bandera',NULL,'PIEZA',770.000000,'',0,1,0,0,0),(178,'Artesania Alebrijes',NULL,'PIEZA',150.000000,'',0,1,0,0,0),(179,'Servicio ReparaciÃ³n Playeras DTF',NULL,'Unidad de Servicio',38.500000,'',0,1,0,0,0),(180,'MONEDA FIGURA CACAO',NULL,'PIEZA',42.000000,'',0,1,0,0,0),(181,'Lon Mesh Medida 2X3',NULL,'PIEZA',2300.000000,'',0,1,0,0,0),(182,'BOLSAS DE ROLL UP',NULL,'PIEZA',228.000000,'',0,1,0,0,0),(183,'BOLSAS DE MURO',NULL,'PIEZA',391.000000,'',0,1,0,0,0),(184,'Estructura Tubular Colgante con Tela',NULL,'PIEZA',18000.000000,'',0,1,0,0,0),(185,'SHAKER ALUMINIO 350ML',NULL,'PIEZA',275.000000,'',0,1,0,0,0),(186,'COSTER DE PIEL SIN COSTURAS',NULL,'PIEZA',150.000000,'',0,1,0,0,0),(187,'TROQUEL',NULL,'PIEZA',3000.000000,'',0,1,0,0,0),(188,'CAJA ESPECIAL',NULL,'PIEZA',220.000000,'',0,1,0,0,0),(189,'Grabado Laser',NULL,'Servicio',0.000000,'',0,1,0,0,0),(190,'BASE DE MADERA RECONOCIMIENTO',NULL,'PIEZA',215.000000,'',0,1,0,0,0),(191,'Folders Conferencia',NULL,'PIEZA',350.000000,'',0,1,0,0,0),(192,'Servicio ponchado',NULL,'Servicio',250.000000,'',0,1,0,0,0),(193,'Cesto Palma',NULL,'PIEZA',350.000000,'',0,1,0,0,0),(194,'YETI ORIGINAL CON GRABADO',NULL,'PIEZA',0.000000,'',0,1,0,0,0),(195,'TENIS XELS ACTION LEATHER BLANCOS #23',NULL,'PAR',840.000000,'',0,1,0,0,0),(196,'TENIS XELS ACTION LEATHER BLANCOS #24',NULL,'PAR',840.000000,'',0,1,0,0,0),(197,'TENIS XELS ACTION LEATHER BLANCOS #25',NULL,'PAR',840.000000,'',0,1,0,0,0),(198,'TENIS XELS ACTION LEATHER BLANCOS #26',NULL,'PAR',840.000000,'',0,1,0,0,0),(199,'TENIS XELS ACTION LEATHER BLANCOS #27',NULL,'PAR',840.000000,'',0,1,0,0,0),(200,'TENIS XELS ACTION LEATHER BLANCOS #28',NULL,'PAR',840.000000,'',0,1,0,0,0),(201,'TENIS XELS ACTION LEATHER BLANCOS #29',NULL,'PAR',840.000000,'',0,1,0,0,0),(202,'TENIS XELS ACTION LEATHER AZUL #23',NULL,'PAR',840.000000,'',0,1,0,0,0),(203,'TENIS XELS ACTION LEATHER AZUL #24',NULL,'PAR',840.000000,'',0,1,0,0,0),(204,'TENIS XELS ACTION LEATHER AZUL #25',NULL,'PAR',840.000000,'',0,1,0,0,0),(205,'TENIS XELS ACTION LEATHER AZUL #26',NULL,'PAR',840.000000,'',0,1,0,0,0),(206,'TENIS XELS ACTION LEATHER AZUL #27',NULL,'PAR',840.000000,'',0,1,0,0,0),(207,'TENIS XELS ACTION LEATHER AZUL #28',NULL,'PAR',840.000000,'',0,1,0,0,0),(208,'TENIS XELS ACTION LEATHER AZUL #29',NULL,'PAR',840.000000,'',0,1,0,0,0),(209,'TENIS XELS ACTION LEATHER ROJO #23',NULL,'PAR',840.000000,'',0,1,0,0,0),(210,'TENIS XELS ACTION LEATHER ROJO #24',NULL,'PAR',840.000000,'',0,1,0,0,0),(211,'TENIS XELS ACTION LEATHER ROJO #25',NULL,'PAR',840.000000,'',0,1,0,0,0),(212,'TENIS XELS ACTION LEATHER ROJO #26',NULL,'PAR',840.000000,'',0,1,0,0,0),(213,'TENIS XELS ACTION LEATHER ROJO #27',NULL,'PAR',840.000000,'',0,1,0,0,0),(214,'TENIS XELS ACTION LEATHER ROJO #28',NULL,'PAR',840.000000,'',0,1,0,0,0),(215,'TENIS XELS ACTION LEATHER ROJO #29',NULL,'PAR',840.000000,'',0,1,0,0,0),(216,'TENIS XELS ACTION LEATHER NEGRO #23',NULL,'PAR',840.000000,'',0,1,0,0,0),(217,'TENIS XELS ACTION LEATHER NEGRO #24',NULL,'PAR',840.000000,'',0,1,0,0,0),(218,'TENIS XELS ACTION LEATHER NEGRO #25',NULL,'PAR',840.000000,'',0,1,0,0,0),(219,'TENIS XELS ACTION LEATHER NEGRO #26',NULL,'PAR',840.000000,'',0,1,0,0,0),(220,'TENIS XELS ACTION LEATHER NEGRO #27',NULL,'PAR',840.000000,'',0,1,0,0,0),(221,'TENIS XELS ACTION LEATHER NEGRO #28',NULL,'PAR',840.000000,'',0,1,0,0,0),(222,'TENIS XELS ACTION LEATHER NEGRO #29',NULL,'PAR',840.000000,'',0,1,0,0,0),(223,'TENIS XELS ACTION LEATHER CAFE #23',NULL,'PAR',840.000000,'',0,1,0,0,0),(224,'TENIS XELS ACTION LEATHER CAFE #24',NULL,'PAR',840.000000,'',0,1,0,0,0),(225,'TENIS XELS ACTION LEATHER CAFE #25',NULL,'PAR',840.000000,'',0,1,0,0,0),(226,'TENIS XELS ACTION LEATHER CAFE #26',NULL,'PAR',840.000000,'',0,1,0,0,0),(227,'TENIS XELS ACTION LEATHER CAFE #27',NULL,'PAR',840.000000,'',0,1,0,0,0),(228,'TENIS XELS ACTION LEATHER CAFE #28',NULL,'PAR',840.000000,'',0,1,0,0,0),(229,'TENIS XELS ACTION LEATHER CAFE #29',NULL,'PAR',840.000000,'',0,1,0,0,0),(230,'PAÑOS DE LENTES',NULL,'PIEZA',25.000000,'',0,1,0,0,0),(231,'FAJAS INDUSTRIALES',NULL,'PIEZA',96.500000,'',0,1,0,0,0),(232,'ESTRUCTURA TOLDO 3 X3',NULL,'PIEZA',10970.000000,'',0,1,0,0,0),(233,'PULSERAS CON AHORCADOR',NULL,'PIEZA',6.300000,'',0,1,0,0,0),(234,'GAFETES ESTIRENO',NULL,'PIEZA',25.000000,'',0,1,0,0,0),(235,'SELLOS DE GOLF',NULL,'PIEZA',4800.000000,'',0,1,0,0,0),(236,'PORTA COMANDAS',NULL,'PIEZA',160.000000,'',0,1,0,0,0),(237,'RECONOCIMIENTOS TEXTURIZADOS',NULL,'Unidad de Servicio',0.000000,'',0,1,0,0,0),(238,'NOTAS DE CREDITO',NULL,'Unidad de Servicio',0.000000,'',0,1,0,0,0),(239,'PALIACATES',NULL,'PIEZA',150.000000,'',0,1,0,0,0),(240,'ESTROPAJO LUFFA',NULL,'PIEZA',23.300000,'',0,1,0,0,0),(241,'ALUCOBOND ALUMINIO',NULL,'PIEZA',17600.000000,'',0,1,0,0,0),(242,'TORTILLERO C/TAPA OVALADO 17CM',NULL,'PIEZA',462.000000,'',0,1,0,0,0),(243,'PANERA OVALADA 35X20CM',NULL,'PIEZA',584.700000,'',0,1,0,0,0),(244,'SUMINISTRO DE PISO PVC PARA PISCINA',NULL,'ROLLO',8833.500000,'',0,1,0,0,0),(245,'LETREROS DE ALUCOBOND',NULL,'PIEZA',1900.000000,'',0,1,0,0,0),(246,'PLAYERAS RASH UV',NULL,'PIEZA',320.000000,'',0,1,0,0,0),(247,'PARCHES XPLOR',NULL,'PIEZA',0.000000,'',0,1,0,0,0),(248,'COLLAR ACCESORIO XELS',NULL,'PIEZA',390.000000,'',0,1,0,0,0),(249,'CALCOMONIA TATUAJE',NULL,'PIEZA',0.000000,'',0,1,0,0,0),(250,'CESTO LARGO AZUL',NULL,'PIEZA',1336.000000,'',0,1,0,0,0),(251,'CESTO LARGO CORAL',NULL,'PIEZA',1336.000000,'',0,1,0,0,0),(252,'BOTIN INDUSTRIAL BLANCO',NULL,'PAR',683.000000,'',0,1,0,0,0),(253,'LETRERO MADERA',NULL,'PIEZA',290.800000,'',0,1,0,0,0),(254,'PANTALONES LIMPIEZA ALOTEC',NULL,'PIEZA',0.000000,'',0,1,0,0,0),(255,'LEGGIN DAMA/CABALLERO LYCRA',NULL,'PIEZA',0.000000,'',0,1,0,0,0);
/*!40000 ALTER TABLE `ikontrol_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_labels`
--

DROP TABLE IF EXISTS `ikontrol_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `color` varchar(15) NOT NULL,
  `context` enum('event','invoice','note','project','task','ticket','to_do','subscription','client','help','knowledge_base') DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `context` (`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_labels`
--

LOCK TABLES `ikontrol_labels` WRITE;
/*!40000 ALTER TABLE `ikontrol_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_lead_source`
--

DROP TABLE IF EXISTS `ikontrol_lead_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_lead_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `sort` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_lead_source`
--

LOCK TABLES `ikontrol_lead_source` WRITE;
/*!40000 ALTER TABLE `ikontrol_lead_source` DISABLE KEYS */;
INSERT INTO `ikontrol_lead_source` VALUES (1,'Google',1,0),(2,'Facebook',2,0),(3,'Twitter',3,0),(4,'Youtube',4,0),(5,'Elsewhere',5,0);
/*!40000 ALTER TABLE `ikontrol_lead_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_lead_status`
--

DROP TABLE IF EXISTS `ikontrol_lead_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_lead_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `color` varchar(7) NOT NULL,
  `sort` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_lead_status`
--

LOCK TABLES `ikontrol_lead_status` WRITE;
/*!40000 ALTER TABLE `ikontrol_lead_status` DISABLE KEYS */;
INSERT INTO `ikontrol_lead_status` VALUES (1,'New','#f1c40f',0,0),(2,'Qualified','#2d9cdb',1,0),(3,'Discussion','#29c2c2',2,0),(4,'Negotiation','#2d9cdb',3,0),(5,'Won','#83c340',4,0),(6,'Lost','#e74c3c',5,0);
/*!40000 ALTER TABLE `ikontrol_lead_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_leave_applications`
--

DROP TABLE IF EXISTS `ikontrol_leave_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_leave_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `leave_type_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_hours` decimal(7,2) NOT NULL,
  `total_days` decimal(5,2) NOT NULL,
  `applicant_id` int(11) NOT NULL,
  `reason` mediumtext NOT NULL,
  `status` enum('pending','approved','rejected','canceled') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `checked_at` datetime DEFAULT NULL,
  `checked_by` int(11) NOT NULL DEFAULT 0,
  `files` text NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `leave_type_id` (`leave_type_id`),
  KEY `user_id` (`applicant_id`),
  KEY `checked_by` (`checked_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_leave_applications`
--

LOCK TABLES `ikontrol_leave_applications` WRITE;
/*!40000 ALTER TABLE `ikontrol_leave_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_leave_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_leave_types`
--

DROP TABLE IF EXISTS `ikontrol_leave_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_leave_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `color` varchar(7) NOT NULL,
  `description` text DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_leave_types`
--

LOCK TABLES `ikontrol_leave_types` WRITE;
/*!40000 ALTER TABLE `ikontrol_leave_types` DISABLE KEYS */;
INSERT INTO `ikontrol_leave_types` VALUES (1,'Casual Leave','active','#83c340','',0);
/*!40000 ALTER TABLE `ikontrol_leave_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_legacy_import_batches`
--

DROP TABLE IF EXISTS `ikontrol_legacy_import_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_legacy_import_batches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(50) NOT NULL,
  `source_database` varchar(150) DEFAULT NULL,
  `source_owner_id` varchar(100) DEFAULT NULL,
  `source_owner_key` varchar(150) DEFAULT NULL,
  `entity_scope` varchar(50) NOT NULL,
  `source_backup_name` varchar(255) DEFAULT NULL,
  `source_backup_hash` char(64) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'pending',
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `summary_json` longtext DEFAULT NULL,
  `error_message` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_legacy_batch_source_owner` (`source_system`,`source_owner_key`),
  KEY `idx_legacy_batch_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_legacy_import_batches`
--

LOCK TABLES `ikontrol_legacy_import_batches` WRITE;
/*!40000 ALTER TABLE `ikontrol_legacy_import_batches` DISABLE KEYS */;
INSERT INTO `ikontrol_legacy_import_batches` VALUES (1,'fc2','fc2_migration_source','15','DOLD860620EW7','master_data_preview',NULL,NULL,'failed','2026-08-04 19:23:37','2026-08-04 19:23:37',NULL,NULL,'Master-data preview import failed.','2026-08-04 19:23:37','2026-08-04 19:23:37'),(2,'fc2','fc2_migration_source','15','DOLD860620EW7','master_data_preview',NULL,NULL,'completed_with_warnings','2026-08-04 19:24:09','2026-08-04 19:24:10',NULL,'{\"clients\":{\"default_cfdi_use_missing\":182,\"destination_expected\":180,\"exact_duplicates\":2,\"fiscal_incomplete\":47,\"mappings_expected\":182,\"source_rows\":182},\"errors\":0,\"issuer\":{\"accounts\":1,\"profiles\":1},\"products\":{\"destination_expected\":255,\"duplicate_key_rows\":88,\"fiscal_incomplete\":255,\"mappings_expected\":255,\"missing_description\":1,\"source_rows\":255,\"zero_price\":10},\"series\":{\"conflicts\":[\"INGRESO|I\"],\"imported\":0,\"source_rows\":5},\"warnings\":149}',NULL,'2026-08-04 19:24:09','2026-08-04 19:24:10'),(3,'fc2','fc2_migration_source','15','DOLD860620EW7','master_data_preview',NULL,NULL,'completed_with_warnings','2026-08-04 19:29:49','2026-08-04 19:29:49',NULL,'{\"clients\":{\"default_cfdi_use_missing\":182,\"destination_expected\":180,\"exact_duplicates\":2,\"fiscal_incomplete\":47,\"mappings_expected\":182,\"source_rows\":182},\"errors\":0,\"issuer\":{\"accounts\":1,\"profiles\":1},\"products\":{\"destination_expected\":255,\"duplicate_key_rows\":88,\"fiscal_incomplete\":255,\"mappings_expected\":255,\"missing_description\":1,\"source_rows\":255,\"zero_price\":10},\"series\":{\"conflicts\":[\"INGRESO|I\"],\"imported\":0,\"source_rows\":5},\"warnings\":149}',NULL,'2026-08-04 19:29:49','2026-08-04 19:29:49'),(4,'fc2','fc2_migration_source','15','DOLD860620EW7','master_data_preview',NULL,NULL,'completed_with_warnings','2026-08-04 19:31:15','2026-08-04 19:31:16',NULL,'{\"clients\":{\"default_cfdi_use_missing\":182,\"destination_expected\":180,\"exact_duplicates\":2,\"fiscal_incomplete\":47,\"mappings_expected\":182,\"source_rows\":182},\"errors\":0,\"issuer\":{\"accounts\":1,\"profiles\":1},\"products\":{\"destination_expected\":255,\"duplicate_key_rows\":88,\"fiscal_incomplete\":255,\"mappings_expected\":255,\"missing_description\":1,\"source_rows\":255,\"zero_price\":10},\"series\":{\"conflicts\":[\"INGRESO|I\"],\"imported\":0,\"source_rows\":5},\"warnings\":149}',NULL,'2026-08-04 19:31:15','2026-08-04 19:31:16');
/*!40000 ALTER TABLE `ikontrol_legacy_import_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_legacy_import_mappings`
--

DROP TABLE IF EXISTS `ikontrol_legacy_import_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_legacy_import_mappings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `import_batch_id` bigint(20) unsigned NOT NULL,
  `source_system` varchar(50) NOT NULL,
  `source_table` varchar(100) NOT NULL,
  `source_owner_id` varchar(100) NOT NULL DEFAULT '',
  `source_id` varchar(100) NOT NULL,
  `destination_table` varchar(100) DEFAULT NULL,
  `destination_id` varchar(100) DEFAULT NULL,
  `source_hash` char(64) DEFAULT NULL,
  `destination_hash` char(64) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'pending',
  `action` varchar(30) DEFAULT NULL,
  `warnings_json` longtext DEFAULT NULL,
  `source_snapshot_json` longtext DEFAULT NULL,
  `imported_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_legacy_mapping_source` (`source_system`,`source_table`,`source_owner_id`,`source_id`),
  KEY `idx_legacy_mapping_batch` (`import_batch_id`),
  KEY `idx_legacy_mapping_destination` (`destination_table`,`destination_id`),
  KEY `idx_legacy_mapping_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_legacy_import_mappings`
--

LOCK TABLES `ikontrol_legacy_import_mappings` WRITE;
/*!40000 ALTER TABLE `ikontrol_legacy_import_mappings` DISABLE KEYS */;
INSERT INTO `ikontrol_legacy_import_mappings` VALUES (2,2,'fc2','users','15','15','company','1','1e510680a264e9fd1cc47df4f5f9c6e9f10149d05ec179e88f8fb19fc4925824',NULL,'imported','insert',NULL,'{\"active\":\"1\",\"email\":\"dmd.dennisse@gmail.com\",\"id\":\"15\",\"username\":\"DOLD860620EW7\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:24:09'),(3,4,'fc2','users_perfil','15','12','fiscal_profiles','2','be37ff2e3caa2438a25799da2dc332837bd376d9440d2b80f3251dbcfdb7b9e8',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"domicilio\":{\"calle\":\"2\",\"codigo_postal\":\"97130\",\"colonia\":\"VISTA ALEGRE NORTE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"230\",\"no_int\":null,\"nombre_contacto\":null,\"pais\":\"México\",\"telefono\":null},\"id\":\"12\",\"razon_social\":\"DENNISSE MILDRETH DOMINGUEZ LOPEZ\",\"razon_social_original\":\"DENNISSE MILDRETH DOMINGUEZ LOPEZ\",\"regimen_fiscal\":\"612\",\"rfc\":\"DOLD860620EW7\",\"rfc_original\":\"DOLD860620EW7\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(4,4,'fc2','clientes','15','119','clients','1','0829ee479bca69bc4948e52371da9698189c0cfd7c0a9dc87b80500a6ff4019c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":\"Ricardo Siqueff\",\"domicilio\":{\"calle\":\"19 x 20 y 22\",\"colonia\":\"Col. Mexico\",\"estado\":\"Yucatan\",\"localidad\":null,\"municipio\":\"Merida\",\"no_ext\":\"#106\",\"no_int\":null},\"email\":\"milcabrera05@hotmail.com\",\"email_comparison\":\"milcabrera05@hotmail.com\",\"legacy_id\":\"119\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"Rial marketing , S.A de C.V\",\"razon_social_comparison\":\"RIAL MARKETING , S.A DE C.V\",\"razon_social_original\":\"Rial marketing , S.A de C.V\",\"regimen_fiscal\":\"601\",\"rfc\":\"RMA110113DF8\",\"rfc_original\":\"RMA110113DF8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(5,4,'fc2','clientes','15','120','clients','2','c58cfc922b9e8ff8aae0ac70160836048343be5a11a9f8aedc8e5272e2d4f540',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":null,\"domicilio\":{\"calle\":\"56 B\",\"colonia\":\"Itzimna\",\"estado\":\"Yucatan\",\"localidad\":\"Merida\",\"municipio\":\"Merida\",\"no_ext\":\"452\",\"no_int\":null},\"email\":\"aespadasp@bepensa.com\",\"email_comparison\":\"aespadasp@bepensa.com\",\"legacy_id\":\"120\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"FINANCIERA BEPENSA\",\"razon_social_comparison\":\"FINANCIERA BEPENSA\",\"razon_social_original\":\"FINANCIERA BEPENSA\",\"regimen_fiscal\":null,\"rfc\":\"FBE930202QFA\",\"rfc_original\":\"FBE930202QFA\",\"rfc_valid\":true,\"telefono\":\"982-2827\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(6,4,'fc2','clientes','15','134','clients','3','e160385c67a11636c602af8389510e179c664cd4ef4b68f4fd6459e3919146d1',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97308\",\"contacto\":null,\"domicilio\":{\"calle\":\"KM 15.5 CARRET. MERIDA A PROGRESO\",\"colonia\":\"CARRT A CHABLEKAL\",\"estado\":\"MERIDA\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":null,\"no_int\":\"KM2\"},\"email\":\"mariela.agruelles@anahuac.mx\",\"email_comparison\":\"mariela.agruelles@anahuac.mx\",\"legacy_id\":\"134\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"UNIVERSIDAD DEL MAYAB\",\"razon_social_comparison\":\"UNIVERSIDAD DEL MAYAB\",\"razon_social_original\":\"UNIVERSIDAD DEL MAYAB\",\"regimen_fiscal\":\"603\",\"rfc\":\"UMA870531DG9\",\"rfc_original\":\"UMA870531DG9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(7,4,'fc2','clientes','15','140','clients','4','6c86f08a627fe920a7442257ddc5bed10aeb86d784a4d1cb8ae81ccc934ab587',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97050\",\"contacto\":\"MARCO CAPETILLO\",\"domicilio\":{\"calle\":\"21  entre 16 y 18\",\"colonia\":\"YUCATAN\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"91a\",\"no_int\":null},\"email\":\"capetoss@hotmail.com\",\"email_comparison\":\"capetoss@hotmail.com\",\"legacy_id\":\"140\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"COMERCIALIZADORA DE PILAS DEL SURESTE SA DE CV\",\"razon_social_comparison\":\"COMERCIALIZADORA DE PILAS DEL SURESTE SA DE CV\",\"razon_social_original\":\"COMERCIALIZADORA DE PILAS DEL SURESTE SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"CPS030331E56\",\"rfc_original\":\"CPS030331E56\",\"rfc_valid\":true,\"telefono\":\"9991119279\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(8,4,'fc2','clientes','15','142','clients','5','673da16346efd0db12b186791e8064c5a8e51c1632144f83adf1e9fb79b12cea',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"89000\",\"contacto\":null,\"domicilio\":{\"calle\":\"BENITO JUAREZ\",\"colonia\":\"CENTRO\",\"estado\":\"TAMPICO\",\"localidad\":\"TAMPICO\",\"municipio\":\"TAMPICO\",\"no_ext\":\"117\",\"no_int\":\"A SUR\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"142\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"DESTROYER MEXICANA DE TAMPICO SA DE CV\",\"razon_social_comparison\":\"DESTROYER MEXICANA DE TAMPICO SA DE CV\",\"razon_social_original\":\"DESTROYER MEXICANA DE TAMPICO SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"DMT8308307R4\",\"rfc_original\":\"DMT8308307R4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(9,4,'fc2','clientes','15','147','clients','6','bbdfc8adc3d999e2cf034eceae6ec0cdefc9ba4fca5f97102aa1c9364dc41b99',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97000\",\"contacto\":null,\"domicilio\":{\"calle\":\"59\",\"colonia\":\"CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"S/N\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"147\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SECRETARIA DE ADMINISTRACION Y FINANZAS\",\"razon_social_comparison\":\"SECRETARIA DE ADMINISTRACION Y FINANZAS\",\"razon_social_original\":\"SECRETARIA DE ADMINISTRACION Y FINANZAS \",\"regimen_fiscal\":null,\"rfc\":\"SHA840512SX1\",\"rfc_original\":\"SHA840512SX1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(10,4,'fc2','clientes','15','174','clients','7','6cffe0df24291fe6fe14a1e41e0cdc391ebeda72a7a777741624b786bdd9f94e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97110\",\"contacto\":null,\"domicilio\":{\"calle\":\"AV PRINCIPAL INDUSTRIAS NO CONTAMINANTES\",\"colonia\":\"SODZIL NORTE SR\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"13613\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"174\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"INSTITUTO YUCATECO DE EMPRENDEDORES\",\"razon_social_comparison\":\"INSTITUTO YUCATECO DE EMPRENDEDORES\",\"razon_social_original\":\"INSTITUTO YUCATECO DE EMPRENDEDORES \",\"regimen_fiscal\":null,\"rfc\":\"IIC991117V18\",\"rfc_original\":\"IIC991117V18\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(11,4,'fc2','clientes','15','239','clients','8','8c0fe1d92f4f658cb06ec7a0eeec880e22af4a6afdbf86446a9731b054baa4a3',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":\"LETICIA\",\"domicilio\":{\"calle\":\"Calle 29  por 34 y 36\",\"colonia\":\"Fraccionamiento Montecarlo\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"#348\",\"no_int\":null},\"email\":\"bolsadetrabajo@arrigunagacano.com.mx\",\"email_comparison\":\"bolsadetrabajo@arrigunagacano.com.mx\",\"legacy_id\":\"239\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ARRIGUNAGA CANO SC\",\"razon_social_comparison\":\"ARRIGUNAGA CANO SC\",\"razon_social_original\":\"ARRIGUNAGA CANO SC\",\"regimen_fiscal\":null,\"rfc\":\"ACA080812GZ0\",\"rfc_original\":\"ACA080812GZ0\",\"rfc_valid\":true,\"telefono\":\"9991759330\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(12,4,'fc2','clientes','15','667','clients','9','3d0e1de54a5b8d757e7b4afb71b032c87aeebfb0ed9d94cf3762fd5cfd19a8ff',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"06700\",\"contacto\":null,\"domicilio\":{\"calle\":\"COLIMA\",\"colonia\":\"ROMA NORTE\",\"estado\":\"MEXICO\",\"localidad\":null,\"municipio\":\"CD. DE MEXICO\",\"no_ext\":\"107\",\"no_int\":\"2\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"667\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SUM SHOP SAPI DE CV\",\"razon_social_comparison\":\"SUM SHOP SAPI DE CV\",\"razon_social_original\":\"SUM SHOP SAPI DE CV\",\"regimen_fiscal\":null,\"rfc\":\"SSH160210AP0\",\"rfc_original\":\"SSH160210AP0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(13,4,'fc2','clientes','15','698','clients','10','76b426f4a8dfa46bb8a5e5d925c6d5f68af969d507223c006eb3e3857f5155a2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"06600\",\"contacto\":null,\"domicilio\":{\"calle\":\"VARSOVIA\",\"colonia\":\"JUAREZ\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"CUAUHTEMOC\",\"municipio\":\"CUAUHTEMOC\",\"no_ext\":\"44\",\"no_int\":\"1202\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"698\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"SOLDAI SAPI  DE CV\",\"razon_social_comparison\":\"SOLDAI SAPI DE CV\",\"razon_social_original\":\"SOLDAI SAPI  DE CV\",\"regimen_fiscal\":null,\"rfc\":\"SOL151021P60\",\"rfc_original\":\"SOL151021P60\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(14,4,'fc2','clientes','15','1079','clients','11','e8982a5dc8a8c5fe4ca222c25624f9a10b704faf5f29e9b9f6f34eb2558eb13a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97109\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 42\",\"colonia\":\"JESUS CARRANZA\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"454\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"1079\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GRUPO EDITORIAL DEL SURESTE SA DE CV\",\"razon_social_comparison\":\"GRUPO EDITORIAL DEL SURESTE SA DE CV\",\"razon_social_original\":\"GRUPO EDITORIAL DEL SURESTE SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"GES090320UU3\",\"rfc_original\":\"GES090320UU3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(15,4,'fc2','clientes','15','1083','clients','12','1a9237d64226d94130051dd3b0023aa0824a7ce4c60589093e49401aa62750f4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97300\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 11\",\"colonia\":\"SANTA GERTRUDIS COPO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"122\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"1083\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CERAMICA Y MATERIALES CONTINENTAL  SAPI DE CV\",\"razon_social_comparison\":\"CERAMICA Y MATERIALES CONTINENTAL SAPI DE CV\",\"razon_social_original\":\"CERAMICA Y MATERIALES CONTINENTAL  SAPI DE CV\",\"regimen_fiscal\":null,\"rfc\":\"CMC970224II2\",\"rfc_original\":\"CMC970224II2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(16,4,'fc2','clientes','15','1458','clients','13','eda4c8c862a2a1ddc70586e10cc717a65d9e901642f576c8a5620984173627f8',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97070\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 13\",\"colonia\":\"GARCIA GINERES\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"219 X 30\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"1458\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARIA CRISTINA GAMBOA MOLINA\",\"razon_social_comparison\":\"MARIA CRISTINA GAMBOA MOLINA\",\"razon_social_original\":\"MARIA CRISTINA GAMBOA MOLINA\",\"regimen_fiscal\":null,\"rfc\":\"GAMC921219965\",\"rfc_original\":\"GAMC921219965\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(17,4,'fc2','clientes','15','2169','clients','14','d187e660bbfe42e41d0492d9985062d9d7927cb00afc8fb4fb77ff225e76ba76',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 30,  ENTRE 17 Y 19\",\"colonia\":\"MEXICO NORTE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"92 A\",\"no_int\":\"LOCAL 3,\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"2169\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"QUINTATINTA S. DE R.L. DE C. V.\",\"razon_social_comparison\":\"QUINTATINTA S. DE R.L. DE C. V.\",\"razon_social_original\":\"QUINTATINTA S. DE R.L. DE C. V.\",\"regimen_fiscal\":null,\"rfc\":\"QUI160629CA8\",\"rfc_original\":\"QUI160629CA8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(18,4,'fc2','clientes','15','2240','clients','15','2bc6bacee283427ba828ad46edba86858045aebb29a8721b6de0cef2658a343d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97128\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 20 X CALLE 21\",\"colonia\":\"MEXICO NORTE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"96\",\"no_int\":\"LOC-7\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"2240\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"IMPULSA Y APS EMPRESARIOS\",\"razon_social_comparison\":\"IMPULSA Y APS EMPRESARIOS\",\"razon_social_original\":\"IMPULSA Y APS EMPRESARIOS \",\"regimen_fiscal\":null,\"rfc\":\"IAE160919NH8\",\"rfc_original\":\"IAE160919NH8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(19,4,'fc2','clientes','15','2253','clients','16','17fa498281d9f0cd825813dc0c9a3eb00ae69eeabe8c16f7da071d8f3f94c1bc',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":\".\",\"domicilio\":{\"calle\":\"CALLE 30, ENTRE 29 Y Esquina\",\"colonia\":\"MEXICO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"122A\",\"no_int\":\"DEPTO 4\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"2253\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"IVAN JESUS QUIÑONES GONZALEZ\",\"razon_social_comparison\":\"IVAN JESUS QUIÑONES GONZALEZ\",\"razon_social_original\":\"IVAN JESUS QUIÑONES GONZALEZ\",\"regimen_fiscal\":null,\"rfc\":\"QUGI900928G99\",\"rfc_original\":\"QUGI900928G99\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(20,4,'fc2','clientes','15','2254','clients','17','98da25e3b2229300ccafd22634e13a5abc87e01c54a3f22878dc50a98efde318',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"24120\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 50\",\"colonia\":\"PLAYA NORTE\",\"estado\":\"CAMPECHE\",\"localidad\":\"CD DEL CARMEN\",\"municipio\":\"CD DEL CARMEN\",\"no_ext\":\"LOTE 2\",\"no_int\":\".\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"2254\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"VIANNEY DEL ROCIO LOPEZ REBOLLEDO\",\"razon_social_comparison\":\"VIANNEY DEL ROCIO LOPEZ REBOLLEDO\",\"razon_social_original\":\"VIANNEY DEL ROCIO LOPEZ REBOLLEDO\",\"regimen_fiscal\":null,\"rfc\":\"LORV880624PZ2\",\"rfc_original\":\"LORV880624PZ2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(21,4,'fc2','clientes','15','2583','clients','18','b6aaacf4ecb5757d7571ef322545858172994bf4d0cdc6c20ca0a8844fea3781',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97302\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARR PROGRESO CHABLEKAL K\",\"colonia\":\"/\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\".\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"2583\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"FUNDACION PARQUE TECNOLOGICO ANAHUAC MAYAB, SC\",\"razon_social_comparison\":\"FUNDACION PARQUE TECNOLOGICO ANAHUAC MAYAB, SC\",\"razon_social_original\":\"FUNDACION PARQUE TECNOLOGICO ANAHUAC MAYAB, SC\",\"regimen_fiscal\":null,\"rfc\":\"FPT130410GG8\",\"rfc_original\":\"FPT130410GG8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(22,4,'fc2','clientes','15','3239','clients','19','90ecb0fbddb244b2405f5f7e9f8e3a8cf6b21aeb51789f62da4cacd7df857af8',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":\"-\",\"domicilio\":{\"calle\":\"30 num\",\"colonia\":\"mexico norte\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"92 entre\",\"no_int\":\"loc3 17-19\"},\"email\":\"asistente.cafeconsultores@gmail.com\",\"email_comparison\":\"asistente.cafeconsultores@gmail.com\",\"legacy_id\":\"3239\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"QUINTATINTA S. DE R.L. DE C.V.\",\"razon_social_comparison\":\"QUINTATINTA S. DE R.L. DE C.V.\",\"razon_social_original\":\"QUINTATINTA S. DE R.L. DE C.V.\",\"regimen_fiscal\":null,\"rfc\":\"QUI160629CA8\",\"rfc_original\":\"QUI160629CA8\",\"rfc_valid\":true,\"telefono\":\"-\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(23,4,'fc2','clientes','15','3274','clients','20','04f2e071cec071db59df73101296d36d880aa4a5fa9df705215c75e6fbeb312c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97133\",\"contacto\":null,\"domicilio\":{\"calle\":\"C. 12 NO. 335\",\"colonia\":\"CAMARA DE COMERCIO NORTE\",\"estado\":\"YUCATÁN\",\"localidad\":\"MÉRIDA\",\"municipio\":\"MÉRIDA\",\"no_ext\":\".\",\"no_int\":\".\"},\"email\":\"asistente.cafeconsultores@gmail.com\",\"email_comparison\":\"asistente.cafeconsultores@gmail.com\",\"legacy_id\":\"3274\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"GOVA COMUNICACIONES S.A. C.V.\",\"razon_social_comparison\":\"GOVA COMUNICACIONES S.A. C.V.\",\"razon_social_original\":\"GOVA COMUNICACIONES S.A. C.V.\",\"regimen_fiscal\":null,\"rfc\":\"GCO050824UQ4\",\"rfc_original\":\"GCO050824UQ4\",\"rfc_valid\":true,\"telefono\":\"-\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(24,4,'fc2','clientes','15','3594','clients','21','c98f8f1010c9975ddf17e25c642d72eaf95f09db65df933712026d48945030f3',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97000\",\"contacto\":null,\"domicilio\":{\"calle\":\"C. 47 X 60\",\"colonia\":\"CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"424\",\"no_int\":\"DEPTO. 4\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"3594\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ESENCIA MAYA S.A. DE C.V.\",\"razon_social_comparison\":\"ESENCIA MAYA S.A. DE C.V.\",\"razon_social_original\":\"ESENCIA MAYA S.A. DE C.V.\",\"regimen_fiscal\":null,\"rfc\":\"EMA150119IT9\",\"rfc_original\":\"EMA150119IT9\",\"rfc_valid\":true,\"telefono\":\"9230040\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(25,4,'fc2','clientes','15','3667','clients','22','74b7ae365f674a0321e019933591ef32c0aa2f9eda2970dc8498ef3ecd71aefc',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"06700\",\"contacto\":\"CARMEN CASTILLO\",\"domicilio\":{\"calle\":\"ALVARO OBREGON\",\"colonia\":\"ROMA\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"CUAUHTEMOC\",\"municipio\":\"CUAUHTEMOC\",\"no_ext\":\"250\",\"no_int\":null},\"email\":\"carmen.castillo@ciceg.org\",\"email_comparison\":\"carmen.castillo@ciceg.org\",\"legacy_id\":\"3667\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CAMARA NACIONAL DE LA INDUSTRIA DEL CALZADO\",\"razon_social_comparison\":\"CAMARA NACIONAL DE LA INDUSTRIA DEL CALZADO\",\"razon_social_original\":\"CAMARA NACIONAL DE LA INDUSTRIA DEL CALZADO \",\"regimen_fiscal\":null,\"rfc\":\"CNI420306BI0\",\"rfc_original\":\"CNI420306BI0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(26,4,'fc2','clientes','15','3742','clients','23','e76f3f378552f745c5f5ce0ff2e04f4ec2f58e9bdf22b003d38eabb20e477b52',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97302\",\"contacto\":null,\"domicilio\":{\"calle\":\"59\",\"colonia\":\"LAS AMERICAS\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"842\",\"no_int\":\"8\"},\"email\":\"octadis.contacto@gmail.com\",\"email_comparison\":\"octadis.contacto@gmail.com\",\"legacy_id\":\"3742\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GLADYS MARIA LUJAN CANTO\",\"razon_social_comparison\":\"GLADYS MARIA LUJAN CANTO\",\"razon_social_original\":\"GLADYS MARIA LUJAN CANTO \",\"regimen_fiscal\":null,\"rfc\":\"LUCG4303229B7\",\"rfc_original\":\"LUCG4303229B7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(27,4,'fc2','clientes','15','4223','clients','24','93ed71f0c11ab2569a378179fa56cea6a6208b0ea7d2e30aa4c444e04ef3c134',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"66240\",\"contacto\":null,\"domicilio\":{\"calle\":\"LOMAS DEL VALLE\",\"colonia\":\"LOMAS DEL VALLE\",\"estado\":\"NUEVO LEON\",\"localidad\":\"NUEVO LEON\",\"municipio\":\"SAN PEDRO GARA CARGIA N.L\",\"no_ext\":\"430\",\"no_int\":\"2-7\"},\"email\":\"mundoferfi@hotmail.com\",\"email_comparison\":\"mundoferfi@hotmail.com\",\"legacy_id\":\"4223\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CERN INMOBILIARIA\",\"razon_social_comparison\":\"CERN INMOBILIARIA\",\"razon_social_original\":\"CERN INMOBILIARIA \",\"regimen_fiscal\":null,\"rfc\":\"CIN1710067L9\",\"rfc_original\":\"CIN1710067L9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(28,4,'fc2','clientes','15','4362','clients','25','c85d6780f5dd89b0acb534e9bdd7664a2a3eb1b5939f5671574d3ca72e7effa2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"01210\",\"contacto\":\"Ramon Chatú\",\"domicilio\":{\"calle\":\"Guillermo gonzalez camarena\",\"colonia\":\"Santa Fe\",\"estado\":\"Ciudad de México\",\"localidad\":\"Alvaro Obregon\",\"municipio\":\"Alvaro Obregon\",\"no_ext\":\"1200\",\"no_int\":\"Piso 10\"},\"email\":\"contabilidad@enalto.mx\",\"email_comparison\":\"contabilidad@enalto.mx\",\"legacy_id\":\"4362\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"Fideicomiso F/4075\",\"razon_social_comparison\":\"FIDEICOMISO F/4075\",\"razon_social_original\":\"Fideicomiso F/4075\",\"regimen_fiscal\":null,\"rfc\":\"FFX190926AL1\",\"rfc_original\":\"FFX190926AL1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(29,4,'fc2','clientes','15','4513','clients','26','1c3bfb1ec6e8ead0497848701a382d77e5ffc5ec708d96171aed4a141e94a201',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":null,\"domicilio\":{\"calle\":\"21\",\"colonia\":\"Col Mex\",\"estado\":\"Yucatan\",\"localidad\":\"Yucatan\",\"municipio\":\"Merida\",\"no_ext\":\"125\",\"no_int\":\"A\"},\"email\":\"leticia.herrera@rosavento.mx\",\"email_comparison\":\"leticia.herrera@rosavento.mx\",\"legacy_id\":\"4513\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"Inmoyuca peninsular S.A de C.V\",\"razon_social_comparison\":\"INMOYUCA PENINSULAR S.A DE C.V\",\"razon_social_original\":\"Inmoyuca peninsular S.A de C.V\",\"regimen_fiscal\":null,\"rfc\":\"IPE140806TB5\",\"rfc_original\":\"IPE140806TB5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(30,4,'fc2','clientes','15','4548','clients','27','0abf284451c478bbe125ef8d0921f21facb6e7e5d50dcf4e86cb218feabc0f04',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97120\",\"contacto\":null,\"domicilio\":{\"calle\":\"1 G\",\"colonia\":\"CAMPESTRE\",\"estado\":\"YUCATAN\",\"localidad\":\"YUCATAN\",\"municipio\":\"MERIDA\",\"no_ext\":\"310\",\"no_int\":null},\"email\":\"accounts@lessmore.group\",\"email_comparison\":\"accounts@lessmore.group\",\"legacy_id\":\"4548\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"LESSMOREGROUP CONSULTORIA DE DISEÑO\",\"razon_social_comparison\":\"LESSMOREGROUP CONSULTORIA DE DISEÑO\",\"razon_social_original\":\"LESSMOREGROUP CONSULTORIA DE DISEÑO\",\"regimen_fiscal\":null,\"rfc\":\"LCD180511FI0\",\"rfc_original\":\"LCD180511FI0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(31,4,'fc2','clientes','15','4657','clients','28','4b9a3ffbbd96d5fe7ea72e999eaeade93efd8d97267ef4ed5c28b81f2bc2166e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"38050\",\"contacto\":\"Valeria\",\"domicilio\":{\"calle\":\"Siracusa\",\"colonia\":\"Mediterraneo\",\"estado\":\"Guanajuato\",\"localidad\":null,\"municipio\":\"Celaya\",\"no_ext\":\"133\",\"no_int\":null},\"email\":\"facturacionaedv@gmail.com\",\"email_comparison\":\"facturacionaedv@gmail.com\",\"legacy_id\":\"4657\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"Valeria Arellano Delgado\",\"razon_social_comparison\":\"VALERIA ARELLANO DELGADO\",\"razon_social_original\":\"Valeria Arellano Delgado\",\"regimen_fiscal\":null,\"rfc\":\"AEDV881025982\",\"rfc_original\":\"AEDV881025982\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(32,4,'fc2','clientes','15','5149','clients','29','1b87d5104d847db8bbafc6331fa3e67f6b481a46a90c24962ce655dc15ca173d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"01020\",\"contacto\":\"Ofelia\",\"domicilio\":{\"calle\":\"INSURGENTES SUR\",\"colonia\":\"GUADALUPE INN\",\"estado\":\"Ciudad de México\",\"localidad\":null,\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"1809\",\"no_int\":\"PISO 8\"},\"email\":\"ofelia.zarco@tportho.com\",\"email_comparison\":\"ofelia.zarco@tportho.com\",\"legacy_id\":\"5149\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"TP ORTHODONTICS MEXICO S DE RL DE CV\",\"razon_social_comparison\":\"TP ORTHODONTICS MEXICO S DE RL DE CV\",\"razon_social_original\":\"TP ORTHODONTICS MEXICO S DE RL DE CV\",\"regimen_fiscal\":null,\"rfc\":\"TOM950524U51\",\"rfc_original\":\"TOM950524U51\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(33,4,'fc2','clientes','15','5182','clients','30','22c1eb2b09ae1780f1978eb11732fe52aae9a70c3d35600407ffa0d4b2abe21b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97000\",\"contacto\":\"HANSEL RUIZ\",\"domicilio\":{\"calle\":\"70\",\"colonia\":\"CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"535-A\",\"no_int\":null},\"email\":\"comprador2@fernandez.com.mx\",\"email_comparison\":\"comprador2@fernandez.com.mx\",\"legacy_id\":\"5182\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"COMPAÑIA FERNANDEZ DE MERIDA, S,A DE C.V\",\"razon_social_comparison\":\"COMPAÑIA FERNANDEZ DE MERIDA, S,A DE C.V\",\"razon_social_original\":\"COMPAÑIA FERNANDEZ DE MERIDA, S,A DE C.V \",\"regimen_fiscal\":null,\"rfc\":\"FME860201IT5\",\"rfc_original\":\"FME860201IT5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(34,4,'fc2','clientes','15','5523','clients','31','fe3cbea58846c4492a119930eedb762f318bf37a3c2045fb5afbf1f73a5f9adc',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"Blvd. Kukulkan Km 3.5\",\"colonia\":\"Zona Hotelera,\",\"estado\":\"Q. Roo\",\"localidad\":null,\"municipio\":\"Cancún\",\"no_ext\":\"Mz. 30 Lote D-9-7 Ed\",\"no_int\":null},\"email\":\"contabilidad@bluewaterlife.com.mx\",\"email_comparison\":\"contabilidad@bluewaterlife.com.mx\",\"legacy_id\":\"5523\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"C MARINE SAPI DE CV\",\"razon_social_comparison\":\"C MARINE SAPI DE CV\",\"razon_social_original\":\" C MARINE SAPI DE CV\",\"regimen_fiscal\":null,\"rfc\":\"CMA140627651\",\"rfc_original\":\"CMA140627651\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(35,4,'fc2','clientes','15','5526','clients','32','348c1367618bb8cb4dae0ecedc1d52591062141b4f7803fb8bb2d31a4fa94f83',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"37290\",\"contacto\":null,\"domicilio\":{\"calle\":\"Blvd. Adolfo Lopez Mateos\",\"colonia\":\"Fracc. Julián de Obregón\",\"estado\":\"Guanajuato\",\"localidad\":\"Guanajuato\",\"municipio\":\"Leon\",\"no_ext\":\"3401 OTE\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"5526\",\"observaciones\":null,\"pais\":\"mexico\",\"razon_social\":\"Cámara de la industria del calzado del Estado de Guanajuato\",\"razon_social_comparison\":\"CÁMARA DE LA INDUSTRIA DEL CALZADO DEL ESTADO DE GUANAJUATO\",\"razon_social_original\":\"Cámara de la industria del calzado del Estado de Guanajuato\",\"regimen_fiscal\":null,\"rfc\":\"CIC6910143B5\",\"rfc_original\":\"CIC6910143B5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(36,4,'fc2','clientes','15','5698','clients','33','8784012d8eb8f96aace2cdb99f9a737c648712e4dbaa83e442df8a7dd4073f7b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97390\",\"contacto\":null,\"domicilio\":{\"calle\":\"KM 8 CARRETERA UMAN\",\"colonia\":\"AMPLIACION CD INDUSTRIAL\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":null,\"no_int\":null},\"email\":\"guadalupe.flores@polimerida.com\",\"email_comparison\":\"guadalupe.flores@polimerida.com\",\"legacy_id\":\"5698\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"POLIMERIDA SA DE CV\",\"razon_social_comparison\":\"POLIMERIDA SA DE CV\",\"razon_social_original\":\"POLIMERIDA SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"POL900418IF3\",\"rfc_original\":\"POL900418IF3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(37,4,'fc2','clientes','15','5851','clients','34','2f6600019f8d6877a7481edf79a2eb89c78d8477eb173cd5db07ef5de4a7228e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97305\",\"contacto\":\"sergio bringas\",\"domicilio\":{\"calle\":\"Calle 7A-1\",\"colonia\":\"Sta. Gertrudis Copó\",\"estado\":\"Yucatan\",\"localidad\":null,\"municipio\":\"Merida\",\"no_ext\":\"325\",\"no_int\":\"12\"},\"email\":\"sergio@amorseguro.org\",\"email_comparison\":\"sergio@amorseguro.org\",\"legacy_id\":\"5851\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"Cree Ama y Espera AC\",\"razon_social_comparison\":\"CREE AMA Y ESPERA AC\",\"razon_social_original\":\"Cree Ama y Espera AC\",\"regimen_fiscal\":null,\"rfc\":\"CAE1203229T0\",\"rfc_original\":\"CAE1203229T0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(38,4,'fc2','clientes','15','5878','clients','35','9616c171779f0aee00a59191f2e8336b0df424667a28de1f74717881a0d938aa',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"Fe otc\",\"domicilio\":{\"calle\":\"CARRET CHETUMAL PUERTO JUAREZ KILOMETRO 282\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"INTERIOR B\",\"no_int\":null},\"email\":\"fe.otc@xcaret.com\",\"email_comparison\":\"fe.otc@xcaret.com\",\"legacy_id\":\"5878\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EXPERIENCIAS XCARET PARQUES\",\"razon_social_comparison\":\"EXPERIENCIAS XCARET PARQUES\",\"razon_social_original\":\"EXPERIENCIAS XCARET PARQUES\",\"regimen_fiscal\":\"601\",\"rfc\":\"OTC080114C30\",\"rfc_original\":\"OTC080114C30\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(39,4,'fc2','clientes','15','6048','clients','36','c2996a93cba89908374a019bad9c1cb9b3ef2ef1c46777725c37cc7bec8baac8',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRET FEDERAL PYA DEL CARMEN TULUM KM 2.5\",\"colonia\":\"PARCEL 17 MZA 337 LOTE 027\",\"estado\":\"Q.ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":null,\"no_ext\":\"PARCEL 17 MZA 337 LO\",\"no_int\":null},\"email\":\"alexis@aventurasmayas.com\",\"email_comparison\":\"alexis@aventurasmayas.com\",\"legacy_id\":\"6048\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"AVENTURAS MAYAS SA DE CV\",\"razon_social_comparison\":\"AVENTURAS MAYAS SA DE CV\",\"razon_social_original\":\"AVENTURAS MAYAS SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"AMA030617SN8\",\"rfc_original\":\"AMA030617SN8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(40,4,'fc2','clientes','15','6411','clients','37','310b2a2c972c7a0cb4ef95835a41852ff04ccbd5cc47471e12d6841a3db9d011',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"03100\",\"contacto\":\"daniel blando\",\"domicilio\":{\"calle\":\"SAN FRANCISCO\",\"colonia\":\"DEL VALLE\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"BENITO JUAREZ\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"226\",\"no_int\":\"103\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"6411\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PRODUCCIONES TRAMANDO LAB\",\"razon_social_comparison\":\"PRODUCCIONES TRAMANDO LAB\",\"razon_social_original\":\"PRODUCCIONES TRAMANDO LAB\",\"regimen_fiscal\":null,\"rfc\":\"PTL170410UC7\",\"rfc_original\":\"PTL170410UC7\",\"rfc_valid\":true,\"telefono\":\"55 2521 8891\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(41,4,'fc2','clientes','15','6412','clients','37','ae5a933075f1d9f27af9b9f7d6b85d82da01153e8f00241b4a95561c9900e9df',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"03100\",\"contacto\":\"daniel blando\",\"domicilio\":{\"calle\":\"SAN FRANCISCO\",\"colonia\":\"DEL VALLE\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"BENITO JUAREZ\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"226\",\"no_int\":\"103\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"6412\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PRODUCCIONES TRAMANDO LAB\",\"razon_social_comparison\":\"PRODUCCIONES TRAMANDO LAB\",\"razon_social_original\":\"PRODUCCIONES TRAMANDO LAB\",\"regimen_fiscal\":null,\"rfc\":\"PTL170410UC7\",\"rfc_original\":\"PTL170410UC7\",\"rfc_valid\":true,\"telefono\":\"55 2521 8891\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(42,4,'fc2','clientes','15','6529','clients','38','15972febe7f598b70f7ef774070ee3f7cface8e3ac64740548e6851849bcfe5d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77560\",\"contacto\":\"Sofia Pedraza\",\"domicilio\":{\"calle\":\"DE ACCESO L28 MANZANA 16 L37 EDIFICIO C\",\"colonia\":\"SM 309\",\"estado\":\"QUINTANA ROO\",\"localidad\":null,\"municipio\":\"CANCUN BENITO JUAREZ\",\"no_ext\":\"LOCAL S\",\"no_int\":null},\"email\":\"apinvoices@grupolomas.com\",\"email_comparison\":\"apinvoices@grupolomas.com\",\"legacy_id\":\"6529\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SERVICIOS TURISTICOS COSTA TURQUESA, S.A DE C.V\",\"razon_social_comparison\":\"SERVICIOS TURISTICOS COSTA TURQUESA, S.A DE C.V\",\"razon_social_original\":\"SERVICIOS TURISTICOS COSTA TURQUESA, S.A DE C.V\",\"regimen_fiscal\":null,\"rfc\":\"STC861023CMA\",\"rfc_original\":\"STC861023CMA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(43,4,'fc2','clientes','15','6552','clients','39','7ed50bf7b730ed529552f3a7ef9f08cb7e1e5926e82f220c13bcd0aeba4b8636',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77560\",\"contacto\":\"CARELLY SULUB CHAN\",\"domicilio\":{\"calle\":\"LUIS DONALDO COLOSIO\",\"colonia\":\"SM 301\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 4 LOTE 5\",\"no_int\":\"BODEGA 519\"},\"email\":\"mdaguilar@grupoavanti.com\",\"email_comparison\":\"mdaguilar@grupoavanti.com\",\"legacy_id\":\"6552\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"FB DISTRIBUCIONES\",\"razon_social_comparison\":\"FB DISTRIBUCIONES\",\"razon_social_original\":\"FB DISTRIBUCIONES\",\"regimen_fiscal\":null,\"rfc\":\"FDI1502063M0\",\"rfc_original\":\"FDI1502063M0\",\"rfc_valid\":true,\"telefono\":\"9981112267\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(44,4,'fc2','clientes','15','6666','clients','40','f447ad3633f4f903e4def9bcb12469aad6bc0cdd4e9668485ab4315fe667cfbd',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":\"Jacqueline Mancilla\",\"domicilio\":{\"calle\":\"Blvd. Kukulkan Km 3.5\",\"colonia\":\"Zona Hotelera\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"CANCUN BENITO JUAREZ\",\"no_ext\":\"Mz. 30 Lote D-9-7\",\"no_int\":\"Edificio 1 Local PB\"},\"email\":\"contabilidad@bluewaterlife.com.mx\",\"email_comparison\":\"contabilidad@bluewaterlife.com.mx\",\"legacy_id\":\"6666\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"C MARINE SAPI DE CV\",\"razon_social_comparison\":\"C MARINE SAPI DE CV\",\"razon_social_original\":\"C MARINE SAPI DE CV\",\"regimen_fiscal\":null,\"rfc\":\"CMA140627651\",\"rfc_original\":\"CMA140627651\",\"rfc_valid\":true,\"telefono\":\"9987043717\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(45,4,'fc2','clientes','15','6803','clients','41','42b6ea50294ca9f1944b0318a29350aeaa25b328bc4cb781565de53137b9eb6d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"11950\",\"contacto\":\"Claudio Bautista\",\"domicilio\":{\"calle\":\"Av. Paseo de Reforma\",\"colonia\":\"Lomas Altas\",\"estado\":\"Cuidad de México\",\"localidad\":\"Cuidad de México\",\"municipio\":\"Cuidad de México\",\"no_ext\":\"2620\",\"no_int\":\"Piso 16\"},\"email\":\"claudia.bautista@thompsonhotels.com\",\"email_comparison\":\"claudia.bautista@thompsonhotels.com\",\"legacy_id\":\"6803\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"Mosquitos Hospitality Group S. de R.L de C.V\",\"razon_social_comparison\":\"MOSQUITOS HOSPITALITY GROUP S. DE R.L DE C.V\",\"razon_social_original\":\"Mosquitos Hospitality Group S. de R.L de C.V \",\"regimen_fiscal\":null,\"rfc\":\"MHG121130EK5\",\"rfc_original\":\"MHG121130EK5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(46,4,'fc2','clientes','15','6946','clients','42','f6be413b2dc2b56b59bc9acd650ba9d22e3354e8fd236ad7cfdfd4dfc3e68f47',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"37299\",\"contacto\":null,\"domicilio\":{\"calle\":\"MONTE ARABI\",\"colonia\":\"SANTA FE\",\"estado\":\"GUANAJUATO\",\"localidad\":\"LEON\",\"municipio\":\"LEON\",\"no_ext\":\"262\",\"no_int\":null},\"email\":\"marcohernandez21@hotmail.com\",\"email_comparison\":\"marcohernandez21@hotmail.com\",\"legacy_id\":\"6946\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"AQUI TODO ES DIVERSION, SA DE CV\",\"razon_social_comparison\":\"AQUI TODO ES DIVERSION, SA DE CV\",\"razon_social_original\":\"AQUI TODO ES DIVERSION, SA DE CV\",\"regimen_fiscal\":null,\"rfc\":\"ATE1608256AA\",\"rfc_original\":\"ATE1608256AA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(47,4,'fc2','clientes','15','7068','clients','43','6e9c8e659d13d03d413287dcd0f5cba98e14b20e264af3a7e9901c8e9372d9e3',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"KM 282 CARRETERA CHETUMAL PTO JUAREZ\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":null,\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"SN\",\"no_int\":\"LOC A\"},\"email\":\"xcafisca@gxcaret.com.mx\",\"email_comparison\":\"xcafisca@gxcaret.com.mx\",\"legacy_id\":\"7068\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GRUPO POLE\",\"razon_social_comparison\":\"GRUPO POLE\",\"razon_social_original\":\"GRUPO POLE\",\"regimen_fiscal\":\"601\",\"rfc\":\"GPO040428SE8\",\"rfc_original\":\"GPO040428SE8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(48,4,'fc2','clientes','15','7093','clients','44','c7686f4f98e82a67f324b32149b553920ff9965bd5005572bd40dc99d7952a25',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"32618\",\"contacto\":null,\"domicilio\":{\"calle\":\"SAN ANTONIO\",\"colonia\":\"PARTIDO IGLESIAS\",\"estado\":\"CHIHUAHUA\",\"localidad\":\"CD JUAREZ\",\"municipio\":\"JUAREZ\",\"no_ext\":\"4370\",\"no_int\":\"425 PISO 4\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7093\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SOCIEDAD DE ERGONOMISTAS DE MEXICO\",\"razon_social_comparison\":\"SOCIEDAD DE ERGONOMISTAS DE MEXICO\",\"razon_social_original\":\"SOCIEDAD DE ERGONOMISTAS DE MEXICO\",\"regimen_fiscal\":null,\"rfc\":\"EME0001285E0\",\"rfc_original\":\"EME0001285E0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(49,4,'fc2','clientes','15','7109','clients','45','9589cdb50de27c073277cca1d489818bca5aeb21081b408c1d57e95463f8cb9a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97070\",\"contacto\":null,\"domicilio\":{\"calle\":\"6\",\"colonia\":\"GARCIA GINERES\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"508 C\",\"no_int\":\"1\"},\"email\":\"cgranados62@hotmail.com\",\"email_comparison\":\"cgranados62@hotmail.com\",\"legacy_id\":\"7109\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CORPORATIVO DE SERVICIOS TURISTICOS AMIGO\",\"razon_social_comparison\":\"CORPORATIVO DE SERVICIOS TURISTICOS AMIGO\",\"razon_social_original\":\"CORPORATIVO DE SERVICIOS TURISTICOS AMIGO\",\"regimen_fiscal\":null,\"rfc\":\"CST1402219G5\",\"rfc_original\":\"CST1402219G5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(50,4,'fc2','clientes','15','7112','clients','46','0afb11dca22bbb4bd9d54e18cd9f5b38be6752005903ace7361389ca8b77eb3b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"67176\",\"contacto\":null,\"domicilio\":{\"calle\":\"Pablo Livas\",\"colonia\":\"Mirador de la Silla\",\"estado\":\"Nuevo León\",\"localidad\":null,\"municipio\":\"Guadalupe\",\"no_ext\":\"2540\",\"no_int\":\"9 y 10\"},\"email\":\"facturacion@loci.com.mx\",\"email_comparison\":\"facturacion@loci.com.mx\",\"legacy_id\":\"7112\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"Logística de Comercio Internacional S.A. de C.V.\",\"razon_social_comparison\":\"LOGÍSTICA DE COMERCIO INTERNACIONAL S.A. DE C.V.\",\"razon_social_original\":\"Logística de Comercio Internacional S.A. de C.V.\",\"regimen_fiscal\":null,\"rfc\":\"LCI071009UX4\",\"rfc_original\":\"LCI071009UX4\",\"rfc_valid\":true,\"telefono\":\"(81) 8479-8731\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(51,4,'fc2','clientes','15','7124','clients','47','4c0e63d01d887b4c8a0e982c64f54a4ee47eec051e647fb7333bdeec8740ca2b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97345\",\"contacto\":null,\"domicilio\":{\"calle\":\"tablaje\",\"colonia\":null,\"estado\":\"Yucatan\",\"localidad\":\"Conkal\",\"municipio\":\"Conkal\",\"no_ext\":\"31041\",\"no_int\":null},\"email\":\"sdeangel@yahoo.com.mx\",\"email_comparison\":\"sdeangel@yahoo.com.mx\",\"legacy_id\":\"7124\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"SUEÑOS DE ANGEL\",\"razon_social_comparison\":\"SUEÑOS DE ANGEL\",\"razon_social_original\":\"SUEÑOS DE ANGEL\",\"regimen_fiscal\":null,\"rfc\":\"SAN060614SQ4\",\"rfc_original\":\"SAN060614SQ4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(52,4,'fc2','clientes','15','7183','clients','48','eeafafb517f47c2eee75c0aeb46c73cc65d6dd9377164afecd3c35d666a7ae3c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":null,\"domicilio\":{\"calle\":\"S/N\",\"colonia\":\"N/A\",\"estado\":null,\"localidad\":\"N/A\",\"municipio\":\"N/A\",\"no_ext\":\"S/N\",\"no_int\":\"S/N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7183\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"PUBLICO GENERAL\",\"razon_social_comparison\":\"PUBLICO GENERAL\",\"razon_social_original\":\"PUBLICO GENERAL\",\"regimen_fiscal\":\"616\",\"rfc\":\"XAXX010101000\",\"rfc_original\":\"XAXX010101000\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(53,4,'fc2','clientes','15','7248','clients','49','7115fe4ceabd51409d2b54691d5bd7b0e33a42273d06871c2020c78b78580e8a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"62550\",\"contacto\":\"neri\",\"domicilio\":{\"calle\":\"CERILLERA\",\"colonia\":\"CENTRO JIUTEPEC\",\"estado\":\"MORELOS\",\"localidad\":\"JIUTEPEC\",\"municipio\":\"JIUTEPEC\",\"no_ext\":\"43\",\"no_int\":null},\"email\":\"neri@gruporev.com\",\"email_comparison\":\"neri@gruporev.com\",\"legacy_id\":\"7248\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CARETAS REV\",\"razon_social_comparison\":\"CARETAS REV\",\"razon_social_original\":\"CARETAS REV\",\"regimen_fiscal\":\"601\",\"rfc\":\"CRE7712179M5\",\"rfc_original\":\"CRE7712179M5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(54,4,'fc2','clientes','15','7260','clients','50','dd2bcd3703e499386d0d39b922d7029516098fed1b975502da3d25a5bb0274a8',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97000\",\"contacto\":null,\"domicilio\":{\"calle\":\"44\",\"colonia\":\"MERIDA CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"423\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7260\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"20 NUDOS\",\"razon_social_comparison\":\"20 NUDOS\",\"razon_social_original\":\"20 NUDOS\",\"regimen_fiscal\":\"601\",\"rfc\":\"VNU1605041J1\",\"rfc_original\":\"VNU1605041J1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(55,4,'fc2','clientes','15','7272','clients','51','3c064935d4caba4ca1e840888b61611b9e1c170ce2cc485409e792b021704ea6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"55 PONIENTE X 18 NORTE\",\"colonia\":\"EJIDO NORTE\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MANZANA 168\",\"no_int\":\"LOTE 006\"},\"email\":\"saskia@oceantoursmexico.com\",\"email_comparison\":\"saskia@oceantoursmexico.com\",\"legacy_id\":\"7272\",\"observaciones\":null,\"pais\":\"MÉXICO\",\"razon_social\":\"OCEAN TOURS PLAYA\",\"razon_social_comparison\":\"OCEAN TOURS PLAYA\",\"razon_social_original\":\"OCEAN TOURS PLAYA\",\"regimen_fiscal\":null,\"rfc\":\"OTP110225PK3\",\"rfc_original\":\"OTP110225PK3\",\"rfc_valid\":true,\"telefono\":\"984 2061444\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(56,4,'fc2','clientes','15','7281','clients','52','4a414e5719b9255853e3ebe80206953ae2cffc4eb30f841bcb824c2136bc1363',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97816\",\"contacto\":\"CARLOS REYNALDO ALDANA HERRERA\",\"domicilio\":{\"calle\":\"23\",\"colonia\":\"CHOCHOLA\",\"estado\":\"YUCATAN\",\"localidad\":\"CHOCHOLA\",\"municipio\":\"CHOCHOLA\",\"no_ext\":\"126\",\"no_int\":null},\"email\":\"facturacion.cenotesanignacio@gmail.com\",\"email_comparison\":\"facturacion.cenotesanignacio@gmail.com\",\"legacy_id\":\"7281\",\"observaciones\":null,\"pais\":\"MÉXICO\",\"razon_social\":\"CARLOS REYNALDO ALDANA HERRERA\",\"razon_social_comparison\":\"CARLOS REYNALDO ALDANA HERRERA\",\"razon_social_original\":\"CARLOS REYNALDO ALDANA HERRERA\",\"regimen_fiscal\":\"612\",\"rfc\":\"AAHC690729U64\",\"rfc_original\":\"AAHC690729U64\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(57,4,'fc2','clientes','15','7308','clients','53','9ca91c81000258668cbc475caf5bdd6710ed4b15e456c1b34adaf7e7bb6b1d85',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRETERA CHETUMAL PUERTO JUAREZ\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KILOMETRO 282\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7308\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"XERVIGAS\",\"razon_social_comparison\":\"XERVIGAS\",\"razon_social_original\":\"XERVIGAS\",\"regimen_fiscal\":null,\"rfc\":\"XER170125R18\",\"rfc_original\":\"XER170125R18\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(58,4,'fc2','clientes','15','7342','clients','54','2d38c084ce72e74d63017d3cef30cedefbef2f00ea401b4c0ec7cbd9d970db7b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"91000\",\"contacto\":null,\"domicilio\":{\"calle\":\"ALTAMIRANO\",\"colonia\":\"CENTRO\",\"estado\":\"VERACRUZ DE IGNACIO DE LA LLAVE\",\"localidad\":\"XALAPA\",\"municipio\":\"XALAPA\",\"no_ext\":\"17\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7342\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ANGEL ARTURO MAXIMILIANO\",\"razon_social_comparison\":\"ANGEL ARTURO MAXIMILIANO\",\"razon_social_original\":\"ANGEL ARTURO MAXIMILIANO\",\"regimen_fiscal\":null,\"rfc\":\"VEGA781012N61\",\"rfc_original\":\"VEGA781012N61\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(59,4,'fc2','clientes','15','7363','clients','55','92133f830413e7cc129f1387ab8c2d54a6dee7822e856bbc3aae0f3850406ee0',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97128\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 1H\",\"colonia\":\"MEXICO NORTE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"192\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7363\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARIEL LAVALLE ALONZO\",\"razon_social_comparison\":\"MARIEL LAVALLE ALONZO\",\"razon_social_original\":\"MARIEL LAVALLE ALONZO\",\"regimen_fiscal\":\"612\",\"rfc\":\"LAAM9101286G3\",\"rfc_original\":\"LAAM9101286G3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(60,4,'fc2','clientes','15','7394','clients','56','61b5e8982727741839cfc9dee2edb7b0c53d82d8508bd9d7032202a8286d498b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97144\",\"contacto\":null,\"domicilio\":{\"calle\":\"16\",\"colonia\":\"EMILIANO ZAPATA OTE\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"332\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7394\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PIAPRODUCCIONES\",\"razon_social_comparison\":\"PIAPRODUCCIONES\",\"razon_social_original\":\"PIAPRODUCCIONES\",\"regimen_fiscal\":\"626\",\"rfc\":\"PIA1308285X1\",\"rfc_original\":\"PIA1308285X1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(61,4,'fc2','clientes','15','7437','clients','57','daf8486392d716e06fdc9828bcaf668a2895a18383256c7c93d074845a701a27',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"76000\",\"contacto\":\"CIUDAD MADERAS\",\"domicilio\":{\"calle\":\"5 DE MAYO\",\"colonia\":\"CENTRO\",\"estado\":\"QUERETARO\",\"localidad\":null,\"municipio\":\"QUERETARO\",\"no_ext\":\"75\",\"no_int\":\"S/N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7437\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CENTRO INMOBILIARIO DEL BAJIO\",\"razon_social_comparison\":\"CENTRO INMOBILIARIO DEL BAJIO\",\"razon_social_original\":\"CENTRO INMOBILIARIO DEL BAJIO\",\"regimen_fiscal\":\"601\",\"rfc\":\"CIB920312FS2\",\"rfc_original\":\"CIB920312FS2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(62,4,'fc2','clientes','15','7508','clients','58','692d807387d15ae5edbc37ef5535d49c50637c14ba3673019d51c29b9ce622be',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"45100\",\"contacto\":null,\"domicilio\":{\"calle\":\"SABINO DELGADO\",\"colonia\":\"ZAPOPA CENTRO\",\"estado\":\"JALISCO\",\"localidad\":\"ZAPOPAN\",\"municipio\":\"ZAPOPAN\",\"no_ext\":\"S/N\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7508\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"INOVACREATIVA\",\"razon_social_comparison\":\"INOVACREATIVA\",\"razon_social_original\":\"INOVACREATIVA\",\"regimen_fiscal\":\"601\",\"rfc\":\"INO130128JF7\",\"rfc_original\":\"INO130128JF7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(63,4,'fc2','clientes','15','7599','clients','59','5bd57ad80d95fa30f68f4c5925249d250b4593dc3054a3ef17a0149b38cf62be',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":\"Cristina\",\"domicilio\":{\"calle\":\"24\",\"colonia\":\"Altabrisa\",\"estado\":\"Yucatan\",\"localidad\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"municipio\":\"Merida\",\"no_ext\":\"356\",\"no_int\":\"1,2,3,4,A,B,C,D\"},\"email\":\"almacen@grupocielo.com.mx\",\"email_comparison\":\"almacen@grupocielo.com.mx\",\"legacy_id\":\"7599\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"DESARROLLOS AMARILLOS DE LA PENINSULA\",\"razon_social_comparison\":\"DESARROLLOS AMARILLOS DE LA PENINSULA\",\"razon_social_original\":\"DESARROLLOS AMARILLOS DE LA PENINSULA\",\"regimen_fiscal\":\"601\",\"rfc\":\"DAP170822SE1\",\"rfc_original\":\"DAP170822SE1\",\"rfc_valid\":true,\"telefono\":\"9992625557\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(64,4,'fc2','clientes','15','7603','clients','60','52d5d9b1aa82178b934df4dba8f1b707a0301b237688ef3f53be247c46194e53',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"03900\",\"contacto\":null,\"domicilio\":{\"calle\":\"Avenida Insurgentes sur y Calle Jose Ma. Ibarran\",\"colonia\":\"SAN JOSE INSURGENTES\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":null,\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"101\",\"no_int\":\"´Planta Baja\"},\"email\":\"jcmedina@spartodopromo.com\",\"email_comparison\":\"jcmedina@spartodopromo.com\",\"legacy_id\":\"7603\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"SPAR TODOPROMO\",\"razon_social_comparison\":\"SPAR TODOPROMO\",\"razon_social_original\":\"SPAR TODOPROMO\",\"regimen_fiscal\":\"601\",\"rfc\":\"STO110826RS0\",\"rfc_original\":\"STO110826RS0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(65,4,'fc2','clientes','15','7604','clients','61','e275a0d78c158aa65fb8e9bbf1659b413d61844510a5b859b06dafbc4aaa48d1',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"37545\",\"contacto\":\"MARINA PEREA GONZALEZ\",\"domicilio\":{\"calle\":\"LAUREL Y ALTAR DE SAN PABLO\",\"colonia\":\"SAN JOSE EN ALTO\",\"estado\":\"GUANAJUATO\",\"localidad\":null,\"municipio\":\"LEON\",\"no_ext\":\"218\",\"no_int\":\"A\"},\"email\":\"asenegocios2@gmail.com\",\"email_comparison\":\"asenegocios2@gmail.com\",\"legacy_id\":\"7604\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARINA PEREA GONZALEZ\",\"razon_social_comparison\":\"MARINA PEREA GONZALEZ\",\"razon_social_original\":\"MARINA PEREA GONZALEZ\",\"regimen_fiscal\":\"612\",\"rfc\":\"PEGM591214V78\",\"rfc_original\":\"PEGM591214V78\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(66,4,'fc2','clientes','15','7605','clients','62','6310ab4969640c02f09f6ec189a7641f6a249c6b632b3b89cdb22e2297021749',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":\"AB&C LEASING DE MEXICO\",\"domicilio\":{\"calle\":\"11 Y 13\",\"colonia\":\"ITZIMNA\",\"estado\":\"Yucatan\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"452\",\"no_int\":null},\"email\":\"notificacionesfiscal@bepensa.com\",\"email_comparison\":\"notificacionesfiscal@bepensa.com\",\"legacy_id\":\"7605\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"AB&C LEASING DE MEXICO\",\"razon_social_comparison\":\"AB&C LEASING DE MEXICO\",\"razon_social_original\":\"AB&C LEASING DE MEXICO\",\"regimen_fiscal\":\"623\",\"rfc\":\"ALM9910114D6\",\"rfc_original\":\"ALM9910114D6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(67,4,'fc2','clientes','15','7616','clients','63','c15f350e9dc7d25563889297ef1b3b68ea4eb23d8cda6852207b1467c709a629',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97320\",\"contacto\":\"MULTISUR\",\"domicilio\":{\"calle\":\"CALLE 75 ENTRE CALLE 72\",\"colonia\":\"CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"PROGRESO\",\"municipio\":\"PROGRESO\",\"no_ext\":\"147\",\"no_int\":null},\"email\":\"fernando.rojas@logra.com.mx\",\"email_comparison\":\"fernando.rojas@logra.com.mx\",\"legacy_id\":\"7616\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MULTISUR\",\"razon_social_comparison\":\"MULTISUR\",\"razon_social_original\":\"MULTISUR\",\"regimen_fiscal\":\"601\",\"rfc\":\"MUL8508057S7\",\"rfc_original\":\"MUL8508057S7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(68,4,'fc2','clientes','15','7681','clients','64','89a079823d3041c7d470c300124b82f3f65f51ccc04e764b959113ed4191793a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":null,\"colonia\":\"EJIDO SUR\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":null,\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7681\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"RIO SECRETO\",\"razon_social_comparison\":\"RIO SECRETO\",\"razon_social_original\":\"RIO SECRETO\",\"regimen_fiscal\":\"601\",\"rfc\":\"RSE0811123T6\",\"rfc_original\":\"RSE0811123T6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(69,4,'fc2','clientes','15','7690','clients','65','d82d445dc93e0464323aa881cba2d6c9b8b78a24412a5ae837b316fc9fed2aac',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":\"GRADUATE\",\"domicilio\":{\"calle\":\"20\",\"colonia\":\"ITZIMNA\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"89-B\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7690\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GRADYREC DE MEXICO\",\"razon_social_comparison\":\"GRADYREC DE MEXICO\",\"razon_social_original\":\"GRADYREC DE MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"GME201228743\",\"rfc_original\":\"GME201228743\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(70,4,'fc2','clientes','15','7695','clients','66','0a0aa1d121d42381844aaf22c2919c0a51bc56e84d286b9e9407968982dca681',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":null,\"colonia\":\"PLAYA DEL SECRETO\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KM 311-500\",\"no_int\":\"PA\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7695\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"VALENTIN TRAVEL MEXICO\",\"razon_social_comparison\":\"VALENTIN TRAVEL MEXICO\",\"razon_social_original\":\"VALENTIN TRAVEL MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"VTM181204M49\",\"rfc_original\":\"VTM181204M49\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(71,4,'fc2','clientes','15','7759','clients','67','2d3cfb6908ef30b425a5edc0b5fbecc1602ee5dc562a8dae6179cf58220ccd0f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"01040\",\"contacto\":null,\"domicilio\":{\"calle\":\"TLACOPAC\",\"colonia\":\"CAMPESTRE\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"ALVARO OBREGON\",\"municipio\":\"ALVARO OBREGON\",\"no_ext\":\"6\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7759\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"OPESA OPERADORA DE PROYECTOS ESPECIALES\",\"razon_social_comparison\":\"OPESA OPERADORA DE PROYECTOS ESPECIALES\",\"razon_social_original\":\"OPESA OPERADORA DE PROYECTOS ESPECIALES\",\"regimen_fiscal\":\"601\",\"rfc\":\"OOP230428NM3\",\"rfc_original\":\"OOP230428NM3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(72,4,'fc2','clientes','15','7760','clients','68','98d1bb05d652eb47d31c2230ab68865e4ba6346483b68c556407d8778f547699',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"01600\",\"contacto\":null,\"domicilio\":{\"calle\":null,\"colonia\":\"MERCED GOMEZ\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"ALVARO OBREGON\",\"municipio\":\"ALVARO OBREGON\",\"no_ext\":\"28\",\"no_int\":\"401\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7760\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CURIA DE MEXICO\",\"razon_social_comparison\":\"CURIA DE MEXICO\",\"razon_social_original\":\"CURIA DE MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"CME210922CA5\",\"rfc_original\":\"CME210922CA5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(73,4,'fc2','clientes','15','7796','clients','69','c0ad7a0a3d4a8e3bb33c9a0e0537b07b91b5f770625187ff19763668ac922e91',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARR CHE PTO JUARZ\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":null,\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KM 282\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7796\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"DESTINO XCARET\",\"razon_social_comparison\":\"DESTINO XCARET\",\"razon_social_original\":\"DESTINO XCARET\",\"regimen_fiscal\":\"601\",\"rfc\":\"DXC9912292N7\",\"rfc_original\":\"DXC9912292N7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:15'),(74,4,'fc2','clientes','15','7799','clients','70','f45a07877588bbd6f7ed70a9f88f10ccb7055b30ad451f054a0fb13b0396a422',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRETERA FEDERAL CHETUMAL PUERTO JUAREZ\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KILOMETRO 282\",\"no_int\":\"L T 023 2\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7799\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EXPERIENCIAS XCARET HOTELES\",\"razon_social_comparison\":\"EXPERIENCIAS XCARET HOTELES\",\"razon_social_original\":\"EXPERIENCIAS XCARET HOTELES\",\"regimen_fiscal\":\"601\",\"rfc\":\"EXH160510UW8\",\"rfc_original\":\"EXH160510UW8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(75,4,'fc2','clientes','15','7859','clients','71','3ab08c1545acc31a11833be502864ab0086f62c956b5bc221ef583667323b9a0',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97125\",\"contacto\":\"AARON DIAZ\",\"domicilio\":{\"calle\":\"CALLE 17\",\"colonia\":\"Colonia Mexico\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":null,\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7859\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"AARON DIAZ LOPEZ\",\"razon_social_comparison\":\"AARON DIAZ LOPEZ\",\"razon_social_original\":\"AARON DIAZ LOPEZ\",\"regimen_fiscal\":\"612\",\"rfc\":\"DILA760201TE7\",\"rfc_original\":\"DILA760201TE7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(76,4,'fc2','clientes','15','7881','clients','72','1918ba99be65492073f15d39ed7682d4ad58ec34800e190fc9eaf3712cac3e77',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"23232\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE\",\"colonia\":\"LA VENTANA\",\"estado\":\"BAJA CALIFORNIA SUR\",\"localidad\":\"LA PAZ\",\"municipio\":\"LA VENTANA\",\"no_ext\":\"SN\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7881\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"GUNTER VILLA URBINA\",\"razon_social_comparison\":\"GUNTER VILLA URBINA\",\"razon_social_original\":\"GUNTER VILLA URBINA\",\"regimen_fiscal\":\"626\",\"rfc\":\"VIUG740608D82\",\"rfc_original\":\"VIUG740608D82\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(77,4,'fc2','clientes','15','7882','clients','73','612e0e9b0e6588e491c67fa02d36f95c9d3682df6477148827a5dcc849fd24c6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97314\",\"contacto\":\"GERARDO\",\"domicilio\":{\"calle\":\"CALLE\",\"colonia\":\"HOGARES CAUCEL\",\"estado\":\"YUCATAN\",\"localidad\":\"CAUCEL\",\"municipio\":\"MERIDA\",\"no_ext\":\"645\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7882\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"LUIS GERARDO COSGAYA SOSA\",\"razon_social_comparison\":\"LUIS GERARDO COSGAYA SOSA\",\"razon_social_original\":\"LUIS GERARDO COSGAYA SOSA\",\"regimen_fiscal\":\"612\",\"rfc\":\"COSL980112VB9\",\"rfc_original\":\"COSL980112VB9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(78,4,'fc2','clientes','15','7883','clients','74','e038bd5df9145bfba97db75f50c22ec17b0e636579c0259450af69c2d62c575c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"52786\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA UNIVERSIDAD ANAHUAC\",\"colonia\":\"LOMAS ANAHUAC\",\"estado\":\"MEXICO\",\"localidad\":null,\"municipio\":\"HUIXQUILUCAN\",\"no_ext\":\"46\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7883\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"INVESTIGACIONES Y ESTUDIOS SUPERIORES\",\"razon_social_comparison\":\"INVESTIGACIONES Y ESTUDIOS SUPERIORES\",\"razon_social_original\":\"INVESTIGACIONES Y ESTUDIOS SUPERIORES\",\"regimen_fiscal\":\"603\",\"rfc\":\"IES870531FU5\",\"rfc_original\":\"IES870531FU5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(79,4,'fc2','clientes','15','7907','clients','75','9b7525759c7b8db787923e2574f579cbdded9ac9179afb6e6b9965c65861082e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97204\",\"contacto\":\"YUCAVILE\",\"domicilio\":{\"calle\":\"20-A\",\"colonia\":\"X-CUMPICH\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"297\",\"no_int\":\"SUITE101\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7907\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"XCUMPICH TRAVEL\",\"razon_social_comparison\":\"XCUMPICH TRAVEL\",\"razon_social_original\":\"XCUMPICH TRAVEL\",\"regimen_fiscal\":\"601\",\"rfc\":\"XTR150821KR1\",\"rfc_original\":\"XTR150821KR1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(80,4,'fc2','clientes','15','7923','clients','76','1f224523c68408bbe85e1c89d672ebf5fc258ff813bc2344d5c21f863d7f092f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97138\",\"contacto\":\"ALE MATA\",\"domicilio\":{\"calle\":\"CALLE 29\",\"colonia\":\"SANTA MARIA CHUBURNA\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"261-A\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7923\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARIA EUGENIA MEDINA RINCON\",\"razon_social_comparison\":\"MARIA EUGENIA MEDINA RINCON\",\"razon_social_original\":\"MARIA EUGENIA MEDINA RINCON\",\"regimen_fiscal\":\"612\",\"rfc\":\"MERE581009AS2\",\"rfc_original\":\"MERE581009AS2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(81,4,'fc2','clientes','15','7932','clients','77','ad0bbc962abd5414b42a83b9ca48979e30a2b8a91477d714879ba963f2bd39f0',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"03020\",\"contacto\":null,\"domicilio\":{\"calle\":\"EUGENIA\",\"colonia\":\"NARVARTE ORIENTE\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":null,\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"189\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7932\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"UNITED PARCEL SERVICE DE MEXICO\",\"razon_social_comparison\":\"UNITED PARCEL SERVICE DE MEXICO\",\"razon_social_original\":\"UNITED PARCEL SERVICE DE MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"UPS891122HV8\",\"rfc_original\":\"UPS891122HV8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(82,4,'fc2','clientes','15','7933','clients','78','f4b3c30f5a41a15f8cd7846fc9ca8fa803e9fd5c2ea4b9f85105fb15ee2eeb67',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"10 NORTE\",\"colonia\":\"CENTRO\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MANZANA 100 LOTE 01\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7933\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SCUBA CHIPOTLE\",\"razon_social_comparison\":\"SCUBA CHIPOTLE\",\"razon_social_original\":\"SCUBA CHIPOTLE\",\"regimen_fiscal\":\"601\",\"rfc\":\"SCI1708074W4\",\"rfc_original\":\"SCI1708074W4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(83,4,'fc2','clientes','15','7934','clients','79','01ea0703020ba05d404ede18db3846a96e57aee382b99e3540543061ba6a49e5',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 10 NORTE MZA 21 LOTE 8\",\"colonia\":\"CENTRO\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"LOCAL 9\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"7934\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SCUBA PLAYA\",\"razon_social_comparison\":\"SCUBA PLAYA\",\"razon_social_original\":\"SCUBA PLAYA\",\"regimen_fiscal\":\"601\",\"rfc\":\"SPL090616B95\",\"rfc_original\":\"SPL090616B95\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(84,4,'fc2','clientes','15','8014','clients','80','4dbb47aa594349d0a85c5e374c205a4e2746cef5beeefa5278b63b00748c03f4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77516\",\"contacto\":null,\"domicilio\":{\"calle\":\"46\",\"colonia\":\"SUPERMANZANA 91\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"8\",\"no_int\":\"SN\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8014\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"TODO PREFABRICADOS 5\",\"razon_social_comparison\":\"TODO PREFABRICADOS 5\",\"razon_social_original\":\"TODO PREFABRICADOS 5\",\"regimen_fiscal\":\"601\",\"rfc\":\"TPC1902211T2\",\"rfc_original\":\"TPC1902211T2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(85,4,'fc2','clientes','15','8015','clients','81','81a1cde9f17dff071043a3b14252860fb9b2ef588f5b239a0c48d4012d6fc464',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"53040\",\"contacto\":\"MONICA ALVAREZ\",\"domicilio\":{\"calle\":\"TRINIDAD\",\"colonia\":\"LAS AMERICAS\",\"estado\":\"ESTADO DE MEXICO\",\"localidad\":\"NAUCALPAN DE JUAREZ\",\"municipio\":\"NAUCALPAN\",\"no_ext\":\"7\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8015\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MEGA TRAVEL OPERADORA\",\"razon_social_comparison\":\"MEGA TRAVEL OPERADORA\",\"razon_social_original\":\"MEGA TRAVEL OPERADORA\",\"regimen_fiscal\":\"601\",\"rfc\":\"MTO171211CN7\",\"rfc_original\":\"MTO171211CN7\",\"rfc_valid\":true,\"telefono\":\"9993492736\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(86,4,'fc2','clientes','15','8016','clients','82','af222733e1c295f1c06c766ddb5d34261ce0619e27aa78572f7b99fa88a62354',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77580\",\"contacto\":null,\"domicilio\":{\"calle\":\"Central Vallarta\",\"colonia\":\"Puerto Morelos\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"Puerto Morelos\",\"municipio\":\"Puerto Morelos\",\"no_ext\":\"KM 7.5 P\",\"no_int\":\"SN\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8016\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"TODO PREFABRICADOS 5\",\"razon_social_comparison\":\"TODO PREFABRICADOS 5\",\"razon_social_original\":\"TODO PREFABRICADOS 5\",\"regimen_fiscal\":\"601\",\"rfc\":\"TPC1902211T2\",\"rfc_original\":\"TPC1902211T2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(87,4,'fc2','clientes','15','8032','clients','83','4ca15586735a747e8be6b4056b36cd88db0f4837dd388711c3e17558dddc56de',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77035\",\"contacto\":null,\"domicilio\":{\"calle\":\"ADOLFO LOPEZ MATEOS\",\"colonia\":\"ITALIA\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CHETUMAL\",\"municipio\":\"OTHON P BLANCO\",\"no_ext\":\"363\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8032\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CONSTRUCCIONES Y SUMINISTROS MAHAUAL\",\"razon_social_comparison\":\"CONSTRUCCIONES Y SUMINISTROS MAHAUAL\",\"razon_social_original\":\"CONSTRUCCIONES Y SUMINISTROS MAHAUAL\",\"regimen_fiscal\":\"601\",\"rfc\":\"CSM9906236F7\",\"rfc_original\":\"CSM9906236F7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(88,4,'fc2','clientes','15','8033','clients','84','986765ca85b932bf965959baa824da7aa1614214451ae90a0e37c5c0c65b08d4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97279\",\"contacto\":null,\"domicilio\":{\"calle\":\"101\",\"colonia\":\"SANTA ROSA\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"357\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8033\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"KATY EMILIA RIVERO DIAZ\",\"razon_social_comparison\":\"KATY EMILIA RIVERO DIAZ\",\"razon_social_original\":\"KATY EMILIA RIVERO DIAZ\",\"regimen_fiscal\":\"626\",\"rfc\":\"RIDK710519827\",\"rfc_original\":\"RIDK710519827\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(89,4,'fc2','clientes','15','8040','clients','85','5ecd44a7b84cf1c711bdd6976153489fec99518f6a52cfb7804dc1b93e91d5f6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"53370\",\"contacto\":null,\"domicilio\":{\"calle\":\"ESFUERZO NACIONAL\",\"colonia\":\"INDUSTRIAL ALCE BLANCO\",\"estado\":\"MEXICO\",\"localidad\":null,\"municipio\":\"NAUCALPAN DE  JUAREZ\",\"no_ext\":\"2\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8040\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"BOSTIK MEXICANA\",\"razon_social_comparison\":\"BOSTIK MEXICANA\",\"razon_social_original\":\"BOSTIK MEXICANA\",\"regimen_fiscal\":\"601\",\"rfc\":\"BME631003N72\",\"rfc_original\":\"BME631003N72\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(90,4,'fc2','clientes','15','8076','clients','86','215aadcbe75bdde8875204727a09553d825cbb0fc6ef36c41cf1e59638d3a34c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRETERA CANCUN AEREOPUERTO KM 14.5\",\"colonia\":\"CARRETERA CANCUN AEROPUERTO ORIENTE\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"BODEGA 67 68 85 Y 86\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8076\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"INFLIGHT SERVICES MEXICO\",\"razon_social_comparison\":\"INFLIGHT SERVICES MEXICO\",\"razon_social_original\":\"INFLIGHT SERVICES MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"ISM9803269C1\",\"rfc_original\":\"ISM9803269C1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(91,4,'fc2','clientes','15','8091','clients','87','10b5038addc4b16b5d6fdd1faacfeb6adb21cd0273f73ab7117461fe45603f5a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"44160\",\"contacto\":null,\"domicilio\":{\"calle\":\"MIGUEL LAREDO DE TEJEDA\",\"colonia\":\"AMERICANA\",\"estado\":\"JALISCO\",\"localidad\":\"GUADALAJARA\",\"municipio\":\"GUADALAJARA\",\"no_ext\":\"2108\",\"no_int\":null},\"email\":\"ROSA.GONZALEZ@TAFERRESORTS.COM\",\"email_comparison\":\"rosa.gonzalez@taferresorts.com\",\"legacy_id\":\"8091\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"TAFER RESORTS MANAGEMENT\",\"razon_social_comparison\":\"TAFER RESORTS MANAGEMENT\",\"razon_social_original\":\"TAFER RESORTS MANAGEMENT\",\"regimen_fiscal\":\"601\",\"rfc\":\"TRM180530UU8\",\"rfc_original\":\"TRM180530UU8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(92,4,'fc2','clientes','15','8092','clients','88','4c588f096a809ffb8a42ac7f142fa02d86050638ffb6285c0b9f9805fab7022f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77580\",\"contacto\":null,\"domicilio\":{\"calle\":\"KM 19 PARCELA 213\",\"colonia\":\"PUERTO MORELOS\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PUERTO MORELOS\",\"municipio\":\"PUERTO MORELOS\",\"no_ext\":\"Z1P1 CTRAVALL\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8092\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"RESERVA BENGALA\",\"razon_social_comparison\":\"RESERVA BENGALA\",\"razon_social_original\":\"RESERVA BENGALA\",\"regimen_fiscal\":\"601\",\"rfc\":\"RBE140303BUA\",\"rfc_original\":\"RBE140303BUA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(93,4,'fc2','clientes','15','8093','clients','89','3d53b9a8c662557813d6467e72d1165e8938ed4775a0f10616d21a727f7bd8d4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77504\",\"contacto\":null,\"domicilio\":{\"calle\":\"BANCO CHINCHORRO\",\"colonia\":\"SUPER MANZANA 13\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MZ 1 LT 8\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8093\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"EJECUTIVOS DE TURISMO SUSTENTABLE\",\"razon_social_comparison\":\"EJECUTIVOS DE TURISMO SUSTENTABLE\",\"razon_social_original\":\"EJECUTIVOS DE TURISMO SUSTENTABLE\",\"regimen_fiscal\":\"601\",\"rfc\":\"ETS181205CA4\",\"rfc_original\":\"ETS181205CA4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(94,4,'fc2','clientes','15','8094','clients','90','569e7f708be0861ff4c0dc486830c5c7c679ff0b5e6952b5437b32421b04ef01',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77533\",\"contacto\":null,\"domicilio\":{\"calle\":\"KABAH\",\"colonia\":\"SUPERMANZANA 55\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 04 LOTE 1\",\"no_int\":\"301\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8094\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"CONTROLADORA DOLPHIN\",\"razon_social_comparison\":\"CONTROLADORA DOLPHIN\",\"razon_social_original\":\"CONTROLADORA DOLPHIN\",\"regimen_fiscal\":\"601\",\"rfc\":\"CDO070410V77\",\"rfc_original\":\"CDO070410V77\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(95,4,'fc2','clientes','15','8097','clients','91','f0e8ede9d06cfb2bf350f22627416b7d4e56bce0170911e23aaaaab46a194602',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA 95 SUR\",\"colonia\":\"EJIDO SUR\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"LOTE 04 MANZANA 398\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8097\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARIO ALBERTO LUCHINI\",\"razon_social_comparison\":\"MARIO ALBERTO LUCHINI\",\"razon_social_original\":\"MARIO ALBERTO LUCHINI\",\"regimen_fiscal\":\"612\",\"rfc\":\"LUMA661114IS8\",\"rfc_original\":\"LUMA661114IS8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(96,4,'fc2','clientes','15','8108','clients','92','8597e5575114c20c080153737abf62c000c0c987797225a35c3b07268ae0cedc',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97135\",\"contacto\":null,\"domicilio\":{\"calle\":\"17\",\"colonia\":\"JARDINES DE MERIDA\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":null,\"no_ext\":\"661\",\"no_int\":\"LOCAL 4\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8108\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"XULTA SOLUCIONES\",\"razon_social_comparison\":\"XULTA SOLUCIONES\",\"razon_social_original\":\"XULTA SOLUCIONES\",\"regimen_fiscal\":\"626\",\"rfc\":\"XSO200728TK4\",\"rfc_original\":\"XSO200728TK4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(97,4,'fc2','clientes','15','8109','clients','93','1468ff7f1350d932650201a3f92663eef5ab2793be4f2bf87b04c138469ad967',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97135\",\"contacto\":null,\"domicilio\":{\"calle\":\"17\",\"colonia\":\"JARDINES DE MERIDA\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"661\",\"no_int\":\"LOCAL 4\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8109\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"XULTA INGENIERIA DE COSTOS\",\"razon_social_comparison\":\"XULTA INGENIERIA DE COSTOS\",\"razon_social_original\":\"XULTA INGENIERIA DE COSTOS\",\"regimen_fiscal\":\"601\",\"rfc\":\"XIC211221FB9\",\"rfc_original\":\"XIC211221FB9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(98,4,'fc2','clientes','15','8110','clients','94','e50c8a87500543bdfcf34a92890c6b5a6646879811fe87b3901cd632798964c7',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"BONAMPAK\",\"colonia\":\"SM 6\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"BENITO JUAREZ\",\"municipio\":\"CANCUN\",\"no_ext\":\"MANZANA 1 LOTE 1\",\"no_int\":\"PISO 5\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8110\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GINO CONTROL EMPRESARIAL\",\"razon_social_comparison\":\"GINO CONTROL EMPRESARIAL\",\"razon_social_original\":\"GINO CONTROL EMPRESARIAL\",\"regimen_fiscal\":\"601\",\"rfc\":\"GCE190724KT7\",\"rfc_original\":\"GCE190724KT7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(99,4,'fc2','clientes','15','8112','clients','95','620468370e4e86dc6be93b106ae596488a4405744b832e7912c8f25d7778d32e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"94299\",\"contacto\":null,\"domicilio\":{\"calle\":\"BOULEVARD (BLVD)\",\"colonia\":\"FRACC DE LAS AMERICAS\",\"estado\":\"VERACRUZ DE IGNACIO DE LA  LLAVE\",\"localidad\":\"BOCA DEL RIO\",\"municipio\":\"BOCA DEL RIO\",\"no_ext\":\"ADOLFO RUIZ CORTINES\",\"no_int\":\"3321\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8112\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GULF MARINE DE MEXICO\",\"razon_social_comparison\":\"GULF MARINE DE MEXICO\",\"razon_social_original\":\"GULF MARINE DE MEXICO\",\"regimen_fiscal\":\"601\",\"rfc\":\"GMM0706299H8\",\"rfc_original\":\"GMM0706299H8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(100,4,'fc2','clientes','15','8115','clients','96','048fcd1877b85606f32baacd494236dd58a2daa8b52b44b2e0f9694cb368e744',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"TAXISTAS\",\"colonia\":\"EJIDO SUR\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MZA 786 LT 002-3\",\"no_int\":\"B FRACCION 1 A-3 DE\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8115\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"AGL PRODUCE\",\"razon_social_comparison\":\"AGL PRODUCE\",\"razon_social_original\":\"AGL PRODUCE\",\"regimen_fiscal\":\"622\",\"rfc\":\"APR180905RC8\",\"rfc_original\":\"APR180905RC8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(101,4,'fc2','clientes','15','8121','clients','97','e7b779ee3ce658e156d7cb5cdfa578e8f5d8142f32ca76517331be935ac65d82',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 18 Y CALLE 20\",\"colonia\":\"ITZIMNA\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"108\",\"no_int\":\"13\"},\"email\":\"rosario.amaya@logra.mx\",\"email_comparison\":\"rosario.amaya@logra.mx\",\"legacy_id\":\"8121\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SERVICIOS CORPORATIVOS SAC BE\",\"razon_social_comparison\":\"SERVICIOS CORPORATIVOS SAC BE\",\"razon_social_original\":\"SERVICIOS CORPORATIVOS SAC BE\",\"regimen_fiscal\":\"601\",\"rfc\":\"SCS040225SR6\",\"rfc_original\":\"SCS040225SR6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(102,4,'fc2','clientes','15','8123','clients','39','39acb1c340ab82fe2582095ee23cdea07d3d369775b158eb30591f38897f0fe6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77560\",\"contacto\":null,\"domicilio\":{\"calle\":\"LUIS DONALDO COLOSIO\",\"colonia\":\"SM 301\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 4 LOTE 5\",\"no_int\":\"BODEGA 519\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8123\",\"observaciones\":null,\"pais\":\"mexico\",\"razon_social\":\"FB DISTRIBUCIONES\",\"razon_social_comparison\":\"FB DISTRIBUCIONES\",\"razon_social_original\":\"FB DISTRIBUCIONES\",\"regimen_fiscal\":\"601\",\"rfc\":\"FDI1502063M0\",\"rfc_original\":\"FDI1502063M0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(103,4,'fc2','clientes','15','8124','clients','98','2d4782840ba1d1dad84f0640492830e4b43d610bcdb8967652e79156be43884e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77536\",\"contacto\":null,\"domicilio\":{\"calle\":\"LUIS DONALDO COLOSIO\",\"colonia\":\"SUPERMANZANA 301\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"520 MANZANA 4 LOTE 5\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8124\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ADELANTE DISTRIBUCIONES\",\"razon_social_comparison\":\"ADELANTE DISTRIBUCIONES\",\"razon_social_original\":\"ADELANTE DISTRIBUCIONES\",\"regimen_fiscal\":\"601\",\"rfc\":\"ADI120203QF5\",\"rfc_original\":\"ADI120203QF5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(104,4,'fc2','clientes','15','8149','clients','99','649b3579cc832bd00a63c4f03471eefea250575d44811c8727c3f4a72638f4bd',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77560\",\"contacto\":\"Nancy Garcia\",\"domicilio\":{\"calle\":\"Cancun Aeropuerto\",\"colonia\":\"Central de Abastos\",\"estado\":\"Quintana Roo\",\"localidad\":\"Cancun\",\"municipio\":\"Benito Juarez\",\"no_ext\":\"Manzana 4 Lote 5 SM\",\"no_int\":\"Bodega 518 BT-1\"},\"email\":\"nancygarcia@aldosgelato.com\",\"email_comparison\":\"nancygarcia@aldosgelato.com\",\"legacy_id\":\"8149\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"KERSHE\",\"razon_social_comparison\":\"KERSHE\",\"razon_social_original\":\"KERSHE\",\"regimen_fiscal\":\"601\",\"rfc\":\"KER150619642\",\"rfc_original\":\"KER150619642\",\"rfc_valid\":true,\"telefono\":\"9981300181\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(105,4,'fc2','clientes','15','8151','clients','100','f4f100456eea24ef231c91b7bad3043f0f561dd4934a5e352cfbe88b30f1ee1a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77726\",\"contacto\":\"Luca Marziano\",\"domicilio\":{\"calle\":\"Caracoles\",\"colonia\":\"Encuentro\",\"estado\":\"Quintana Roo\",\"localidad\":\"Playa del Carmen\",\"municipio\":\"Solidaridad\",\"no_ext\":\"MZ 20 LT 008\",\"no_int\":\"SN\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8151\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"RESIDENCIAL SALAMANCA PDC\",\"razon_social_comparison\":\"RESIDENCIAL SALAMANCA PDC\",\"razon_social_original\":\"RESIDENCIAL SALAMANCA PDC\",\"regimen_fiscal\":\"603\",\"rfc\":\"RSP240521T12\",\"rfc_original\":\"RSP240521T12\",\"rfc_valid\":true,\"telefono\":\"5521289728\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(106,4,'fc2','clientes','15','8164','clients','101','835e27719d1f546f20ef65f9461410b39dca8b2f67974165461f5661fb17af28',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77670\",\"contacto\":\"DANIEL\",\"domicilio\":{\"calle\":\"65\",\"colonia\":\"ZONA INDUSTRIA\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"COZUMEL\",\"municipio\":\"COZUMEL\",\"no_ext\":\"SN\",\"no_int\":\"6,7,8\"},\"email\":\"rh@kuzapark.com\",\"email_comparison\":\"rh@kuzapark.com\",\"legacy_id\":\"8164\",\"observaciones\":null,\"pais\":\"MEXIXCO\",\"razon_social\":\"GLOBAL CRUISES MX\",\"razon_social_comparison\":\"GLOBAL CRUISES MX\",\"razon_social_original\":\"GLOBAL CRUISES MX\",\"regimen_fiscal\":\"601\",\"rfc\":\"GCM220406SM5\",\"rfc_original\":\"GCM220406SM5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(107,4,'fc2','clientes','15','8168','clients','102','e884e004edaefeb2240cd41079fdd76af179161b248fca83fa5b8e0dac9fc93b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"96710\",\"contacto\":\"RENE\",\"domicilio\":{\"calle\":\"MARIANO ABASOLO\",\"colonia\":\"INSURGENTES NORTE\",\"estado\":\"VERACRUZ DE IGNACIO DE LA LLAVE\",\"localidad\":\"MINATITLAN\",\"municipio\":\"MINATITLAN\",\"no_ext\":\"19\",\"no_int\":\"S N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8168\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"DAMARIS ELIDED VILLAVICENCIO VERA\",\"razon_social_comparison\":\"DAMARIS ELIDED VILLAVICENCIO VERA\",\"razon_social_original\":\"DAMARIS ELIDED VILLAVICENCIO VERA\",\"regimen_fiscal\":\"612\",\"rfc\":\"VIVD010805513\",\"rfc_original\":\"VIVD010805513\",\"rfc_valid\":true,\"telefono\":\"9842658670\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(108,4,'fc2','clientes','15','8175','clients','103','686d14fd90943647a6562f7c679cefd5ddc2cab1a28e28337c05db84d0f97f3d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77536\",\"contacto\":\"BRIDIA\",\"domicilio\":{\"calle\":\"CARRETERA FEDERAL CANCUN -  AEROPUERTO\",\"colonia\":\"SUPERMANZANA 301\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 61 LOTE 61\",\"no_int\":\"18 A Y 18 B\"},\"email\":\"BRIDIA.TRUJEQUE@UNORETRO.COM\",\"email_comparison\":\"bridia.trujeque@unoretro.com\",\"legacy_id\":\"8175\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SURTIDORA DE FRIOS DE LA PENINSULA\",\"razon_social_comparison\":\"SURTIDORA DE FRIOS DE LA PENINSULA\",\"razon_social_original\":\"SURTIDORA DE FRIOS DE LA PENINSULA\",\"regimen_fiscal\":\"601\",\"rfc\":\"SFP190612IK7\",\"rfc_original\":\"SFP190612IK7\",\"rfc_valid\":true,\"telefono\":\"9982030245\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(109,4,'fc2','clientes','15','8184','clients','104','21d6f1279990de09c5115af605d79a5d102a860c16d7417649f2cd8c0fdd61bc',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"MARISTA@XCARET.COM\",\"domicilio\":{\"calle\":\"CARRETERA CHETUMAL PUERTO JUAREZ\",\"colonia\":\"RANCHO XCARET\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"PREDIO XCARET MZ 12\",\"no_int\":\"TORRE 1 PARQUE XCARE\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8184\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EXPERIENCIAS XCARET CORPORATIVO\",\"razon_social_comparison\":\"EXPERIENCIAS XCARET CORPORATIVO\",\"razon_social_original\":\"EXPERIENCIAS XCARET CORPORATIVO\",\"regimen_fiscal\":\"601\",\"rfc\":\"MUL1102229J0\",\"rfc_original\":\"MUL1102229J0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(110,4,'fc2','clientes','15','8209','clients','105','030a6506e6663ae52ac7a6a619fb03ff91b9931b4b85ae3a545b9e47773b7f64',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77524\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA LOPEZ PORTILLO\",\"colonia\":\"SMZA 64 CANCUN\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 46 LOTE 1\",\"no_int\":\"SN\"},\"email\":\"publicidad@millet.com.mx\",\"email_comparison\":\"publicidad@millet.com.mx\",\"legacy_id\":\"8209\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"M INDUSTRIA\",\"razon_social_comparison\":\"M INDUSTRIA\",\"razon_social_original\":\"M INDUSTRIA\",\"regimen_fiscal\":\"601\",\"rfc\":\"MIN120224147\",\"rfc_original\":\"MIN120224147\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(111,4,'fc2','clientes','15','8210','clients','106','7bd43bc00a47606305d5c15a06d5246ad0c7a48c918c97677e95f19c1b36d818',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97113\",\"contacto\":null,\"domicilio\":{\"calle\":\"20 A\",\"colonia\":\"MONTEBELLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"298\",\"no_int\":null},\"email\":\"maquimexcomercializadora@gmail.com\",\"email_comparison\":\"maquimexcomercializadora@gmail.com\",\"legacy_id\":\"8210\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"COMERCIALIZADORA DE MAQUINARIA INDUSTRIAL MAQUIMEX\",\"razon_social_comparison\":\"COMERCIALIZADORA DE MAQUINARIA INDUSTRIAL MAQUIMEX\",\"razon_social_original\":\"COMERCIALIZADORA DE MAQUINARIA INDUSTRIAL MAQUIMEX\",\"regimen_fiscal\":\"626\",\"rfc\":\"CMI2305097A3\",\"rfc_original\":\"CMI2305097A3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(112,4,'fc2','clientes','15','8221','clients','107','3bea57ea37e0922091a275fb5926c2f068e6397d6ca104980752df53a1fc2a3e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97115\",\"contacto\":null,\"domicilio\":{\"calle\":null,\"colonia\":null,\"estado\":null,\"localidad\":null,\"municipio\":null,\"no_ext\":null,\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8221\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"SWITCH SOLUCIONES DIGITALES\",\"razon_social_comparison\":\"SWITCH SOLUCIONES DIGITALES\",\"razon_social_original\":\"SWITCH SOLUCIONES DIGITALES\",\"regimen_fiscal\":\"601\",\"rfc\":\"SSD201106LI9\",\"rfc_original\":\"SSD201106LI9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(113,4,'fc2','clientes','15','8227','clients','108','e4b63096cf67ea2d0e6fbdbc67b9a921caef0ef8746cc3d5afdf099c3ff1268c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"03900\",\"contacto\":\"Lisseth isla\",\"domicilio\":{\"calle\":\"AV INSURGENTES SUR\",\"colonia\":\"SAN JOSE INSURGENTES\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"BENITO JUAREZ\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"1647\",\"no_int\":null},\"email\":\"lisseth.isla@clubmed.com\",\"email_comparison\":\"lisseth.isla@clubmed.com\",\"legacy_id\":\"8227\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"OPERADORA DE ALDEAS VACACIONALES\",\"razon_social_comparison\":\"OPERADORA DE ALDEAS VACACIONALES\",\"razon_social_original\":\"OPERADORA DE ALDEAS VACACIONALES\",\"regimen_fiscal\":\"601\",\"rfc\":\"OAV730502NZ8\",\"rfc_original\":\"OAV730502NZ8\",\"rfc_valid\":true,\"telefono\":\"9981811461\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(114,4,'fc2','clientes','15','8232','clients','109','44835ee719ec85dbce496affe09a287df94e910314a98f721795e4d97ce4976f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"Luca Marziano\",\"domicilio\":{\"calle\":\"PRIVADA PAPUA\",\"colonia\":null,\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MZN 40 LT 001-011\",\"no_int\":\"VIV 12\"},\"email\":\"luca.marziano84@gmail.com\",\"email_comparison\":\"luca.marziano84@gmail.com\",\"legacy_id\":\"8232\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"VL GESTION CONDOMINAL\",\"razon_social_comparison\":\"VL GESTION CONDOMINAL\",\"razon_social_original\":\"VL GESTION CONDOMINAL\",\"regimen_fiscal\":\"626\",\"rfc\":\"VGC231128HE5\",\"rfc_original\":\"VGC231128HE5\",\"rfc_valid\":true,\"telefono\":\"9841409161\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(115,4,'fc2','clientes','15','8236','clients','110','1b7d6d90d852502ba8be6f87bee21df63f4d30bf14bef8ee3eed5476e142628f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77730\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRETERA FEDERAL 307 CANCUN TULUM\",\"colonia\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KILOMETRO 302 340 LO\",\"no_int\":\"UNIDAD DE PROP EXCLU\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8236\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"OPERADORA HOTELERA ETRO\",\"razon_social_comparison\":\"OPERADORA HOTELERA ETRO\",\"razon_social_original\":\"OPERADORA HOTELERA ETRO\",\"regimen_fiscal\":\"601\",\"rfc\":\"PEN010212DU9\",\"rfc_original\":\"PEN010212DU9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(116,4,'fc2','clientes','15','8241','clients','111','f136b5b8661419428671e13a3b8bd6063a8c236e739eb18df287d36d3bcf9bea',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":\"Daniel Carrillo\",\"domicilio\":{\"calle\":\"Carlos Nader\",\"colonia\":\"Super Manzana 2 Centro\",\"estado\":\"Quintana Roo\",\"localidad\":\"Cancun\",\"municipio\":\"Benito Juarez\",\"no_ext\":\"Mz 1 Lt28\",\"no_int\":null},\"email\":\"daniel.carrillo@delphinus.com.mx\",\"email_comparison\":\"daniel.carrillo@delphinus.com.mx\",\"legacy_id\":\"8241\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"OPERADORA XUNA\",\"razon_social_comparison\":\"OPERADORA XUNA\",\"razon_social_original\":\"OPERADORA XUNA\",\"regimen_fiscal\":\"601\",\"rfc\":\"OXU080111NS1\",\"rfc_original\":\"OXU080111NS1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(117,4,'fc2','clientes','15','8242','clients','112','bb742d7754da6caeae05a5b434d396c87fabdbb168d1ec9e6dd1b4f059c7292c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"ANDREA PURECO\",\"domicilio\":{\"calle\":\"CARRETERA FEDERAL PLAYA - CANCUN A UN COSTADO DE CAPITAN LAFITTE\",\"colonia\":\"EJIDO\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"298\",\"no_int\":null},\"email\":\"ANDREA.PURECO@FAIRMONT.COM\",\"email_comparison\":\"andrea.pureco@fairmont.com\",\"legacy_id\":\"8242\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"OPERADORA HOTELERA DEL CORREDOR MAYAKOBA\",\"razon_social_comparison\":\"OPERADORA HOTELERA DEL CORREDOR MAYAKOBA\",\"razon_social_original\":\"OPERADORA HOTELERA DEL CORREDOR MAYAKOBA\",\"regimen_fiscal\":\"601\",\"rfc\":\"OHC030508CA2\",\"rfc_original\":\"OHC030508CA2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(118,4,'fc2','clientes','15','8255','clients','113','5eb6c735d1f1a735a3d5abb59a8c3de00deb5582d275d89e112de403c15b7214',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"02760\",\"contacto\":\"ALFONSO LOZA\",\"domicilio\":{\"calle\":\"CENTEOTL Y CALLE TOCHTLI ENTRE ACATL\",\"colonia\":\"INDUSTRIAL SAN ANTONIO\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"AZCAPOTZALCO\",\"municipio\":\"AZCAPOTZALCO\",\"no_ext\":\"267 B\",\"no_int\":null},\"email\":\"alfonso.loza@pickup-coffee.com\",\"email_comparison\":\"alfonso.loza@pickup-coffee.com\",\"legacy_id\":\"8255\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"STARBREAKER\",\"razon_social_comparison\":\"STARBREAKER\",\"razon_social_original\":\"STARBREAKER\",\"regimen_fiscal\":\"601\",\"rfc\":\"STA230830MX9\",\"rfc_original\":\"STA230830MX9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(119,4,'fc2','clientes','15','8257','clients','114','c269a523284b0a99e51a19b4236d87bec0bf0c0aa3fdad7a4873a040bfc5fb56',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"66230\",\"contacto\":null,\"domicilio\":{\"calle\":\"IGNACIO MORONES PRIETO\",\"colonia\":\"CENTRO\",\"estado\":\"NUEVO LEON\",\"localidad\":\"SAN PEDRO GARZA GARCIA\",\"municipio\":\"SAN PEDRO GARZA GARCIA\",\"no_ext\":\"791\",\"no_int\":\"8\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8257\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"AULA 24 HORAS\",\"razon_social_comparison\":\"AULA 24 HORAS\",\"razon_social_original\":\"AULA 24 HORAS\",\"regimen_fiscal\":\"601\",\"rfc\":\"AVH0107164T2\",\"rfc_original\":\"AVH0107164T2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(120,4,'fc2','clientes','15','8259','clients','115','b6476954010e10832595676d04678df34d90986e43c4320753d653cb85bf3af2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77569\",\"contacto\":null,\"domicilio\":{\"calle\":\"SUPER MANZANA 41 MZ 01\",\"colonia\":null,\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"LOTE 1 - 01\",\"no_int\":\"SN\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8259\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PROMOTORA RANCHO SAN MIGUEL\",\"razon_social_comparison\":\"PROMOTORA RANCHO SAN MIGUEL\",\"razon_social_original\":\"PROMOTORA RANCHO SAN MIGUEL\",\"regimen_fiscal\":\"601\",\"rfc\":\"PRS050126FW2\",\"rfc_original\":\"PRS050126FW2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(121,4,'fc2','clientes','15','8261','clients','116','8ce5ed3e051bf85e9ada3eba4b6f9e662a9f23e23a8da5da51b9063ef146803f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97070\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 10\",\"colonia\":\"GARCIA GINERES\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"96\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8261\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ARQUIDIOCESIS DE YUCATAN\",\"razon_social_comparison\":\"ARQUIDIOCESIS DE YUCATAN\",\"razon_social_original\":\"ARQUIDIOCESIS DE YUCATAN\",\"regimen_fiscal\":\"603\",\"rfc\":\"AYU930608I73\",\"rfc_original\":\"AYU930608I73\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(122,4,'fc2','clientes','15','8264','clients','117','9861e626cac9e6c348cc2874c05f7a2234d0e45746103c0da7d6c5b42b6f6060',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":\"NAIN\",\"domicilio\":{\"calle\":\"KUKULCAN\",\"colonia\":\"ZONA HOTELERA\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 60 LOTE 5-02\",\"no_int\":\"SECCION D TERCERA ET\"},\"email\":\"boutique.selvatica@etsconsultores.com\",\"email_comparison\":\"boutique.selvatica@etsconsultores.com\",\"legacy_id\":\"8264\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PROYECTOS EJECUTIVOS SUSTENTABLES\",\"razon_social_comparison\":\"PROYECTOS EJECUTIVOS SUSTENTABLES\",\"razon_social_original\":\"PROYECTOS EJECUTIVOS SUSTENTABLES\",\"regimen_fiscal\":\"601\",\"rfc\":\"PES181205470\",\"rfc_original\":\"PES181205470\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(123,4,'fc2','clientes','15','8266','clients','118','6b9873c5750b3389166cb3d7f180ebfa7b956013ba91fda3ee10d0d072dc777d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":null,\"domicilio\":{\"calle\":\"56 POR 30 Y 31 A\",\"colonia\":\"ITZIMNA\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"NO 336J\",\"no_int\":null},\"email\":\"D.HUMANO@TOTALGUSTO.COM\",\"email_comparison\":\"d.humano@totalgusto.com\",\"legacy_id\":\"8266\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"TOTAL GUSTO\",\"razon_social_comparison\":\"TOTAL GUSTO\",\"razon_social_original\":\"TOTAL GUSTO\",\"regimen_fiscal\":\"601\",\"rfc\":\"TGU011113CR6\",\"rfc_original\":\"TGU011113CR6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(124,4,'fc2','clientes','15','8281','clients','119','cac570a69c773764a72a69b412d6e14529298156e627555f484d662321495453',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"BONAMPAK\",\"colonia\":\"SM 4A\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 1 LOTE 4C ED\",\"no_int\":\"LOC 1504\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8281\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"LL MEX\",\"razon_social_comparison\":\"LL MEX\",\"razon_social_original\":\"LL MEX\",\"regimen_fiscal\":\"601\",\"rfc\":\"MOB191114KL6\",\"rfc_original\":\"MOB191114KL6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(125,4,'fc2','clientes','15','8285','clients','120','db16cd1021f03c7dd8dbd115a3dd038acd99d6eba3cc03a45aeb0be1677043f9',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97256\",\"contacto\":\"OHA SOLUCIONES EN INGENIERIA\",\"domicilio\":{\"calle\":\"69\",\"colonia\":\"LIBERTAD\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"649\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8285\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"OHA SOLUCIONES EN INGENIERIA\",\"razon_social_comparison\":\"OHA SOLUCIONES EN INGENIERIA\",\"razon_social_original\":\"OHA SOLUCIONES EN INGENIERIA\",\"regimen_fiscal\":\"601\",\"rfc\":\"OSI180904QB3\",\"rfc_original\":\"OSI180904QB3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(126,4,'fc2','clientes','15','8286','clients','121','abcf6402f0ed962bed455c95c9c1166f394e133e4dda71d9c920095eaa859801',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"44380\",\"contacto\":\"Alina Orozco Marquez\",\"domicilio\":{\"calle\":\"CALLE SAN PEDRO\",\"colonia\":\"SAN MARTIN\",\"estado\":null,\"localidad\":null,\"municipio\":\"GUADALAJARA\",\"no_ext\":\"1421\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8286\",\"observaciones\":null,\"pais\":\"México\",\"razon_social\":\"ALINA OROZCO MARQUEZ\",\"razon_social_comparison\":\"ALINA OROZCO MARQUEZ\",\"razon_social_original\":\"ALINA OROZCO MARQUEZ\",\"regimen_fiscal\":\"612\",\"rfc\":\"OOMA860315A49\",\"rfc_original\":\"OOMA860315A49\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(127,4,'fc2','clientes','15','8290','clients','122','cfb3f8b1c3c529ddb01884ff948da9b32366dbf5e91ccc769b9425c3b3a1ac3c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97246\",\"contacto\":\"German Augusto Marin Uc\",\"domicilio\":{\"calle\":\"20\",\"colonia\":\"Fraccionamiento Mulsay\",\"estado\":null,\"localidad\":null,\"municipio\":\"Merida\",\"no_ext\":\"323\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8290\",\"observaciones\":null,\"pais\":\"Mexico\",\"razon_social\":\"GERMAN AUGUSTO MARIN UC\",\"razon_social_comparison\":\"GERMAN AUGUSTO MARIN UC\",\"razon_social_original\":\"GERMAN AUGUSTO MARIN UC\",\"regimen_fiscal\":\"626\",\"rfc\":\"MAUG731023JH8\",\"rfc_original\":\"MAUG731023JH8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(128,4,'fc2','clientes','15','8292','clients','123','5174bcc8e70cc230435e31d2b4c8657e3fcac7ad7bb172f3b009b1f0eea99a63',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97113\",\"contacto\":\"YUCATAN SEAS\",\"domicilio\":{\"calle\":\"VIALIDAD 14 ENTRE CALLE 13 Y 15\",\"colonia\":\"MONTEBELLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"290\",\"no_int\":\"121\"},\"email\":\"facturas@yucatanseas.com\",\"email_comparison\":\"facturas@yucatanseas.com\",\"legacy_id\":\"8292\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"YUCATAN SEAS\",\"razon_social_comparison\":\"YUCATAN SEAS\",\"razon_social_original\":\"YUCATAN SEAS\",\"regimen_fiscal\":\"626\",\"rfc\":\"YSE210430F8A\",\"rfc_original\":\"YSE210430F8A\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(129,4,'fc2','clientes','15','8294','clients','124','7bf0390e1287cbfc8d14171d30706278f70c2f38523770517e219f6dea662042',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97115\",\"contacto\":\"RICARDOMIMENZA ARCE\",\"domicilio\":{\"calle\":\"63\",\"colonia\":\"AME\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"97\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8294\",\"observaciones\":null,\"pais\":\"MÈXICO\",\"razon_social\":\"RICARDO MIMENZA ARCE\",\"razon_social_comparison\":\"RICARDO MIMENZA ARCE\",\"razon_social_original\":\"RICARDO MIMENZA ARCE\",\"regimen_fiscal\":\"612\",\"rfc\":\"MIAR000721EP3\",\"rfc_original\":\"MIAR000721EP3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(130,4,'fc2','clientes','15','8296','clients','125','074cc34a07094556f824bd9464a51e587e3065cf62b62b67ca0f2dbf4181891a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":\"PERFORMANCE BOATS USA LLC\",\"domicilio\":{\"calle\":\"1441 Brickell avenue\",\"colonia\":null,\"estado\":\"Estados unidos de america\",\"localidad\":\"Florida\",\"municipio\":\"Miami\",\"no_ext\":\"Suite 1400\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8296\",\"observaciones\":null,\"pais\":\"Estados unidos de america\",\"razon_social\":\"PERFORMANCE BOATS USA LLC\",\"razon_social_comparison\":\"PERFORMANCE BOATS USA LLC\",\"razon_social_original\":\"PERFORMANCE BOATS USA LLC\",\"regimen_fiscal\":\"616\",\"rfc\":\"XEXX010101000\",\"rfc_original\":\"XEXX010101000\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(131,4,'fc2','clientes','15','8297','clients','126','3733a965328a7416bdedf0334d20c8d962fbe8742502ba8d5494fd323c764777',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97113\",\"contacto\":\"KEM SPORTS\",\"domicilio\":{\"calle\":\"16\",\"colonia\":\"MONTEBELLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"402 A\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8297\",\"observaciones\":null,\"pais\":\"MÉXICO\",\"razon_social\":\"KEM SPORTS\",\"razon_social_comparison\":\"KEM SPORTS\",\"razon_social_original\":\"KEM SPORTS\",\"regimen_fiscal\":\"601\",\"rfc\":\"KSP210209RS2\",\"rfc_original\":\"KSP210209RS2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(132,4,'fc2','clientes','15','8298','clients','127','624d93c0b8572ba693005d8abf22c41f4c8b908b5ede20d0aeaa2494ec3e8291',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77508\",\"contacto\":\"LUKAT\",\"domicilio\":{\"calle\":\"AVENIDA KABAH\",\"colonia\":\"SM 31\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 6 LOTE 25\",\"no_int\":\"LETRA D\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8298\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PROVEEDORA Y CONSTRUCTORA MEXICANA\",\"razon_social_comparison\":\"PROVEEDORA Y CONSTRUCTORA MEXICANA\",\"razon_social_original\":\"PROVEEDORA Y CONSTRUCTORA MEXICANA\",\"regimen_fiscal\":\"601\",\"rfc\":\"PCM960301681\",\"rfc_original\":\"PCM960301681\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(133,4,'fc2','clientes','15','8303','clients','128','76ea18a3df86c15ebe0e19a2ad161930f18cb44618c80def46af937fe42bb06c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"85506\",\"contacto\":null,\"domicilio\":{\"calle\":\"HUGO DELGADO LOMELI\",\"colonia\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"estado\":\"SONORA\",\"localidad\":\"SAN CARLOS (SAN CARLOS NUEVO GUAYMAS)\",\"municipio\":\"GUAYMAS\",\"no_ext\":\"SN\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8303\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"COMERCIALIZADORA STERN\",\"razon_social_comparison\":\"COMERCIALIZADORA STERN\",\"razon_social_original\":\"COMERCIALIZADORA STERN\",\"regimen_fiscal\":\"601\",\"rfc\":\"CST0806167Z8\",\"rfc_original\":\"CST0806167Z8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(134,4,'fc2','clientes','15','8312','clients','129','3269b5320a20ebb48b41daef5320bdd13abe6a913757b7cabadf71b9ebd719df',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"14018\",\"contacto\":\"VA CATAMARANES\",\"domicilio\":{\"calle\":\"AV.  PERIFERICO SUR\",\"colonia\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"OTRA NO ESPECIFICADA EN EL CATALOGO\",\"municipio\":\"TLALPAN\",\"no_ext\":\"4421\",\"no_int\":\"402\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8312\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"VA CATAMARANES\",\"razon_social_comparison\":\"VA CATAMARANES\",\"razon_social_original\":\"VA CATAMARANES\",\"regimen_fiscal\":\"601\",\"rfc\":\"VCA171116HMA\",\"rfc_original\":\"VCA171116HMA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(135,4,'fc2','clientes','15','8313','clients','130','f75942aec6e7dc20d7962dd5bd48627a2c78515ec603b0597a622db0a828636a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97700\",\"contacto\":\"JERICO NAVARRO PAREDES\",\"domicilio\":{\"calle\":\"49\",\"colonia\":\"CENTRO\",\"estado\":\"YUCATAN\",\"localidad\":\"TIZIMIN\",\"municipio\":\"TIZIMIN\",\"no_ext\":\"321-A\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8313\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"JERICO NAVARRO PAREDES\",\"razon_social_comparison\":\"JERICO NAVARRO PAREDES\",\"razon_social_original\":\"JERICO NAVARRO PAREDES\",\"regimen_fiscal\":\"626\",\"rfc\":\"NAPJ930117PG6\",\"rfc_original\":\"NAPJ930117PG6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(136,4,'fc2','clientes','15','8315','clients','131','3dc0447d08b5abf669778d0f68ed4eaf54573d3fb1839fb9cd97dc3178186b58',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"44670\",\"contacto\":null,\"domicilio\":{\"calle\":\"JAUN PALOMAR Y ARIAS\",\"colonia\":\"MONRAZ\",\"estado\":\"JALISCO\",\"localidad\":\"GUADALAJARA\",\"municipio\":\"GUADALAJARA\",\"no_ext\":\"567\",\"no_int\":\"57\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8315\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"LA MEDITERRANEA PREMIUM SPIRITS\",\"razon_social_comparison\":\"LA MEDITERRANEA PREMIUM SPIRITS\",\"razon_social_original\":\"LA MEDITERRANEA PREMIUM SPIRITS\",\"regimen_fiscal\":\"601\",\"rfc\":\"MPS210324TY0\",\"rfc_original\":\"MPS210324TY0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(137,4,'fc2','clientes','15','8318','clients','132','686e1324257028f52e0c195a7da465896ab9def0509c49f91c87339cb8cb2b3b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77504\",\"contacto\":null,\"domicilio\":{\"calle\":\"ACANCEH\",\"colonia\":\"SUPERMANZANA 11\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 2 LOTE 3\",\"no_int\":\"PISO 3 3B\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8318\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MOTORTECH\",\"razon_social_comparison\":\"MOTORTECH\",\"razon_social_original\":\"MOTORTECH\",\"regimen_fiscal\":\"626\",\"rfc\":\"MOT210924UWA\",\"rfc_original\":\"MOT210924UWA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(138,4,'fc2','clientes','15','8327','clients','133','53805dbf0f8579e22711e1c93e8c400d5c8b06fa8086dc920e6d0ad8beec2871',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97116\",\"contacto\":null,\"domicilio\":{\"calle\":\"49\",\"colonia\":\"SAN ANTONIO CUCUL\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"230\",\"no_int\":\"208\"},\"email\":\"pcastillo.solm@gmail.com\",\"email_comparison\":\"pcastillo.solm@gmail.com\",\"legacy_id\":\"8327\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"JULIO CESAR MARIN GALERA\",\"razon_social_comparison\":\"JULIO CESAR MARIN GALERA\",\"razon_social_original\":\"JULIO CESAR MARIN GALERA\",\"regimen_fiscal\":\"626\",\"rfc\":\"MAGJ561127ET5\",\"rfc_original\":\"MAGJ561127ET5\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(139,4,'fc2','clientes','15','8337','clients','134','07770498acd06185dfa46dc6eb4dc1892655079bb9a4c4752fab7c1a64184494',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77535\",\"contacto\":null,\"domicilio\":{\"calle\":\"PUERTO VALLARTA\",\"colonia\":\"SUPERMANZANA 528\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"21\",\"no_int\":\"M 8 L 1\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8337\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"GCS GRUPOS E INCENTIVOS\",\"razon_social_comparison\":\"GCS GRUPOS E INCENTIVOS\",\"razon_social_original\":\"GCS GRUPOS E INCENTIVOS\",\"regimen_fiscal\":\"601\",\"rfc\":\"GGI160805HQ6\",\"rfc_original\":\"GGI160805HQ6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(140,4,'fc2','clientes','15','8345','clients','135','f445e74307b21ba9a310901ac03283e962fcb6b6b8ff991aa8ff9f3611326d40',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":\"ANDREA IVONNE OJEDA LIZAMA\",\"domicilio\":{\"calle\":\"17\",\"colonia\":\"MONTECARLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"286\",\"no_int\":\"LOCAL 1\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8345\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ANDREA IVONNE OJEDA LIZAMA\",\"razon_social_comparison\":\"ANDREA IVONNE OJEDA LIZAMA\",\"razon_social_original\":\"ANDREA IVONNE OJEDA LIZAMA\",\"regimen_fiscal\":\"621\",\"rfc\":\"OELA9208172S1\",\"rfc_original\":\"OELA9208172S1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(141,4,'fc2','clientes','15','8346','clients','136','1bd8ed35d9bee6c13653c1a3fa4e4439ab8e43518b7b317bced90c175c27ec1e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97113\",\"contacto\":\"EOXMID\",\"domicilio\":{\"calle\":\"32\",\"colonia\":\"MONTEBELLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"298\",\"no_int\":\"PISO 3\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8346\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EOXMID\",\"razon_social_comparison\":\"EOXMID\",\"razon_social_original\":\"EOXMID\",\"regimen_fiscal\":\"603\",\"rfc\":\"EOX240722CA0\",\"rfc_original\":\"EOX240722CA0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(142,4,'fc2','clientes','15','8355','clients','137','4eec685bc3f17e30dfc188b769681dc19af42a6f2c58747bf93fe3be4a117b52',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"06700\",\"contacto\":null,\"domicilio\":{\"calle\":\"COLIMA\",\"colonia\":\"ROMA NORTE\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"CUAUHTEMOC\",\"municipio\":\"CUAUHTEMOC\",\"no_ext\":\"23\",\"no_int\":\"LOCAL B\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8355\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"OPERADORA DE FRANQUICIAS MALABARES\",\"razon_social_comparison\":\"OPERADORA DE FRANQUICIAS MALABARES\",\"razon_social_original\":\"OPERADORA DE FRANQUICIAS MALABARES\",\"regimen_fiscal\":\"601\",\"rfc\":\"OFM060920RJ8\",\"rfc_original\":\"OFM060920RJ8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(143,4,'fc2','clientes','15','8371','clients','138','894efd034e16573399fd486fd8283f2b055dff3d55c8a954bab175261f993269',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"BLVD KUKULKAN KM 4.5\",\"colonia\":\"ZONA HOTELERA\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"KM 4.5\",\"no_int\":\"D7 ZONA TURISTICA 1A\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8371\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EXPERIENCIAS XCARET NAVIERA\",\"razon_social_comparison\":\"EXPERIENCIAS XCARET NAVIERA\",\"razon_social_original\":\"EXPERIENCIAS XCARET NAVIERA\",\"regimen_fiscal\":\"601\",\"rfc\":\"NCM210618RE0\",\"rfc_original\":\"NCM210618RE0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(144,4,'fc2','clientes','15','8387','clients','139','7d5cdf258246bc7fd66601562efbfdfe7b75e95e50fa1b2d7dcc1dfbacdcc897',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77580\",\"contacto\":\"ROCIO\",\"domicilio\":{\"calle\":\"CARRETERA FEDERAL CANCUN A PUERTO MORELOS KM 27.5\",\"colonia\":\"PUERTO MORELOS\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PUERTO MORELOS\",\"municipio\":\"PUERTO MORELOS\",\"no_ext\":\"SM 32 MZ 01 L 1-11 C\",\"no_int\":\"LOC 20\"},\"email\":\"accounting@ishoppinggifts.com\",\"email_comparison\":\"accounting@ishoppinggifts.com\",\"legacy_id\":\"8387\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"TESORO VIVO\",\"razon_social_comparison\":\"TESORO VIVO\",\"razon_social_original\":\"TESORO VIVO\",\"regimen_fiscal\":\"601\",\"rfc\":\"TVI190618F79\",\"rfc_original\":\"TVI190618F79\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(145,4,'fc2','clientes','15','8388','clients','140','9d6d00bf0745821f4617a4ece96cdbc2e40579af178dc5d6d28e3128a0c3ccb2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"11860\",\"contacto\":\"Mercy\",\"domicilio\":{\"calle\":\"MARINA\",\"colonia\":\"OBSERVATORIO\",\"estado\":\"CIUDAD DE MEXICO\",\"localidad\":\"MIGUEL HIDALGO\",\"municipio\":\"MIGUEL HIDALGO\",\"no_ext\":\"34\",\"no_int\":null},\"email\":\"cxp@protectogard.com.mx\",\"email_comparison\":\"cxp@protectogard.com.mx\",\"legacy_id\":\"8388\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PROTECTOGARD\",\"razon_social_comparison\":\"PROTECTOGARD\",\"razon_social_original\":\"PROTECTOGARD\",\"regimen_fiscal\":\"601\",\"rfc\":\"PRO090819GQ3\",\"rfc_original\":\"PRO090819GQ3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(146,4,'fc2','clientes','15','8418','clients','141','695d28402aaca989af21d0923ccb10fee784086e95f7d5e760c9c340d5b1591f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":\"Fernando Barajas\",\"domicilio\":{\"calle\":\"BLVD KUKULCAN KM 3.5\",\"colonia\":\"ZONA HOTELERA\",\"estado\":null,\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"CAMINO AL HOTEL VERA\",\"no_int\":\"CAMINO AL HOTEL OCEA\"},\"email\":\"logoshop@original-group.com\",\"email_comparison\":\"logoshop@original-group.com\",\"legacy_id\":\"8418\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"FUNDACION ORIGINAL\",\"razon_social_comparison\":\"FUNDACION ORIGINAL\",\"razon_social_original\":\"FUNDACION ORIGINAL\",\"regimen_fiscal\":\"603\",\"rfc\":\"FOR100930BF7\",\"rfc_original\":\"FOR100930BF7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(147,4,'fc2','clientes','15','8421','clients','142','4e84ac47ee1f13c308f08870190b2c65430a55fa7edec02220ab6ca73a6656c0',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARR FEDERAL CHETUMAL PTO. JUAREZ\",\"colonia\":\"EJIDO PLAYA DEL CARMEN\",\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KM 298\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8421\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"GOLF DE MAYAKOBA\",\"razon_social_comparison\":\"GOLF DE MAYAKOBA\",\"razon_social_original\":\"GOLF DE MAYAKOBA\",\"regimen_fiscal\":\"601\",\"rfc\":\"GMA040326F27\",\"rfc_original\":\"GMA040326F27\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(148,4,'fc2','clientes','15','8422','clients','143','41404346bedb35ba8968bcddfadfddb5750ed4010fac88220223e67e4fb60cb2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA BONAMPAK ENTRE AVENIDA COBA\",\"colonia\":\"SUPERMANZANA 3 CENTRO\",\"estado\":\"Q,ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 9 LOTE 17 01\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8422\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PROMOTORA HOTELERA ORIGINAL\",\"razon_social_comparison\":\"PROMOTORA HOTELERA ORIGINAL\",\"razon_social_original\":\"PROMOTORA HOTELERA ORIGINAL\",\"regimen_fiscal\":\"601\",\"rfc\":\"HBP031220MQ4\",\"rfc_original\":\"HBP031220MQ4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(149,4,'fc2','clientes','15','8423','clients','144','317ac19125d661add7fd5e0138b213dd1cabec0e7e43027e41d5a6cb6c01a14e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA BONAMPAK ENTRE AVENIDA COBA\",\"colonia\":\"SUPERMANZANA 3 CENTRO\",\"estado\":\"Q,ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 9 LOTE 17 01\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8423\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PH ORIGINAL\",\"razon_social_comparison\":\"PH ORIGINAL\",\"razon_social_original\":\"PH ORIGINAL\",\"regimen_fiscal\":\"601\",\"rfc\":\"POR2209074V0\",\"rfc_original\":\"POR2209074V0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(150,4,'fc2','clientes','15','8424','clients','145','4e7a9deab0a714800d97b2b39dd8d8bdf8e4cb156eb142c030d5805b2216ac00',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77500\",\"contacto\":null,\"domicilio\":{\"calle\":\"AVENIDA BONAMPAK ENTRE AVENIDA COBA\",\"colonia\":\"SUPERMANZANA 3 CENTRO\",\"estado\":\"Q,ROO\",\"localidad\":\"CANCUN\",\"municipio\":\"BENITO JUAREZ\",\"no_ext\":\"MANZANA 9 LOTE 17 01\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8424\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"OGV CLUB\",\"razon_social_comparison\":\"OGV CLUB\",\"razon_social_original\":\"OGV CLUB\",\"regimen_fiscal\":\"601\",\"rfc\":\"OCL220907748\",\"rfc_original\":\"OCL220907748\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(151,4,'fc2','clientes','15','8427','clients','146','abff12a1c5df75796a2f2d8f716a236ae3eba3517dc2454e49ea15fe554f020b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"34138\",\"contacto\":null,\"domicilio\":{\"calle\":\"BLVD. BELISARIO DOMINGUEZ ENTRE CALLE PRIMO DE VERDAD\",\"colonia\":\"HERNANDEZ\",\"estado\":null,\"localidad\":\"VICTORIA DE DURANGO\",\"municipio\":\"DURANGO\",\"no_ext\":\"602 B\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8427\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"HIX ADVENTURE\",\"razon_social_comparison\":\"HIX ADVENTURE\",\"razon_social_original\":\"HIX ADVENTURE\",\"regimen_fiscal\":\"601\",\"rfc\":\"HAD190206KX7\",\"rfc_original\":\"HAD190206KX7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(152,4,'fc2','clientes','15','8433','clients','147','6f675f72641f20f6304e85d93dc3aff315cc87bda9def73a1ec33400d00681f5',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77600\",\"contacto\":null,\"domicilio\":{\"calle\":\"7 SUR\",\"colonia\":\"CENTRO\",\"estado\":null,\"localidad\":\"COZUMEL\",\"municipio\":\"COZUMEL\",\"no_ext\":\"EXT 5\",\"no_int\":\"DEPTO B\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8433\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"EXPLORA CARIBE TOURS\",\"razon_social_comparison\":\"EXPLORA CARIBE TOURS\",\"razon_social_original\":\"EXPLORA CARIBE TOURS\",\"regimen_fiscal\":\"601\",\"rfc\":\"ECT060203GB9\",\"rfc_original\":\"ECT060203GB9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(153,4,'fc2','clientes','15','8439','clients','148','edcf6395809f5f15b96520ce92e26826ae169d643d3a0b2b4f055d3cc42d3e01',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"23405\",\"contacto\":null,\"domicilio\":{\"calle\":\"KM 19.5 CARRETERA TRANSPENINSULAR\",\"colonia\":\"SAN JOSE DEL CABO\",\"estado\":\"BAJA CALIFORNIA SUR\",\"localidad\":null,\"municipio\":\"LOS CABOS\",\"no_ext\":null,\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8439\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"PARAISO LOS CABOS\",\"razon_social_comparison\":\"PARAISO LOS CABOS\",\"razon_social_original\":\"PARAISO LOS CABOS\",\"regimen_fiscal\":\"601\",\"rfc\":\"PCA9601303TA\",\"rfc_original\":\"PCA9601303TA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(154,4,'fc2','clientes','15','8451','clients','149','6275adb5700e4a145c490be0a8fb6d2895f8c330e2d34b72f1446d7f21bab4e4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97113\",\"contacto\":\"JUAN JESUS VALLADARES CANO\",\"domicilio\":{\"calle\":\"ANDRES GARCIA LAVIN CALLE 32\",\"colonia\":\"MONTEBELLO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"298\",\"no_int\":\"PISO 11\"},\"email\":\"jvalladares@thepalacecompany.com\",\"email_comparison\":\"jvalladares@thepalacecompany.com\",\"legacy_id\":\"8451\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"ALMACENES PALACE RESORTS\",\"razon_social_comparison\":\"ALMACENES PALACE RESORTS\",\"razon_social_original\":\"ALMACENES PALACE RESORTS\",\"regimen_fiscal\":\"601\",\"rfc\":\"APR180808CP0\",\"rfc_original\":\"APR180808CP0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(155,4,'fc2','clientes','15','8452','clients','150','96770ad2942a0f2a3ff639b27ad841702a2f69027423050c5d2f09a274ea561a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"11590\",\"contacto\":\"JUAN JESUS VALLADARES CANO\",\"domicilio\":{\"calle\":\"TOLSTOI Y VICTOR HUGO\",\"colonia\":\"ANZURES\",\"estado\":\"CUIDAD DE MEXICO\",\"localidad\":null,\"municipio\":\"MIGUEL HIDALGO\",\"no_ext\":\"10\",\"no_int\":null},\"email\":\"jvalladares@thepalacecompany.com\",\"email_comparison\":\"jvalladares@thepalacecompany.com\",\"legacy_id\":\"8452\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"HOTELERA PALACE RESORTS\",\"razon_social_comparison\":\"HOTELERA PALACE RESORTS\",\"razon_social_original\":\"HOTELERA PALACE RESORTS\",\"regimen_fiscal\":\"601\",\"rfc\":\"PIN131210PG9\",\"rfc_original\":\"PIN131210PG9\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(156,4,'fc2','clientes','15','8459','clients','151','82e31bc0b105af736f561a543f6a9e72eeb75ae78ef447d0bf885c3768495625',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77664\",\"contacto\":null,\"domicilio\":{\"calle\":\"15 SUR ENTRE 13 SUR\",\"colonia\":null,\"estado\":\"QUINTANA ROO\",\"localidad\":\"COZUMEL\",\"municipio\":\"COZUMEL\",\"no_ext\":\"940\",\"no_int\":\"LOCAL 2\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8459\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SCUBABLU COZUMEL\",\"razon_social_comparison\":\"SCUBABLU COZUMEL\",\"razon_social_original\":\"SCUBABLU COZUMEL\",\"regimen_fiscal\":\"601\",\"rfc\":\"SCO201209GN8\",\"rfc_original\":\"SCO201209GN8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(157,4,'fc2','clientes','15','8460','clients','152','f89a9d5cafb41d12977c41b67a5d47b7606ae505843174e704eac35fbbdb4c01',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"01030\",\"contacto\":\"GILBERTO ACOSTA MALAGON\",\"domicilio\":{\"calle\":\"INSURGENTES SUR\",\"colonia\":\"FLORIDA\",\"estado\":\"CUIDAD DE MEXICO\",\"localidad\":\"ALVARO OBREGON\",\"municipio\":\"ALVARO OBREGON\",\"no_ext\":\"1814\",\"no_int\":\"601\"},\"email\":\"gilberto.acosta@actnow.mx\",\"email_comparison\":\"gilberto.acosta@actnow.mx\",\"legacy_id\":\"8460\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"PROMOCIONES AMERICA LATINA\",\"razon_social_comparison\":\"PROMOCIONES AMERICA LATINA\",\"razon_social_original\":\"PROMOCIONES AMERICA LATINA\",\"regimen_fiscal\":\"601\",\"rfc\":\"PAL030731427\",\"rfc_original\":\"PAL030731427\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(158,4,'fc2','clientes','15','8467','clients','153','8129d8697a01961257ab746801d9bac27da42e8fa15cd46115f8f62bfeecbcf6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"125 AV NORTE U.P.E. 003 MZ 4 FRACC LA GRAN PLAZA DE LA RIVIERA II\",\"colonia\":null,\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"LT 3\",\"no_int\":\"OFNA ADMTVA \\\"A\\\"\"},\"email\":\"admonvalleaurora@gmail.com\",\"email_comparison\":\"admonvalleaurora@gmail.com\",\"legacy_id\":\"8467\",\"observaciones\":null,\"pais\":null,\"razon_social\":\"ADMINISTRADORA DE CONDOMINIOS VALLE AURORA TORRE 1\",\"razon_social_comparison\":\"ADMINISTRADORA DE CONDOMINIOS VALLE AURORA TORRE 1\",\"razon_social_original\":\"ADMINISTRADORA DE CONDOMINIOS VALLE AURORA TORRE 1\",\"regimen_fiscal\":\"603\",\"rfc\":\"ACV211210I41\",\"rfc_original\":\"ACV211210I41\",\"rfc_valid\":true,\"telefono\":\"9981168226\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(159,4,'fc2','clientes','15','8474','clients','154','642a3027eb3b6d3caa309805eee36eeefdd73d1a63258bb18f3377927888e932',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77600\",\"contacto\":null,\"domicilio\":{\"calle\":\"RAFAEL E MELGAR ENTRE HOTEL CASA DEL MAR\",\"colonia\":\"ZONA HOTELERA SUR COZUMEL\",\"estado\":\"QUINTANANA ROO\",\"localidad\":\"COZUMEL\",\"municipio\":\"COZUMEL\",\"no_ext\":\"KM 4 02\",\"no_int\":\"S/N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8474\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"ALFREDO ALEJANDRO MORALES HERRERA\",\"razon_social_comparison\":\"ALFREDO ALEJANDRO MORALES HERRERA\",\"razon_social_original\":\"ALFREDO ALEJANDRO MORALES HERRERA\",\"regimen_fiscal\":\"612\",\"rfc\":\"MOHA750529DF1\",\"rfc_original\":\"MOHA750529DF1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(160,4,'fc2','clientes','15','8478','clients','155','204a7ebcc674daf6ca51056da3faae096ff6eacd53dbfd6d78c838d3ac916681',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97320\",\"contacto\":\"DIEGO VALES BOLIO\",\"domicilio\":{\"calle\":\"S/N\",\"colonia\":\"YUCALPETEN\",\"estado\":\"YUCATAN\",\"localidad\":\"PROGRESO\",\"municipio\":\"PROGRESO\",\"no_ext\":\"TABLAJE CATASTRAL 62\",\"no_int\":\"S/N\"},\"email\":\"Diego@marinasilcer.com\",\"email_comparison\":\"diego@marinasilcer.com\",\"legacy_id\":\"8478\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"MARINA SILCER\",\"razon_social_comparison\":\"MARINA SILCER\",\"razon_social_original\":\"MARINA SILCER\",\"regimen_fiscal\":\"601\",\"rfc\":\"MSI0906164TA\",\"rfc_original\":\"MSI0906164TA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(161,4,'fc2','clientes','15','8483','clients','156','4c2327adc742ced853939a1100ddc7319ef003c1858de1b61bfb0a79b7c0f92e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97305\",\"contacto\":\"Maria Jimena\",\"domicilio\":{\"calle\":\"24 ENTRE 7B\",\"colonia\":\"SANTA GERTUDRIS COPO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"291\",\"no_int\":\"S/N\"},\"email\":\"jimena@nauticossureste.com\",\"email_comparison\":\"jimena@nauticossureste.com\",\"legacy_id\":\"8483\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"SERVICIOS Y PROMOCIONES NAUTICAS DEL SURESTE\",\"razon_social_comparison\":\"SERVICIOS Y PROMOCIONES NAUTICAS DEL SURESTE\",\"razon_social_original\":\"SERVICIOS Y PROMOCIONES NAUTICAS DEL SURESTE\",\"regimen_fiscal\":\"601\",\"rfc\":\"SPN221205P86\",\"rfc_original\":\"SPN221205P86\",\"rfc_valid\":true,\"telefono\":\"9993680002\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(162,4,'fc2','clientes','15','8484','clients','157','73af8fac1bd4f3480dcf3fae05902e96e6e4ce858b989ab80860ac2a1fe18cfd',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CAMINO DE ACCESO PARQUE XENSES ENTRE CAMINO ACCESO AL PARQUE XCARET\",\"colonia\":\"RANCHO XCARET\",\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KILÃ“METRO 282\",\"no_int\":\"INTERIOR B\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8484\",\"observaciones\":null,\"pais\":\"MEXICO\",\"razon_social\":\"EXPERIENCIAS XCARET LOYALTY\",\"razon_social_comparison\":\"EXPERIENCIAS XCARET LOYALTY\",\"razon_social_original\":\"EXPERIENCIAS XCARET LOYALTY\",\"regimen_fiscal\":\"601\",\"rfc\":\"EXL1705186P6\",\"rfc_original\":\"EXL1705186P6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(163,4,'fc2','clientes','15','8493','clients','158','3186c59c857c0b799d12b94179f442a8d45784ac11f4c3784b7e5063d745c5e3',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97305\",\"contacto\":\"Fernando\",\"domicilio\":{\"calle\":\"11\",\"colonia\":\"SANTA GERTUDRIS COPO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"N° 344\",\"no_int\":\"S/N\"},\"email\":\"Fsanchez@grupog.com.mx\",\"email_comparison\":\"fsanchez@grupog.com.mx\",\"legacy_id\":\"8493\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"SOLUCIONES NAUTICAS\",\"razon_social_comparison\":\"SOLUCIONES NAUTICAS\",\"razon_social_original\":\"SOLUCIONES NAUTICAS\",\"regimen_fiscal\":\"601\",\"rfc\":\"SNA100424V72\",\"rfc_original\":\"SNA100424V72\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(164,4,'fc2','clientes','15','8496','clients','159','bbff7700f223fc6e0fe14dedc1def2e0009de1cd1dadd39b7a7ea2cc5bacfa24',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"02970\",\"contacto\":null,\"domicilio\":{\"calle\":\"JARDIN\",\"colonia\":\"AMPLIACION DEL GAS\",\"estado\":null,\"localidad\":\"AZCAPOTZALCO\",\"municipio\":\"AZCAPOTZALCO\",\"no_ext\":\"257\",\"no_int\":\"TORRE 5 DEPTO 1205\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8496\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"ISAAC ANZURES TORRES\",\"razon_social_comparison\":\"ISAAC ANZURES TORRES\",\"razon_social_original\":\"ISAAC ANZURES TORRES\",\"regimen_fiscal\":\"612\",\"rfc\":\"AUTI030620V18\",\"rfc_original\":\"AUTI030620V18\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(165,4,'fc2','clientes','15','8499','clients','160','2e50ad2620984f19bbf19af1689445a3d8cf083b74cf9f1c1fa6ed92bc0b6326',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97305\",\"contacto\":\"PAMELA\",\"domicilio\":{\"calle\":\"CALLE 12-A\",\"colonia\":\"SANTA GERTUDRIS COPO\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"310\",\"no_int\":\"LOCAL A4, PISO 7\"},\"email\":\"jefatura.mkt@therealestatehub.mx\",\"email_comparison\":\"jefatura.mkt@therealestatehub.mx\",\"legacy_id\":\"8499\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"EDIFICACIONES Y CONSTRUCCIONES RCUATRO\",\"razon_social_comparison\":\"EDIFICACIONES Y CONSTRUCCIONES RCUATRO\",\"razon_social_original\":\"EDIFICACIONES Y CONSTRUCCIONES RCUATRO\",\"regimen_fiscal\":\"601\",\"rfc\":\"ECR120910SL2\",\"rfc_original\":\"ECR120910SL2\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(166,4,'fc2','clientes','15','8500','clients','161','39a181983c02a5ec9edd712717f4872ee78b6b025db6e621219b17b951df760a',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"64640\",\"contacto\":null,\"domicilio\":{\"calle\":\"SAN JERONIMO\",\"colonia\":\"SAN JERONIMO\",\"estado\":\"NUEVO LEON\",\"localidad\":\"MONTERREY\",\"municipio\":\"MONTERREY\",\"no_ext\":\"310\",\"no_int\":\"PISO 12\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8500\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"MARITIMOS DE FRANCIA AG\",\"razon_social_comparison\":\"MARITIMOS DE FRANCIA AG\",\"razon_social_original\":\"MARITIMOS DE FRANCIA AG\",\"regimen_fiscal\":\"601\",\"rfc\":\"MFA220308FJ0\",\"rfc_original\":\"MFA220308FJ0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(167,4,'fc2','clientes','15','8502','clients','162','aa50f39022354aba023de0ecaaf262fdb3f327e4afa113cdb97840308c664149',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97302\",\"contacto\":null,\"domicilio\":{\"calle\":\"55 A ENTRE CALLE 120\",\"colonia\":\"LAS AMERICAS II\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"987\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8502\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"ANA KARINA DOMINGUEZ DE LOS SANTOS\",\"razon_social_comparison\":\"ANA KARINA DOMINGUEZ DE LOS SANTOS\",\"razon_social_original\":\"ANA KARINA DOMINGUEZ DE LOS SANTOS\",\"regimen_fiscal\":\"612\",\"rfc\":\"DOSA8906034D4\",\"rfc_original\":\"DOSA8906034D4\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(168,4,'fc2','clientes','15','8505','clients','163','99bdaaa68c3675a3d54f3b2d23ae75a1d9bb99e84276a7bf0ab37c72ddef767d',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"Nohemi Delgado\",\"domicilio\":{\"calle\":\"CARRETERA FEDERAL CHETUMAL -PUERTO JUAREZ KM 299+500\",\"colonia\":null,\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MZA 10 LTE 01\",\"no_int\":\"BODEGA 4\"},\"email\":\"nohemi.delgado@bonassi.io\",\"email_comparison\":\"nohemi.delgado@bonassi.io\",\"legacy_id\":\"8505\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"PUNTO SUB\",\"razon_social_comparison\":\"PUNTO SUB\",\"razon_social_original\":\"PUNTO SUB\",\"regimen_fiscal\":\"601\",\"rfc\":\"PSU091130I16\",\"rfc_original\":\"PSU091130I16\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(169,4,'fc2','clientes','15','8506','clients','164','5256e2cfe335469f2a25091b793d11d8be067eb6e07c7fb5f70a0b1131a74d4e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"TAXISTAS\",\"colonia\":\"EJIDO SUR\",\"estado\":\"QUINTANA ROO\",\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"LOTE 1\",\"no_int\":\"S/N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8506\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"XEDIS QROO\",\"razon_social_comparison\":\"XEDIS QROO\",\"razon_social_original\":\"XEDIS QROO\",\"regimen_fiscal\":\"601\",\"rfc\":\"XQR190529BA7\",\"rfc_original\":\"XQR190529BA7\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(170,4,'fc2','clientes','15','8507','clients','165','385add6ae3d503cda9c0cc424497dd9c0cbdfa5c3df9e62142289219e178890e',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77712\",\"contacto\":null,\"domicilio\":{\"calle\":\"DIAGONAL 85 NORTE\",\"colonia\":\"EJIDAL\",\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"MANZANA 72 LOTE 11 A\",\"no_int\":\"S/N\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8507\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"COMERCIALIZADORA AGROTERRA DEL SURESTE\",\"razon_social_comparison\":\"COMERCIALIZADORA AGROTERRA DEL SURESTE\",\"razon_social_original\":\"COMERCIALIZADORA AGROTERRA DEL SURESTE\",\"regimen_fiscal\":\"601\",\"rfc\":\"CAS150616285\",\"rfc_original\":\"CAS150616285\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(171,4,'fc2','clientes','15','8508','clients','166','1055ceb5706cd89d4fa850b449f24bedb43d0bec853f1db2d2228aff119786bf',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97069\",\"contacto\":null,\"domicilio\":{\"calle\":\"86\",\"colonia\":\"INALAMBRICA\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"473 F\",\"no_int\":\"S/N\"},\"email\":\"merimoto_hondamarine@outlook.com\",\"email_comparison\":\"merimoto_hondamarine@outlook.com\",\"legacy_id\":\"8508\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"MERIMOTO\",\"razon_social_comparison\":\"MERIMOTO\",\"razon_social_original\":\"MERIMOTO\",\"regimen_fiscal\":\"601\",\"rfc\":\"MER881110EM0\",\"rfc_original\":\"MER881110EM0\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(172,4,'fc2','clientes','15','8510','clients','167','c2eb93dcb170311958b795f7b5b5a22774127445c0da7d7e416deaa6dab134b7',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"66260\",\"contacto\":null,\"domicilio\":{\"calle\":\"RIO AMACUZAC, CALLE LOMAS DEL MAR\",\"colonia\":\"RESIDENCIAL SAN AGUSTIN PRIMER SECTOR\",\"estado\":\"NUEVO LEON\",\"localidad\":\"SAN PEDRO GARZA GARCIA\",\"municipio\":\"SAN PEDRO GARZA GARCIA\",\"no_ext\":\"216\",\"no_int\":\"PISO 4 OFICINA 2\"},\"email\":\"ventas@glampingco.mx\",\"email_comparison\":\"ventas@glampingco.mx\",\"legacy_id\":\"8510\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"GLAMPINGCO\",\"razon_social_comparison\":\"GLAMPINGCO\",\"razon_social_original\":\"GLAMPINGCO\",\"regimen_fiscal\":\"601\",\"rfc\":\"GLA241031Q48\",\"rfc_original\":\"GLA241031Q48\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(173,4,'fc2','clientes','15','8512','clients','168','c00fe6e0df4b932218208d05a8fcf269d42e412efb3651bb1d8517dfa77cdcf2',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"24115\",\"contacto\":\"RODRIGO RIOS\",\"domicilio\":{\"calle\":\"FLAMBOYANES CALLE CIRICOTE\",\"colonia\":\"MIAMI\",\"estado\":\"CAMPECHE\",\"localidad\":\"CUIDAD DEL CARMEN\",\"municipio\":\"CARMEN\",\"no_ext\":\"22\",\"no_int\":\"SN\"},\"email\":\"rioswatersolutions.contacto@gmail.com\",\"email_comparison\":\"rioswatersolutions.contacto@gmail.com\",\"legacy_id\":\"8512\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"RIOS WATER SOLUTIONS\",\"razon_social_comparison\":\"RIOS WATER SOLUTIONS\",\"razon_social_original\":\"RIOS WATER SOLUTIONS\",\"regimen_fiscal\":\"601\",\"rfc\":\"RWS250901UI1\",\"rfc_original\":\"RWS250901UI1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(174,4,'fc2','clientes','15','8513','clients','169','7aefb144b52863f494f40ee4d802dae6cd2fe93e95e08b1e40791d152f18095f',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"67174\",\"contacto\":\"GERARDO SOSA\",\"domicilio\":{\"calle\":\"EFRAIN HUERTA\",\"colonia\":\"COUNTRY SOL\",\"estado\":\"NUEVO LEON\",\"localidad\":\"GUADALUPE\",\"municipio\":\"GUADALUPE\",\"no_ext\":\"1703\",\"no_int\":\"SN\"},\"email\":\"somosbluers@gmail.com\",\"email_comparison\":\"somosbluers@gmail.com\",\"legacy_id\":\"8513\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"DAVID JACOB DE LA GARZA VILLARREAL\",\"razon_social_comparison\":\"DAVID JACOB DE LA GARZA VILLARREAL\",\"razon_social_original\":\"DAVID JACOB DE LA GARZA VILLARREAL\",\"regimen_fiscal\":\"605\",\"rfc\":\"GAVD881024FBA\",\"rfc_original\":\"GAVD881024FBA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(175,4,'fc2','clientes','15','8514','clients','170','debef061a04510266258792f6629b47c39b3a9760616fda0d97097b4a501e199',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97320\",\"contacto\":\"FERNANDO CRUZ\",\"domicilio\":{\"calle\":\"19 ENTRE CALLE 14\",\"colonia\":\"COSTA AZUL\",\"estado\":\"YUCATAN\",\"localidad\":\"PROGRESO\",\"municipio\":\"PROGRESO\",\"no_ext\":\"79\",\"no_int\":\"SN\"},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8514\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"ROXANA PATRICIA GUZMAN LICONA\",\"razon_social_comparison\":\"ROXANA PATRICIA GUZMAN LICONA\",\"razon_social_original\":\"ROXANA PATRICIA GUZMAN LICONA\",\"regimen_fiscal\":\"612\",\"rfc\":\"GULR8108285HA\",\"rfc_original\":\"GULR8108285HA\",\"rfc_valid\":true,\"telefono\":\"9381248173\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(176,4,'fc2','clientes','15','8515','clients','171','23099ace8773c091d1147f77244018d59d6f7d360195b1bf85095f3feacd8a01',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97100\",\"contacto\":\"KARLA CANTO\",\"domicilio\":{\"calle\":null,\"colonia\":\"ITZIMNA\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"84\",\"no_int\":\"SN\"},\"email\":\"rserviran@marinasureste.com\",\"email_comparison\":\"rserviran@marinasureste.com\",\"legacy_id\":\"8515\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"MARINA SURESTE\",\"razon_social_comparison\":\"MARINA SURESTE\",\"razon_social_original\":\"MARINA SURESTE\",\"regimen_fiscal\":\"601\",\"rfc\":\"MSU020604TW8\",\"rfc_original\":\"MSU020604TW8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(177,4,'fc2','clientes','15','8516','clients','172','fe75004f56fa6d5fc5a6334c4a5c5d9408e220a4ecf0f49d57e86254b33398ed',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97130\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 8 ENTRE CALLE 15\",\"colonia\":\"DIAZ ORDAZ\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"417\",\"no_int\":\"SN\"},\"email\":\"ventas@mantalifejackets.com\",\"email_comparison\":\"ventas@mantalifejackets.com\",\"legacy_id\":\"8516\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"MARIA CECILIA MAFUD SALUM\",\"razon_social_comparison\":\"MARIA CECILIA MAFUD SALUM\",\"razon_social_original\":\"MARIA CECILIA MAFUD SALUM\",\"regimen_fiscal\":\"612\",\"rfc\":\"MASC6203093NA\",\"rfc_original\":\"MASC6203093NA\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(178,4,'fc2','clientes','15','8523','clients','173','8684e85652077ebc833bc7c02fcc16ca806ed1fb252c8130aa8ac77075025b5c',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97120\",\"contacto\":\"PAMELA RENDON\",\"domicilio\":{\"calle\":\"1D CALE 36 ENTRE CALLE 38\",\"colonia\":\"CAMPESTRE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":null,\"no_ext\":\"258\",\"no_int\":\"SN\"},\"email\":\"jefatura.mkt@therealestatehub.mx\",\"email_comparison\":\"jefatura.mkt@therealestatehub.mx\",\"legacy_id\":\"8523\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"DESARROLLOS NORTEMID\",\"razon_social_comparison\":\"DESARROLLOS NORTEMID\",\"razon_social_original\":\"DESARROLLOS NORTEMID\",\"regimen_fiscal\":\"601\",\"rfc\":\"DNO1712074D8\",\"rfc_original\":\"DNO1712074D8\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(179,4,'fc2','clientes','15','8527','clients','174','ce654b2d72ca3967aa8af1be77018b0e8530a1439079026fda8a980dde8f05e6',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97203\",\"contacto\":\"MIGUEL CORTAZAR\",\"domicilio\":{\"calle\":\"40 CALLE 7 ENTRE CALLE 5\",\"colonia\":\"SAN PEDRO UXMAL\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":null,\"no_ext\":\"321\",\"no_int\":null},\"email\":\"M.cortazar@urbansolar.io\",\"email_comparison\":\"m.cortazar@urbansolar.io\",\"legacy_id\":\"8527\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"URBAN SOLAR\",\"razon_social_comparison\":\"URBAN SOLAR\",\"razon_social_original\":\"URBAN SOLAR\",\"regimen_fiscal\":\"626\",\"rfc\":\"USO190214I21\",\"rfc_original\":\"USO190214I21\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(180,4,'fc2','clientes','15','8534','clients','175','914fbf7308fa270a74e1b76caaf063ed9d8c1a8ff926b25ec7416030e9026c7b',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":null,\"domicilio\":{\"calle\":\"CARRETERA FEDERAL KM 298\",\"colonia\":null,\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SOLIDARIDAD\",\"no_ext\":\"KM 298\",\"no_int\":null},\"email\":null,\"email_comparison\":null,\"legacy_id\":\"8534\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"ISLAS DE MAYAKOBA\",\"razon_social_comparison\":\"ISLAS DE MAYAKOBA\",\"razon_social_original\":\"ISLAS DE MAYAKOBA\",\"regimen_fiscal\":\"601\",\"rfc\":\"IMA030814G16\",\"rfc_original\":\"IMA030814G16\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(181,4,'fc2','clientes','15','8536','clients','176','8fa868f14460f1d725e86113c4a631154e82762f52fbd12bc113e084f08aa5f5',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97302\",\"contacto\":\"ALEJANDRA ORTIZ\",\"domicilio\":{\"calle\":\"SIN CRUZAMIENTO\",\"colonia\":\"TEMOZON NORTE\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"KM3\",\"no_int\":\"1\"},\"email\":\"alejandra@footballcoaching.com.mx\",\"email_comparison\":\"alejandra@footballcoaching.com.mx\",\"legacy_id\":\"8536\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"LIGIA MACIEL GARCIA\",\"razon_social_comparison\":\"LIGIA MACIEL GARCIA\",\"razon_social_original\":\"LIGIA MACIEL GARCIA\",\"regimen_fiscal\":\"621\",\"rfc\":\"MAGL830429FI6\",\"rfc_original\":\"MAGL830429FI6\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(182,4,'fc2','clientes','15','8550','clients','177','19d3beb3912379da7f3d5f217f4d2f2cf4fb1982e336839743c7457ab3d694c0',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97070\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 26\",\"colonia\":\"GARCIA GINERES\",\"estado\":\"YUCATAN\",\"localidad\":null,\"municipio\":\"MERIDA\",\"no_ext\":\"185\",\"no_int\":\"S/N\"},\"email\":\"somosbluers@gmail.com\",\"email_comparison\":\"somosbluers@gmail.com\",\"legacy_id\":\"8550\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"SOMOS BLUERS\",\"razon_social_comparison\":\"SOMOS BLUERS\",\"razon_social_original\":\"SOMOS BLUERS\",\"regimen_fiscal\":\"601\",\"rfc\":\"SBL2601076E3\",\"rfc_original\":\"SBL2601076E3\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(183,4,'fc2','clientes','15','8553','clients','178','c85e2795f55e52ef6cd8458294612d43226d8a09a2d217137bd1505f8355c0b4',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"97249\",\"contacto\":null,\"domicilio\":{\"calle\":\"CALLE 122 ENTRE 120 A\",\"colonia\":\"NUEVA MULSAY\",\"estado\":\"YUCATAN\",\"localidad\":\"MERIDA\",\"municipio\":\"MERIDA\",\"no_ext\":\"1003\",\"no_int\":\"SN\"},\"email\":\"facturacionmoyuc@yahoo.com.mx\",\"email_comparison\":\"facturacionmoyuc@yahoo.com.mx\",\"legacy_id\":\"8553\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"CONSTRUCCIONES MOYUC\",\"razon_social_comparison\":\"CONSTRUCCIONES MOYUC\",\"razon_social_original\":\"CONSTRUCCIONES MOYUC\",\"regimen_fiscal\":\"601\",\"rfc\":\"CMO000128Q59\",\"rfc_original\":\"CMO000128Q59\",\"rfc_valid\":true,\"telefono\":\"999 163 9125\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(184,4,'fc2','clientes','15','8555','clients','179','c84ecd6bad1726057a6fc975978afe812646e83736aaac7ac28a62d8536cae70',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"45019\",\"contacto\":\"ALFONSO LOZA PEREZ\",\"domicilio\":{\"calle\":\"JILGUEROS ENTRE CARRET. GUADALAJARA-TEPIC\",\"colonia\":\"SAN JUAN DE OCOTAN\",\"estado\":\"JALISCO\",\"localidad\":\"ZAPOPAN\",\"municipio\":\"ZAPOPAN\",\"no_ext\":\"1204\",\"no_int\":\"24\"},\"email\":\"a.loza@vidabirdman.com\",\"email_comparison\":\"a.loza@vidabirdman.com\",\"legacy_id\":\"8555\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"TAKE FLIGHT VENTURES\",\"razon_social_comparison\":\"TAKE FLIGHT VENTURES\",\"razon_social_original\":\"TAKE FLIGHT VENTURES\",\"regimen_fiscal\":\"601\",\"rfc\":\"TFV220408B62\",\"rfc_original\":\"TFV220408B62\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(185,4,'fc2','clientes','15','8563','clients','180','3ea981a0fc563247861f3ac766131d7e32393505aea0d71b331d66f4f1d1db29',NULL,'skipped','skip','[\"source unchanged\"]','{\"codigo_postal\":\"77710\",\"contacto\":\"Luis Baños\",\"domicilio\":{\"calle\":\"CARR FEDERAL CHETUMAL PTO. JUAREZ\",\"colonia\":null,\"estado\":null,\"localidad\":\"PLAYA DEL CARMEN\",\"municipio\":\"SAN PEDRO GARZA GARCIA\",\"no_ext\":\"KM 298\",\"no_int\":\"SN\"},\"email\":\"almacen@mayakoba-ac.com\",\"email_comparison\":\"almacen@mayakoba-ac.com\",\"legacy_id\":\"8563\",\"observaciones\":null,\"pais\":\"MEX\",\"razon_social\":\"CONDOMINIO MAYAKOBA\",\"razon_social_comparison\":\"CONDOMINIO MAYAKOBA\",\"razon_social_original\":\"CONDOMINIO MAYAKOBA\",\"regimen_fiscal\":\"603\",\"rfc\":\"CMA0408246P1\",\"rfc_original\":\"CMA0408246P1\",\"rfc_valid\":true,\"telefono\":null,\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(186,4,'fc2','productos','15','2218','items','1','39ad5860c89687e279503090d0bebba150b4e9af6e12a3bc0a286e22b937789f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"86101705\",\"clave_prod_serv\":\"86101705\",\"clave_prod_serv_id\":\"51845\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"CAPACITACION DE EMPLEADOS\",\"legacy_id\":\"2218\",\"observaciones\":\".\",\"precio\":\"1.0000\",\"precio_error\":null,\"precio_original\":\"1.0000\",\"unidad_comercial\":\"SERV.\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(187,4,'fc2','productos','15','2262','items','2','d82728e7ea71a8cb2d5141547c529405b503a24fec8b325aeb85dbd2e570cf06',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"ZAPATOS\",\"legacy_id\":\"2262\",\"observaciones\":\".\",\"precio\":\"1.0000\",\"precio_error\":null,\"precio_original\":\"1.0000\",\"unidad_comercial\":\"PRS\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(188,4,'fc2','productos','15','3964','items','3','15c171004e1020622180bf8cf93975fc78c1ad2be993ffb96d4e1d9f21145148',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ciceg\",\"clave_prod_serv\":\"94101600\",\"clave_prod_serv_id\":\"52475\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Prestación de servicios profesionales en Yucatán\",\"legacy_id\":\"3964\",\"observaciones\":null,\"precio\":\"5000.0000\",\"precio_error\":null,\"precio_original\":\"5000.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(189,4,'fc2','productos','15','4032','items','4','77964b6eb50bb02287c472b55d2284211662ff7c8f4e6f2fb04e976feb9a9df1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ciceg\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Prestación de servicios profesionales en Yucatán\",\"legacy_id\":\"4032\",\"observaciones\":null,\"precio\":\"3000.0000\",\"precio_error\":null,\"precio_original\":\"3000.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(190,4,'fc2','productos','15','4317','items','5','3dbc809f0af0aa46fd7cfe8e9538307e63cc4af6d24c577cc29973b44004c856',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"STANDS PARA BANDERAS\",\"clave_prod_serv\":\"55121906\",\"clave_prod_serv_id\":\"47144\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"bandera tela sublimada  con estructura metálica y flexible base cromada en x\",\"legacy_id\":\"4317\",\"observaciones\":null,\"precio\":\"3600.0000\",\"precio_error\":null,\"precio_original\":\"3600.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(191,4,'fc2','productos','15','4360','items','6','6e6a074cf33ebaceecbfc93cb5b2d55c8fdc45401364c8b00cba4d3b0cc73367',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"cartera\",\"clave_prod_serv\":\"11131502\",\"clave_prod_serv_id\":\"8057\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Cartera tarjetero piel\",\"legacy_id\":\"4360\",\"observaciones\":null,\"precio\":\"406.0000\",\"precio_error\":null,\"precio_original\":\"406.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(192,4,'fc2','productos','15','4361','items','7','6d19985772b9403ebc0aa4556f6707bfb3fbabd963d55f09757a00f030b7fd81',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"cosmetiquera\",\"clave_prod_serv\":\"24121513\",\"clave_prod_serv_id\":\"11248\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"cosmetiquera sintetico\",\"legacy_id\":\"4361\",\"observaciones\":null,\"precio\":\"200.0000\",\"precio_error\":null,\"precio_original\":\"200.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(193,4,'fc2','productos','15','4371','items','8','ef241d2ba183d6454d42da446e92986197500690f55f142628e5c62270578ae4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ROLL up\",\"clave_prod_serv\":\"55121908\",\"clave_prod_serv_id\":\"47146\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Display Roll Up\",\"legacy_id\":\"4371\",\"observaciones\":null,\"precio\":\"1800.0000\",\"precio_error\":null,\"precio_original\":\"1800.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(194,4,'fc2','productos','15','4567','items','9','c35ec31fdbb8f71306c82e43629020eb650f7ccd3cfc7eee765cdc0517c58762',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Muro 305 x 2.27\",\"clave_prod_serv\":\"30162401\",\"clave_prod_serv_id\":\"13799\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Muro expandible\",\"legacy_id\":\"4567\",\"observaciones\":null,\"precio\":\"6832.4000\",\"precio_error\":null,\"precio_original\":\"6832.4000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(195,4,'fc2','productos','15','4613','items','10','2821e6a07e7cf479ce46b97c731bf1fff561981cb1fac3080256078e125ddfc1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"esc 304-19\",\"clave_prod_serv\":\"44112005\",\"clave_prod_serv_id\":\"24881\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"libreta personalizada espiral\",\"legacy_id\":\"4613\",\"observaciones\":null,\"precio\":\"98.6000\",\"precio_error\":null,\"precio_original\":\"98.6000\",\"unidad_comercial\":\"Lib\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(196,4,'fc2','productos','15','4927','items','11','089f184bfc23c21532f6b27d750f99ec05059a6cecee3a2876ea23d6f3a80297',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Flete\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"C62\",\"clave_unidad_id\":\"441\",\"descripcion\":\"SERVICIO DE FLETE\",\"legacy_id\":\"4927\",\"observaciones\":null,\"precio\":\"700.0000\",\"precio_error\":null,\"precio_original\":\"700.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(197,4,'fc2','productos','15','4928','items','12','0976a99de3da20f481f321b53068b6913ba8283967a0f0de80a6f833328d2e25',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Careta\",\"clave_prod_serv\":\"39111815\",\"clave_prod_serv_id\":\"17691\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Careta protectora\",\"legacy_id\":\"4928\",\"observaciones\":null,\"precio\":\"58.0000\",\"precio_error\":null,\"precio_original\":\"58.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(198,4,'fc2','productos','15','4930','items','13','d05f55eec12b92d5fde768a4c84a30d4721bcfb51a4e7bb58dd31b681a8c24df',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"FLAYERS PUBLICIDAD\",\"clave_prod_serv\":\"82101505\",\"clave_prod_serv_id\":\"51220\",\"clave_unidad\":\"XKI\",\"clave_unidad_id\":\"2203\",\"descripcion\":\"FLAYERS 1/4 CARTA UNA VISTA\",\"legacy_id\":\"4930\",\"observaciones\":null,\"precio\":\"590.0000\",\"precio_error\":null,\"precio_original\":\"590.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(199,4,'fc2','productos','15','4978','items','14','fc07e530bff9c11544dd69643906bd5a05c7fe77e0ee09be90df8f81da3da139',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TAPETE SANITIZANTE PVC\",\"clave_prod_serv\":\"52101508\",\"clave_prod_serv_id\":\"46320\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"TAPETE SANITIZANTE PVC\",\"legacy_id\":\"4978\",\"observaciones\":null,\"precio\":\"216.0000\",\"precio_error\":null,\"precio_original\":\"216.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(200,4,'fc2','productos','15','5851','items','15','7e9b104a36da06bed94a487362a5e2b83bcafd91ca5f516bd355db0e8637e733',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"full plastic\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Tenis full plastic pvc reciclable\",\"legacy_id\":\"5851\",\"observaciones\":null,\"precio\":\"197.0000\",\"precio_error\":null,\"precio_original\":\"197.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(201,4,'fc2','productos','15','5852','items','16','024d3b116d4abef9e57a64ce8e4ef0accf62c3991a6f74b192156d648bb0a842',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"full plastic\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Tenis full plastic pvc reciclable\",\"legacy_id\":\"5852\",\"observaciones\":null,\"precio\":\"197.0000\",\"precio_error\":null,\"precio_original\":\"197.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(202,4,'fc2','productos','15','6644','items','17','b84911171867a6f8d27cd812066bde07379f837c7e5d8f461998b154eafd0280',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS OPERACIONES\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS ANTIDERRAPANTE  XELS\",\"legacy_id\":\"6644\",\"observaciones\":null,\"precio\":\"189.0000\",\"precio_error\":null,\"precio_original\":\"189.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(203,4,'fc2','productos','15','7139','items','18','5dc22bd19401275a9ab665978d50a29801f9df72351923df595973579b7b8090',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"bolsa malla\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"T4\",\"clave_unidad_id\":\"1965\",\"descripcion\":\"Bolsa malla sec, ahorcador\",\"legacy_id\":\"7139\",\"observaciones\":null,\"precio\":\"14.0000\",\"precio_error\":null,\"precio_original\":\"14.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(204,4,'fc2','productos','15','7141','items','19','25b2f52bad947563def4967da7420494d1ac17a7174ac647f2ed839e2b8af066',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"EnviÃ³ (LogÃ­stica)\",\"clave_prod_serv\":\"81141601\",\"clave_prod_serv_id\":\"51145\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"LogÃ­stica de Entrega\",\"legacy_id\":\"7141\",\"observaciones\":null,\"precio\":\"250.0000\",\"precio_error\":null,\"precio_original\":\"250.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(205,4,'fc2','productos','15','7570','items','20','555d1e0a6818c2acd7321fe96709df59dae2be7cdd5461662225526ed5f13b6e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"kit maquillaje\",\"clave_prod_serv\":\"53131629\",\"clave_prod_serv_id\":\"46892\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SET MAQUILLAJE CATRINA REV 40301100 GR\",\"legacy_id\":\"7570\",\"observaciones\":null,\"precio\":\"43.0200\",\"precio_error\":null,\"precio_original\":\"43.0200\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(206,4,'fc2','productos','15','7571','items','21','482cabb8744175fb4d67075a6e28cd8fa1785702619e9f602a0c98feda7771c4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"kit maquillaje 3\",\"clave_prod_serv\":\"53131629\",\"clave_prod_serv_id\":\"46892\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"MAQUILLAJE TUBO REV i9442C 40 GR NGO\",\"legacy_id\":\"7571\",\"observaciones\":null,\"precio\":\"19.7400\",\"precio_error\":null,\"precio_original\":\"19.7400\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(207,4,'fc2','productos','15','7572','items','22','3a3c20df1c058045f67e56f6c63dd2e4ceddfcb046ebe715d45a4f3fc7e212e9',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"kit 2 maquillaje\",\"clave_prod_serv\":\"53131629\",\"clave_prod_serv_id\":\"46892\",\"clave_unidad\":\"KT\",\"clave_unidad_id\":\"1350\",\"descripcion\":\"glow dark make up\",\"legacy_id\":\"7572\",\"observaciones\":null,\"precio\":\"25.7800\",\"precio_error\":null,\"precio_original\":\"25.7800\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(208,4,'fc2','productos','15','7624','items','23','106191f40ac748ccd83955936b9d797d2db1d87e975957e7ca675896178fb583',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Llavero personalizado\",\"clave_prod_serv\":\"49101602\",\"clave_prod_serv_id\":\"26115\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Llavero plastisol personalizado, herraje sencillo\",\"legacy_id\":\"7624\",\"observaciones\":null,\"precio\":\"49.6000\",\"precio_error\":null,\"precio_original\":\"49.6000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(209,4,'fc2','productos','15','7914','items','24','3a0302e7d6239fec7c702f58873aaa6d7bfbc57f9b56829d3aece832646afeaa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"uniformes mia\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Uniformes borados Mia tulum\",\"legacy_id\":\"7914\",\"observaciones\":null,\"precio\":\"381.6000\",\"precio_error\":null,\"precio_original\":\"381.6000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(210,4,'fc2','productos','15','8101','items','25','ca97853361e3714224b3b69e2ae27b316b373285daf4f902b5e7d7878921e423',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ACT\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ANTICIPO ZAPATOS BB XELS\",\"legacy_id\":\"8101\",\"observaciones\":null,\"precio\":\"14648.1000\",\"precio_error\":null,\"precio_original\":\"14648.1000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(211,4,'fc2','productos','15','8221','items','26','134f49ecfa4d8fe15c2a37c1303d40bf6e1243c11e8315c3f0773994f7afcf84',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ACT\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ANTICIPO ZAPATOS XELS FULL PLASTIC\",\"legacy_id\":\"8221\",\"observaciones\":null,\"precio\":\"1054806.0000\",\"precio_error\":null,\"precio_original\":\"1054806.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(212,4,'fc2','productos','15','8248','items','27','b33ec5e5760787c66fa94a1902c2f2f285daaaf0b6c5083ced3c620e95e2a707',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111603\",\"clave_prod_serv_id\":\"46796\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia XELS Entrenadora Droppers Infantil 604 Azul Petroleo\",\"legacy_id\":\"8248\",\"observaciones\":null,\"precio\":\"136.3636\",\"precio_error\":null,\"precio_original\":\"136.3636\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(213,4,'fc2','productos','15','8249','items','28','6ba5aabc7f1c7e26e0376448873d97010389c249a5895d50d897a1a5eac19e3a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111603\",\"clave_prod_serv_id\":\"46796\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia XELS Entrenadora Kidori Infantil 9886 Rojo\",\"legacy_id\":\"8249\",\"observaciones\":null,\"precio\":\"127.2727\",\"precio_error\":null,\"precio_original\":\"127.2727\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(214,4,'fc2','productos','15','8250','items','29','cb4e4db2ebd709069db68eacb5db3aa79ff9c27b3e10cff76eccbb910a0be57d',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111604\",\"clave_prod_serv_id\":\"46797\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia XELS Entrenadora Droppers Infantil 603 Rosa Pastel\",\"legacy_id\":\"8250\",\"observaciones\":null,\"precio\":\"136.3636\",\"precio_error\":null,\"precio_original\":\"136.3636\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(215,4,'fc2','productos','15','8251','items','30','8ad741d49f8cb6bb0ed19a989dbf7a734db8935becf0d18fe5ee648bbb0282fb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111604\",\"clave_prod_serv_id\":\"46797\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia XELS Kids Para Niña Ice Cream 661\",\"legacy_id\":\"8251\",\"observaciones\":null,\"precio\":\"154.5455\",\"precio_error\":null,\"precio_original\":\"154.5455\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(216,4,'fc2','productos','15','8252','items','31','b8dc3fc5f4c13e34de42636836113aa26126ff93d43d0c36aad2a2df129fda41',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111604\",\"clave_prod_serv_id\":\"46797\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia XELS Para Niña Con Forma De Unicornio 9878\",\"legacy_id\":\"8252\",\"observaciones\":null,\"precio\":\"181.8182\",\"precio_error\":null,\"precio_original\":\"181.8182\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(217,4,'fc2','productos','15','8253','items','32','df6016de43e77a36beddbaf2b8cc9e18f6e1a206641e649928507ee6799c66aa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Anticipo\",\"clave_prod_serv\":\"80141600\",\"clave_prod_serv_id\":\"50876\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"NOTA DE CRÉDITO POR ANTICIPO POR SERVICIOS PRESTADOS\",\"legacy_id\":\"8253\",\"observaciones\":null,\"precio\":\"14648.1000\",\"precio_error\":null,\"precio_original\":\"14648.1000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(218,4,'fc2','productos','15','8352','items','33','08f3ed203e1a3571e80bcc81a6b89aebcbaa7b059174f41a01493d2539c2d3b3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Zapato Acuático Unisex Negro\",\"legacy_id\":\"8352\",\"observaciones\":null,\"precio\":\"89.0000\",\"precio_error\":null,\"precio_original\":\"89.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(219,4,'fc2','productos','15','8353','items','34','c8abec2d26188b915cede84f7765fcac9a79e43442a2ff1ae4ff26633932f483',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Zapato Acuático Tela C/diseño Cab\",\"legacy_id\":\"8353\",\"observaciones\":null,\"precio\":\"115.0000\",\"precio_error\":null,\"precio_original\":\"115.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(220,4,'fc2','productos','15','8354','items','35','996cf1fbf66f552b580299499ebc686d634d51e5a4d03f9043cb1214effb120a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Zapato Acuático Tela C/diseño Dama\",\"legacy_id\":\"8354\",\"observaciones\":null,\"precio\":\"115.0000\",\"precio_error\":null,\"precio_original\":\"115.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(221,4,'fc2','productos','15','8403','items','36','6322fed9363858339908642ccccdf1063e133f49e9ba40193502565bd02df5ae',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Tennis suela runner antiderrapante  MODELO X10\",\"legacy_id\":\"8403\",\"observaciones\":null,\"precio\":\"266.0000\",\"precio_error\":null,\"precio_original\":\"266.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(222,4,'fc2','productos','15','8404','items','37','e7155e43ab933976b180a0c551af6c3984d50c1def4a97cf47daed0e8ace42ae',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"SANDALIA W60\",\"legacy_id\":\"8404\",\"observaciones\":null,\"precio\":\"134.2000\",\"precio_error\":null,\"precio_original\":\"134.2000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(223,4,'fc2','productos','15','8405','items','38','b8afb660a649c6c7294590553fb83ee3e08719cd3e6a18b7c653f5960334529f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA CHUNKY DAMA\",\"legacy_id\":\"8405\",\"observaciones\":null,\"precio\":\"134.2000\",\"precio_error\":null,\"precio_original\":\"134.2000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(224,4,'fc2','productos','15','8406','items','39','b7b4483fff29b30826ae1ae838390f5e8686c13ea2c16fdd82ce894c8db75e1a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"X10-UN-BLA\",\"legacy_id\":\"8406\",\"observaciones\":null,\"precio\":\"599.0000\",\"precio_error\":null,\"precio_original\":\"599.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(225,4,'fc2','productos','15','8407','items','40','843fbcb5e4247e652e5ac2b60b3a0c7755927eaed9c8adf43cc9251c67fee91b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA W20\",\"legacy_id\":\"8407\",\"observaciones\":null,\"precio\":\"102.1000\",\"precio_error\":null,\"precio_original\":\"102.1000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(226,4,'fc2','productos','15','8408','items','41','f191ed807030c7b5d8a4f079590b63f2262b15112beb03da0833ebd12d52ef8f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA TIRAS\",\"legacy_id\":\"8408\",\"observaciones\":null,\"precio\":\"102.1000\",\"precio_error\":null,\"precio_original\":\"102.1000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(227,4,'fc2','productos','15','8409','items','42','8a089395d60fa753643075270b404c2a0ac701511cb24c350d3eaa6bb6c99c10',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA W70\",\"legacy_id\":\"8409\",\"observaciones\":null,\"precio\":\"134.2000\",\"precio_error\":null,\"precio_original\":\"134.2000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(228,4,'fc2','productos','15','8410','items','43','ada8e1f9c0767d5e0e06ebb9dff9c687b8d578c92f4aedcdcef61fc4df81ac7e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA CHUNKY P DE GALLO\",\"legacy_id\":\"8410\",\"observaciones\":null,\"precio\":\"134.2000\",\"precio_error\":null,\"precio_original\":\"134.2000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(229,4,'fc2','productos','15','8411','items','44','9072a60fdbab14857a3e9404fb5d66ca3c78302ed637aae3f59445959c9e3952',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SANDALIA W20C\",\"legacy_id\":\"8411\",\"observaciones\":null,\"precio\":\"112.8000\",\"precio_error\":null,\"precio_original\":\"112.8000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(230,4,'fc2','productos','15','8412','items','45','327eee451e0d513d7cc050eea462943e0eb80df9d5c9a547f7e836bf7f300755',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"X10-UN-BLU\",\"legacy_id\":\"8412\",\"observaciones\":null,\"precio\":\"450.0000\",\"precio_error\":null,\"precio_original\":\"450.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(231,4,'fc2','productos','15','8413','items','46','654e2a8afae411d26025f4124566eab57cbf72fcc4620eaa7ed1555e0fedd991',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Ganchos\",\"clave_prod_serv\":\"53112000\",\"clave_prod_serv_id\":\"46817\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Gancho Garza\",\"legacy_id\":\"8413\",\"observaciones\":null,\"precio\":\"3.5000\",\"precio_error\":null,\"precio_original\":\"3.5000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(232,4,'fc2','productos','15','8414','items','47','8ae0374e2a39b8bd0ac767759791bf8265f48f40d1b22a4ed27ef114150a74a4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Ganchos\",\"clave_prod_serv\":\"53112000\",\"clave_prod_serv_id\":\"46817\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Gancho Fussion\",\"legacy_id\":\"8414\",\"observaciones\":null,\"precio\":\"2.0000\",\"precio_error\":null,\"precio_original\":\"2.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(233,4,'fc2','productos','15','8416','items','48','f9ecccfb2a1312918c4e04dc72071c864cb8239a74b8a0a108e0a47467b66f8a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Zapato Xels Antiderrapante\",\"legacy_id\":\"8416\",\"observaciones\":null,\"precio\":\"230.0000\",\"precio_error\":null,\"precio_original\":\"230.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(234,4,'fc2','productos','15','8425','items','49','23040b11e99df8fcd3e047ea0b88382cb51c7fd3c2e7ae60b8a88f55d502bd19',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ACT\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ANTICIPO ZAPATOS XELS AQUASHOES\",\"legacy_id\":\"8425\",\"observaciones\":null,\"precio\":\"1268982.0000\",\"precio_error\":null,\"precio_original\":\"1268982.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(235,4,'fc2','productos','15','8519','items','50','35ec01e05659676a17f89f5e9caf83d19e3b8e53bdee61bc225da66728a28ba7',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalia minimalista Modelo W50\",\"legacy_id\":\"8519\",\"observaciones\":null,\"precio\":\"170.0000\",\"precio_error\":null,\"precio_original\":\"170.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(236,4,'fc2','productos','15','8620','items','51','3d96adaa8989f19811b999ecf016191ffb2544c06254cd2d307b4f53f5dd5c25',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Camisa\",\"clave_prod_serv\":\"53101602\",\"clave_prod_serv_id\":\"46671\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Camisa Cuello Mao Color Blanco para Caballero\",\"legacy_id\":\"8620\",\"observaciones\":null,\"precio\":\"370.0000\",\"precio_error\":null,\"precio_original\":\"370.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(237,4,'fc2','productos','15','8622','items','52','9af746453846bd010af5a8943175599ad57f5ef111700ab304970f414c1ec1b6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Camisa\",\"clave_prod_serv\":\"53101604\",\"clave_prod_serv_id\":\"46673\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Camisa Cuello Mao Azul para Dama\",\"legacy_id\":\"8622\",\"observaciones\":null,\"precio\":\"370.0000\",\"precio_error\":null,\"precio_original\":\"370.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(238,4,'fc2','productos','15','8631','items','53','689da46b33664cd11cc6277d3bf6d2399e687e6af7da9867386ff45eac46375e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BANDERAS\",\"clave_prod_serv\":\"55121715\",\"clave_prod_serv_id\":\"47113\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Banderines tela sublimada Medidas 1.5 x 3.5 m\",\"legacy_id\":\"8631\",\"observaciones\":null,\"precio\":\"2800.0000\",\"precio_error\":null,\"precio_original\":\"2800.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(239,4,'fc2','productos','15','8632','items','54','294375bdaea534f2c16f186d5903671c650185f119c8ae722388ab56f4b271a8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Instalacion\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Instalaciones\",\"legacy_id\":\"8632\",\"observaciones\":null,\"precio\":\"990.0000\",\"precio_error\":null,\"precio_original\":\"990.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(240,4,'fc2','productos','15','8634','items','55','0bd0167b22244221688cb5416b279f87327ca2f363ac2bb6ce666ce9907edece',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TELA SUBLIMADA\",\"clave_prod_serv\":\"30161511\",\"clave_prod_serv_id\":\"13726\",\"clave_unidad\":\"XBT\",\"clave_unidad_id\":\"2098\",\"descripcion\":\"TELA SUBLIMADA\",\"legacy_id\":\"8634\",\"observaciones\":null,\"precio\":\"3100.0000\",\"precio_error\":null,\"precio_original\":\"3100.0000\",\"unidad_comercial\":\"Rollo de tela\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(241,4,'fc2','productos','15','8696','items','56','95754d1f65ed83e381d47348e92ace5fc8595e63cd2ef140af77e5d185857e97',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Camisa seguridad\",\"clave_prod_serv\":\"53101602\",\"clave_prod_serv_id\":\"46671\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Camisa de uniforme de seguridad\",\"legacy_id\":\"8696\",\"observaciones\":null,\"precio\":\"360.0000\",\"precio_error\":null,\"precio_original\":\"360.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(242,4,'fc2','productos','15','8817','items','57','102f3497f980bdbdf2f1c9c1c3cc7af7f34eef5122059d32b6b22bf947b04a58',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"morral artesanal\",\"clave_prod_serv\":\"53121603\",\"clave_prod_serv_id\":\"46836\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"morrales artesanales\",\"legacy_id\":\"8817\",\"observaciones\":null,\"precio\":\"149.0000\",\"precio_error\":null,\"precio_original\":\"149.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(243,4,'fc2','productos','15','8991','items','58','592c1a9ef896a0f8edfd0f8be0efbca05df13b5351b67feda53eae7ec90c1c20',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"w90 pro\",\"clave_prod_serv\":\"53111800\",\"clave_prod_serv_id\":\"46805\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"sandalia eva unisex w90 pro\",\"legacy_id\":\"8991\",\"observaciones\":null,\"precio\":\"145.0000\",\"precio_error\":null,\"precio_original\":\"145.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(244,4,'fc2','productos','15','8992','items','59','b6aca49b118c7b475ba7d47dbb56f616e4a69ca44e7ba84c6762972fb05267ab',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"w20\",\"clave_prod_serv\":\"53111800\",\"clave_prod_serv_id\":\"46805\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"sandalia w20\",\"legacy_id\":\"8992\",\"observaciones\":null,\"precio\":\"99.0000\",\"precio_error\":null,\"precio_original\":\"99.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(245,4,'fc2','productos','15','9506','items','60','a1ab3f188ccc2c22f51b053598e7b278034eef6b2ca3383f4ee1a39b5c35cee4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PLAYERA LICRA MANGA LARGA XB\",\"clave_prod_serv\":\"53102901\",\"clave_prod_serv_id\":\"46777\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"playera Xels licra\",\"legacy_id\":\"9506\",\"observaciones\":null,\"precio\":\"320.0000\",\"precio_error\":null,\"precio_original\":\"320.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(246,4,'fc2','productos','15','9531','items','61','4cf663e937a04cf5984c6e733bbc2eaa5065d790a385d2bc5a075b249fb70a4e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Sandalia T-star Miki gr\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"sandalia eva cafe grande\",\"legacy_id\":\"9531\",\"observaciones\":null,\"precio\":\"154.0000\",\"precio_error\":null,\"precio_original\":\"154.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(247,4,'fc2','productos','15','9532','items','62','d56244ffaf36825597abb2ea2274295a5cbd15926a7fa470d10af1fbf54e907a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Sandalia T-star Miki ch\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"sandalia eva cafe chica\",\"legacy_id\":\"9532\",\"observaciones\":null,\"precio\":\"143.0000\",\"precio_error\":null,\"precio_original\":\"143.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(248,4,'fc2','productos','15','9577','items','63','73cd1c301ac4b1b5888169a00f098c3dbb35f61e236ad70f34f8bcb968435017',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"STANDS EXHIBIDORES\",\"clave_prod_serv\":\"56121902\",\"clave_prod_serv_id\":\"47379\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"STANDS EXHIBIDORES\",\"legacy_id\":\"9577\",\"observaciones\":null,\"precio\":\"955.0000\",\"precio_error\":null,\"precio_original\":\"955.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(249,4,'fc2','productos','15','9578','items','64','870009322699c99c0839ff9fa5c2fe0d37eba1088fe7a007329a0cad2f8cb718',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Banderola\",\"clave_prod_serv\":\"55121715\",\"clave_prod_serv_id\":\"47113\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Bandera sublimada de .90 x 1.50\",\"legacy_id\":\"9578\",\"observaciones\":null,\"precio\":\"655.5500\",\"precio_error\":null,\"precio_original\":\"655.5500\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(250,4,'fc2','productos','15','9590','items','65','179bc8cb46e34a3ed738a552e0867d76da26efe28a40c54a2d5cdc7596d4d563',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Back estructura\",\"clave_prod_serv\":\"30162401\",\"clave_prod_serv_id\":\"13799\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Back estructura\",\"legacy_id\":\"9590\",\"observaciones\":null,\"precio\":\"5850.0000\",\"precio_error\":null,\"precio_original\":\"5850.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(251,4,'fc2','productos','15','9631','items','66','9dde556d95b5a02a2e7221044e4e327cd6a764f0bf96007ce341979a375a4718',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Bases de Acero\",\"clave_prod_serv\":\"27112305\",\"clave_prod_serv_id\":\"13092\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Base de acero para Bandera\",\"legacy_id\":\"9631\",\"observaciones\":null,\"precio\":\"1600.0000\",\"precio_error\":null,\"precio_original\":\"1600.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(252,4,'fc2','productos','15','9706','items','67','e0dbe2440130cef42294d6c5cc157dbe31abd9fbd851f35e2a49ca0db319130c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"topsider\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"topsider rojo\",\"legacy_id\":\"9706\",\"observaciones\":null,\"precio\":\"190.0000\",\"precio_error\":null,\"precio_original\":\"190.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(253,4,'fc2','productos','15','9715','items','68','c90d1c90c6ad8dcb83b390eedcfcbd3fb51df5edc5c57f11e167146f0074e84a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ACT\",\"clave_prod_serv\":\"82101500\",\"clave_prod_serv_id\":\"51215\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ANTICIPO.- INSUMOS DE BRANDING PARA TORNEO DE GOLF\",\"legacy_id\":\"9715\",\"observaciones\":null,\"precio\":\"13360.3400\",\"precio_error\":null,\"precio_original\":\"13360.3400\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(254,4,'fc2','productos','15','9728','items','69','428fba9881abcd2b02e596798a6d0e05bcafd55ab9411c6d4ca61bdbc693e8c4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ACT\",\"clave_prod_serv\":\"82101500\",\"clave_prod_serv_id\":\"51215\",\"clave_unidad\":\"XKI\",\"clave_unidad_id\":\"2203\",\"descripcion\":\"INSUMOS DE BRANDING PARA TORNEO DE GOLF\",\"legacy_id\":\"9728\",\"observaciones\":null,\"precio\":\"26718.0000\",\"precio_error\":null,\"precio_original\":\"26718.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(255,4,'fc2','productos','15','9729','items','70','e1f24251ece4923736c713cd5a12ce3398bac2d7b20e3d317a7c324cad906e9d',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Camisa caballero\",\"clave_prod_serv\":\"53101602\",\"clave_prod_serv_id\":\"46671\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Camisa de caballero\",\"legacy_id\":\"9729\",\"observaciones\":null,\"precio\":\"270.0000\",\"precio_error\":null,\"precio_original\":\"270.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(256,4,'fc2','productos','15','9730','items','71','8aa2f3d4856b8dc46700c486b6a2420687825f00193f48c058951c03e3b9cbc1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Blusa dama\",\"clave_prod_serv\":\"53101604\",\"clave_prod_serv_id\":\"46673\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Blusa dama\",\"legacy_id\":\"9730\",\"observaciones\":null,\"precio\":\"333.0000\",\"precio_error\":null,\"precio_original\":\"333.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(257,4,'fc2','productos','15','9731','items','72','1b0ea14086f7386e67075695cfa075747744e54ed9c17a523f4c8eea01ea03c7',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Blusa dama\",\"clave_prod_serv\":\"53101604\",\"clave_prod_serv_id\":\"46673\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Blusa dama especial\",\"legacy_id\":\"9731\",\"observaciones\":null,\"precio\":\"423.0000\",\"precio_error\":null,\"precio_original\":\"423.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(258,4,'fc2','productos','15','9732','items','73','92f5394d3ca2bfacf220168bb1f3daf8df689dae884e975c198b3f0b7eb431f2',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Vestido\",\"clave_prod_serv\":\"53102002\",\"clave_prod_serv_id\":\"46695\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Vestido para mujer\",\"legacy_id\":\"9732\",\"observaciones\":null,\"precio\":\"576.0000\",\"precio_error\":null,\"precio_original\":\"576.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(259,4,'fc2','productos','15','9733','items','74','8a20e07a0010f24b11faeeabb6b2a690bfb995a5359fe7ebdc0cf79084dd8919',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pantalon hombre\",\"clave_prod_serv\":\"53101502\",\"clave_prod_serv_id\":\"46665\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Pantalon hombre\",\"legacy_id\":\"9733\",\"observaciones\":null,\"precio\":\"315.0000\",\"precio_error\":null,\"precio_original\":\"315.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(260,4,'fc2','productos','15','9734','items','75','0f49f8a0f9cda4c8d0f43e4c841966739b62cf4b204ee4ba7373c763ee8d8d54',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pantalon dama\",\"clave_prod_serv\":\"53101504\",\"clave_prod_serv_id\":\"46667\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Pantalon dama\",\"legacy_id\":\"9734\",\"observaciones\":null,\"precio\":\"315.0000\",\"precio_error\":null,\"precio_original\":\"315.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(261,4,'fc2','productos','15','9735','items','76','57af0c299f6cbfdb472fd3c87c6ee61f6a65f8216fd25536a7d472de50d37d17',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pantalon dama especial\",\"clave_prod_serv\":\"53101504\",\"clave_prod_serv_id\":\"46667\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Pantalon dama especial\",\"legacy_id\":\"9735\",\"observaciones\":null,\"precio\":\"405.0000\",\"precio_error\":null,\"precio_original\":\"405.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(262,4,'fc2','productos','15','9816','items','77','3bc0ac16bb0d4a24462e09f156af2a381df0fb4869e1eb08a9d16559ac8ffa5b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SET DE COLLAR Y PEINETA\",\"clave_prod_serv\":\"20121445\",\"clave_prod_serv_id\":\"9426\",\"clave_unidad\":\"XKI\",\"clave_unidad_id\":\"2203\",\"descripcion\":\"SET DE COLLAR Y PEINETA PARA HOSTESS\",\"legacy_id\":\"9816\",\"observaciones\":null,\"precio\":\"317.7200\",\"precio_error\":null,\"precio_original\":\"317.7200\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(263,4,'fc2','productos','15','9817','items','78','cc502c48608683266c847158f18536bcac69f2030b34ffdd68fe396f7520204e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SET DE COLLAR Y ARETES\",\"clave_prod_serv\":\"20121445\",\"clave_prod_serv_id\":\"9426\",\"clave_unidad\":\"XKI\",\"clave_unidad_id\":\"2203\",\"descripcion\":\"SET DE COLLAR Y ARETES PARA HOSTESS\",\"legacy_id\":\"9817\",\"observaciones\":null,\"precio\":\"250.5000\",\"precio_error\":null,\"precio_original\":\"250.5000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(264,4,'fc2','productos','15','9830','items','79','f740d9becbd707a309cc5975d9232ddc145c04d299a42898b39d972f9a4a565c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CHALECO G\",\"clave_prod_serv\":\"46181507\",\"clave_prod_serv_id\":\"25507\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CHALECO SEG GPO CINTA REF GRIS GRI G\",\"legacy_id\":\"9830\",\"observaciones\":null,\"precio\":\"146.3000\",\"precio_error\":null,\"precio_original\":\"146.3000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(265,4,'fc2','productos','15','9831','items','80','afc2fd80194f6d9192e0b53834b2cd761c5e491f9ff5ecf5001de97f9a97a6a4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CHALECO XG\",\"clave_prod_serv\":\"46181507\",\"clave_prod_serv_id\":\"25507\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CHALECO SEG GPO CINTA REF GRIS GRI XG\",\"legacy_id\":\"9831\",\"observaciones\":null,\"precio\":\"146.3000\",\"precio_error\":null,\"precio_original\":\"146.3000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(266,4,'fc2','productos','15','9832','items','81','fecc5767aeef53cc09575b794dd80a170fae371510411dd397d9dfd8d893bb2c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CHALECO M\",\"clave_prod_serv\":\"46181507\",\"clave_prod_serv_id\":\"25507\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CHALECO SEG GPO CINTA REF GRIS GRI M\",\"legacy_id\":\"9832\",\"observaciones\":null,\"precio\":\"146.3000\",\"precio_error\":null,\"precio_original\":\"146.3000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(267,4,'fc2','productos','15','9929','items','82','f16726009649f2b738345132194085e228ac5c1ca45380a6087bd6c267e0d65e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Dona Plastisol\",\"clave_prod_serv\":\"80141605\",\"clave_prod_serv_id\":\"50881\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Dona plastisol doble vista\",\"legacy_id\":\"9929\",\"observaciones\":null,\"precio\":\"13.0000\",\"precio_error\":null,\"precio_original\":\"13.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(268,4,'fc2','productos','15','9930','items','83','683bb6cf615b489e21e41dea6cbf1afdbbb46acffb763f51e0e9160741e4d24a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Molde Aluminio\",\"clave_prod_serv\":\"11101705\",\"clave_prod_serv_id\":\"7945\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Molde Aluminio\",\"legacy_id\":\"9930\",\"observaciones\":null,\"precio\":\"2600.0000\",\"precio_error\":null,\"precio_original\":\"2600.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(269,4,'fc2','productos','15','9964','items','84','3faa6c304486716b19b1dfcfead28f879e71d9a0a7a6fa9bf7b91e97093473b9',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Aquashoes Unisex\",\"legacy_id\":\"9964\",\"observaciones\":null,\"precio\":\"111.7200\",\"precio_error\":null,\"precio_original\":\"111.7200\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(270,4,'fc2','productos','15','9982','items','85','74ed50b8e5ed17ae0dbe8ad91b68f52cab4981a772c1619bfb29bacbc8175736',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Estaca\",\"clave_prod_serv\":\"30241511\",\"clave_prod_serv_id\":\"13975\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Estaca\",\"legacy_id\":\"9982\",\"observaciones\":null,\"precio\":\"400.0000\",\"precio_error\":null,\"precio_original\":\"400.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(271,4,'fc2','productos','15','9991','items','86','0802289ff19cf7b58d23216017bfca590381866d5bb6678f49b37a1529336ba7',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Cuerda\",\"clave_prod_serv\":\"31151500\",\"clave_prod_serv_id\":\"15076\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"50 metros de cuerda\",\"legacy_id\":\"9991\",\"observaciones\":null,\"precio\":\"18.2700\",\"precio_error\":null,\"precio_original\":\"18.2700\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(272,4,'fc2','productos','15','9992','items','87','41f9e8def63453a56fedd47d47187c11cf0ad963e25ba3b47ff6b629318dc1ce',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Poste\",\"clave_prod_serv\":\"30102904\",\"clave_prod_serv_id\":\"13489\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Poste de madera\",\"legacy_id\":\"9992\",\"observaciones\":null,\"precio\":\"200.0000\",\"precio_error\":null,\"precio_original\":\"200.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(273,4,'fc2','productos','15','10112','items','88','5199aaa626be86322f0485589b78aedcbd9ba4e07a10d6a31ccd7caee734eb78',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"XELS WET DAMA PACIFIC MNO\",\"clave_prod_serv\":\"53102901\",\"clave_prod_serv_id\":\"46777\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"XELS WET DAMA PACIFIC MNO\",\"legacy_id\":\"10112\",\"observaciones\":null,\"precio\":\"401.3600\",\"precio_error\":null,\"precio_original\":\"401.3600\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(274,4,'fc2','productos','15','10113','items','89','a27070aee7bbd989b3ac7d935d4de016026ae84eb5e799ccb326f61e0c6414aa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"XELS WET CAB PACIFIC MNO\",\"clave_prod_serv\":\"53102902\",\"clave_prod_serv_id\":\"46778\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"XELS WET CAB PACIFIC MNO\",\"legacy_id\":\"10113\",\"observaciones\":null,\"precio\":\"346.8400\",\"precio_error\":null,\"precio_original\":\"346.8400\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(275,4,'fc2','productos','15','10116','items','90','d99081741caed3c72cac17b185e688486cefd89b4a50117575370004b393fc5e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Zapatos Aquashoes\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Zapatos Aquashoes\",\"legacy_id\":\"10116\",\"observaciones\":null,\"precio\":\"129.6000\",\"precio_error\":null,\"precio_original\":\"129.6000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(276,4,'fc2','productos','15','10122','items','91','7a52f7b37c5e9403151402091e552cf50f69a6bc3a9209cfbcebc8cb38d3287b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Sandalias\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Sandalias\",\"legacy_id\":\"10122\",\"observaciones\":null,\"precio\":\"450.0000\",\"precio_error\":null,\"precio_original\":\"450.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(277,4,'fc2','productos','15','10123','items','92','cf8f1d92488be32db189e49eca8e06e5362002d083a121061c38c8974f1a7990',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Sandalias\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"X10-UN-BLA\",\"legacy_id\":\"10123\",\"observaciones\":null,\"precio\":\"599.0000\",\"precio_error\":null,\"precio_original\":\"599.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(278,4,'fc2','productos','15','10124','items','93','74515953be97241afb032bd51aa6e52e48c9a38bf6844bacbb3ded6e1ba05f23',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Sandalias\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"X10-UN-BLU\",\"legacy_id\":\"10124\",\"observaciones\":null,\"precio\":\"599.0000\",\"precio_error\":null,\"precio_original\":\"599.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(279,4,'fc2','productos','15','10138','items','94','5cf0628b8533924e0930460399b34a60abfd59cb673d64a8a4dcca8b035676a1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 23\",\"legacy_id\":\"10138\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(280,4,'fc2','productos','15','10139','items','95','f88dbb1431e656fd0d650d4ca8e4677a0b8d5b4e9c17342e39f1c14547eb3a33',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 24\",\"legacy_id\":\"10139\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(281,4,'fc2','productos','15','10140','items','96','c32f662b592fd4024a432d0455bb1fa8121aa3911c188397582ef6700d76959f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 26\",\"legacy_id\":\"10140\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(282,4,'fc2','productos','15','10141','items','97','ee6736bb110ac52436a73f3717a49a8e878dc7792feef3ae4456afce47032f42',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 27\",\"legacy_id\":\"10141\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(283,4,'fc2','productos','15','10142','items','98','039e1b611f268220c1bc8285b48296f5723f6b0cb4c44597c068aad82db1db4a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 28\",\"legacy_id\":\"10142\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(284,4,'fc2','productos','15','10143','items','99','f4172aa92c9794ae2061f080597bb09aed237f8300e8ae7424a595a91302a431',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 29\",\"legacy_id\":\"10143\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(285,4,'fc2','productos','15','10144','items','100','1dcae0f8a7fd031991de79767af090ad494b59926416ca7feb44ac3f40cf803a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Multicolor Negro/Amarillo/Naranja 30\",\"legacy_id\":\"10144\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(286,4,'fc2','productos','15','10145','items','101','bf69ee3e3501d24de0fd32a0d563bfa344a476d2d2f2aff6509471ed02ebbcd5',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111601\",\"clave_prod_serv_id\":\"46794\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Caballero Negro/Azul 26\",\"legacy_id\":\"10145\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(287,4,'fc2','productos','15','10146','items','102','180ccef6b3eafac5ddeb9c596b1924669f9eaf68128825bdec9db5526a742eeb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111601\",\"clave_prod_serv_id\":\"46794\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Caballero Negro/Azul 27\",\"legacy_id\":\"10146\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(288,4,'fc2','productos','15','10147','items','103','6c72478bdee65aed673b87cc810a56dafd27fd44d49001b41913a1602eb58a41',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111601\",\"clave_prod_serv_id\":\"46794\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Caballero Negro/Azul 28\",\"legacy_id\":\"10147\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(289,4,'fc2','productos','15','10148','items','104','23c7da8e22791f38c860f51c877420cf913ff81a8f6d65afdd0b453f03d9a292',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111601\",\"clave_prod_serv_id\":\"46794\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Caballero Negro/Azul 29\",\"legacy_id\":\"10148\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(290,4,'fc2','productos','15','10149','items','105','5d3994c0df247ef536840fb98e0d94f5921e69f49e9b282898ac108721999693',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aquashoes Xels Unisex\",\"clave_prod_serv\":\"53111601\",\"clave_prod_serv_id\":\"46794\",\"clave_unidad\":\"DPR\",\"clave_unidad_id\":\"622\",\"descripcion\":\"Caballero Negro/Azul 30\",\"legacy_id\":\"10149\",\"observaciones\":null,\"precio\":\"274.5000\",\"precio_error\":null,\"precio_original\":\"274.5000\",\"unidad_comercial\":\"PARES\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(291,4,'fc2','productos','15','10449','items','106','9a0919f3da1afffe596b5744803dfa84163618b752ce54ea72e86f01ca10244e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Polo Uniforme\",\"clave_prod_serv\":\"53101602\",\"clave_prod_serv_id\":\"46671\",\"clave_unidad\":\"XUN\",\"clave_unidad_id\":\"2318\",\"descripcion\":\"Playera Polo 50 poliester y 50 algodon\",\"legacy_id\":\"10449\",\"observaciones\":null,\"precio\":\"344.0000\",\"precio_error\":null,\"precio_original\":\"344.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(292,4,'fc2','productos','15','10488','items','107','ddac6b52bca6cf3ceeb4606abb4bdf0d2259083fa85e4ab568794e3d5d0409cc',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ARETES\",\"clave_prod_serv\":\"54101604\",\"clave_prod_serv_id\":\"46975\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SET DE ARETES - SET DE ARETES PARA HOSTESS\",\"legacy_id\":\"10488\",\"observaciones\":null,\"precio\":\"100.0000\",\"precio_error\":null,\"precio_original\":\"100.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(293,4,'fc2','productos','15','10515','items','108','56ee190d675786b94ee4dc531745cf22a967def1144f677e4562802ccf7964e3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pendones\",\"clave_prod_serv\":\"55121714\",\"clave_prod_serv_id\":\"47112\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Pendones 1.5 x 4.00 M\",\"legacy_id\":\"10515\",\"observaciones\":null,\"precio\":\"3045.0000\",\"precio_error\":null,\"precio_original\":\"3045.0000\",\"unidad_comercial\":\"Pendones\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(294,4,'fc2','productos','15','10530','items','109','bb86c25308b2d1601114ed7228d8877cc864fc93b46e7af74d60761596e04ed9',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Reparacion Display\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Reparacion Display\",\"legacy_id\":\"10530\",\"observaciones\":null,\"precio\":\"2000.0000\",\"precio_error\":null,\"precio_original\":\"2000.0000\",\"unidad_comercial\":\"Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(295,4,'fc2','productos','15','10559','items','110','b3b9ff84749a55ee45c426d632d52dd63dacf6edf3728ec2bcab5a4866a1703e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTAS IMPERMEABLE S/CASCO\",\"clave_prod_serv\":\"53111500\",\"clave_prod_serv_id\":\"46787\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTAS IMPERMEABLE S/CASCO\",\"legacy_id\":\"10559\",\"observaciones\":null,\"precio\":\"294.0000\",\"precio_error\":null,\"precio_original\":\"294.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(296,4,'fc2','productos','15','10560','items','111','95ee18b76a3092cad440f619d062307b8e9089b01b4bc7011afc9a94a06646e8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTAS IMPERMEABLE C/CASCO\",\"clave_prod_serv\":\"53111500\",\"clave_prod_serv_id\":\"46787\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTAS IMPERMEABLE C/CASCO\",\"legacy_id\":\"10560\",\"observaciones\":null,\"precio\":\"318.0000\",\"precio_error\":null,\"precio_original\":\"318.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(297,4,'fc2','productos','15','10561','items','112','331b62cfb21262eefe03b799bbd74bb96dd7b28e74248e66b0f51f066101b82f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Bolsas para laptop\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"C62\",\"clave_unidad_id\":\"441\",\"descripcion\":\"Bolsas para laptop personalizada\",\"legacy_id\":\"10561\",\"observaciones\":null,\"precio\":\"536.0000\",\"precio_error\":null,\"precio_original\":\"536.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(298,4,'fc2','productos','15','10604','items','113','d70b9a4cf68af0befd2e735a04b38631de6dd6eddf4492d22ed8ddc967339eb8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Placa de Acero Personalizada\",\"clave_prod_serv\":\"30102204\",\"clave_prod_serv_id\":\"13423\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Placa de Acero Personalizada\",\"legacy_id\":\"10604\",\"observaciones\":null,\"precio\":\"499.0000\",\"precio_error\":null,\"precio_original\":\"499.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(299,4,'fc2','productos','15','10633','items','114','df0f0a7a0632df08a30c5cb6d114cdf58d938e5e48e29dc44c399c6d576eaeef',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Casaca\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Casaca\",\"legacy_id\":\"10633\",\"observaciones\":null,\"precio\":\"251.4400\",\"precio_error\":null,\"precio_original\":\"251.4400\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(300,4,'fc2','productos','15','10637','items','115','c53fb745c3c8b538e84cf0cc44f965161648eea624eabac8cb6a08e4aea9931f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Manteles Sublimados\",\"clave_prod_serv\":\"52121604\",\"clave_prod_serv_id\":\"46348\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Mantel Licra Sublimado\",\"legacy_id\":\"10637\",\"observaciones\":null,\"precio\":\"1777.4300\",\"precio_error\":null,\"precio_original\":\"1777.4300\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(301,4,'fc2','productos','15','10638','items','116','ea72af963b6bedbfbf558d8673a1d4776e075a9683deea75946c8ae0d4942e99',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Crocs\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Crocs Modelo Classic\",\"legacy_id\":\"10638\",\"observaciones\":null,\"precio\":\"820.0000\",\"precio_error\":null,\"precio_original\":\"820.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(302,4,'fc2','productos','15','10752','items','117','f01baf69d7413ca127e2d9bbe68a013c3d60a30287ce29e2e5ee6553767dd7e6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pines\",\"clave_prod_serv\":\"31163220\",\"clave_prod_serv_id\":\"15543\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Pines\",\"legacy_id\":\"10752\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(303,4,'fc2','productos','15','10764','items','118','d52dbc68dbadea949ce5bfafa4824a62672be36f899a487aef29b71fb8c76f22',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"IMAN PERSONALIZADO\",\"clave_prod_serv\":\"49101602\",\"clave_prod_serv_id\":\"26115\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"IMAN PERSONALIZADO\",\"legacy_id\":\"10764\",\"observaciones\":null,\"precio\":\"44.0000\",\"precio_error\":null,\"precio_original\":\"44.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(304,4,'fc2','productos','15','10769','items','119','c73925afb7a37a6de98bafef3d5e2d2d3e5af755d24e8fa1a8f3b3a38b05796d',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"buffs\",\"clave_prod_serv\":\"46181550\",\"clave_prod_serv_id\":\"25541\",\"clave_unidad\":\"XUN\",\"clave_unidad_id\":\"2318\",\"descripcion\":\"Buffs\",\"legacy_id\":\"10769\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(305,4,'fc2','productos','15','10772','items','120','7d64eda34b7863e9bb3afd8bbc9a36cd04b8ab46035bc15c2eb37929c3e08de7',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LANYARDS\",\"clave_prod_serv\":\"55121804\",\"clave_prod_serv_id\":\"47134\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LANYARDS\",\"legacy_id\":\"10772\",\"observaciones\":null,\"precio\":\"121.7000\",\"precio_error\":null,\"precio_original\":\"121.7000\",\"unidad_comercial\":\"Lanyards\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(306,4,'fc2','productos','15','10782','items','121','ed81061d56149a8ca0a0be74f092a0d642e4a8dadabc51287a530885dbff800e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"COLCHON\",\"clave_prod_serv\":\"56101508\",\"clave_prod_serv_id\":\"47155\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"COLCHON\",\"legacy_id\":\"10782\",\"observaciones\":null,\"precio\":\"4990.0000\",\"precio_error\":null,\"precio_original\":\"4990.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(307,4,'fc2','productos','15','10810','items','122','49606b995cf898f5b01b15eb3e7fb18fdaa96f78a59a569c322e5872773c2812',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Computadora escritorio\",\"clave_prod_serv\":\"43211507\",\"clave_prod_serv_id\":\"24119\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"COMPU\",\"legacy_id\":\"10810\",\"observaciones\":null,\"precio\":\"15000.0000\",\"precio_error\":null,\"precio_original\":\"15000.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(308,4,'fc2','productos','15','10823','items','123','7ca1981a9b6f7f2b88d44b12fdd3f6ba6e9ede3f6a20a08f81f51fda8808fb88',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CHALECOUNI\",\"clave_prod_serv\":\"46181507\",\"clave_prod_serv_id\":\"25507\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Chaleco Elastico Reflejante Doble Vista\",\"legacy_id\":\"10823\",\"observaciones\":null,\"precio\":\"210.0000\",\"precio_error\":null,\"precio_original\":\"210.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(309,4,'fc2','productos','15','10826','items','124','f5716a9fb4c6ae5c307c6b9ec0f50ead7fb6e4aadbb717741a886c38e568c40f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CHALECO MESH\",\"clave_prod_serv\":\"53103100\",\"clave_prod_serv_id\":\"46783\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CHALECO VIAL MESH SUBLIMADO\",\"legacy_id\":\"10826\",\"observaciones\":null,\"precio\":\"576.9200\",\"precio_error\":null,\"precio_original\":\"576.9200\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(310,4,'fc2','productos','15','10859','items','125','ecd1354193e8464eba271e9bb96f0f2c6a55f4c2b399cfa1c7d3324be9f46378',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTINAGUJETA\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTIN DAMA\",\"legacy_id\":\"10859\",\"observaciones\":null,\"precio\":\"386.0000\",\"precio_error\":null,\"precio_original\":\"386.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(311,4,'fc2','productos','15','10959','items','126','b83c6fdd61842623873153d4f316ee6f65cd3d12857652baf5971db6f37db564',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Kit Promocionales\",\"clave_prod_serv\":\"82101500\",\"clave_prod_serv_id\":\"51215\",\"clave_unidad\":\"KT\",\"clave_unidad_id\":\"1350\",\"descripcion\":\"material promocional\",\"legacy_id\":\"10959\",\"observaciones\":null,\"precio\":\"58.4900\",\"precio_error\":null,\"precio_original\":\"58.4900\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(312,4,'fc2','productos','15','11045','items','127','4a6a6cd6f52aff3c5054ea31d804b69cce7fee6402ab14150709d3051c638fe6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TROVISEL\",\"clave_prod_serv\":\"82101500\",\"clave_prod_serv_id\":\"51215\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"COPETE SOBRE TROVISEL\",\"legacy_id\":\"11045\",\"observaciones\":null,\"precio\":\"240.0000\",\"precio_error\":null,\"precio_original\":\"240.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(313,4,'fc2','productos','15','11046','items','128','f07af01031e290b99c2ca2a943dfb88fc6bb9a2809184b937e5c040d5e1ffa7a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"INFLABLE GIRATORIO\",\"clave_prod_serv\":\"60141012\",\"clave_prod_serv_id\":\"48748\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"INFLABLE GIRATORIO PERSONALIZADO\",\"legacy_id\":\"11046\",\"observaciones\":null,\"precio\":\"26000.0000\",\"precio_error\":null,\"precio_original\":\"26000.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(314,4,'fc2','productos','15','11077','items','129','d1dbefef0e57c62b05cee2819a312db3edebf87aa53378f10ebcf5986ebe410e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Impresion para casco\",\"clave_prod_serv\":\"82121504\",\"clave_prod_serv_id\":\"51338\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"impresion para casco\",\"legacy_id\":\"11077\",\"observaciones\":null,\"precio\":\"700.0000\",\"precio_error\":null,\"precio_original\":\"700.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(315,4,'fc2','productos','15','11146','items','130','a004ba608d8663c7aa3e10bccc11d8d09b263a809e671278050f0695f5f539c4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SOM PREM\",\"clave_prod_serv\":\"53102503\",\"clave_prod_serv_id\":\"46728\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SOMBRERO DRY FIT\",\"legacy_id\":\"11146\",\"observaciones\":null,\"precio\":\"380.0000\",\"precio_error\":null,\"precio_original\":\"380.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(316,4,'fc2','productos','15','11172','items','131','ba626fced6141c89ec6e939e8af0a0a57bd54c3569637f36d651d71161f5d300',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LENTES DE SOL\",\"clave_prod_serv\":\"42142905\",\"clave_prod_serv_id\":\"21335\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LENTES DE SOL\",\"legacy_id\":\"11172\",\"observaciones\":null,\"precio\":\"120.0000\",\"precio_error\":null,\"precio_original\":\"120.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(317,4,'fc2','productos','15','11176','items','132','02ed9c22880f024fe708f263e5ea984a867dd78eb800cd671fe2fab907583293',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"mochila impermeable\",\"clave_prod_serv\":\"53121500\",\"clave_prod_serv_id\":\"46829\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"mochila impermeable\",\"legacy_id\":\"11176\",\"observaciones\":null,\"precio\":\"600.0000\",\"precio_error\":null,\"precio_original\":\"600.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(318,4,'fc2','productos','15','11177','items','133','2691ab7a86c002c034d2cd4e208eea39363a84567946912c60c4ac9f8e40bbdf',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Gorra o Sombrero\",\"clave_prod_serv\":\"53102503\",\"clave_prod_serv_id\":\"46728\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Gorra o sombrero\",\"legacy_id\":\"11177\",\"observaciones\":null,\"precio\":\"99.0000\",\"precio_error\":null,\"precio_original\":\"99.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(319,4,'fc2','productos','15','11178','items','134','98f77df4430b2094fb4b82226c8d86592da00dcf6e29c077ab6e8a1dcdb4c505',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Bota de piel con casquillo\",\"clave_prod_serv\":\"46181604\",\"clave_prod_serv_id\":\"25548\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Bota de piel con casquillo\",\"legacy_id\":\"11178\",\"observaciones\":null,\"precio\":\"750.0000\",\"precio_error\":null,\"precio_original\":\"750.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(320,4,'fc2','productos','15','11201','items','135','f33f371daf065b348da60c9f8098ccd4a6296a8ccebf3a4f5448e987cc4d5d87',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"FAJA\",\"clave_prod_serv\":\"42241811\",\"clave_prod_serv_id\":\"22772\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"FAJAS\",\"legacy_id\":\"11201\",\"observaciones\":null,\"precio\":\"240.0000\",\"precio_error\":null,\"precio_original\":\"240.0000\",\"unidad_comercial\":\"FAJA\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(321,4,'fc2','productos','15','11246','items','136','16252b2bcb39ad9b95ee91729b0727d2c7013eabe8bcf9f5ecc4bfd9c524c1fb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Placas con logo\",\"clave_prod_serv\":\"30102204\",\"clave_prod_serv_id\":\"13423\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Servicio de elaboración de placas con logo.\",\"legacy_id\":\"11246\",\"observaciones\":null,\"precio\":\"1000.0000\",\"precio_error\":null,\"precio_original\":\"1000.0000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(322,4,'fc2','productos','15','11249','items','137','dfa8038234f55b2364bb1b85945120dda4afc02d9985cb14942dd7b56ac7805b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Elaboracion de parche\",\"clave_prod_serv\":\"82141507\",\"clave_prod_serv_id\":\"51384\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Elaboración de parche\",\"legacy_id\":\"11249\",\"observaciones\":null,\"precio\":\"22.0000\",\"precio_error\":null,\"precio_original\":\"22.0000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(323,4,'fc2','productos','15','11361','items','138','e92bff1989f6aa89259c221a4499db8e4d09e5796f1af4c3d3810278d101d89f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOYA\",\"clave_prod_serv\":\"46161509\",\"clave_prod_serv_id\":\"25392\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"REDUCTOR DE VELOCIDAD PLASTICO INDUSTRIAL\",\"legacy_id\":\"11361\",\"observaciones\":null,\"precio\":\"145.0000\",\"precio_error\":null,\"precio_original\":\"145.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(324,4,'fc2','productos','15','11362','items','139','a7c3baf8290a704a1afc6648491bad98cf49867c2df051c88579ec626bf4e87a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Calzado Deportivo Xels\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Calzado Deportivo Xels\",\"legacy_id\":\"11362\",\"observaciones\":null,\"precio\":\"650.0000\",\"precio_error\":null,\"precio_original\":\"650.0000\",\"unidad_comercial\":\"par\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(325,4,'fc2','productos','15','11382','items','140','00afeda7b89609625467ea11085589b822547424f83925a1831e11db48f15dc6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Vasos personalizados\",\"clave_prod_serv\":\"48101919\",\"clave_prod_serv_id\":\"26045\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"cubeta 4 litros\",\"legacy_id\":\"11382\",\"observaciones\":null,\"precio\":\"49.0000\",\"precio_error\":null,\"precio_original\":\"49.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(326,4,'fc2','productos','15','11391','items','141','8abe62c783cfee23f224cea3c16f18d2b471ce4b246231776d2c8f24f0895034',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Porta latas\",\"clave_prod_serv\":\"55121807\",\"clave_prod_serv_id\":\"47136\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Porta Latas de Neopreno\",\"legacy_id\":\"11391\",\"observaciones\":null,\"precio\":\"34.0000\",\"precio_error\":null,\"precio_original\":\"34.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(327,4,'fc2','productos','15','11400','items','142','06dbd58a29da9adb76ecc0f256d90b7267272cc2a8f5887ccbb513b925f008ac',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"bolsa manta\",\"clave_prod_serv\":\"24111500\",\"clave_prod_serv_id\":\"11144\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Bolsa de manta\",\"legacy_id\":\"11400\",\"observaciones\":null,\"precio\":\"49.0000\",\"precio_error\":null,\"precio_original\":\"49.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(328,4,'fc2','productos','15','11402','items','143','aa572bd300a4bcbb068408198bb4ece0480207853f1076e4cd3f5c36680aa081',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Derechos de autor\",\"clave_prod_serv\":\"82111701\",\"clave_prod_serv_id\":\"51252\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Regalias por derechos de autor\",\"legacy_id\":\"11402\",\"observaciones\":null,\"precio\":\"249504.0000\",\"precio_error\":null,\"precio_original\":\"249504.0000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(329,4,'fc2','productos','15','11404','items','144','29229177bfef64f21b28a74a3e3db042005e35ff97bb6461f75b2bd9dec28e23',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Spaguetti flotador espuma\",\"clave_prod_serv\":\"20121302\",\"clave_prod_serv_id\":\"9357\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Spaguetti flotador espuma\",\"legacy_id\":\"11404\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(330,4,'fc2','productos','15','11405','items','145','2f3e392e2363e7574a3f897e25e91a9f5c2fbeca9e02182882c88785e584d5a3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Bolsa de playa de malla\",\"clave_prod_serv\":\"24111500\",\"clave_prod_serv_id\":\"11144\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Bolsa de playa de malla\",\"legacy_id\":\"11405\",\"observaciones\":null,\"precio\":\"80.0000\",\"precio_error\":null,\"precio_original\":\"80.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(331,4,'fc2','productos','15','11406','items','146','03a6931f74847ac0742c78d43909180a01d98510b39a897ad72a7bd45b2ad5c1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Tabla natacion\",\"clave_prod_serv\":\"49221533\",\"clave_prod_serv_id\":\"26412\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Tabla natacion\",\"legacy_id\":\"11406\",\"observaciones\":null,\"precio\":\"200.0000\",\"precio_error\":null,\"precio_original\":\"200.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(332,4,'fc2','productos','15','11407','items','147','2c291bbae9f799be4f3cb420751bcedd59707742505c5c33bc9cf21c36c0e6d2',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aros flotadores\",\"clave_prod_serv\":\"23151910\",\"clave_prod_serv_id\":\"10327\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Aros flotadores\",\"legacy_id\":\"11407\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(333,4,'fc2','productos','15','11408','items','148','5247f4eab19a1941a8cd77761b647507323781dde1925c75b35de6e8e4ddb4a6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Mascara Snorkel\",\"clave_prod_serv\":\"01010101\",\"clave_prod_serv_id\":\"1\",\"clave_unidad\":\"18\",\"clave_unidad_id\":\"1\",\"descripcion\":\"Careta Snorkel\",\"legacy_id\":\"11408\",\"observaciones\":null,\"precio\":\"820.0000\",\"precio_error\":null,\"precio_original\":\"820.0000\",\"unidad_comercial\":\"Pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(334,4,'fc2','productos','15','11413','items','149','e2bd54fe6bb4c9bdcbcbb1903652837ba4d53431d5142cb41bd37d96e60c89ba',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Spaguetti flotador\",\"clave_prod_serv\":\"49221533\",\"clave_prod_serv_id\":\"26412\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Spaguetti flotador\",\"legacy_id\":\"11413\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:09','2026-08-04 19:24:09','2026-08-04 19:31:16'),(335,4,'fc2','productos','15','11414','items','150','261d4e891cf4c5e475658d5c5f39f8b64931ed6e9cc26036a2719b97d85ffcbe',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Aros flotadores\",\"clave_prod_serv\":\"49221533\",\"clave_prod_serv_id\":\"26412\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Aros flotadores\",\"legacy_id\":\"11414\",\"observaciones\":null,\"precio\":\"70.0000\",\"precio_error\":null,\"precio_original\":\"70.0000\",\"unidad_comercial\":\"pieza\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(336,4,'fc2','productos','15','11423','items','151','d5d77269cc2d3e2888e988c24e164e96cfea31f8aaa564e5c0ba93005d16872c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Calzado deportivo\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"Tennis tejido antiderrapante\",\"legacy_id\":\"11423\",\"observaciones\":null,\"precio\":\"800.0000\",\"precio_error\":null,\"precio_original\":\"800.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(337,4,'fc2','productos','15','11426','items','152','18c56b8e18cb11f9738622ece02ef8f75fc52cbdacc8783dadaab4f24923fb61',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Llavero Sublimado\",\"clave_prod_serv\":\"49101602\",\"clave_prod_serv_id\":\"26115\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Llavero sublimado personalizable\",\"legacy_id\":\"11426\",\"observaciones\":null,\"precio\":\"20.0000\",\"precio_error\":null,\"precio_original\":\"20.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(338,4,'fc2','productos','15','11428','items','153','d41f77da91a81aa35f54e2c21a085e06569c9abe1722f5fa22b0236f680f8346',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Bandana de mascota con collar\",\"clave_prod_serv\":\"10111300\",\"clave_prod_serv_id\":\"50\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Bandana sublimada para mascota\",\"legacy_id\":\"11428\",\"observaciones\":null,\"precio\":\"177.0000\",\"precio_error\":null,\"precio_original\":\"177.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(339,4,'fc2','productos','15','11430','items','154','fe29bfc18a1b1b7d87e3b85f7d55a41a87d40180c25200246a95be247dc26427',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Facturación de anticipos\",\"clave_prod_serv\":\"84111506\",\"clave_prod_serv_id\":\"51542\",\"clave_unidad\":\"ACT\",\"clave_unidad_id\":\"241\",\"descripcion\":\"El precio se debe poner correspondiente al anticipo que se realizo\",\"legacy_id\":\"11430\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(340,4,'fc2','productos','15','11432','items','155','5d1d940e44a89ab82232f2b3f69db5b3eee4923c10e57d25f7a7e20805504c33',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PLAYERA DRY FIT\",\"clave_prod_serv\":\"53102902\",\"clave_prod_serv_id\":\"46778\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"DRY FIT REGULAR\",\"legacy_id\":\"11432\",\"observaciones\":null,\"precio\":\"250.0000\",\"precio_error\":null,\"precio_original\":\"250.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(341,4,'fc2','productos','15','11433','items','156','edc3fc8ba9391a175fdbd00345fda78cb92416ac35d57b5402e1114954085e69',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LAPICEROS PERSONALIZADOS\",\"clave_prod_serv\":\"44121705\",\"clave_prod_serv_id\":\"24930\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LAPICEROS PERSONALIZADOS\",\"legacy_id\":\"11433\",\"observaciones\":null,\"precio\":\"19.0000\",\"precio_error\":null,\"precio_original\":\"19.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(342,4,'fc2','productos','15','11436','items','157','8b058a5c098d1c2cb7caf78d46e0e9e82d62fda16606dbe3725b06aa456b71a1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"IMPERMEABLE\",\"clave_prod_serv\":\"46181543\",\"clave_prod_serv_id\":\"25534\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"IMPERMEABLE ADULTO\",\"legacy_id\":\"11436\",\"observaciones\":null,\"precio\":\"150.0000\",\"precio_error\":null,\"precio_original\":\"150.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(343,4,'fc2','productos','15','11437','items','158','72c42dbeabbc58389326a60a93735296c50e5dfc490771c74a37261a510c25f4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Pantunflas\",\"clave_prod_serv\":\"53111702\",\"clave_prod_serv_id\":\"46801\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"PANTUNFLAS\",\"legacy_id\":\"11437\",\"observaciones\":null,\"precio\":\"280.0000\",\"precio_error\":null,\"precio_original\":\"280.0000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(344,4,'fc2','productos','15','11440','items','159','875b88f6db7b463fbe84cb83f50253c6958835d24f2cb342c45edb5d1c061784',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Stiker\",\"clave_prod_serv\":\"60121015\",\"clave_prod_serv_id\":\"48174\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Stiker\",\"legacy_id\":\"11440\",\"observaciones\":null,\"precio\":\"7.5000\",\"precio_error\":null,\"precio_original\":\"7.5000\",\"unidad_comercial\":\"1\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(345,4,'fc2','productos','15','11594','items','160','2d161a34e281e49b0cf1325afeea219275e1fcb8bdb233b4097a344f0341b85f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Hamaca de alberca\",\"clave_prod_serv\":\"56101808\",\"clave_prod_serv_id\":\"47225\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Hamacas para Alberca (Inflable)\",\"legacy_id\":\"11594\",\"observaciones\":null,\"precio\":\"100.0000\",\"precio_error\":null,\"precio_original\":\"100.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(346,4,'fc2','productos','15','11627','items','161','787b61ea5773bfb870c7c77d9528a1ddddcf8e5c2179369a8d08cc1a61c4aa54',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOLSAS TEJIDAS\",\"clave_prod_serv\":\"53121600\",\"clave_prod_serv_id\":\"46833\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BOLSAS TEJIDAS\",\"legacy_id\":\"11627\",\"observaciones\":null,\"precio\":\"190.0000\",\"precio_error\":null,\"precio_original\":\"190.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(347,4,'fc2','productos','15','11655','items','162','8fe6af5ed8953f2f4a8f38de329d922ca6042ad47a3ed7501479fdf2c4490b95',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"MANDIL AHULADO\",\"clave_prod_serv\":\"46181533\",\"clave_prod_serv_id\":\"25524\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"MANDIL AHULADO NEGRO\",\"legacy_id\":\"11655\",\"observaciones\":null,\"precio\":\"150.0000\",\"precio_error\":null,\"precio_original\":\"150.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(348,4,'fc2','productos','15','11658','items','163','68f4eacaca942ae979a9af80a25110b10a9f1f39bcc2aa77eacad16d980712a5',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TOALLAS DE GOLF\",\"clave_prod_serv\":\"52121702\",\"clave_prod_serv_id\":\"46355\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"TOALLAS DE GOLF PROMOCIONAL WAFLE CHICO\",\"legacy_id\":\"11658\",\"observaciones\":null,\"precio\":\"103.0000\",\"precio_error\":null,\"precio_original\":\"103.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(349,4,'fc2','productos','15','11661','items','164','c6aad2cdfb985f698c937d570841c1cdaa38dd37e53e7093cfd84c19541e5d09',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"STICKERS\",\"clave_prod_serv\":\"60121012\",\"clave_prod_serv_id\":\"48171\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"STICKERS\",\"legacy_id\":\"11661\",\"observaciones\":null,\"precio\":\"130.0000\",\"precio_error\":null,\"precio_original\":\"130.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(350,4,'fc2','productos','15','11662','items','165','bf905e1928a46ab35a7a9317b480b5edf4cbb62904e3614d35f6d88d1733c421',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SEÃ‘ALIZADORES INTERCAMBIABLES\",\"clave_prod_serv\":\"55121700\",\"clave_prod_serv_id\":\"47100\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SEÃ‘ALETICA INTERCAMBIABLE DE ALUMINIO\",\"legacy_id\":\"11662\",\"observaciones\":null,\"precio\":\"1500.0000\",\"precio_error\":null,\"precio_original\":\"1500.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(351,4,'fc2','productos','15','11712','items','166','258dd9f007c3ee032f33f5682ad6085a619e81bdf850552b347a5951b589122e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Botas Camara Fria\",\"clave_prod_serv\":\"46181600\",\"clave_prod_serv_id\":\"25544\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTA CAMARA FRIA ESTILO  6-67 FLEXP01-D\",\"legacy_id\":\"11712\",\"observaciones\":null,\"precio\":\"1100.0000\",\"precio_error\":null,\"precio_original\":\"1100.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(352,4,'fc2','productos','15','11754','items','167','28cf7cb0a43084c09fb570afcec082875e7303c354bae91b50ae0533b33b171c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TIJERA ALUMINIO\",\"clave_prod_serv\":\"44121618\",\"clave_prod_serv_id\":\"24907\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"TIJERA ALUMINIO\",\"legacy_id\":\"11754\",\"observaciones\":null,\"precio\":\"620.0000\",\"precio_error\":null,\"precio_original\":\"620.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(353,4,'fc2','productos','15','11755','items','168','0cb7b9b907468340fab8150438614ca7722e0cf38841226c5e98d54fc8fce97c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CONECTOR DE PLASTICO\",\"clave_prod_serv\":\"40172508\",\"clave_prod_serv_id\":\"18788\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":null,\"legacy_id\":\"11755\",\"observaciones\":null,\"precio\":\"309.0000\",\"precio_error\":null,\"precio_original\":\"309.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(354,4,'fc2','productos','15','11756','items','169','33600d03e8be2ae4f0fbdb63d56e64b19996cea17257d656eefa89127c5f4486',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTAS DE CONGELACION ALTA\",\"clave_prod_serv\":\"46181604\",\"clave_prod_serv_id\":\"25548\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTAS DE CONGELACION ALTA\",\"legacy_id\":\"11756\",\"observaciones\":null,\"precio\":\"1100.0000\",\"precio_error\":null,\"precio_original\":\"1100.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(355,4,'fc2','productos','15','11769','items','170','b605e56062e2fa24c9ae99efaef2d286bd53288000cbe5e1b3b390b6284770be',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"FUNDAS SUN COVER\",\"clave_prod_serv\":\"56101900\",\"clave_prod_serv_id\":\"47231\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"FUNDAS SUN COVER\",\"legacy_id\":\"11769\",\"observaciones\":null,\"precio\":\"2300.0000\",\"precio_error\":null,\"precio_original\":\"2300.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(356,4,'fc2','productos','15','11770','items','171','2f6191e0d21b597f46118a2a79074130e3d0f8150148a1d2d28042a1d6d1a8fb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOLSA TEJIDO TEXTIL\",\"clave_prod_serv\":\"11161804\",\"clave_prod_serv_id\":\"8156\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BOLSA TEJIDO TEXTIL\",\"legacy_id\":\"11770\",\"observaciones\":null,\"precio\":\"240.0000\",\"precio_error\":null,\"precio_original\":\"240.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(357,4,'fc2','productos','15','11771','items','172','730c5574b28df0d5438e5ffc44f54433e5a651c4c52d044fc57e786f3f2cf858',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOLSA DE MANTA\",\"clave_prod_serv\":\"24111513\",\"clave_prod_serv_id\":\"11156\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BOLSAS DE MANTA\",\"legacy_id\":\"11771\",\"observaciones\":null,\"precio\":\"16.1000\",\"precio_error\":null,\"precio_original\":\"16.1000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(358,4,'fc2','productos','15','11772','items','173','e92d42e72d86b3dcc9607bd7bb822fae2c00e91067dcd120fa00b46689f07818',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CALZADO P/ CAMARISTA DAMA\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"CALZADO P/ CAMARISTA DAMA COLOR CAFE\",\"legacy_id\":\"11772\",\"observaciones\":null,\"precio\":\"986.2300\",\"precio_error\":null,\"precio_original\":\"986.2300\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(359,4,'fc2','productos','15','11773','items','174','117535a715ceeb51c9159e60b9a2cc0d5d55a60a13dd7783b4f26ee387446e95',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CALZADO P/ CAMARISTO CABALLERO\",\"clave_prod_serv\":\"53111600\",\"clave_prod_serv_id\":\"46793\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"CALZADO P/ CAMARISTO CABALLERO COLOR CAFE\",\"legacy_id\":\"11773\",\"observaciones\":null,\"precio\":\"910.0000\",\"precio_error\":null,\"precio_original\":\"910.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(360,4,'fc2','productos','15','11774','items','175','0fcddfc4276702f5e8e55fdea29b2946c6db8911308d0b2809ec4c9ec57b8460',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTA DIELECTRICA\",\"clave_prod_serv\":\"46181604\",\"clave_prod_serv_id\":\"25548\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTA DIELECTRICA\",\"legacy_id\":\"11774\",\"observaciones\":null,\"precio\":\"699.0000\",\"precio_error\":null,\"precio_original\":\"699.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(361,4,'fc2','productos','15','11775','items','176','ad335b9663bd436ce6cd8cb63ab0931568d4375d7893bd16bc48a8cc002eb3a3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"EVENTO MONTELOBOS NAVIKA\",\"clave_prod_serv\":\"80141607\",\"clave_prod_serv_id\":\"50883\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"EVENTO MONTELOBOS NAVIKA\",\"legacy_id\":\"11775\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":null,\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(362,4,'fc2','productos','15','11781','items','177','35b5012ff194e8a9ea9acca091c924b5f83602ad87ed7720c7213647671c80db',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Postes de Aluminio\",\"clave_prod_serv\":\"30102903\",\"clave_prod_serv_id\":\"13488\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Poste de Aluminio para Bandera\",\"legacy_id\":\"11781\",\"observaciones\":null,\"precio\":\"770.0000\",\"precio_error\":null,\"precio_original\":\"770.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(363,4,'fc2','productos','15','11782','items','178','644c990ef5310338d514c096db0ab4d75c590f8352ddb1d0407263d247c0c1d8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Artesania Alebrijes\",\"clave_prod_serv\":\"60124102\",\"clave_prod_serv_id\":\"48494\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Artesania Alebrijes\",\"legacy_id\":\"11782\",\"observaciones\":null,\"precio\":\"150.0000\",\"precio_error\":null,\"precio_original\":\"150.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(364,4,'fc2','productos','15','11784','items','179','d271f2945bcc731c22fa4ab0eb1a3898e0190a9d27068d21c1c8dc4244c0ee68',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Servicio ReparaciÃ³n Playeras\",\"clave_prod_serv\":\"82121510\",\"clave_prod_serv_id\":\"51344\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Servicio ReparaciÃ³n Playeras DTF\",\"legacy_id\":\"11784\",\"observaciones\":null,\"precio\":\"38.5000\",\"precio_error\":null,\"precio_original\":\"38.5000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(365,4,'fc2','productos','15','11785','items','180','a0b5c691772218e7b8be0236fca9c04662cf1e2002556b0a1c29d28786d213e8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"MONEDA\",\"clave_prod_serv\":\"60124400\",\"clave_prod_serv_id\":\"48523\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"MONEDA FIGURA CACAO\",\"legacy_id\":\"11785\",\"observaciones\":null,\"precio\":\"42.0000\",\"precio_error\":null,\"precio_original\":\"42.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(366,4,'fc2','productos','15','11786','items','181','dd12995b72dc3df8bf4d9351cb494ef55fab7c16bee3cf8c9a54a69b0b653792',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Lonas Publicitarias\",\"clave_prod_serv\":\"82121505\",\"clave_prod_serv_id\":\"51339\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Lon Mesh Medida 2X3\",\"legacy_id\":\"11786\",\"observaciones\":null,\"precio\":\"2300.0000\",\"precio_error\":null,\"precio_original\":\"2300.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(367,4,'fc2','productos','15','11787','items','182','127364c331f1dc779474fd099f0c21edbb354b736adf5eb1d39175a03ee28f77',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOLSAS DE ROLL UP\",\"clave_prod_serv\":\"45101700\",\"clave_prod_serv_id\":\"25046\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BOLSAS DE ROLL UP\",\"legacy_id\":\"11787\",\"observaciones\":null,\"precio\":\"228.0000\",\"precio_error\":null,\"precio_original\":\"228.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(368,4,'fc2','productos','15','11788','items','183','def735b548be1e2cb4cd9b37217d762ba667e79d834e91424f4be13099e169ff',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOLSAS DE MURO\",\"clave_prod_serv\":\"45101700\",\"clave_prod_serv_id\":\"25046\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BOLSAS DE MURO\",\"legacy_id\":\"11788\",\"observaciones\":null,\"precio\":\"391.0000\",\"precio_error\":null,\"precio_original\":\"391.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(369,4,'fc2','productos','15','11789','items','184','558cc272218e20c16bf5ac225a063a95cd2bff68e67902b0fc6eb1f0fa65aef4',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Estructura Tubular Colgante\",\"clave_prod_serv\":\"60121900\",\"clave_prod_serv_id\":\"48382\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Estructura Tubular Colgante con Tela\",\"legacy_id\":\"11789\",\"observaciones\":null,\"precio\":\"18000.0000\",\"precio_error\":null,\"precio_original\":\"18000.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(370,4,'fc2','productos','15','11790','items','185','a3cfb698df9707e5404ef29c32f00c7b185176840ca580b0b570ac311e39ad89',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SHAKER ALUMINIO 350ML\",\"clave_prod_serv\":\"52151504\",\"clave_prod_serv_id\":\"46461\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SHAKER ALUMINIO 350ML\",\"legacy_id\":\"11790\",\"observaciones\":null,\"precio\":\"275.0000\",\"precio_error\":null,\"precio_original\":\"275.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(371,4,'fc2','productos','15','11791','items','186','722090ee2a58d588bac58e4db14623ef3141a1fd1909b4a0bfd094caeb592464',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"COSTER DE PIEL\",\"clave_prod_serv\":\"52151600\",\"clave_prod_serv_id\":\"46465\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"COSTER DE PIEL SIN COSTURAS\",\"legacy_id\":\"11791\",\"observaciones\":null,\"precio\":\"150.0000\",\"precio_error\":null,\"precio_original\":\"150.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(372,4,'fc2','productos','15','11792','items','187','5fc3d53f58f110f980af116891baa2dedf4af9b10d49f22f080e3e049b781b4e',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TROQUEL\",\"clave_prod_serv\":\"23251810\",\"clave_prod_serv_id\":\"10826\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"TROQUEL\",\"legacy_id\":\"11792\",\"observaciones\":null,\"precio\":\"3000.0000\",\"precio_error\":null,\"precio_original\":\"3000.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(373,4,'fc2','productos','15','11793','items','188','c0c5aabadb00d64d028e2cd19a0529aa6beb2cfdd0f41cc8035141019d34d151',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CAJA ESPECIAL\",\"clave_prod_serv\":\"14111601\",\"clave_prod_serv_id\":\"8982\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CAJA ESPECIAL\",\"legacy_id\":\"11793\",\"observaciones\":null,\"precio\":\"220.0000\",\"precio_error\":null,\"precio_original\":\"220.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(374,4,'fc2','productos','15','11794','items','189','3575a37f47775d4e545276be886f2b47c47d1b6586fd0c9ffec24b12f6821ade',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Impresion Digital\",\"clave_prod_serv\":\"82121503\",\"clave_prod_serv_id\":\"51337\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Grabado Laser\",\"legacy_id\":\"11794\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(375,4,'fc2','productos','15','11795','items','190','4b92d894f3ab9e5d4a8630cdfd74e87de0264b95f5ae8fd7bc17d30cf1c113eb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BASE DE MADERA RECONOCIMIENTO\",\"clave_prod_serv\":\"11122000\",\"clave_prod_serv_id\":\"8048\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"BASE DE MADERA RECONOCIMIENTO\",\"legacy_id\":\"11795\",\"observaciones\":null,\"precio\":\"215.0000\",\"precio_error\":null,\"precio_original\":\"215.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(376,4,'fc2','productos','15','11796','items','191','450dce86296a80fc587beb33734770816112f3e270670629c0ae5839bc5c7a51',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Folders Conferencia\",\"clave_prod_serv\":\"44122032\",\"clave_prod_serv_id\":\"24992\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Folders Conferencia\",\"legacy_id\":\"11796\",\"observaciones\":null,\"precio\":\"350.0000\",\"precio_error\":null,\"precio_original\":\"350.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(377,4,'fc2','productos','15','11797','items','192','9f118ea140a09bac2543aafd465edfeb694447f0d4392ca811610110147f3101',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Servicio Costura Industrial\",\"clave_prod_serv\":\"73141715\",\"clave_prod_serv_id\":\"50215\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"Servicio ponchado\",\"legacy_id\":\"11797\",\"observaciones\":null,\"precio\":\"250.0000\",\"precio_error\":null,\"precio_original\":\"250.0000\",\"unidad_comercial\":\"Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(378,4,'fc2','productos','15','11798','items','193','d5a6cf2d9a4747492758294b3631336888e45462c0b99d45d16c71ceed3a8fe9',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Cesto Palma\",\"clave_prod_serv\":\"60124102\",\"clave_prod_serv_id\":\"48494\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"Cesto Palma\",\"legacy_id\":\"11798\",\"observaciones\":null,\"precio\":\"350.0000\",\"precio_error\":null,\"precio_original\":\"350.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(379,4,'fc2','productos','15','11799','items','194','4cdb10c3f61b0fb19bbecc3e1d62c2b65528f9b91ca815946a389812efffbb62',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"YETI ORIGINAL\",\"clave_prod_serv\":\"52152102\",\"clave_prod_serv_id\":\"46584\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"YETI ORIGINAL CON GRABADO\",\"legacy_id\":\"11799\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(380,4,'fc2','productos','15','11800','items','195','a6793a2829ae32b2f186976cb690476329fa96957a8f6a63fdfdfda7179333a9',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #23\",\"legacy_id\":\"11800\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(381,4,'fc2','productos','15','11801','items','196','f36d784b8b30e9a1972187a9cbeeadc1313f0417bb453a34ed50672b490b22c6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #24\",\"legacy_id\":\"11801\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(382,4,'fc2','productos','15','11802','items','197','966337ebef428cd68053d9f1f56d117cc2bd2416e349b228d69dbb46ddf0801c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #25\",\"legacy_id\":\"11802\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(383,4,'fc2','productos','15','11803','items','198','a8f0f28e2195d4d849b1ca7a7affd179fc56ec1e74b9cec542ffa4b958f63867',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #26\",\"legacy_id\":\"11803\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(384,4,'fc2','productos','15','11804','items','199','cc421ed066f6b8eff6e4093e75e91b057cd5bbed886ab49a7066f544eedf8c2c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #27\",\"legacy_id\":\"11804\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(385,4,'fc2','productos','15','11805','items','200','a7b44e9d1c1401bce107727c92135db9645da9cca5b1f3dc852437e44e440f73',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #28\",\"legacy_id\":\"11805\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(386,4,'fc2','productos','15','11806','items','201','d4843773e818ce0bffd7abb18cbbeb7833887b254f535d5f8f9b09b65f49f852',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER BLANCOS #29\",\"legacy_id\":\"11806\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(387,4,'fc2','productos','15','11807','items','202','33b88629f212a8853d172aa7e200febf41fd25b31613ff16e11ab5a8c58c7697',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #23\",\"legacy_id\":\"11807\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(388,4,'fc2','productos','15','11808','items','203','c2fce977f5d8770a93dae0a9b26bfc793dc48d65ee8e15fa1dd57bce78bf65fa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #24\",\"legacy_id\":\"11808\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(389,4,'fc2','productos','15','11809','items','204','9f7091a2f3d219c1536f731196088f48fe9dc380c2b2f1a6214dc8fdf218abf3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #25\",\"legacy_id\":\"11809\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(390,4,'fc2','productos','15','11810','items','205','931e217223a8e2a7aa0586e7ddb40ea2f0b79a4adb87b619ed3ba86d43741379',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #26\",\"legacy_id\":\"11810\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(391,4,'fc2','productos','15','11811','items','206','77ccb2012160b9ffabac27e5395fc9f5dc7f8571d522051b9f984ce531ef9086',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #27\",\"legacy_id\":\"11811\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(392,4,'fc2','productos','15','11812','items','207','ec0baac8d5c29921c6483e9eb441b19d493d5b400a9dae8e188797fbb088d82c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #28\",\"legacy_id\":\"11812\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(393,4,'fc2','productos','15','11813','items','208','d2e66df9fec45f072c7f87ea34850a0cf004e45dc26a0fd19b81dcc1d8461517',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER AZUL #29\",\"legacy_id\":\"11813\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(394,4,'fc2','productos','15','11814','items','209','f37b4726f682dbb2992b3cfadbd880755d5f29e701f535a09580bb3d428299ef',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #23\",\"legacy_id\":\"11814\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(395,4,'fc2','productos','15','11815','items','210','20c5f2ab78b25e1ca11041a6ee10c4046735fe69d5478abd2fbe31970f93ff42',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #24\",\"legacy_id\":\"11815\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(396,4,'fc2','productos','15','11816','items','211','21e4a31d9072f1e22a9cea6e4d14d32c66da7a2cc5af6d4d48fc5a6589344caa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #25\",\"legacy_id\":\"11816\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(397,4,'fc2','productos','15','11817','items','212','6148b13eca675827d9f4639d2a87bc63399cb5c933923aafe40b5afc7e53fe4c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #26\",\"legacy_id\":\"11817\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(398,4,'fc2','productos','15','11818','items','213','0c603c813ff9f92835e5425354c9e5a625a90cb54d603ef5e4fc5da7f4608ae8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #27\",\"legacy_id\":\"11818\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(399,4,'fc2','productos','15','11819','items','214','9f619627f5145a333263ebd9bf4053810374d364da715a57d2dfe0df60b46377',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #28\",\"legacy_id\":\"11819\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(400,4,'fc2','productos','15','11820','items','215','2a89b5c2251d32fe2f07f1ced758378eb002e79b3534baaa4e768cb23d3918f8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER ROJO #29\",\"legacy_id\":\"11820\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(401,4,'fc2','productos','15','11821','items','216','1bc9354a73b2c209a5d47bd2481deb39a97cb6abad14dde0361876293bf6a45c',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #23\",\"legacy_id\":\"11821\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(402,4,'fc2','productos','15','11822','items','217','0c072ad11793cc69fac245bfec43f8120ee77ba148137aa1cdf9c62d793b4ec3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #24\",\"legacy_id\":\"11822\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(403,4,'fc2','productos','15','11823','items','218','bbcd465336d2a8bb5927459419e809dc481f6dff54fde14f41d0e93a77bc5d7b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #25\",\"legacy_id\":\"11823\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(404,4,'fc2','productos','15','11824','items','219','4446b570757c6fed039eda2138bcb4fe6ad23208bc1b23ae944e887455febeec',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #26\",\"legacy_id\":\"11824\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(405,4,'fc2','productos','15','11825','items','220','2c7c6d382af94963ebbac52f27f9d908777ea83c35bec3f30cee0ebc27850935',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #27\",\"legacy_id\":\"11825\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(406,4,'fc2','productos','15','11826','items','221','96cd49771e021bb2975e854bc3d0edca5abc00ae8bf9f7b9af834c7223c8768f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #28\",\"legacy_id\":\"11826\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(407,4,'fc2','productos','15','11827','items','222','5056abaf3bb450ff0e97928bda71b2e016d612eea8340cd3fa6e759ccadae7f6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER NEGRO #29\",\"legacy_id\":\"11827\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(408,4,'fc2','productos','15','11828','items','223','b167858c28bef444242a2cef25fcfc63edf595a7bbc8934cb6d724a6a221a9a2',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #23\",\"legacy_id\":\"11828\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(409,4,'fc2','productos','15','11829','items','224','a033599bac98e61353418cc01ef0ab517450e2734e628bb7392478a246dee891',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #24\",\"legacy_id\":\"11829\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(410,4,'fc2','productos','15','11830','items','225','0c666495fd622ad3c4e8af3c715ee356b541107186bf9c60fd28c8d5c12c2833',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #25\",\"legacy_id\":\"11830\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(411,4,'fc2','productos','15','11831','items','226','e76ccaef29a1f67b7e59e1c93783e9b284ad3ece2b46ac5540b00c2f290e4f2a',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #26\",\"legacy_id\":\"11831\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(412,4,'fc2','productos','15','11832','items','227','1e6d2d39323202bdf15462f443b3542f550b44c7072bf4c19998dee2ee4e2aee',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #27\",\"legacy_id\":\"11832\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(413,4,'fc2','productos','15','11833','items','228','ccee109d0b0ed51b9427152ea1c89152819bd1f77e4e4959883dafc20f0b081b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #28\",\"legacy_id\":\"11833\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(414,4,'fc2','productos','15','11834','items','229','dca8aa60ebffcae97d8f42d418418e7e87df92b4da0f72bcf777c8197162bc89',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TENIS XELS ACTION LEATHER\",\"clave_prod_serv\":\"53111900\",\"clave_prod_serv_id\":\"46811\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"TENIS XELS ACTION LEATHER CAFE #29\",\"legacy_id\":\"11834\",\"observaciones\":null,\"precio\":\"840.0000\",\"precio_error\":null,\"precio_original\":\"840.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(415,4,'fc2','productos','15','11835','items','230','9a0fd2e164cc8f81a2f8ee9d5bd0d280fb49a125d1960b28a7c007a9d75e473b',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PAÑOS MICROFIBRA\",\"clave_prod_serv\":\"47131502\",\"clave_prod_serv_id\":\"25840\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PAÑOS DE LENTES\",\"legacy_id\":\"11835\",\"observaciones\":null,\"precio\":\"25.0000\",\"precio_error\":null,\"precio_original\":\"25.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(416,4,'fc2','productos','15','11836','items','231','806cfc4fe913373e1102a9ac698e4fb78888fe6649d223bf679bd3c2229e0191',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"FAJAS INDUSTRIALES\",\"clave_prod_serv\":\"46182201\",\"clave_prod_serv_id\":\"25604\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"FAJAS INDUSTRIALES\",\"legacy_id\":\"11836\",\"observaciones\":null,\"precio\":\"96.5000\",\"precio_error\":null,\"precio_original\":\"96.5000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(417,4,'fc2','productos','15','11838','items','232','cfd9f1321a6a28a75b4b9573e43e69460cfc3764af5e3a62ae1e6cf7ccf22eb3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ESTRUCTURA TOLDO 3 X3\",\"clave_prod_serv\":\"30151901\",\"clave_prod_serv_id\":\"13709\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ESTRUCTURA TOLDO 3 X3\",\"legacy_id\":\"11838\",\"observaciones\":null,\"precio\":\"10970.0000\",\"precio_error\":null,\"precio_original\":\"10970.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(418,4,'fc2','productos','15','11839','items','233','c090b7ac9cd9982fda74879670974e9bb3e66ba7712d1522e25d4f51260dcc36',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PULSERAS\",\"clave_prod_serv\":\"54101601\",\"clave_prod_serv_id\":\"46972\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PULSERAS CON AHORCADOR\",\"legacy_id\":\"11839\",\"observaciones\":null,\"precio\":\"6.3000\",\"precio_error\":null,\"precio_original\":\"6.3000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(419,4,'fc2','productos','15','11840','items','234','9eb357d76051594bf8adc18114a4e04a3f716fac6a74b6438fd71cfe48dbaaea',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"GAFETES\",\"clave_prod_serv\":\"55121804\",\"clave_prod_serv_id\":\"47134\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"GAFETES ESTIRENO\",\"legacy_id\":\"11840\",\"observaciones\":null,\"precio\":\"25.0000\",\"precio_error\":null,\"precio_original\":\"25.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(420,4,'fc2','productos','15','11841','items','235','4f8a36d575e85e9bb81efd13fa4ee56e11289bf32e7579231aecf46a3bfae6cb',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SELLOS\",\"clave_prod_serv\":\"60121701\",\"clave_prod_serv_id\":\"48349\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"SELLOS DE GOLF\",\"legacy_id\":\"11841\",\"observaciones\":null,\"precio\":\"4800.0000\",\"precio_error\":null,\"precio_original\":\"4800.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(421,4,'fc2','productos','15','11843','items','236','7600c511d462cd3256c4616aa03032e9d8ac259dcbb1b56d98081bff26457b82',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PORTACOMANDAS\",\"clave_prod_serv\":\"44122003\",\"clave_prod_serv_id\":\"24966\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PORTA COMANDAS\",\"legacy_id\":\"11843\",\"observaciones\":null,\"precio\":\"160.0000\",\"precio_error\":null,\"precio_original\":\"160.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(422,4,'fc2','productos','15','11844','items','237','d0cd3b2e7922b9179dd1fae78666b4a0711428c3568236d6ff62ea43150fdad6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"Servicio de Fabricación\",\"clave_prod_serv\":\"73151503\",\"clave_prod_serv_id\":\"50219\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"RECONOCIMIENTOS TEXTURIZADOS\",\"legacy_id\":\"11844\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(423,4,'fc2','productos','15','11845','items','238','36ae55f8e0c4338546ee9a592ff6ac08f82c7c37564ec0a9ce4de4d65f5f668d',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"NOTAS DE CREDITO\",\"clave_prod_serv\":\"84111506\",\"clave_prod_serv_id\":\"51542\",\"clave_unidad\":\"E48\",\"clave_unidad_id\":\"678\",\"descripcion\":\"NOTAS DE CREDITO\",\"legacy_id\":\"11845\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"Unidad de Servicio\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(424,4,'fc2','productos','15','11846','items','239','fdd0f401281b6b27beae85142de4855b8649450c7292e80effb47b6b099487e3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PAÑUELOS- PALIACATES\",\"clave_prod_serv\":\"53102500\",\"clave_prod_serv_id\":\"46725\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PALIACATES\",\"legacy_id\":\"11846\",\"observaciones\":null,\"precio\":\"150.0000\",\"precio_error\":null,\"precio_original\":\"150.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(425,4,'fc2','productos','15','11848','items','240','ded38211be2b83c78723c1b095091385686ba3162017d737bba9901beb7da58f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ESTROPAJO LUFFA\",\"clave_prod_serv\":\"47131603\",\"clave_prod_serv_id\":\"25845\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ESTROPAJO LUFFA\",\"legacy_id\":\"11848\",\"observaciones\":null,\"precio\":\"23.3000\",\"precio_error\":null,\"precio_original\":\"23.3000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(426,4,'fc2','productos','15','11853','items','241','8a52eb545197d4d5a6100599c89129f4427f12b348a3afdc7ae5f1858472af9f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"ALUCOBOND ALUMINIO\",\"clave_prod_serv\":\"30265000\",\"clave_prod_serv_id\":\"14212\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"ALUCOBOND ALUMINIO\",\"legacy_id\":\"11853\",\"observaciones\":null,\"precio\":\"17600.0000\",\"precio_error\":null,\"precio_original\":\"17600.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(427,4,'fc2','productos','15','11856','items','242','c265cca67088ba5f864fe0b8449121361627a96a811eca37fef38798bc766dbc',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"TORTILLERO OVALADO 17CM\",\"clave_prod_serv\":\"60122300\",\"clave_prod_serv_id\":\"48413\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"TORTILLERO C/TAPA OVALADO 17CM\",\"legacy_id\":\"11856\",\"observaciones\":null,\"precio\":\"462.0000\",\"precio_error\":null,\"precio_original\":\"462.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(428,4,'fc2','productos','15','11857','items','243','01ce48111f7e8be5e90494cb601d4b2e0649192775f7f8a3fd4ece739912dfc7',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PANERA OVALADA 35X20CM\",\"clave_prod_serv\":\"60122300\",\"clave_prod_serv_id\":\"48413\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PANERA OVALADA 35X20CM\",\"legacy_id\":\"11857\",\"observaciones\":null,\"precio\":\"584.7000\",\"precio_error\":null,\"precio_original\":\"584.7000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(429,4,'fc2','productos','15','11858','items','244','74db3e8e9623d132a7a4d8ebccb2d6fb186df3be3beba18bc6c0d14ac07026e3',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"SUMINISTRO DE PISO PVC\",\"clave_prod_serv\":\"30161711\",\"clave_prod_serv_id\":\"13742\",\"clave_unidad\":\"XRO\",\"clave_unidad_id\":\"2278\",\"descripcion\":\"SUMINISTRO DE PISO PVC PARA PISCINA\",\"legacy_id\":\"11858\",\"observaciones\":null,\"precio\":\"8833.5000\",\"precio_error\":null,\"precio_original\":\"8833.5000\",\"unidad_comercial\":\"ROLLO\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(430,4,'fc2','productos','15','11859','items','245','b0f8618868545e081b94a3b4654d9acd9ede1e1ed6489ec8a63296f880da3d42',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LETREROS DE ALUCOBOND\",\"clave_prod_serv\":\"55121700\",\"clave_prod_serv_id\":\"47100\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LETREROS DE ALUCOBOND\",\"legacy_id\":\"11859\",\"observaciones\":null,\"precio\":\"1900.0000\",\"precio_error\":null,\"precio_original\":\"1900.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(431,4,'fc2','productos','15','11860','items','246','0f7230153246e115ad0e0134d8bdadc9ec48007bccb17d79d59dcf189cdc5ab6',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PLAYERAS RASH UV\",\"clave_prod_serv\":\"53102900\",\"clave_prod_serv_id\":\"46776\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PLAYERAS RASH UV\",\"legacy_id\":\"11860\",\"observaciones\":null,\"precio\":\"320.0000\",\"precio_error\":null,\"precio_original\":\"320.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(432,4,'fc2','productos','15','11862','items','247','bef489b84655c8d127d926d31c5514742ff604083d15a6a8bdfbf1a3ddae007f',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PARCHES\",\"clave_prod_serv\":\"53102500\",\"clave_prod_serv_id\":\"46725\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PARCHES XPLOR\",\"legacy_id\":\"11862\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(433,4,'fc2','productos','15','11863','items','248','6222bbf871263566568b918d936f923a537c887e96522e474671c0f4f88c09b8',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"COLLAR ACCESORIO XELS\",\"clave_prod_serv\":\"54101602\",\"clave_prod_serv_id\":\"46973\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"COLLAR ACCESORIO XELS\",\"legacy_id\":\"11863\",\"observaciones\":null,\"precio\":\"390.0000\",\"precio_error\":null,\"precio_original\":\"390.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(434,4,'fc2','productos','15','11864','items','249','353f2de18664b1fb0f8c3d77da5010a9106e4236ad250162c0d94be378005b6d',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CALCOMONIA TATUAJE\",\"clave_prod_serv\":\"60101313\",\"clave_prod_serv_id\":\"47447\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CALCOMONIA TATUAJE\",\"legacy_id\":\"11864\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(435,4,'fc2','productos','15','11865','items','250','d4cffc026ceb47527a79dfa2cbd9fd5b536d899c7293596a94daf3047fb192be',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CESTO LARGO AZUL\",\"clave_prod_serv\":\"60124102\",\"clave_prod_serv_id\":\"48494\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CESTO LARGO AZUL\",\"legacy_id\":\"11865\",\"observaciones\":null,\"precio\":\"1336.0000\",\"precio_error\":null,\"precio_original\":\"1336.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(436,4,'fc2','productos','15','11866','items','251','7e653da0cd028e33478622418144118f1198f8565978b6e06f34f9aa7700bd11',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"CESTO LARGO CORAL\",\"clave_prod_serv\":\"60124102\",\"clave_prod_serv_id\":\"48494\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"CESTO LARGO CORAL\",\"legacy_id\":\"11866\",\"observaciones\":null,\"precio\":\"1336.0000\",\"precio_error\":null,\"precio_original\":\"1336.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(437,4,'fc2','productos','15','11867','items','252','d23770068074af61da0c3f42d5ebc670d26b2a62bea34fbe57c102c6ec81abfa',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"BOTIN INDUSTRIAL BLANCO\",\"clave_prod_serv\":\"46181604\",\"clave_prod_serv_id\":\"25548\",\"clave_unidad\":\"PR\",\"clave_unidad_id\":\"1858\",\"descripcion\":\"BOTIN INDUSTRIAL BLANCO\",\"legacy_id\":\"11867\",\"observaciones\":null,\"precio\":\"683.0000\",\"precio_error\":null,\"precio_original\":\"683.0000\",\"unidad_comercial\":\"PAR\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(438,4,'fc2','productos','15','11868','items','253','8f2a37633cebe9951dd16cd000d86be388fd9d5a7174cce25139a1009fe2c263',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LETRERO MADERA\",\"clave_prod_serv\":\"55121716\",\"clave_prod_serv_id\":\"47114\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LETRERO MADERA\",\"legacy_id\":\"11868\",\"observaciones\":null,\"precio\":\"290.8000\",\"precio_error\":null,\"precio_original\":\"290.8000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(439,4,'fc2','productos','15','11869','items','254','92eb733c7d4134dfb2a29fa7b0cc4554fa78d3b2ab4685ab1106e12c5f10cdc1',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"PANTALONES LIMPIEZA\",\"clave_prod_serv\":\"53102706\",\"clave_prod_serv_id\":\"46759\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"PANTALONES LIMPIEZA ALOTEC\",\"legacy_id\":\"11869\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16'),(440,4,'fc2','productos','15','11870','items','255','16939808f9e4a9810d70ebc3564df053723475f2d1c71c22c369ee20d38b20de',NULL,'skipped','skip','[\"source unchanged\"]','{\"clave_interna\":\"LEGGIN DAMA/CABALLERO LYCRA\",\"clave_prod_serv\":\"46181527\",\"clave_prod_serv_id\":\"25518\",\"clave_unidad\":\"H87\",\"clave_unidad_id\":\"1070\",\"descripcion\":\"LEGGIN DAMA/CABALLERO LYCRA\",\"legacy_id\":\"11870\",\"observaciones\":null,\"precio\":\"0.0000\",\"precio_error\":null,\"precio_original\":\"0.0000\",\"unidad_comercial\":\"PIEZA\",\"users_id\":\"15\"}','2026-08-04 19:24:10','2026-08-04 19:24:10','2026-08-04 19:31:16');
/*!40000 ALTER TABLE `ikontrol_legacy_import_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_likes`
--

DROP TABLE IF EXISTS `ikontrol_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_comment_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_likes`
--

LOCK TABLES `ikontrol_likes` WRITE;
/*!40000 ALTER TABLE `ikontrol_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_messages`
--

DROP TABLE IF EXISTS `ikontrol_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) NOT NULL DEFAULT 'Untitled',
  `message` mediumtext NOT NULL,
  `created_at` datetime NOT NULL,
  `from_user_id` int(11) NOT NULL,
  `to_user_id` int(11) NOT NULL,
  `status` enum('unread','read') NOT NULL DEFAULT 'unread',
  `message_id` int(11) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `files` longtext NOT NULL,
  `deleted_by_users` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message_from` (`from_user_id`),
  KEY `message_to` (`to_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_messages`
--

LOCK TABLES `ikontrol_messages` WRITE;
/*!40000 ALTER TABLE `ikontrol_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_migrations`
--

DROP TABLE IF EXISTS `ikontrol_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_migrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_migrations`
--

LOCK TABLES `ikontrol_migrations` WRITE;
/*!40000 ALTER TABLE `ikontrol_migrations` DISABLE KEYS */;
INSERT INTO `ikontrol_migrations` VALUES (1,'2026-07-21-000000','App\\Database\\Migrations\\RiseAdministrativeBaseline','clean_build','App',1785866321,1),(2,'2026-07-21-010000','App\\Database\\Migrations\\CreateMinimalSatCatalogs','clean_build','App',1785866321,1),(3,'2026-07-21-010100','App\\Database\\Migrations\\ExtendAdministrativeTaxesForFiscalPreparation','clean_build','App',1785866321,1),(4,'2026-07-21-010200','App\\Database\\Migrations\\CreateFiscalProfiles','clean_build','App',1785866321,1),(5,'2026-07-22-020000','App\\Database\\Migrations\\AddEstimateSaleAutomationSetting','clean_build','App',1785866321,1),(6,'2026-07-22-020100','App\\Database\\Migrations\\NormalizeEstimateSaleAutomationSetting','clean_build','App',1785866321,1),(7,'2026-07-23-030000','App\\Database\\Migrations\\CreateSatProductServiceKeys','clean_build','App',1785866321,1),(8,'2026-07-23-030100','App\\Database\\Migrations\\CreateSatUnitKeys','clean_build','App',1785866321,1),(9,'2026-07-23-030200','App\\Database\\Migrations\\CreateSatTaxObjectCodes','clean_build','App',1785866321,1),(10,'2026-07-23-030300','App\\Database\\Migrations\\CreateItemFiscalSettings','clean_build','App',1785866321,1),(11,'2026-07-23-030400','App\\Database\\Migrations\\CreateItemFiscalTaxes','clean_build','App',1785866321,1),(12,'2026-07-23-030500','App\\Database\\Migrations\\AddCompleteFiscalAddressToProfiles','clean_build','App',1785866321,1),(13,'2026-07-24-040000','App\\Database\\Migrations\\ExtendFiscalProfilesForIssuers','clean_build','App',1785866321,1),(14,'2026-07-24-040100','App\\Database\\Migrations\\CreateFiscalSeries','clean_build','App',1785866322,1),(15,'2026-07-25-050000','App\\Database\\Migrations\\AddIssuerTaxPricingPolicy','clean_build','App',1785866322,1),(16,'2026-07-25-050100','App\\Database\\Migrations\\CreateSaleFiscalPricingPreparations','clean_build','App',1785866322,1),(17,'2026-07-26-060000','App\\Database\\Migrations\\CreateFiscalDraftCatalogs','clean_build','App',1785866322,1),(18,'2026-07-26-060100','App\\Database\\Migrations\\CreateFiscalDocuments','clean_build','App',1785866322,1),(19,'2026-07-26-060200','App\\Database\\Migrations\\CreateFiscalDocumentIssuers','clean_build','App',1785866322,1),(20,'2026-07-26-060300','App\\Database\\Migrations\\CreateFiscalDocumentReceivers','clean_build','App',1785866322,1),(21,'2026-07-26-060400','App\\Database\\Migrations\\CreateFiscalDocumentItems','clean_build','App',1785866322,1),(22,'2026-07-26-060500','App\\Database\\Migrations\\CreateFiscalDocumentItemTaxes','clean_build','App',1785866322,1),(23,'2026-07-26-060600','App\\Database\\Migrations\\CreateFiscalDocumentTaxTotals','clean_build','App',1785866322,1),(24,'2026-07-26-060700','App\\Database\\Migrations\\CreateFiscalDocumentMetadataAndAudit','clean_build','App',1785866322,1),(25,'2026-07-27-070000','App\\Database\\Migrations\\CreateFiscalDocumentArtifacts','clean_build','App',1785866322,1),(26,'2026-07-28-080000','App\\Database\\Migrations\\CreateFiscalIssuerCertificatesAndPaymentMappings','clean_build','App',1785866322,1),(27,'2026-07-28-080100','App\\Database\\Migrations\\CreateFiscalDocumentSignatures','clean_build','App',1785866322,1),(28,'2026-07-29-090000','App\\Database\\Migrations\\CreateFiscalPacConfigurations','clean_build','App',1785866322,1),(29,'2026-07-29-090100','App\\Database\\Migrations\\CreateFiscalStampAttempts','clean_build','App',1785866322,1),(30,'2026-07-29-090200','App\\Database\\Migrations\\CreateFiscalDocumentStamps','clean_build','App',1785866322,1),(31,'2026-07-29-090300','App\\Database\\Migrations\\PrepareFiscalStampingStates','clean_build','App',1785866322,1),(32,'2026-07-29-090400','App\\Database\\Migrations\\DeprecateDatabasePacCredentials','clean_build','App',1785866322,1),(33,'2026-07-29-090500','App\\Database\\Migrations\\ExtendTimbradorXpressStampMetadata','clean_build','App',1785866322,1),(34,'2026-07-29-090600','App\\Database\\Migrations\\AddPacErrorGuidance','clean_build','App',1785866322,1),(35,'2026-07-29-090700','App\\Database\\Migrations\\CreateFiscalBinaryArtifacts','clean_build','App',1785866322,1),(36,'2026-07-29-090800','App\\Database\\Migrations\\MigrateFiscalPdfPermissions','clean_build','App',1785866322,1),(37,'2026-07-30-100000','App\\Database\\Migrations\\CreateCsdCertificateSecrets','clean_build','App',1785866322,1),(38,'2026-07-31-110000','App\\Database\\Migrations\\CreateFiscalCancellationWorkflow','clean_build','App',1785866322,1),(39,'2026-08-01-120000','App\\Database\\Migrations\\CreateFiscalPdfProviderWorkflow','clean_build','App',1785866323,1),(40,'2026-08-02-130000','App\\Database\\Migrations\\CreateCommercialFiscalAllocationModel','clean_build','App',1785866323,1),(41,'2026-08-03-140000','App\\Database\\Migrations\\ExtendFiscalDraftWorkflow','clean_build','App',1785866323,1),(42,'2026-08-04-150000','App\\Database\\Migrations\\CreateCommercialLifecycle','clean_build','App',1785866323,1),(43,'2026-08-04-150100','App\\Database\\Migrations\\EnsureCommercialStatusCompatibility','clean_build','App',1785866323,1),(44,'2026-08-04-150200','App\\Database\\Migrations\\CreateFiscalDraftItemTaxes','clean_build','App',1785866323,1),(45,'2026-08-04-150300','App\\Database\\Migrations\\PrepareFiscalDraftStamping','clean_build','App',1785866323,1),(46,'2026-08-04-150400','App\\Database\\Migrations\\AddFiscalIntegrationEnvironment','clean_build','App',1785866323,1),(47,'2026-08-04-160000','App\\Database\\Migrations\\CreateLegacyImportRegistry','clean_build','App',1785866323,1),(48,'2026-08-04-160100','App\\Database\\Migrations\\ConvertItemRateToExactDecimal','clean_build','App',1785866323,1);
/*!40000 ALTER TABLE `ikontrol_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_milestones`
--

DROP TABLE IF EXISTS `ikontrol_milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_milestones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `project_id` int(11) NOT NULL,
  `due_date` date NOT NULL,
  `description` text NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_milestones`
--

LOCK TABLES `ikontrol_milestones` WRITE;
/*!40000 ALTER TABLE `ikontrol_milestones` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_note_category`
--

DROP TABLE IF EXISTS `ikontrol_note_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_note_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_note_category`
--

LOCK TABLES `ikontrol_note_category` WRITE;
/*!40000 ALTER TABLE `ikontrol_note_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_note_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_notes`
--

DROP TABLE IF EXISTS `ikontrol_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `title` text NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `labels` text DEFAULT NULL,
  `files` mediumtext NOT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `category_id` int(11) DEFAULT 0,
  `color` varchar(14) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_notes`
--

LOCK TABLES `ikontrol_notes` WRITE;
/*!40000 ALTER TABLE `ikontrol_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_notification_settings`
--

DROP TABLE IF EXISTS `ikontrol_notification_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_notification_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event` varchar(250) NOT NULL,
  `category` varchar(50) NOT NULL,
  `enable_email` int(11) NOT NULL DEFAULT 0,
  `enable_web` int(11) NOT NULL DEFAULT 0,
  `enable_slack` int(11) NOT NULL DEFAULT 0,
  `notify_to_team` text NOT NULL,
  `notify_to_team_members` text NOT NULL,
  `notify_to_terms` text NOT NULL,
  `sort` int(11) NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `event` (`event`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_notification_settings`
--

LOCK TABLES `ikontrol_notification_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_notification_settings` DISABLE KEYS */;
INSERT INTO `ikontrol_notification_settings` VALUES (1,'project_created','project',0,0,0,'','','',1,0),(2,'project_deleted','project',0,0,0,'','','',2,0),(3,'project_task_created','project',0,1,0,'','','task_assignee,task_collaborators',3,0),(4,'project_task_updated','project',0,1,0,'','','task_assignee,task_collaborators',4,0),(5,'project_task_assigned','project',0,1,0,'','','task_assignee,task_collaborators',5,0),(7,'project_task_started','project',0,0,0,'','','',7,0),(8,'project_task_finished','project',0,0,0,'','','',8,0),(9,'project_task_reopened','project',0,0,0,'','','',9,0),(10,'project_task_deleted','project',0,1,0,'','','task_assignee,task_collaborators',10,0),(11,'project_task_commented','project',0,1,0,'','','task_assignee,task_collaborators,mentioned_members',11,0),(12,'project_member_added','project',0,1,0,'','','project_members',12,0),(13,'project_member_deleted','project',0,1,0,'','','project_members',13,0),(14,'project_file_added','project',0,1,0,'','','project_members',14,0),(15,'project_file_deleted','project',0,1,0,'','','project_members',15,0),(16,'project_file_commented','project',0,1,0,'','','project_members,mentioned_members',16,0),(17,'project_comment_added','project',0,1,0,'','','project_members,mentioned_members',17,0),(18,'project_comment_replied','project',0,1,0,'','','project_members,comment_creator,mentioned_members',18,0),(19,'project_customer_feedback_added','project',0,1,0,'','','project_members,mentioned_members',19,0),(20,'project_customer_feedback_replied','project',0,1,0,'','','project_members,client_primary_contact,comment_creator,mentioned_members',20,0),(21,'client_signup','client',0,0,0,'','','',21,0),(22,'invoice_online_payment_received','invoice',0,0,0,'','','',22,0),(23,'leave_application_submitted','leave',0,0,0,'','','',23,0),(24,'leave_approved','leave',0,1,0,'','','leave_applicant',24,0),(25,'leave_assigned','leave',0,1,0,'','','leave_applicant',25,0),(26,'leave_rejected','leave',0,1,0,'','','leave_applicant',26,0),(27,'leave_canceled','leave',0,0,0,'','','',27,0),(28,'ticket_created','ticket',0,0,0,'','','ticket_assignee',28,0),(29,'ticket_commented','ticket',0,1,0,'','','client_primary_contact,ticket_creator,ticket_assignee',29,0),(30,'ticket_closed','ticket',0,1,0,'','','client_primary_contact,ticket_creator,ticket_assignee',30,0),(31,'ticket_reopened','ticket',0,1,0,'','','client_primary_contact,ticket_creator,ticket_assignee',31,0),(32,'estimate_request_received','estimate',0,0,0,'','','',32,0),(34,'estimate_accepted','estimate',0,0,0,'','','',34,0),(35,'estimate_rejected','estimate',0,0,0,'','','',35,0),(36,'new_message_sent','message',0,0,0,'','','',36,0),(37,'message_reply_sent','message',0,0,0,'','','',37,0),(38,'invoice_payment_confirmation','invoice',0,0,0,'','','',22,0),(39,'new_event_added_in_calendar','event',0,1,0,'','','recipient',39,0),(40,'recurring_invoice_created_vai_cron_job','invoice',0,0,0,'','','client_primary_contact',22,0),(41,'new_announcement_created','announcement',0,1,0,'','','recipient',41,0),(42,'invoice_due_reminder_before_due_date','invoice',0,1,0,'','','client_primary_contact',22,0),(43,'invoice_overdue_reminder','invoice',0,1,0,'','','client_primary_contact',22,0),(44,'recurring_invoice_creation_reminder','invoice',0,0,0,'','','',22,0),(45,'project_completed','project',0,0,0,'','','',2,0),(46,'lead_created','lead',0,0,0,'','','',21,0),(47,'client_created_from_lead','lead',0,0,0,'','','',21,0),(48,'project_task_deadline_pre_reminder','project',0,1,0,'','','task_assignee',20,0),(49,'project_task_reminder_on_the_day_of_deadline','project',0,1,0,'','','task_assignee',20,0),(50,'project_task_deadline_overdue_reminder','project',0,1,0,'','','task_assignee',20,0),(51,'recurring_task_created_via_cron_job','project',0,1,0,'','','project_members,task_assignee',20,0),(52,'calendar_event_modified','event',0,0,0,'','','',39,0),(53,'client_contact_requested_account_removal','client',0,0,0,'','','',21,0),(54,'bitbucket_push_received','project',0,0,0,'','','',45,0),(55,'github_push_received','project',0,0,0,'','','',45,0),(56,'invited_client_contact_signed_up','client',0,0,0,'','','',21,0),(57,'created_a_new_post','timeline',0,0,0,'','','',52,0),(58,'timeline_post_commented','timeline',0,1,0,'','','post_creator',52,0),(59,'ticket_assigned','ticket',0,1,0,'','','ticket_assignee',31,0),(60,'new_order_received','order',0,0,0,'','','',1,0),(61,'order_status_updated','order',0,0,0,'','','',2,0),(62,'proposal_accepted','proposal',0,0,0,'','','',34,0),(63,'proposal_rejected','proposal',0,0,0,'','','',35,0),(64,'estimate_commented','estimate',0,0,0,'','','',35,0),(65,'invoice_manual_payment_added','invoice',0,0,0,'','','',22,0),(66,'contract_accepted','contract',0,0,0,'','','',66,0),(67,'contract_rejected','contract',0,0,0,'','','',67,0),(68,'subscription_request_sent','subscription',0,1,0,'','','client_primary_contact',68,0),(69,'subscription_started','subscription',0,1,0,'','','client_primary_contact',68,0),(70,'subscription_invoice_created_via_cron_job','subscription',0,1,0,'','','client_primary_contact',68,0),(71,'general_task_created','general_task',0,1,0,'','','task_assignee,task_collaborators',69,0),(72,'general_task_updated','general_task',0,1,0,'','','task_assignee,task_collaborators',70,0),(73,'general_task_assigned','general_task',0,1,0,'','','task_assignee,task_collaborators',71,0),(74,'general_task_started','general_task',0,0,0,'','','',72,0),(75,'general_task_finished','general_task',0,0,0,'','','',73,0),(76,'general_task_reopened','general_task',0,0,0,'','','',74,0),(77,'general_task_deleted','general_task',0,1,0,'','','task_assignee,task_collaborators',75,0),(78,'general_task_commented','general_task',0,1,0,'','','task_assignee,task_collaborators,mentioned_members',76,0),(79,'proposal_commented','proposal',0,0,0,'','','',77,0),(80,'subscription_cancelled','subscription',0,0,0,'','','',68,0),(81,'proposal_preview_opened','proposal',0,0,0,'','','',77,0),(82,'proposal_email_opened','proposal',0,0,0,'','','',77,0),(83,'subscription_renewal_reminder','subscription',0,0,0,'','','',68,0);
/*!40000 ALTER TABLE `ikontrol_notification_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_notifications`
--

DROP TABLE IF EXISTS `ikontrol_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime NOT NULL,
  `notify_to` mediumtext NOT NULL,
  `read_by` mediumtext NOT NULL,
  `event` varchar(250) NOT NULL,
  `project_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `project_comment_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `ticket_comment_id` int(11) NOT NULL,
  `project_file_id` int(11) NOT NULL,
  `leave_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `to_user_id` int(11) NOT NULL,
  `activity_log_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `invoice_payment_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `estimate_id` int(11) NOT NULL,
  `contract_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `estimate_request_id` int(11) NOT NULL,
  `actual_message_id` int(11) NOT NULL,
  `parent_message_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `announcement_id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `estimate_comment_id` int(11) NOT NULL,
  `subscription_id` int(11) NOT NULL,
  `expense_id` int(11) NOT NULL,
  `proposal_comment_id` int(11) NOT NULL,
  `reminder_log_id` int(11) NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_notifications`
--

LOCK TABLES `ikontrol_notifications` WRITE;
/*!40000 ALTER TABLE `ikontrol_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_order_items`
--

DROP TABLE IF EXISTS `ikontrol_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `order_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `sort` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by_hash` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_order_items`
--

LOCK TABLES `ikontrol_order_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_order_status`
--

DROP TABLE IF EXISTS `ikontrol_order_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_order_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `color` varchar(7) NOT NULL,
  `sort` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_order_status`
--

LOCK TABLES `ikontrol_order_status` WRITE;
/*!40000 ALTER TABLE `ikontrol_order_status` DISABLE KEYS */;
INSERT INTO `ikontrol_order_status` VALUES (1,'New','#f1c40f',0,0),(2,'Processing','#29c2c2',1,0),(3,'Confirmed','#83c340',2,0);
/*!40000 ALTER TABLE `ikontrol_order_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_orders`
--

DROP TABLE IF EXISTS `ikontrol_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `order_date` date NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `discount_amount` double NOT NULL,
  `discount_amount_type` enum('percentage','fixed_amount') NOT NULL,
  `discount_type` enum('before_tax','after_tax') NOT NULL,
  `created_by` int(11) NOT NULL DEFAULT 0,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `files` longtext NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_by_hash` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_orders`
--

LOCK TABLES `ikontrol_orders` WRITE;
/*!40000 ALTER TABLE `ikontrol_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_pages`
--

DROP TABLE IF EXISTS `ikontrol_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `slug` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `internal_use_only` tinyint(1) NOT NULL DEFAULT 0,
  `visible_to_team_members_only` tinyint(1) NOT NULL DEFAULT 0,
  `visible_to_clients_only` tinyint(1) NOT NULL DEFAULT 0,
  `full_width` tinyint(1) NOT NULL DEFAULT 0,
  `hide_topbar` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_pages`
--

LOCK TABLES `ikontrol_pages` WRITE;
/*!40000 ALTER TABLE `ikontrol_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_payment_methods`
--

DROP TABLE IF EXISTS `ikontrol_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `type` varchar(100) NOT NULL DEFAULT 'custom',
  `description` text NOT NULL,
  `online_payable` tinyint(1) NOT NULL DEFAULT 0,
  `available_on_invoice` tinyint(1) NOT NULL DEFAULT 0,
  `minimum_payment_amount` double NOT NULL DEFAULT 0,
  `settings` longtext NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_payment_methods`
--

LOCK TABLES `ikontrol_payment_methods` WRITE;
/*!40000 ALTER TABLE `ikontrol_payment_methods` DISABLE KEYS */;
INSERT INTO `ikontrol_payment_methods` VALUES (1,'Cash','custom','Cash payments',0,0,0,'',0,0),(2,'Stripe','stripe','Stripe online payments',1,0,0,'a:3:{s:15:\"pay_button_text\";s:6:\"Stripe\";s:10:\"secret_key\";s:6:\"\";s:15:\"publishable_key\";s:6:\"\";}',0,0),(3,'PayPal Payments Standard','paypal_payments_standard','PayPal Payments Standard Online Payments',1,0,0,'a:4:{s:15:\"pay_button_text\";s:6:\"PayPal\";s:5:\"email\";s:4:\"\";s:11:\"paypal_live\";s:1:\"0\";s:5:\"debug\";s:1:\"0\";}',0,0),(4,'Paytm','paytm','Paytm online payments',1,0,0,'',0,0),(5,'Client Wallet','client_wallet','Client wallet to store and allocate funds to invoices',0,0,0,'',0,0);
/*!40000 ALTER TABLE `ikontrol_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_paypal_ipn`
--

DROP TABLE IF EXISTS `ikontrol_paypal_ipn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_paypal_ipn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `verification_code` text NOT NULL,
  `payment_verification_code` text NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `contact_user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_paypal_ipn`
--

LOCK TABLES `ikontrol_paypal_ipn` WRITE;
/*!40000 ALTER TABLE `ikontrol_paypal_ipn` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_paypal_ipn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_pin_comments`
--

DROP TABLE IF EXISTS `ikontrol_pin_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_pin_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_comment_id` int(11) NOT NULL DEFAULT 0,
  `ticket_comment_id` int(11) NOT NULL DEFAULT 0,
  `pinned_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_pin_comments`
--

LOCK TABLES `ikontrol_pin_comments` WRITE;
/*!40000 ALTER TABLE `ikontrol_pin_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_pin_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_posts`
--

DROP TABLE IF EXISTS `ikontrol_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `description` mediumtext NOT NULL,
  `post_id` int(11) NOT NULL,
  `share_with` text DEFAULT NULL,
  `files` longtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_posts`
--

LOCK TABLES `ikontrol_posts` WRITE;
/*!40000 ALTER TABLE `ikontrol_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_comments`
--

DROP TABLE IF EXISTS `ikontrol_project_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `description` mediumtext NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `comment_id` int(11) NOT NULL DEFAULT 0,
  `task_id` int(11) NOT NULL DEFAULT 0,
  `file_id` int(11) NOT NULL DEFAULT 0,
  `customer_feedback_id` int(11) NOT NULL DEFAULT 0,
  `files` longtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_comments`
--

LOCK TABLES `ikontrol_project_comments` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_project_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_files`
--

DROP TABLE IF EXISTS `ikontrol_project_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` text NOT NULL,
  `file_id` text DEFAULT NULL,
  `service_type` varchar(20) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `file_size` double NOT NULL,
  `created_at` datetime NOT NULL,
  `project_id` int(11) NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `folder_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_files`
--

LOCK TABLES `ikontrol_project_files` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_project_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_members`
--

DROP TABLE IF EXISTS `ikontrol_project_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `is_leader` tinyint(1) DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_members`
--

LOCK TABLES `ikontrol_project_members` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_project_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_settings`
--

DROP TABLE IF EXISTS `ikontrol_project_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_settings` (
  `project_id` int(11) NOT NULL,
  `setting_name` varchar(100) NOT NULL,
  `setting_value` mediumtext NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `unique_index` (`project_id`,`setting_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_settings`
--

LOCK TABLES `ikontrol_project_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_project_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_status`
--

DROP TABLE IF EXISTS `ikontrol_project_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `title_language_key` text NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_status`
--

LOCK TABLES `ikontrol_project_status` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_status` DISABLE KEYS */;
INSERT INTO `ikontrol_project_status` VALUES (1,'Open','open','open','grid',0),(2,'Completed','completed','completed','check-circle',0),(3,'Hold','hold','','pause-circle',0),(4,'Canceled','canceled','','x-circle',0);
/*!40000 ALTER TABLE `ikontrol_project_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_project_time`
--

DROP TABLE IF EXISTS `ikontrol_project_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_project_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `hours` float NOT NULL,
  `status` enum('open','logged','approved') NOT NULL DEFAULT 'logged',
  `note` text DEFAULT NULL,
  `task_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_project_time`
--

LOCK TABLES `ikontrol_project_time` WRITE;
/*!40000 ALTER TABLE `ikontrol_project_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_project_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_projects`
--

DROP TABLE IF EXISTS `ikontrol_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `project_type` enum('client_project','internal_project') NOT NULL DEFAULT 'client_project',
  `start_date` date DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `created_date` date DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT 0,
  `status` enum('open','completed','hold','canceled') NOT NULL DEFAULT 'open',
  `status_id` int(11) NOT NULL DEFAULT 1,
  `labels` text DEFAULT NULL,
  `price` double NOT NULL DEFAULT 0,
  `starred_by` mediumtext NOT NULL,
  `estimate_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `proposal_id` int(11) DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_projects`
--

LOCK TABLES `ikontrol_projects` WRITE;
/*!40000 ALTER TABLE `ikontrol_projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_proposal_comments`
--

DROP TABLE IF EXISTS `ikontrol_proposal_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_proposal_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `description` mediumtext NOT NULL,
  `proposal_id` int(11) NOT NULL DEFAULT 0,
  `files` longtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_proposal_comments`
--

LOCK TABLES `ikontrol_proposal_comments` WRITE;
/*!40000 ALTER TABLE `ikontrol_proposal_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_proposal_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_proposal_items`
--

DROP TABLE IF EXISTS `ikontrol_proposal_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_proposal_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `proposal_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_proposal_items`
--

LOCK TABLES `ikontrol_proposal_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_proposal_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_proposal_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_proposal_templates`
--

DROP TABLE IF EXISTS `ikontrol_proposal_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_proposal_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `template` mediumtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_proposal_templates`
--

LOCK TABLES `ikontrol_proposal_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_proposal_templates` DISABLE KEYS */;
INSERT INTO `ikontrol_proposal_templates` VALUES (1,'Template 3.9','<p><br></p>\r\n<p><br></p>\r\n<p><br></p>\r\n<h1 style=\"text-align: center;\">Web Design Proposal</h1>\r\n<p style=\"text-align: center;\"><br></p>\r\n\r\n\r\n<p><img src=\"/assets/images/image_preview.png\" style=\"width: 100%;\"><br>\r\n</p>\r\n<p><br></p>\r\n<p style=\"text-align: justify;\">In response to the growing demands and opportunities within the industry, we propose to develop a comprehensive solution tailored to address key challenges and capitalize on emerging trends. Our proposal aims to deliver tangible value by leveraging our expertise, innovative approaches, and commitment to excellence.</p>\r\n<p style=\"text-align: justify;\"><br></p>\r\n<p><br></p>\r\n<h3 style=\"text-align: left;\">{PROPOSAL_ID}</h3>\r\n<p style=\"text-align: left;\">Issued on {PROPOSAL_DATE}. Please note: this proposal expires on {PROPOSAL_EXPIRY_DATE}.</p>\r\n<p style=\"text-align: left;\"><br></p>\r\n<p style=\"text-align: left;\">To:</p>\r\n<p style=\"text-align: left;\">{PROPOSAL_TO_INFO}</p>\r\n<p style=\"text-align: left;\"><br></p>\r\n<p style=\"text-align: left;\">Proposal from:&nbsp;</p>\r\n<p style=\"text-align: left;\">{COMPANY_INFO}</p>\r\n<p><br></p>\r\n<p><br></p>\r\n<h3>Our Best Offer</h3>\r\n<p>In consideration of your unique needs and aspirations, we are pleased to present our best offer, crafted with meticulous attention to detail and driven by a commitment to delivering exceptional value.</p>\r\n<p>{PROPOSAL_ITEMS}</p>\r\n<p><br></p>\r\n<h3><br></h3>\r\n<h3><br></h3>\r\n<h3>Our Objective</h3>\r\n<p>Our objective is to align seamlessly with your business goals, leveraging our expertise and resources to drive tangible results and foster long-term success. Through a collaborative partnership, we aim to understand your unique challenges, opportunities, and aspirations, enabling us to tailor our approach to meet your specific needs. By focusing on measurable outcomes, continuous improvement, and proactive communication, we are committed to exceeding your expectations and establishing a foundation for sustained growth and competitiveness in a dynamic business environment.</p>\r\n<p><img src=\"/assets/images/image_preview.png\" style=\"width: 100%;\"><br>\r\n</p>\r\n<p><br></p>\r\n<p><br></p>\r\n<p><br></p>\r\n<p><br></p>\r\n<p><br></p>\r\n<p><br></p>\r\n<h3>Our Portfolio</h3>\r\n<p>Some of our recent work here:</p>\r\n<table class=\"table table-bordered\">\r\n<tbody>\r\n<tr>\r\n<td>\r\n<p>\r\n<span class=\"timeline-images inline-block\"><img class=\"pasted-image\" src=\"/assets/images/image_preview.png\"></span><br>\r\n</p>\r\n</td>\r\n<td>\r\n<p>\r\n<span class=\"timeline-images inline-block\"><img class=\"pasted-image\" src=\"/assets/images/image_preview.png\"></span>\r\n</p>\r\n</td>\r\n</tr>\r\n<tr>\r\n<td>\r\n<p>\r\n<span class=\"timeline-images inline-block\"><img class=\"pasted-image\" src=\"/assets/images/image_preview.png\"></span>\r\n</p>\r\n</td>\r\n<td>\r\n<p>\r\n<span class=\"timeline-images inline-block\"><img class=\"pasted-image\" src=\"/assets/images/image_preview.png\"></span>\r\n\r\n</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<p><br></p>\r\n<h3>Let’s Connect</h3>\r\n<p>We are excited about the chance to collaborate. Drop us a line at {COMPANY_EMAIL} or give us a call at {COMPANY_PHONE} — we would love to hear from you.</p>',0);
/*!40000 ALTER TABLE `ikontrol_proposal_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_proposals`
--

DROP TABLE IF EXISTS `ikontrol_proposals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_proposals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `proposal_date` date NOT NULL,
  `valid_until` date NOT NULL,
  `note` mediumtext DEFAULT NULL,
  `last_email_sent_date` date DEFAULT NULL,
  `status` enum('draft','sent','accepted','declined') NOT NULL DEFAULT 'draft',
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `discount_type` enum('before_tax','after_tax') NOT NULL,
  `discount_amount` double NOT NULL,
  `discount_amount_type` enum('percentage','fixed_amount') NOT NULL,
  `content` mediumtext NOT NULL,
  `public_key` varchar(10) NOT NULL,
  `accepted_by` int(11) NOT NULL DEFAULT 0,
  `created_by` int(11) NOT NULL DEFAULT 0,
  `total_views` int(11) NOT NULL DEFAULT 0,
  `last_preview_seen` datetime DEFAULT NULL,
  `meta_data` text NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `project_id` int(11) DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_proposals`
--

LOCK TABLES `ikontrol_proposals` WRITE;
/*!40000 ALTER TABLE `ikontrol_proposals` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_proposals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_reminder_logs`
--

DROP TABLE IF EXISTS `ikontrol_reminder_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_reminder_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context` varchar(255) NOT NULL,
  `context_id` int(11) NOT NULL,
  `reminder_event` varchar(255) DEFAULT NULL,
  `notification_status` enum('draft','completed') NOT NULL DEFAULT 'draft',
  `reminder_date` date DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_reminder_logs`
--

LOCK TABLES `ikontrol_reminder_logs` WRITE;
/*!40000 ALTER TABLE `ikontrol_reminder_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_reminder_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_reminder_settings`
--

DROP TABLE IF EXISTS `ikontrol_reminder_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_reminder_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL DEFAULT 'app',
  `context` text NOT NULL,
  `reminder_event` text NOT NULL,
  `reminder1` int(11) DEFAULT NULL,
  `reminder2` int(11) DEFAULT NULL,
  `reminder3` int(11) DEFAULT NULL,
  `reminder4` int(11) DEFAULT NULL,
  `reminder5` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_reminder_settings`
--

LOCK TABLES `ikontrol_reminder_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_reminder_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_reminder_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_roles`
--

DROP TABLE IF EXISTS `ikontrol_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `permissions` mediumtext DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_roles`
--

LOCK TABLES `ikontrol_roles` WRITE;
/*!40000 ALTER TABLE `ikontrol_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sale_fiscal_pricing_preparations`
--

DROP TABLE IF EXISTS `ikontrol_sale_fiscal_pricing_preparations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sale_fiscal_pricing_preparations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` int(10) unsigned NOT NULL,
  `issuer_profile_id` int(10) unsigned NOT NULL,
  `receiver_profile_id` int(10) unsigned DEFAULT NULL,
  `fiscal_series_id` int(10) unsigned DEFAULT NULL,
  `pricing_mode` varchar(20) NOT NULL,
  `administrative_subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `administrative_discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `administrative_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `administrative_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estimated_fiscal_base` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estimated_fiscal_discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estimated_fiscal_tax_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estimated_fiscal_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `difference_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `previous_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estimated_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `payment_total_snapshot` decimal(18,2) NOT NULL DEFAULT 0.00,
  `status` varchar(30) NOT NULL DEFAULT 'simulated',
  `requires_confirmation` tinyint(1) NOT NULL DEFAULT 0,
  `confirmed_by` int(10) unsigned DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `applied_to_sale` tinyint(1) NOT NULL DEFAULT 0,
  `applied_by` int(10) unsigned DEFAULT NULL,
  `applied_at` datetime DEFAULT NULL,
  `calculation_payload` longtext DEFAULT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id_status` (`invoice_id`,`status`),
  KEY `issuer_profile_id_created_at` (`issuer_profile_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sale_fiscal_pricing_preparations`
--

LOCK TABLES `ikontrol_sale_fiscal_pricing_preparations` WRITE;
/*!40000 ALTER TABLE `ikontrol_sale_fiscal_pricing_preparations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_sale_fiscal_pricing_preparations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_cfdi_uses`
--

DROP TABLE IF EXISTS `ikontrol_sat_cfdi_uses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_cfdi_uses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `description` varchar(255) NOT NULL,
  `applies_to_individual` tinyint(1) NOT NULL DEFAULT 0,
  `applies_to_company` tinyint(1) NOT NULL DEFAULT 0,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `valid_from_valid_to` (`valid_from`,`valid_to`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_cfdi_uses`
--

LOCK TABLES `ikontrol_sat_cfdi_uses` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_cfdi_uses` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_cfdi_uses` VALUES (1,'G01','Adquisición de mercancías',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(2,'G02','Devoluciones, descuentos o bonificaciones',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(3,'G03','Gastos en general',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(4,'S01','Sin efectos fiscales',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(5,'CP01','Pagos',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18');
/*!40000 ALTER TABLE `ikontrol_sat_cfdi_uses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_currencies`
--

DROP TABLE IF EXISTS `ikontrol_sat_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_currencies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `requires_exchange_rate` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sat_currencies_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_currencies`
--

LOCK TABLES `ikontrol_sat_currencies` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_currencies` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_currencies` VALUES (1,'MXN','Peso Mexicano',0,1,'2026-08-04 11:58:42',NULL),(2,'USD','Dólar estadounidense',1,1,'2026-08-04 11:58:42',NULL),(3,'EUR','Euro',1,1,'2026-08-04 11:58:42',NULL);
/*!40000 ALTER TABLE `ikontrol_sat_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_payment_forms`
--

DROP TABLE IF EXISTS `ikontrol_sat_payment_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_payment_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sat_payment_forms_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_payment_forms`
--

LOCK TABLES `ikontrol_sat_payment_forms` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_payment_forms` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_payment_forms` VALUES (1,'01','Efectivo',1,'2026-08-04 11:58:42',NULL),(2,'03','Transferencia electrónica de fondos',1,'2026-08-04 11:58:42',NULL),(3,'04','Tarjeta de crédito',1,'2026-08-04 11:58:42',NULL),(4,'28','Tarjeta de débito',1,'2026-08-04 11:58:42',NULL),(5,'99','Por definir',1,'2026-08-04 11:58:42',NULL);
/*!40000 ALTER TABLE `ikontrol_sat_payment_forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_payment_methods`
--

DROP TABLE IF EXISTS `ikontrol_sat_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_payment_methods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sat_payment_methods_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_payment_methods`
--

LOCK TABLES `ikontrol_sat_payment_methods` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_payment_methods` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_payment_methods` VALUES (1,'PUE','Pago en una sola exhibición',1,'2026-08-04 11:58:42',NULL),(2,'PPD','Pago en parcialidades o diferido',1,'2026-08-04 11:58:42',NULL);
/*!40000 ALTER TABLE `ikontrol_sat_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_product_service_keys`
--

DROP TABLE IF EXISTS `ikontrol_sat_product_service_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_product_service_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(8) NOT NULL,
  `description` varchar(500) NOT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `source_version` varchar(80) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `description` (`description`),
  KEY `is_active_valid_from_valid_to` (`is_active`,`valid_from`,`valid_to`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_product_service_keys`
--

LOCK TABLES `ikontrol_sat_product_service_keys` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_product_service_keys` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_product_service_keys` VALUES (1,'01010101','No existe en el catálogo',NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:18','2026-08-04 12:14:18'),(2,'43211503','Computadoras notebook',NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:18','2026-08-04 12:14:18'),(3,'81112100','Servicios de Internet',NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:18','2026-08-04 12:14:18'),(4,'86101705','Capacitación administrativa',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(5,'53111600','Zapatos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(6,'94101600','Asociaciones profesionales',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(7,'55121906','Stands para banderas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(8,'11131502','Pieles',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(9,'24121513','Estuche para empacar',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(10,'55121908','Soportes o stands para señales',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(11,'30162401','Pared plegable',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(12,'44112005','Libretas de citas o repuestos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(13,'39111815','Protector de lámpara y de dispositivo de lámpara',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(14,'82101505','Publicidad en volantes o cupones',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(15,'52101508','Tapetes de entrada',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(16,'81141601','Logística',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(17,'53131629','Kits de maquillaje',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(18,'49101602','Recuerdos (souvenirs)',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(19,'53111603','Zapatos para niño',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(20,'53111604','Zapatos para niña',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(21,'80141600','Actividades de ventas y promoción de negocios',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(22,'53112000','Accesorios para el calzado',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(23,'53101602','Camisas para hombre',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(24,'53101604','Camisas o blusas para mujer',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(25,'55121715','Banderas o accesorios',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(26,'30161511','Tela de pared',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(27,'53121603','Morrales',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(28,'53111800','Sandalias',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(29,'53102901','Ropa atlética para mujer',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(30,'56121902','Stands exhibidores',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(31,'27112305','Marcadores o soportes de metal',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(32,'82101500','Publicidad impresa',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(33,'53102002','Vestidos o faldas o saris o kimonos para para mujer',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(34,'53101502','Pantalones largos o cortos o pantalonetas para hombre',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(35,'53101504','Pantalones largos o cortos o pantalonetas para mujer',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(36,'20121445','Accesorios y partes',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(37,'46181507','Chalecos de seguridad',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(38,'80141605','Mercancía promocional',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(39,'11101705','Aluminio',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(40,'30241511','Estaca o clavija',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(41,'31151500','Cuerdas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(42,'30102904','Postes de madera',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(43,'53102902','Ropa atlética para hombre',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(44,'53111601','Zapatos para hombre',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(45,'54101604','Aretes',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(46,'55121714','Pendones',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(47,'53111500','Botas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(48,'30102204','Placa de acero',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(49,'52121604','Manteles',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(50,'31163220','Juego de pines diversos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(51,'46181550','Bufandas protectoras',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(52,'55121804','Gafetes o porta gafetes',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(53,'56101508','Colchones o sets para dormir',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(54,'43211507','Computadores de escritorio',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(55,'53103100','Chalecos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(56,'60141012','Juguetes inflables',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(57,'82121504','Impresión tipográfica o por serigrafía',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(58,'53102503','Sombreros',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(59,'42142905','Anteojos de sol',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(60,'53121500','Maletas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(61,'46181604','Botas de seguridad',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(62,'42241811','Faja para hernias',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(63,'82141507','Servicios de diseño de serigrafía',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(64,'46161509','Paradas de velocidad',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(65,'53111900','Calzado deportivo',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(66,'48101919','Vasos o tazas o tazones (mugs) o tapas de contenedores para ',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(67,'55121807','Porta productos de identificación o accesorios',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(68,'24111500','Bolsas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(69,'82111701','Servicios de escritores de artículos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(70,'20121302','Flotadores',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(71,'49221533','Tablas flotantes para natación',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(72,'23151910','Flotador',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(73,'10111300','Accesorios, equipo y tratamientos para los animales doméstic',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(74,'84111506','Servicios de facturación',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(75,'44121705','Lápices mecánicos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(76,'46181543','Chaqueta o gabardina impermeable',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(77,'53111702','Pantuflas para mujer',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(78,'60121015','Adhesivos decorativos en vinilo',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(79,'56101808','Columpios o rebotadores o accesorios',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(80,'53121600','Monederos, bolsos de mano y bolsas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(81,'46181533','Batas protectoras',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(82,'52121702','Toallas playeras',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(83,'60121012','Adhesivos decorativos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(84,'55121700','Señalización',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(85,'46181600','Calzado de protección',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(86,'44121618','Tijeras',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(87,'40172508','Conector de tubo de plástico pvc',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(88,'56101900','Piezas de mobiliario y accesorios',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(89,'11161804','Textil sintético tejido',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(90,'24111513','Bolsas de algodón',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(91,'80141607','Gestión de eventos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(92,'30102903','Postes de metal',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(93,'60124102','Productos de artesanía multicultural',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(94,'82121510','Impresión textil',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(95,'60124400','Metales de artesanía',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(96,'82121505','Impresión promocional o publicitaria',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(97,'45101700','Accesorios de imprenta',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(98,'60121900','Materiales de decoración de telas y arte textil y suministro',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(99,'52151504','Tazas o vasos o tapas desechables para uso doméstico',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(100,'52151600','Utensilios de cocina domésticos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(101,'23251810','Troquel de estampado',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(102,'14111601','Papel o bolsas o cajas de regalo',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(103,'82121503','Impresión digital',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(104,'11122000','Productos de madera diseñados',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(105,'44122032','Folders de conferencias',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(106,'73141715','Servicios de costura industrial',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(107,'52152102','Vasos para beber para uso doméstico',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(108,'47131502','Pañitos o toallas para limpiar',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(109,'46182201','Cinturones de soporte de la espalda',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(110,'30151901','Toldos',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(111,'54101601','Brazaletes',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(112,'60121701','Sellos de estampación de caucho',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(113,'44122003','Carpetas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(114,'73151503','Servicio de fabricación y diseños originales',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(115,'53102500','Accesorios de vestir',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(116,'47131603','Esponjas',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(117,'30265000','Láminas de aluminio',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(118,'60122300','Suministros de cestería',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(119,'30161711','Alfombras para exteriores',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(120,'53102900','Prendas de deporte',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(121,'54101602','Collares',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(122,'60101313','Calcomanías para tatuaje',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(123,'55121716','Señales de madera',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(124,'53102706','Uniformes de personal de seguridad',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(125,'46181527','Pantalones protectores',NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16');
/*!40000 ALTER TABLE `ikontrol_sat_product_service_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_tax_codes`
--

DROP TABLE IF EXISTS `ikontrol_sat_tax_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_tax_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_tax_codes`
--

LOCK TABLES `ikontrol_sat_tax_codes` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_tax_codes` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_tax_codes` VALUES (1,'001','ISR','ISR',1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(2,'002','IVA','IVA',1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(3,'003','IEPS','IEPS',1,'2026-08-04 12:14:18','2026-08-04 12:14:18');
/*!40000 ALTER TABLE `ikontrol_sat_tax_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_tax_factor_types`
--

DROP TABLE IF EXISTS `ikontrol_sat_tax_factor_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_tax_factor_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(30) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_tax_factor_types`
--

LOCK TABLES `ikontrol_sat_tax_factor_types` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_tax_factor_types` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_tax_factor_types` VALUES (1,'Tasa','Tasa',1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(2,'Cuota','Cuota',1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(3,'Exento','Exento',1,'2026-08-04 12:14:18','2026-08-04 12:14:18');
/*!40000 ALTER TABLE `ikontrol_sat_tax_factor_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_tax_object_codes`
--

DROP TABLE IF EXISTS `ikontrol_sat_tax_object_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_tax_object_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(2) NOT NULL,
  `description` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_tax_object_codes`
--

LOCK TABLES `ikontrol_sat_tax_object_codes` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_tax_object_codes` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_tax_object_codes` VALUES (1,'01','No objeto de impuesto',1,NULL,NULL,'2026-08-04 12:14:19','2026-08-04 12:14:19'),(2,'02','Sí objeto de impuesto',1,NULL,NULL,'2026-08-04 12:14:19','2026-08-04 12:14:19'),(3,'03','Sí objeto del impuesto y no obligado al desglose',1,NULL,NULL,'2026-08-04 12:14:19','2026-08-04 12:14:19'),(4,'04','Sí objeto del impuesto y no causa impuesto',1,NULL,NULL,'2026-08-04 12:14:19','2026-08-04 12:14:19');
/*!40000 ALTER TABLE `ikontrol_sat_tax_object_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_tax_regimes`
--

DROP TABLE IF EXISTS `ikontrol_sat_tax_regimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_tax_regimes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `description` varchar(255) NOT NULL,
  `applies_to_individual` tinyint(1) NOT NULL DEFAULT 0,
  `applies_to_company` tinyint(1) NOT NULL DEFAULT 0,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `valid_from_valid_to` (`valid_from`,`valid_to`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_tax_regimes`
--

LOCK TABLES `ikontrol_sat_tax_regimes` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_tax_regimes` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_tax_regimes` VALUES (1,'601','General de Ley Personas Morales',0,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(2,'603','Personas Morales con Fines no Lucrativos',0,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(3,'605','Sueldos y Salarios e Ingresos Asimilados a Salarios',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(4,'606','Arrendamiento',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(5,'612','Personas Físicas con Actividades Empresariales y Profesionales',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(6,'616','Sin obligaciones fiscales',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(7,'621','Incorporación Fiscal',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(8,'625','Régimen de las Actividades Empresariales con ingresos a través de Plataformas Tecnológicas',1,0,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18'),(9,'626','Régimen Simplificado de Confianza',1,1,NULL,NULL,1,'2026-08-04 12:14:18','2026-08-04 12:14:18');
/*!40000 ALTER TABLE `ikontrol_sat_tax_regimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_sat_unit_keys`
--

DROP TABLE IF EXISTS `ikontrol_sat_unit_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_sat_unit_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `symbol` varchar(30) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `source_version` varchar(80) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `name` (`name`),
  KEY `is_active_valid_from_valid_to` (`is_active`,`valid_from`,`valid_to`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_sat_unit_keys`
--

LOCK TABLES `ikontrol_sat_unit_keys` WRITE;
/*!40000 ALTER TABLE `ikontrol_sat_unit_keys` DISABLE KEYS */;
INSERT INTO `ikontrol_sat_unit_keys` VALUES (1,'H87','Pieza','Pieza',NULL,NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:19','2026-08-04 12:14:19'),(2,'E48','Unidad de servicio','Unidad de servicio',NULL,NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:19','2026-08-04 12:14:19'),(3,'KGM','Kilogramo','Kilogramo','kg',NULL,NULL,1,'CFDI 4.0 carga mínima','2026-08-04 12:14:19','2026-08-04 12:14:19'),(4,'PR','Par','Par',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(5,'18','Tambor de cincuenta y cinco galones (EUA)','Tambor de cincuenta y cinco galones (EUA)',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(6,'C62','Uno','Uno',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(7,'XKI','Kit (Conjunto de piezas)','Kit (Conjunto de piezas)',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(8,'T4','Bolsa de mil','Bolsa de mil',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(9,'KT','Kit','Kit',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(10,'XBT','Rollo de tela','Rollo de tela',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(11,'DPR','Docenas de pares','Docenas de pares',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(12,'XUN','Unidad','Unidad',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(13,'ACT','Actividad','Actividad',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16'),(14,'XRO','Rollo','Rollo',NULL,NULL,NULL,1,'fc2-preview-reference','2026-08-04 19:31:16','2026-08-04 19:31:16');
/*!40000 ALTER TABLE `ikontrol_sat_unit_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_settings`
--

DROP TABLE IF EXISTS `ikontrol_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_settings` (
  `setting_name` varchar(100) NOT NULL,
  `setting_value` mediumtext NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'app',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `setting_name` (`setting_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_settings`
--

LOCK TABLES `ikontrol_settings` WRITE;
/*!40000 ALTER TABLE `ikontrol_settings` DISABLE KEYS */;
INSERT INTO `ikontrol_settings` VALUES ('accepted_file_formats','jpg,jpeg,png,doc,xlsx,txt,pdf,zip,webm','app',0),('allowed_ip_addresses','','app',0),('app_title','RISE - Ultimate Project Manager and CRM','app',0),('contract_color','#000000','app',0),('create_new_invoices_automatically_when_estimates_gets_accepted','0','app',0),('currency_symbol','$','app',0),('date_format','Y-m-d','app',0),('decimal_separator','.','app',0),('default_contract_template','1','app',0),('default_currency','USD','app',0),('default_due_date_after_billing_date','14','app',0),('default_permissions_for_non_primary_contact','projects','app',0),('default_proposal_template','1','app',0),('default_theme_color','F2F2F2','app',0),('email_sent_from_address','admin@ikontrol20-clean.invalid','app',0),('email_sent_from_name','Clean','app',0),('enable_audio_recording','1','app',0),('estimate_color','#000000','app',0),('first_day_of_week','0','app',0),('invoice_color','#000000','app',0),('invoice_item_list_background','#f4f4f4','app',0),('invoice_logo','default-invoice-logo.png','app',0),('invoice_number_format','{SERIAL}','app',0),('invoice_prefix','INVOICE #','app',0),('item_purchase_code','CLEAN-LOCAL-NOT-LICENSED','app',0),('module_announcement','1','app',0),('module_attendance','1','app',0),('module_chat','1','app',0),('module_contract','1','app',0),('module_estimate','1','app',0),('module_estimate_request','1','app',0),('module_event','1','app',0),('module_expense','1','app',0),('module_file_manager','1','app',0),('module_gantt','1','app',0),('module_help','1','app',0),('module_invoice','1','app',0),('module_knowledge_base','1','app',0),('module_lead','1','app',0),('module_leave','1','app',0),('module_message','1','app',0),('module_note','1','app',0),('module_order','1','app',0),('module_project_timesheet','1','app',0),('module_proposal','1','app',0),('module_reminder','1','app',0),('module_subscription','1','app',0),('module_ticket','1','app',0),('module_timeline','1','app',0),('module_todo','1','app',0),('order_color','#000000','app',0),('proposal_color','#000000','app',0),('show_the_status_checkbox_in_tasks_list','1','app',0),('show_theme_color_changer','yes','app',0),('signin_page_background','sigin-background-image.jpg','app',0),('site_logo','default-stie-logo.png','app',0),('task_point_range','5','app',0),('time_format','small','app',0),('timezone','UTC','app',0);
/*!40000 ALTER TABLE `ikontrol_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_social_links`
--

DROP TABLE IF EXISTS `ikontrol_social_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_social_links` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `facebook` text DEFAULT NULL,
  `twitter` text DEFAULT NULL,
  `linkedin` text DEFAULT NULL,
  `googleplus` text DEFAULT NULL,
  `digg` text DEFAULT NULL,
  `youtube` text DEFAULT NULL,
  `pinterest` text DEFAULT NULL,
  `instagram` text DEFAULT NULL,
  `github` text DEFAULT NULL,
  `tumblr` text DEFAULT NULL,
  `vine` text DEFAULT NULL,
  `whatsapp` text DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_social_links`
--

LOCK TABLES `ikontrol_social_links` WRITE;
/*!40000 ALTER TABLE `ikontrol_social_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_social_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_stripe_ipn`
--

DROP TABLE IF EXISTS `ikontrol_stripe_ipn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_stripe_ipn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` text NOT NULL,
  `verification_code` text NOT NULL,
  `payment_verification_code` text NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `contact_user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `setup_intent` text NOT NULL,
  `subscription_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_stripe_ipn`
--

LOCK TABLES `ikontrol_stripe_ipn` WRITE;
/*!40000 ALTER TABLE `ikontrol_stripe_ipn` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_stripe_ipn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_subscription_items`
--

DROP TABLE IF EXISTS `ikontrol_subscription_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_subscription_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text DEFAULT NULL,
  `quantity` double NOT NULL,
  `unit_type` varchar(20) NOT NULL DEFAULT '',
  `rate` double NOT NULL,
  `total` double NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `subscription_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_subscription_items`
--

LOCK TABLES `ikontrol_subscription_items` WRITE;
/*!40000 ALTER TABLE `ikontrol_subscription_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_subscription_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_subscriptions`
--

DROP TABLE IF EXISTS `ikontrol_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `client_id` int(11) NOT NULL,
  `bill_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `note` mediumtext DEFAULT NULL,
  `labels` text NOT NULL,
  `status` enum('draft','pending','active','cancelled') NOT NULL DEFAULT 'draft',
  `payment_status` enum('success','failed') NOT NULL DEFAULT 'success',
  `tax_id` int(11) NOT NULL DEFAULT 0,
  `tax_id2` int(11) NOT NULL DEFAULT 0,
  `repeat_every` int(11) NOT NULL DEFAULT 1,
  `repeat_type` enum('days','weeks','months','years') DEFAULT NULL,
  `no_of_cycles` int(11) NOT NULL DEFAULT 0,
  `next_recurring_date` date DEFAULT NULL,
  `no_of_cycles_completed` int(11) NOT NULL DEFAULT 0,
  `cancelled_at` datetime DEFAULT NULL,
  `cancelled_by` int(11) NOT NULL,
  `files` mediumtext NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `type` enum('app','stripe') NOT NULL DEFAULT 'app',
  `stripe_subscription_id` text NOT NULL,
  `stripe_product_id` text NOT NULL,
  `stripe_product_price_id` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_subscriptions`
--

LOCK TABLES `ikontrol_subscriptions` WRITE;
/*!40000 ALTER TABLE `ikontrol_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_task_priority`
--

DROP TABLE IF EXISTS `ikontrol_task_priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_task_priority` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `icon` varchar(20) NOT NULL,
  `color` varchar(7) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_task_priority`
--

LOCK TABLES `ikontrol_task_priority` WRITE;
/*!40000 ALTER TABLE `ikontrol_task_priority` DISABLE KEYS */;
INSERT INTO `ikontrol_task_priority` VALUES (1,'Minor','arrow-down','#aab7b7',0),(2,'Major','arrow-up','#e18a00',0),(3,'Critical ','alert-circle','#ad159e',0),(4,'Blocker ','alert-octagon','#e74c3c',0);
/*!40000 ALTER TABLE `ikontrol_task_priority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_task_status`
--

DROP TABLE IF EXISTS `ikontrol_task_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_task_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `color` varchar(7) NOT NULL,
  `sort` int(11) NOT NULL,
  `hide_from_kanban` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `hide_from_non_project_related_tasks` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_task_status`
--

LOCK TABLES `ikontrol_task_status` WRITE;
/*!40000 ALTER TABLE `ikontrol_task_status` DISABLE KEYS */;
INSERT INTO `ikontrol_task_status` VALUES (1,'To Do','to_do','#F9A52D',0,0,0,0),(2,'In progress','in_progress','#1672B9',1,0,0,0),(3,'Done','done','#00B393',2,0,0,0);
/*!40000 ALTER TABLE `ikontrol_task_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_tasks`
--

DROP TABLE IF EXISTS `ikontrol_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `milestone_id` int(11) NOT NULL DEFAULT 0,
  `assigned_to` int(11) NOT NULL,
  `deadline` datetime DEFAULT NULL,
  `labels` text DEFAULT NULL,
  `points` tinyint(4) NOT NULL DEFAULT 1,
  `status` enum('to_do','in_progress','done') NOT NULL DEFAULT 'to_do',
  `status_id` int(11) NOT NULL,
  `priority_id` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `collaborators` text NOT NULL,
  `sort` int(11) NOT NULL DEFAULT 0,
  `recurring` tinyint(1) NOT NULL DEFAULT 0,
  `repeat_every` int(11) NOT NULL DEFAULT 0,
  `repeat_type` enum('days','weeks','months','years') DEFAULT NULL,
  `no_of_cycles` int(11) NOT NULL DEFAULT 0,
  `recurring_task_id` int(11) NOT NULL DEFAULT 0,
  `no_of_cycles_completed` int(11) NOT NULL DEFAULT 0,
  `created_date` date DEFAULT NULL,
  `blocking` text NOT NULL,
  `blocked_by` text NOT NULL,
  `parent_task_id` int(11) NOT NULL,
  `next_recurring_date` date DEFAULT NULL,
  `reminder_date` date DEFAULT NULL,
  `ticket_id` int(11) NOT NULL,
  `status_changed_at` datetime DEFAULT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  `expense_id` int(11) NOT NULL DEFAULT 0,
  `subscription_id` int(11) NOT NULL DEFAULT 0,
  `proposal_id` int(11) NOT NULL DEFAULT 0,
  `contract_id` int(11) NOT NULL DEFAULT 0,
  `order_id` int(11) NOT NULL DEFAULT 0,
  `estimate_id` int(11) NOT NULL DEFAULT 0,
  `invoice_id` int(11) NOT NULL DEFAULT 0,
  `lead_id` int(11) NOT NULL DEFAULT 0,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `context` enum('project','client','lead','invoice','estimate','order','contract','proposal','subscription','ticket','expense','general') NOT NULL DEFAULT 'general',
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status_id` (`status_id`),
  KEY `priority_id` (`priority_id`),
  KEY `sort` (`sort`),
  KEY `project_id` (`project_id`),
  KEY `milestone_id` (`milestone_id`),
  KEY `assigned_to` (`assigned_to`),
  KEY `ticket_id` (`ticket_id`),
  KEY `client_id` (`client_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `estimate_id` (`estimate_id`),
  KEY `order_id` (`order_id`),
  KEY `contract_id` (`contract_id`),
  KEY `proposal_id` (`proposal_id`),
  KEY `subscription_id` (`subscription_id`),
  KEY `expense_id` (`expense_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_tasks`
--

LOCK TABLES `ikontrol_tasks` WRITE;
/*!40000 ALTER TABLE `ikontrol_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_taxes`
--

DROP TABLE IF EXISTS `ikontrol_taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_taxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` tinytext NOT NULL,
  `percentage` double NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `stripe_tax_id` text NOT NULL,
  `sat_tax_code_id` int(10) unsigned DEFAULT NULL,
  `fiscal_tax_type` varchar(20) DEFAULT NULL,
  `factor_type_id` int(10) unsigned DEFAULT NULL,
  `xml_rate` decimal(18,6) DEFAULT NULL,
  `xml_quota` decimal(18,6) DEFAULT NULL,
  `is_fiscal_ready` tinyint(1) DEFAULT 0,
  `use_for_administrative` tinyint(1) DEFAULT 1,
  `use_for_fiscal` tinyint(1) DEFAULT 0,
  `fiscal_notes` text DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_taxes`
--

LOCK TABLES `ikontrol_taxes` WRITE;
/*!40000 ALTER TABLE `ikontrol_taxes` DISABLE KEYS */;
INSERT INTO `ikontrol_taxes` VALUES (1,'Tax (10%)',10,0,'',NULL,NULL,NULL,NULL,NULL,0,1,0,NULL,NULL);
/*!40000 ALTER TABLE `ikontrol_taxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_team`
--

DROP TABLE IF EXISTS `ikontrol_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `members` mediumtext NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_team`
--

LOCK TABLES `ikontrol_team` WRITE;
/*!40000 ALTER TABLE `ikontrol_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_team_member_job_info`
--

DROP TABLE IF EXISTS `ikontrol_team_member_job_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_team_member_job_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date_of_hire` date DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `salary` double NOT NULL DEFAULT 0,
  `salary_term` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_team_member_job_info`
--

LOCK TABLES `ikontrol_team_member_job_info` WRITE;
/*!40000 ALTER TABLE `ikontrol_team_member_job_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_team_member_job_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_ticket_comments`
--

DROP TABLE IF EXISTS `ikontrol_ticket_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_ticket_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `description` mediumtext NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `files` longtext DEFAULT NULL,
  `is_note` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_ticket_comments`
--

LOCK TABLES `ikontrol_ticket_comments` WRITE;
/*!40000 ALTER TABLE `ikontrol_ticket_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_ticket_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_ticket_templates`
--

DROP TABLE IF EXISTS `ikontrol_ticket_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_ticket_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` mediumtext NOT NULL,
  `ticket_type_id` int(11) NOT NULL,
  `private` mediumtext NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_ticket_templates`
--

LOCK TABLES `ikontrol_ticket_templates` WRITE;
/*!40000 ALTER TABLE `ikontrol_ticket_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_ticket_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_ticket_types`
--

DROP TABLE IF EXISTS `ikontrol_ticket_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_ticket_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_ticket_types`
--

LOCK TABLES `ikontrol_ticket_types` WRITE;
/*!40000 ALTER TABLE `ikontrol_ticket_types` DISABLE KEYS */;
INSERT INTO `ikontrol_ticket_types` VALUES (1,'General Support',0);
/*!40000 ALTER TABLE `ikontrol_ticket_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_tickets`
--

DROP TABLE IF EXISTS `ikontrol_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT 0,
  `ticket_type_id` int(11) NOT NULL,
  `title` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `status` enum('new','client_replied','open','closed') NOT NULL DEFAULT 'new',
  `last_activity_at` datetime DEFAULT NULL,
  `assigned_to` int(11) NOT NULL DEFAULT 0,
  `creator_name` varchar(100) NOT NULL,
  `creator_email` varchar(255) NOT NULL,
  `labels` text DEFAULT NULL,
  `task_id` int(11) NOT NULL,
  `closed_at` datetime NOT NULL,
  `merged_with_ticket_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `cc_contacts_and_emails` text DEFAULT NULL,
  `client_last_activity_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `ticket_type_id` (`ticket_type_id`),
  KEY `assigned_to` (`assigned_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_tickets`
--

LOCK TABLES `ikontrol_tickets` WRITE;
/*!40000 ALTER TABLE `ikontrol_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_to_do`
--

DROP TABLE IF EXISTS `ikontrol_to_do`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_to_do` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `title` text NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `labels` text DEFAULT NULL,
  `status` enum('to_do','done') NOT NULL DEFAULT 'to_do',
  `start_date` date DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `files` mediumtext NOT NULL,
  `sort` double NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_to_do`
--

LOCK TABLES `ikontrol_to_do` WRITE;
/*!40000 ALTER TABLE `ikontrol_to_do` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_to_do` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_users`
--

DROP TABLE IF EXISTS `ikontrol_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `user_type` enum('staff','client','lead') NOT NULL DEFAULT 'client',
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(11) NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `message_checked_at` datetime DEFAULT NULL,
  `client_id` int(11) NOT NULL DEFAULT 0,
  `notification_checked_at` datetime DEFAULT NULL,
  `is_primary_contact` tinyint(1) NOT NULL DEFAULT 0,
  `job_title` varchar(100) NOT NULL DEFAULT 'Untitled',
  `disable_login` tinyint(1) NOT NULL DEFAULT 0,
  `note` mediumtext DEFAULT NULL,
  `address` text DEFAULT NULL,
  `alternative_address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `alternative_phone` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `ssn` varchar(20) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `sticky_note` mediumtext DEFAULT NULL,
  `skype` text DEFAULT NULL,
  `language` varchar(50) NOT NULL,
  `enable_web_notification` tinyint(1) NOT NULL DEFAULT 1,
  `enable_email_notification` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `last_online` datetime DEFAULT NULL,
  `requested_account_removal` tinyint(1) NOT NULL DEFAULT 0,
  `client_permissions` text DEFAULT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_type` (`user_type`),
  KEY `email` (`email`),
  KEY `client_id` (`client_id`),
  KEY `deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_users`
--

LOCK TABLES `ikontrol_users` WRITE;
/*!40000 ALTER TABLE `ikontrol_users` DISABLE KEYS */;
INSERT INTO `ikontrol_users` VALUES (1,'Clean','Administrator','staff',1,0,'admin@ikontrol20-clean.invalid','',NULL,'active',NULL,0,NULL,0,'Admin',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'male',NULL,NULL,'',1,1,'0000-00-00 00:00:00',NULL,0,NULL,0);
/*!40000 ALTER TABLE `ikontrol_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ikontrol_verification`
--

DROP TABLE IF EXISTS `ikontrol_verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ikontrol_verification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `type` enum('invoice_payment','reset_password','verify_email','invitation') NOT NULL,
  `code` varchar(10) NOT NULL,
  `params` text NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ikontrol_verification`
--

LOCK TABLES `ikontrol_verification` WRITE;
/*!40000 ALTER TABLE `ikontrol_verification` DISABLE KEYS */;
/*!40000 ALTER TABLE `ikontrol_verification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-04 13:33:22
