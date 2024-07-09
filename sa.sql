-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: localhost    Database: sync_audio
-- ------------------------------------------------------
-- Server version	8.0.37-0ubuntu0.22.04.3

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
-- Table structure for table `access_tokens`
--

DROP TABLE IF EXISTS `access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_tokens` (
  `token` varchar(32) NOT NULL,
  `user_id` int unsigned NOT NULL,
  `user_agent` varchar(64) NOT NULL,
  `ip_address` varchar(32) NOT NULL,
  `issue_date` datetime NOT NULL,
  `last_access_date` datetime NOT NULL,
  PRIMARY KEY (`token`,`user_id`,`user_agent`,`ip_address`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `access_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_tokens`
--

LOCK TABLES `access_tokens` WRITE;
/*!40000 ALTER TABLE `access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `email` varchar(128) NOT NULL,
  `date_added` datetime DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES ('colin.campbell.531@gmail.com','2022-10-24 12:14:49'),('payments@sync-audio.com','2018-05-15 10:19:00'),('paypaluk@jakubdolejs.com','2024-03-06 10:56:55'),('tesleyfrancis4@gmail.com','2024-06-20 20:15:15');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist_payout`
--

DROP TABLE IF EXISTS `artist_payout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist_payout` (
  `sender_item_id` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `time_created` datetime DEFAULT NULL,
  `amount` double(8,2) DEFAULT NULL,
  `currency` varchar(16) DEFAULT NULL,
  `receiver` varchar(128) DEFAULT NULL,
  `transaction_status` varchar(64) DEFAULT NULL,
  `payout_item_fee` double(8,2) DEFAULT NULL,
  `fee_currency` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`sender_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_payout`
--

LOCK TABLES `artist_payout` WRITE;
/*!40000 ALTER TABLE `artist_payout` DISABLE KEYS */;
/*!40000 ALTER TABLE `artist_payout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commercial_licence_categories`
--

DROP TABLE IF EXISTS `commercial_licence_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commercial_licence_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commercial_licence_categories`
--

LOCK TABLES `commercial_licence_categories` WRITE;
/*!40000 ALTER TABLE `commercial_licence_categories` DISABLE KEYS */;
INSERT INTO `commercial_licence_categories` VALUES (1,'Film Trailer','Film trailers are licensed on a per production bases allowing uncapped usage per trailer.'),(2,'Film (Excl. Trailers)','Per film rates allows uncapped usage per film'),(3,'Advertising','Ads licence, designed specifically to promote goods or services to the public.'),(4,'Game Trailer','Game trailer, licensed on a per production bases allowing uncapped usage per trailer.'),(5,'Games','Games rate cover audio, visual or interactive productions, including sales and rental.'),(6,'TV (Episodic)','Cue sheet must be submitted upon completion of the production.');
/*!40000 ALTER TABLE `commercial_licence_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commercial_licences`
--

DROP TABLE IF EXISTS `commercial_licences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commercial_licences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` int DEFAULT NULL,
  `use` text,
  `territory` varchar(64) DEFAULT NULL,
  `unit` varchar(64) DEFAULT NULL,
  `price` double(8,2) DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `category_fk` (`category`),
  CONSTRAINT `category_fk` FOREIGN KEY (`category`) REFERENCES `commercial_licence_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commercial_licences`
--

LOCK TABLES `commercial_licences` WRITE;
/*!40000 ALTER TABLE `commercial_licences` DISABLE KEYS */;
INSERT INTO `commercial_licences` VALUES (1,1,'Film budget £3m–£5m – All media','Single country','track',3500.00,1),(2,1,'Film budget £3m–£5m – All media','Worldwide','track',7000.00,2),(3,1,'Film budget £1.25m–£3m – All media','Single country','track',1700.00,3),(4,1,'Film budget £1.25m–£3m – All media','Worldwide','track',3400.00,4),(5,1,'Film budget under £1.25m – All media','Single country','track',1300.00,5),(6,1,'Film budget under £1.25m – All media','Worldwide','track',2500.00,6),(7,2,'Film Budget up to £750k\nuncapped usage – Use within TV, online exploitation, film festival, physical product release and theatrical.','Worldwide','track',1300.00,7),(8,2,'Film Budget £750k–£1.5m\nuncapped usage – Use within TV, online exploitation, film festival, physical product release and theatrical.','Worldwide','track',3000.00,8),(9,2,'Film Budget £1.5–£3m\nuncapped usage – Use within TV, online exploitation, film festival, physical product release and theatrical.','Worldwide','track',6000.00,9),(10,3,'Campaign Ads\nClear a single track across unlimited adverts of a related or developing theme for a single product. Includes TV, indents, radio and online exploitation. Unlimited cut-downs tag-ends changes, revisions and variations. Broadcast within a 12 month duration before a new licence is required to continue making a new advertisement using the same track.','Worldwide (excl. USA and Canada)','track',12000.00,10),(11,3,'Campaign Ads\nClear a single track across unlimited adverts of a related or developing theme for a single product. Includes TV, indents, radio and online exploitation. Unlimited cut-downs tag-ends changes, revisions and variations. Broadcast within a 12 month duration before a new licence is required to continue making a new advertisement using the same track.','Single country (excl. USA and Canada)','track',6000.00,11),(12,3,'All TV Ads\nIncludes indents, online exploitation and paid media spend.','Worldwide','track',8200.00,13),(13,3,'All TV Ads\nIncludes indents, online exploitation and paid media spend.','Single country','track',4200.00,14),(14,3,'All Media Ads\nIncludes but not limited to TV, radio, online exploitation, physical product and public location.','Worldwide','track',10500.00,15),(15,3,'All Media Ads\nIncludes but not limited to TV, radio, online exploitation, physical product and public location.','Single country','track',5250.00,16),(16,3,'Radio Ads\nIncludes online exploitation and physical product.','Single country','track',650.00,17),(17,3,'Cinema World Ads','Worldwide','track',1000.00,18),(18,4,'Game budget £3m–£5m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Single country','track',4000.00,18),(19,4,'Game budget £3m–£5m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Worldwide','track',9000.00,19),(20,4,'Game budget £1.25m–£3m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Single country','track',2000.00,20),(21,4,'Game budget £1.25m–£3m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Worldwide','track',4000.00,21),(22,4,'Game budget under £1.25m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Single country','track',1500.00,22),(23,4,'Game budget under £1.25m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Worldwide','track',3000.00,23),(24,5,'Budget under £750k\nRetail games, e.g. PlayStation, Xbox, PC games, (physical copies or online exploitation), including virtual reality experience. Uncapped music usage for release to general public.','Worldwide','track',4000.00,24),(25,6,'All Media rates\nIncludes TV, radio, online exploitation and public location.','Worldwide','episode',450.00,25),(26,6,'All Media rates\nIncludes TV, radio, online exploitation and public location.','Worldwide','series (up to 10 ep.)',1500.00,26),(27,6,'All Media rates\nIncludes TV, radio, online exploitation and public location.','Worldwide','series (up to 20 ep.)',3000.00,27),(28,6,'All Media rates\nIncludes TV, radio, online exploitation and public location.','Worldwide','show annual',4000.00,28),(29,3,'Campaign Ads\nClear a single track across unlimited adverts of a related or developing theme for a single product. Includes TV, indents, radio and online exploitation. Unlimited cut-downs tag-ends changes, revisions and variations. Broadcast within a 12 month duration before a new licence is required to continue making a new advertisement using the same track.','USA and Canada','track',NULL,12),(30,2,'Film Budget over £3m\nuncapped usage – Use within TV, online exploitation, film festival, physical product release and theatrical.','Worldwide','track',NULL,10),(31,4,'Game budget over £5m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Single country','track',NULL,16),(32,4,'Game budget over £5m\nuncapped usage – Includes TV, physical product, online exploitation, public location and radio.','Worldwide','track',NULL,17),(33,5,'Budget over £750k','Worldwide','track',NULL,22),(34,1,'Film budget over £5m','Single country','track',NULL,-1),(35,1,'Film budget over £5m','Worldwide','track',NULL,0);
/*!40000 ALTER TABLE `commercial_licences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commercial_transaction_tracks`
--

DROP TABLE IF EXISTS `commercial_transaction_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commercial_transaction_tracks` (
  `transaction_id` varchar(128) DEFAULT NULL,
  `track_id` int unsigned DEFAULT NULL,
  `licence_id` int DEFAULT NULL,
  `amount` double(10,2) DEFAULT NULL,
  `sender_item_id` int(10) unsigned zerofill DEFAULT NULL,
  `first_name` varchar(64) DEFAULT NULL,
  `last_name` varchar(64) DEFAULT NULL,
  `company` varchar(128) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `website` varchar(256) DEFAULT NULL,
  `project_title` varchar(128) DEFAULT NULL,
  UNIQUE KEY `sender_item_id_unique` (`sender_item_id`),
  KEY `com_tracks_licence_id_fk` (`licence_id`),
  KEY `com_txn_tracks_txn_id` (`transaction_id`),
  KEY `com_txn_tracks_track_id` (`track_id`),
  CONSTRAINT `com_tracks_licence_id_fk` FOREIGN KEY (`licence_id`) REFERENCES `commercial_licences` (`id`) ON DELETE SET NULL,
  CONSTRAINT `com_txn_tracks_track_id` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `com_txn_tracks_txn_id` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commercial_transaction_tracks`
--

LOCK TABLES `commercial_transaction_tracks` WRITE;
/*!40000 ALTER TABLE `commercial_transaction_tracks` DISABLE KEYS */;
INSERT INTO `commercial_transaction_tracks` VALUES ('ce99b3c5-fd2f-4d30-a27e-79b41e03590c',NULL,3,1700.00,NULL,'Jakub','Dolejs','Test','jakubdolejs@hotmail.com','www.test.com','Test project'),('269c6e22-ba1f-49de-8fb4-adc532dbc662',260,2,7000.00,NULL,'test','test','test','tj.francis@yahoo.com','test','undefined'),('cb2fbd39-045f-4e34-879a-9911a0d4e4f4',85,6,2500.00,NULL,'Jaimish','ashar','test','jaimish97@gmail.com','test.com','test'),('33183c46-215d-406a-ba90-0a290f244433',80,1,3500.00,NULL,'test','test','test','tj.francis@yahoo.com','test','undefined');
/*!40000 ALTER TABLE `commercial_transaction_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comp_tracks`
--

DROP TABLE IF EXISTS `comp_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comp_tracks` (
  `comp_id` varchar(32) NOT NULL,
  `track_id` int unsigned NOT NULL,
  `pad` double(12,3) NOT NULL DEFAULT '0.000',
  `vol` double(3,2) NOT NULL DEFAULT '1.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comp_tracks`
--

LOCK TABLES `comp_tracks` WRITE;
/*!40000 ALTER TABLE `comp_tracks` DISABLE KEYS */;
/*!40000 ALTER TABLE `comp_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comps`
--

DROP TABLE IF EXISTS `comps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comps` (
  `comp_id` varchar(32) NOT NULL,
  `video_url` varchar(255) NOT NULL,
  `video_volume` double(3,2) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `text` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`comp_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comps`
--

LOCK TABLES `comps` WRITE;
/*!40000 ALTER TABLE `comps` DISABLE KEYS */;
/*!40000 ALTER TABLE `comps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_artists`
--

DROP TABLE IF EXISTS `featured_artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_artists` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `artist` varchar(128) NOT NULL,
  `job` varchar(128) DEFAULT NULL,
  `text` varchar(128) NOT NULL,
  `priority` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `artist` (`artist`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_artists`
--

LOCK TABLES `featured_artists` WRITE;
/*!40000 ALTER TABLE `featured_artists` DISABLE KEYS */;
INSERT INTO `featured_artists` VALUES (15,'T.J Philips','Band','T.J Philips: Producer / Musician. \r\nRecommend for fans of Herbie Hancock and Grover Washington Jr.',1),(20,'Jay.J','Producer','Jay.J is a talented producer songwriter working with Uk and international artists.',3),(25,'Rene Byrd','Artist','Singer Song Writer with a Fabulous Voice',2),(35,'Leon Herbert ','Poet','Poetry: from our most talented / loved Actor, Director of Film and Stage.',1);
/*!40000 ALTER TABLE `featured_artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_comps`
--

DROP TABLE IF EXISTS `featured_comps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_comps` (
  `comp_id` varchar(32) NOT NULL,
  `priority` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`comp_id`),
  KEY `priority` (`priority`),
  CONSTRAINT `featured_comps_ibfk_1` FOREIGN KEY (`comp_id`) REFERENCES `comps` (`comp_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_comps`
--

LOCK TABLES `featured_comps` WRITE;
/*!40000 ALTER TABLE `featured_comps` DISABLE KEYS */;
/*!40000 ALTER TABLE `featured_comps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_tracks`
--

DROP TABLE IF EXISTS `featured_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_tracks` (
  `track_id` int unsigned NOT NULL,
  `priority` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`track_id`),
  KEY `priority` (`priority`),
  CONSTRAINT `featured_tracks_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_tracks`
--

LOCK TABLES `featured_tracks` WRITE;
/*!40000 ALTER TABLE `featured_tracks` DISABLE KEYS */;
INSERT INTO `featured_tracks` VALUES (85,1),(51,2),(113,3),(80,4),(46,5),(75,6),(41,7),(36,8),(103,9),(63,10),(31,12),(58,13),(26,15),(92,16),(21,18),(87,19),(53,20),(115,21),(82,22),(48,23),(77,24),(43,25),(110,26),(71,27),(38,28),(105,29),(65,30),(33,31),(99,32),(60,33),(127,34),(137,35),(28,36),(55,37),(23,39),(89,40),(117,41),(84,42),(50,43),(79,44),(45,45),(112,46),(74,47),(40,48),(107,49),(35,50),(62,51),(139,53),(30,54),(96,55),(134,57),(25,58),(86,60),(52,61),(114,62),(81,63),(47,64),(76,65),(42,66),(109,67),(70,68),(37,69),(104,70),(32,71),(98,72),(59,73),(126,74),(27,75),(93,76),(54,77),(88,79),(116,80),(83,81),(49,82),(78,83),(44,84),(111,85),(73,86),(39,87),(106,88),(66,89),(34,90),(100,91),(61,92),(29,94),(95,95),(56,96),(133,98),(24,99),(146,100),(141,101),(148,102),(143,103),(150,104),(145,105),(140,106),(147,107),(142,108),(149,109),(144,110),(152,111),(155,112),(151,113);
/*!40000 ALTER TABLE `featured_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `genre` varchar(128) NOT NULL,
  `track_id` int NOT NULL,
  PRIMARY KEY (`genre`,`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES ('African',115),('African',182),('African',184),('African',217),('African',342),('African',365),('Asian',114),('Asian',184),('Blues',170),('Blues',192),('Blues',223),('Blues',226),('Blues',297),('Blues',331),('Classical',152),('Classical',175),('Classical',240),('Classical',298),('Classical',306),('Classical',307),('Classical',315),('Classical',363),('Classical',381),('Country',208),('Country',249),('Country',262),('Country',291),('Country',297),('Electronic',28),('Electronic',157),('Electronic',161),('Electronic',166),('Electronic',173),('Electronic',174),('Electronic',182),('Electronic',183),('Electronic',187),('Electronic',196),('Electronic',197),('Electronic',198),('Electronic',199),('Electronic',215),('Electronic',241),('Electronic',285),('Electronic',286),('Electronic',287),('Electronic',288),('Electronic',290),('Electronic',296),('Electronic',299),('Electronic',300),('Electronic',302),('Electronic',303),('Electronic',304),('Electronic',309),('Electronic',315),('Electronic',347),('Electronic',348),('Electronic',349),('Electronic',351),('Electronic',352),('Experimental',21),('Experimental',22),('Experimental',23),('Experimental',25),('Experimental',27),('Experimental',29),('Experimental',30),('Experimental',31),('Experimental',32),('Experimental',33),('Experimental',34),('Experimental',35),('Experimental',36),('Experimental',37),('Experimental',38),('Experimental',39),('Experimental',40),('Experimental',41),('Experimental',42),('Experimental',43),('Experimental',44),('Experimental',45),('Experimental',46),('Experimental',47),('Experimental',48),('Experimental',49),('Experimental',51),('Experimental',139),('Experimental',148),('Experimental',184),('Experimental',189),('Experimental',191),('Experimental',231),('Experimental',232),('Experimental',269),('Experimental',270),('Experimental',271),('Experimental',286),('Experimental',290),('Experimental',295),('Experimental',296),('Experimental',301),('Experimental',317),('Experimental',318),('Experimental',349),('Film TV Music',24),('Film TV Music',27),('Film TV Music',29),('Film TV Music',31),('Film TV Music',33),('Film TV Music',35),('Film TV Music',37),('Film TV Music',39),('Film TV Music',41),('Film TV Music',42),('Film TV Music',45),('Film TV Music',46),('Film TV Music',48),('Film TV Music',49),('Film TV Music',53),('Film TV Music',55),('Film TV Music',69),('Film TV Music',72),('Film TV Music',73),('Film TV Music',78),('Film TV Music',89),('Film TV Music',91),('Film TV Music',92),('Film TV Music',95),('Film TV Music',99),('Film TV Music',100),('Film TV Music',101),('Film TV Music',105),('Film TV Music',106),('Film TV Music',113),('Film TV Music',116),('Film TV Music',117),('Film TV Music',125),('Film TV Music',129),('Film TV Music',130),('Film TV Music',131),('Film TV Music',132),('Film TV Music',133),('Film TV Music',134),('Film TV Music',135),('Film TV Music',136),('Film TV Music',137),('Film TV Music',138),('Film TV Music',140),('Film TV Music',141),('Film TV Music',142),('Film TV Music',143),('Film TV Music',144),('Film TV Music',145),('Film TV Music',146),('Film TV Music',147),('Film TV Music',148),('Film TV Music',151),('Film TV Music',152),('Film TV Music',155),('Film TV Music',156),('Film TV Music',157),('Film TV Music',158),('Film TV Music',166),('Film TV Music',167),('Film TV Music',168),('Film TV Music',169),('Film TV Music',170),('Film TV Music',175),('Film TV Music',184),('Film TV Music',188),('Film TV Music',189),('Film TV Music',190),('Film TV Music',191),('Film TV Music',197),('Film TV Music',208),('Film TV Music',209),('Film TV Music',216),('Film TV Music',217),('Film TV Music',218),('Film TV Music',219),('Film TV Music',220),('Film TV Music',221),('Film TV Music',224),('Film TV Music',225),('Film TV Music',227),('Film TV Music',235),('Film TV Music',240),('Film TV Music',241),('Film TV Music',247),('Film TV Music',252),('Film TV Music',253),('Film TV Music',254),('Film TV Music',255),('Film TV Music',256),('Film TV Music',257),('Film TV Music',259),('Film TV Music',260),('Film TV Music',262),('Film TV Music',263),('Film TV Music',265),('Film TV Music',266),('Film TV Music',267),('Film TV Music',268),('Film TV Music',270),('Film TV Music',286),('Film TV Music',297),('Film TV Music',298),('Film TV Music',306),('Film TV Music',312),('Film TV Music',313),('Film TV Music',314),('Film TV Music',315),('Film TV Music',319),('Film TV Music',333),('Film TV Music',334),('Film TV Music',335),('Film TV Music',336),('Film TV Music',344),('Film TV Music',350),('Film TV Music',354),('Funk',37),('Funk',49),('Funk',52),('Funk',53),('Funk',54),('Funk',91),('Funk',305),('Funk',344),('Hip Hop - Rap',74),('Hip Hop - Rap',75),('Hip Hop - Rap',76),('Hip Hop - Rap',77),('Hip Hop - Rap',78),('Hip Hop - Rap',79),('Hip Hop - Rap',80),('Hip Hop - Rap',81),('Hip Hop - Rap',82),('Hip Hop - Rap',83),('Hip Hop - Rap',84),('Hip Hop - Rap',85),('Hip Hop - Rap',86),('Hip Hop - Rap',87),('Hip Hop - Rap',88),('Hip Hop - Rap',96),('Hip Hop - Rap',149),('Hip Hop - Rap',150),('Hip Hop - Rap',160),('Hip Hop - Rap',163),('Hip Hop - Rap',164),('Hip Hop - Rap',181),('Hip Hop - Rap',186),('Hip Hop - Rap',189),('Hip Hop - Rap',190),('Hip Hop - Rap',219),('Hip Hop - Rap',221),('Hip Hop - Rap',227),('Hip Hop - Rap',231),('Hip Hop - Rap',232),('Hip Hop - Rap',233),('Hip Hop - Rap',234),('Hip Hop - Rap',236),('Hip Hop - Rap',237),('Hip Hop - Rap',238),('Hip Hop - Rap',239),('Hip Hop - Rap',241),('Hip Hop - Rap',242),('Hip Hop - Rap',244),('Hip Hop - Rap',245),('Hip Hop - Rap',246),('Hip Hop - Rap',269),('Hip Hop - Rap',277),('Hip Hop - Rap',278),('Hip Hop - Rap',279),('Hip Hop - Rap',280),('Hip Hop - Rap',284),('Hip Hop - Rap',285),('Hip Hop - Rap',287),('Hip Hop - Rap',290),('Hip Hop - Rap',295),('Hip Hop - Rap',317),('Hip Hop - Rap',321),('Hip Hop - Rap',322),('Hip Hop - Rap',323),('Hip Hop - Rap',332),('Hip Hop - Rap',337),('Hip Hop - Rap',338),('Hip Hop - Rap',339),('Hip Hop - Rap',340),('Hip Hop - Rap',341),('Hip Hop - Rap',350),('Hip Hop - Rap',366),('Hip Hop - Rap',367),('Hip Hop - Rap',368),('Hip Hop - Rap',369),('Hip Hop - Rap',370),('Hip Hop - Rap',374),('Hip Hop - Rap',375),('House',50),('House',55),('House',166),('House',197),('House',215),('House',302),('House',303),('House',304),('Incidental',56),('Incidental',57),('Incidental',58),('Incidental',59),('Incidental',60),('Incidental',61),('Incidental',62),('Incidental',63),('Incidental',64),('Incidental',65),('Incidental',66),('Incidental',67),('Incidental',68),('Incidental',69),('Incidental',70),('Incidental',71),('Incidental',72),('Incidental',73),('Incidental',170),('Incidental',184),('Incidental',267),('Incidental',275),('Incidental',309),('Incidental',349),('Indie',164),('Indie',171),('Indie',172),('Indie',176),('Indie',178),('Indie',179),('Indie',180),('Indie',196),('Indie',198),('Indie',203),('Indie',207),('Indie',224),('Indie',225),('Indie',228),('Indie',247),('Indie',248),('Indie',269),('Indie',282),('Indie',283),('Indie',285),('Indie',289),('Indie',290),('Indie',299),('Indie',300),('Indie',315),('Indie',361),('Indie',362),('Indie',364),('Indie',379),('Jazz',24),('Jazz',127),('Jazz',140),('Jazz',141),('Jazz',142),('Jazz',143),('Jazz',144),('Jazz',145),('Jazz',146),('Jazz',159),('Jazz',168),('Jazz',169),('Jazz',170),('Jazz',216),('Jazz',223),('Jazz',226),('Jazz',250),('Jazz',310),('Jazz',344),('Latin',89),('Latin',90),('Latin',94),('Latin',157),('Latin',158),('Pop',20),('Pop',41),('Pop',45),('Pop',81),('Pop',88),('Pop',89),('Pop',90),('Pop',91),('Pop',92),('Pop',93),('Pop',94),('Pop',95),('Pop',96),('Pop',97),('Pop',98),('Pop',99),('Pop',100),('Pop',101),('Pop',102),('Pop',103),('Pop',105),('Pop',106),('Pop',107),('Pop',108),('Pop',112),('Pop',113),('Pop',114),('Pop',115),('Pop',116),('Pop',117),('Pop',118),('Pop',119),('Pop',120),('Pop',121),('Pop',122),('Pop',124),('Pop',147),('Pop',148),('Pop',153),('Pop',154),('Pop',155),('Pop',157),('Pop',158),('Pop',162),('Pop',165),('Pop',168),('Pop',169),('Pop',171),('Pop',172),('Pop',173),('Pop',174),('Pop',176),('Pop',182),('Pop',185),('Pop',187),('Pop',193),('Pop',194),('Pop',195),('Pop',196),('Pop',197),('Pop',198),('Pop',199),('Pop',203),('Pop',204),('Pop',205),('Pop',206),('Pop',207),('Pop',208),('Pop',210),('Pop',211),('Pop',212),('Pop',213),('Pop',214),('Pop',215),('Pop',222),('Pop',228),('Pop',231),('Pop',232),('Pop',241),('Pop',243),('Pop',245),('Pop',246),('Pop',248),('Pop',249),('Pop',250),('Pop',251),('Pop',270),('Pop',272),('Pop',273),('Pop',274),('Pop',275),('Pop',280),('Pop',281),('Pop',282),('Pop',283),('Pop',288),('Pop',289),('Pop',292),('Pop',294),('Pop',295),('Pop',316),('Pop',320),('Pop',329),('Pop',330),('Pop',343),('Pop',356),('Pop',357),('Pop',358),('Pop',359),('Pop',362),('Pop',365),('Pop',369),('Pop',370),('Pop',372),('Pop',373),('Pop',379),('R&B',24),('R&B',26),('R&B',46),('R&B',48),('R&B',78),('R&B',89),('R&B',90),('R&B',91),('R&B',92),('R&B',95),('R&B',96),('R&B',98),('R&B',100),('R&B',103),('R&B',104),('R&B',105),('R&B',106),('R&B',107),('R&B',108),('R&B',109),('R&B',110),('R&B',111),('R&B',112),('R&B',113),('R&B',114),('R&B',120),('R&B',125),('R&B',126),('R&B',127),('R&B',128),('R&B',129),('R&B',130),('R&B',139),('R&B',147),('R&B',148),('R&B',149),('R&B',155),('R&B',163),('R&B',164),('R&B',165),('R&B',167),('R&B',168),('R&B',169),('R&B',188),('R&B',216),('R&B',218),('R&B',229),('R&B',231),('R&B',236),('R&B',237),('R&B',238),('R&B',239),('R&B',243),('R&B',244),('R&B',275),('R&B',301),('R&B',305),('R&B',316),('R&B',318),('R&B',320),('R&B',322),('R&B',323),('R&B',324),('R&B',325),('R&B',326),('R&B',327),('R&B',329),('R&B',330),('R&B',331),('R&B',339),('R&B',360),('R&B',368),('R&B',371),('R&B',376),('R&B',377),('R&B',382),('Reggae',78),('Reggae',150),('Reggae',151),('Reggae',156),('Reggae',243),('Reggae',361),('Rock',123),('Rock',124),('Rock',176),('Rock',178),('Rock',179),('Rock',180),('Rock',187),('Rock',192),('Rock',193),('Rock',194),('Rock',195),('Rock',196),('Rock',203),('Rock',204),('Rock',205),('Rock',206),('Rock',207),('Rock',208),('Rock',223),('Rock',224),('Rock',225),('Rock',235),('Rock',247),('Rock',248),('Rock',249),('Rock',250),('Rock',263),('Rock',283),('Rock',290),('Rock',315),('Rock',316),('Rock',319),('Rock',333),('Rock',334),('Rock',335),('Rock',336),('Rock',343),('Rock',345),('Rock',351),('Rock',354),('Rock',362),('Rock',372),('Rock',378),('Rock',379),('Soul',97),('Soul',147),('Soul',163),('Soul',165),('Soul',167),('Soul',168),('Soul',169),('Soul',188),('Soul',190),('Soul',218),('Soul',227),('Soul',243),('Soul',276),('Soul',301),('Soul',305),('Soul',328),('Soul',360),('Soul',362),('World',89),('World',96),('World',114),('World',126),('World',127),('World',140),('World',150),('World',170),('World',178),('World',179),('World',180),('World',184),('World',191),('World',217),('World',267),('World',319),('World',330);
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licence_categories`
--

DROP TABLE IF EXISTS `licence_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `licence_categories` (
  `licence_category_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) NOT NULL,
  PRIMARY KEY (`licence_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licence_categories`
--

LOCK TABLES `licence_categories` WRITE;
/*!40000 ALTER TABLE `licence_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `licence_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licence_types`
--

DROP TABLE IF EXISTS `licence_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `licence_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text,
  `description` text,
  `track_price` double(6,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licence_types`
--

LOCK TABLES `licence_types` WRITE;
/*!40000 ALTER TABLE `licence_types` DISABLE KEYS */;
INSERT INTO `licence_types` VALUES (1,'Promotional content Tier 1 (companies with 1–50 employees)','For use in a single (1):  Project promoting a product, brand, service, event, promotion, organization or company. For web, streaming and internally (Facebook, YouTube, Vimeo, TikTok, Instagram, etc.)  Use within a single company/organization. (e.g. presentations, trainings and employees viewings). Includes paid advertising. Does not include broadcasting rights. Perpetual licence',259.99),(2,'Promotional content Tier 2 (companies with 51-250 employees)','For use in a single (1):  Project promoting a product, brand, service, event, promotion, organization or company. For web, streaming and internally (Facebook, YouTube, Vimeo, TikTok, Instagram, etc.)  Use within a single company/organization. (e.g. presentations, trainings and employees viewings). Includes paid advertising. Does not include broadcasting rights. Perpetual licence',359.99),(3,'Promotional content Tier 3 (companies with 250+ employees)','For use in a single (1):  Project promoting a product, brand, service, event, promotion, organization or company. For web, streaming and internally (Facebook, YouTube, Vimeo, TikTok, Instagram, etc.)  Use within a single company/organization. (e.g. presentations, trainings and employees viewings). Includes paid advertising. Does not include broadcasting rights. Perpetual licence',500.00),(5,'Vloggers','For use in a single (1): Vlogger / Blogger log, hosted online, self-financed, up to 300k-page view (YouTube, Facebook etc.) permits monetization. Not to be used for paid advertising or promotion of a product, service or brand. Perpetual licence.',29.99),(6,'Wedding','For use in a single (1): Wedding video or slideshow, internally and streaming online. 15 resalable, 400 giveaways. Perpetual licence.',35.00),(7,'Indie Film','For use in a single (1): indie full-length or short film. Budget up to £500k. For web streaming, tradeshows and festival entry use. This does not include broadcasting rights. Perpetual licence.',160.00),(8,'Indie Film Trailer','For use in a single (1): promotional trailer of the film. Budget up to £500k. For web streaming sites (YouTube, Facebook etc.) tradeshows and festival entry. This does not include broadcasting rights or paid advertising. Perpetual licence.',260.00),(9,'Home / Students','For use in a single (1): Home / education video or slideshow for family and friends and can be viewed on social networks, (e.g. birthday, graduation, Holidays, engagements etc.) For use by students for class assignments/projects. Not to be used for branding, service, company or organisation. Perpetual licence.',18.00),(10,'Commercial Licence','TV, Film & Advertising',NULL),(16,'Podcast (business)','For use in a single (1): Podcast (series use), Audio only. Not for use within sponsored, branded \npodcast (beyond your own business, group or company). Does not include paid/subscription and\npaid downloads. Perpetual licence.',209.00);
/*!40000 ALTER TABLE `licence_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licences`
--

DROP TABLE IF EXISTS `licences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `licences` (
  `licence_id` varchar(32) NOT NULL,
  `usage_restriction` varchar(128) NOT NULL,
  `licence_category_id` int unsigned NOT NULL,
  `track_price` double(8,2) NOT NULL,
  PRIMARY KEY (`licence_id`),
  KEY `licence_category_id` (`licence_category_id`),
  CONSTRAINT `licences_ibfk_1` FOREIGN KEY (`licence_category_id`) REFERENCES `licence_categories` (`licence_category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licences`
--

LOCK TABLES `licences` WRITE;
/*!40000 ALTER TABLE `licences` DISABLE KEYS */;
/*!40000 ALTER TABLE `licences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lifestyles`
--

DROP TABLE IF EXISTS `lifestyles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lifestyles` (
  `lifestyle_id` int unsigned NOT NULL AUTO_INCREMENT,
  `parent_lifestyle_id` int unsigned DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`lifestyle_id`),
  KEY `parent_lifestyle_id` (`parent_lifestyle_id`),
  CONSTRAINT `lifestyles_ibfk_1` FOREIGN KEY (`parent_lifestyle_id`) REFERENCES `lifestyles` (`lifestyle_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lifestyles`
--

LOCK TABLES `lifestyles` WRITE;
/*!40000 ALTER TABLE `lifestyles` DISABLE KEYS */;
/*!40000 ALTER TABLE `lifestyles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `version` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moods`
--

DROP TABLE IF EXISTS `moods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moods` (
  `mood` varchar(128) NOT NULL,
  `track_id` int NOT NULL,
  PRIMARY KEY (`mood`,`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moods`
--

LOCK TABLES `moods` WRITE;
/*!40000 ALTER TABLE `moods` DISABLE KEYS */;
INSERT INTO `moods` VALUES ('Angry / Aggressive',28),('Angry / Aggressive',30),('Angry / Aggressive',33),('Angry / Aggressive',42),('Angry / Aggressive',43),('Angry / Aggressive',62),('Angry / Aggressive',64),('Angry / Aggressive',65),('Angry / Aggressive',101),('Angry / Aggressive',131),('Angry / Aggressive',132),('Angry / Aggressive',133),('Angry / Aggressive',173),('Angry / Aggressive',174),('Angry / Aggressive',178),('Angry / Aggressive',179),('Angry / Aggressive',186),('Angry / Aggressive',189),('Angry / Aggressive',227),('Angry / Aggressive',233),('Angry / Aggressive',234),('Angry / Aggressive',235),('Angry / Aggressive',256),('Angry / Aggressive',257),('Angry / Aggressive',278),('Angry / Aggressive',293),('Angry / Aggressive',299),('Angry / Aggressive',321),('Angry / Aggressive',343),('Angry / Aggressive',361),('Angry / Aggressive',369),('Angry / Aggressive',370),('Angry / Aggressive',379),('Carefree',23),('Carefree',25),('Carefree',28),('Carefree',31),('Carefree',37),('Carefree',38),('Carefree',39),('Carefree',40),('Carefree',41),('Carefree',46),('Carefree',52),('Carefree',54),('Carefree',57),('Carefree',58),('Carefree',61),('Carefree',64),('Carefree',68),('Carefree',72),('Carefree',73),('Carefree',75),('Carefree',79),('Carefree',82),('Carefree',83),('Carefree',95),('Carefree',104),('Carefree',119),('Carefree',126),('Carefree',139),('Carefree',142),('Carefree',145),('Carefree',150),('Carefree',151),('Carefree',152),('Carefree',156),('Carefree',158),('Carefree',181),('Carefree',188),('Carefree',192),('Carefree',193),('Carefree',205),('Carefree',211),('Carefree',212),('Carefree',213),('Carefree',224),('Carefree',225),('Carefree',226),('Carefree',231),('Carefree',232),('Carefree',241),('Carefree',242),('Carefree',243),('Carefree',244),('Carefree',249),('Carefree',276),('Carefree',294),('Carefree',295),('Carefree',296),('Carefree',300),('Carefree',316),('Carefree',330),('Carefree',332),('Carefree',338),('Carefree',356),('Carefree',377),('Chill / Laid back',21),('Chill / Laid back',24),('Chill / Laid back',26),('Chill / Laid back',27),('Chill / Laid back',28),('Chill / Laid back',31),('Chill / Laid back',32),('Chill / Laid back',40),('Chill / Laid back',52),('Chill / Laid back',55),('Chill / Laid back',56),('Chill / Laid back',60),('Chill / Laid back',61),('Chill / Laid back',71),('Chill / Laid back',72),('Chill / Laid back',73),('Chill / Laid back',79),('Chill / Laid back',83),('Chill / Laid back',90),('Chill / Laid back',91),('Chill / Laid back',99),('Chill / Laid back',100),('Chill / Laid back',103),('Chill / Laid back',104),('Chill / Laid back',105),('Chill / Laid back',108),('Chill / Laid back',109),('Chill / Laid back',111),('Chill / Laid back',117),('Chill / Laid back',121),('Chill / Laid back',122),('Chill / Laid back',124),('Chill / Laid back',125),('Chill / Laid back',126),('Chill / Laid back',127),('Chill / Laid back',139),('Chill / Laid back',140),('Chill / Laid back',142),('Chill / Laid back',143),('Chill / Laid back',146),('Chill / Laid back',147),('Chill / Laid back',151),('Chill / Laid back',155),('Chill / Laid back',159),('Chill / Laid back',160),('Chill / Laid back',163),('Chill / Laid back',165),('Chill / Laid back',167),('Chill / Laid back',170),('Chill / Laid back',171),('Chill / Laid back',172),('Chill / Laid back',178),('Chill / Laid back',179),('Chill / Laid back',180),('Chill / Laid back',181),('Chill / Laid back',183),('Chill / Laid back',191),('Chill / Laid back',202),('Chill / Laid back',205),('Chill / Laid back',209),('Chill / Laid back',210),('Chill / Laid back',214),('Chill / Laid back',216),('Chill / Laid back',217),('Chill / Laid back',218),('Chill / Laid back',224),('Chill / Laid back',228),('Chill / Laid back',231),('Chill / Laid back',236),('Chill / Laid back',237),('Chill / Laid back',238),('Chill / Laid back',239),('Chill / Laid back',241),('Chill / Laid back',242),('Chill / Laid back',243),('Chill / Laid back',244),('Chill / Laid back',245),('Chill / Laid back',246),('Chill / Laid back',247),('Chill / Laid back',250),('Chill / Laid back',252),('Chill / Laid back',253),('Chill / Laid back',259),('Chill / Laid back',269),('Chill / Laid back',270),('Chill / Laid back',272),('Chill / Laid back',273),('Chill / Laid back',274),('Chill / Laid back',276),('Chill / Laid back',285),('Chill / Laid back',286),('Chill / Laid back',287),('Chill / Laid back',289),('Chill / Laid back',290),('Chill / Laid back',299),('Chill / Laid back',301),('Chill / Laid back',302),('Chill / Laid back',304),('Chill / Laid back',305),('Chill / Laid back',306),('Chill / Laid back',307),('Chill / Laid back',320),('Chill / Laid back',326),('Chill / Laid back',328),('Chill / Laid back',332),('Chill / Laid back',337),('Chill / Laid back',338),('Chill / Laid back',339),('Chill / Laid back',340),('Chill / Laid back',349),('Chill / Laid back',350),('Chill / Laid back',362),('Chill / Laid back',364),('Chill / Laid back',366),('Chill / Laid back',368),('Chill / Laid back',369),('Chill / Laid back',371),('Chill / Laid back',375),('Chill / Laid back',380),('Comical',29),('Comical',70),('Comical',97),('Comical',129),('Comical',131),('Comical',136),('Comical',137),('Comical',207),('Comical',208),('Comical',219),('Comical',313),('Comical',344),('Comical',357),('Dramatic',27),('Dramatic',29),('Dramatic',36),('Dramatic',37),('Dramatic',42),('Dramatic',45),('Dramatic',51),('Dramatic',56),('Dramatic',62),('Dramatic',65),('Dramatic',70),('Dramatic',71),('Dramatic',73),('Dramatic',78),('Dramatic',80),('Dramatic',86),('Dramatic',87),('Dramatic',101),('Dramatic',102),('Dramatic',113),('Dramatic',123),('Dramatic',124),('Dramatic',130),('Dramatic',131),('Dramatic',134),('Dramatic',135),('Dramatic',136),('Dramatic',137),('Dramatic',138),('Dramatic',144),('Dramatic',148),('Dramatic',157),('Dramatic',173),('Dramatic',174),('Dramatic',184),('Dramatic',185),('Dramatic',186),('Dramatic',187),('Dramatic',189),('Dramatic',190),('Dramatic',194),('Dramatic',195),('Dramatic',197),('Dramatic',200),('Dramatic',214),('Dramatic',221),('Dramatic',227),('Dramatic',244),('Dramatic',252),('Dramatic',253),('Dramatic',254),('Dramatic',255),('Dramatic',256),('Dramatic',257),('Dramatic',258),('Dramatic',259),('Dramatic',260),('Dramatic',261),('Dramatic',263),('Dramatic',264),('Dramatic',265),('Dramatic',266),('Dramatic',267),('Dramatic',268),('Dramatic',272),('Dramatic',277),('Dramatic',278),('Dramatic',281),('Dramatic',282),('Dramatic',284),('Dramatic',285),('Dramatic',297),('Dramatic',298),('Dramatic',315),('Dramatic',319),('Dramatic',321),('Dramatic',332),('Dramatic',335),('Dramatic',343),('Dramatic',344),('Dramatic',345),('Dramatic',349),('Dramatic',352),('Dramatic',354),('Dramatic',355),('Dramatic',357),('Dramatic',359),('Dramatic',363),('Dramatic',372),('Dramatic',381),('Ecstatic',30),('Ecstatic',32),('Ecstatic',34),('Ecstatic',35),('Ecstatic',37),('Ecstatic',39),('Ecstatic',41),('Ecstatic',42),('Ecstatic',47),('Ecstatic',51),('Ecstatic',68),('Ecstatic',79),('Ecstatic',82),('Ecstatic',85),('Ecstatic',86),('Ecstatic',93),('Ecstatic',95),('Ecstatic',104),('Ecstatic',113),('Ecstatic',114),('Ecstatic',123),('Ecstatic',129),('Ecstatic',130),('Ecstatic',136),('Ecstatic',152),('Ecstatic',157),('Ecstatic',164),('Ecstatic',166),('Ecstatic',181),('Ecstatic',205),('Ecstatic',217),('Ecstatic',275),('Ecstatic',295),('Ecstatic',296),('Ecstatic',341),('Ecstatic',342),('Ecstatic',346),('Ecstatic',348),('Happy / uplifting',20),('Happy / uplifting',22),('Happy / uplifting',29),('Happy / uplifting',32),('Happy / uplifting',34),('Happy / uplifting',35),('Happy / uplifting',38),('Happy / uplifting',44),('Happy / uplifting',46),('Happy / uplifting',47),('Happy / uplifting',48),('Happy / uplifting',50),('Happy / uplifting',53),('Happy / uplifting',54),('Happy / uplifting',55),('Happy / uplifting',57),('Happy / uplifting',59),('Happy / uplifting',63),('Happy / uplifting',66),('Happy / uplifting',67),('Happy / uplifting',69),('Happy / uplifting',74),('Happy / uplifting',75),('Happy / uplifting',76),('Happy / uplifting',77),('Happy / uplifting',80),('Happy / uplifting',81),('Happy / uplifting',84),('Happy / uplifting',85),('Happy / uplifting',88),('Happy / uplifting',89),('Happy / uplifting',92),('Happy / uplifting',93),('Happy / uplifting',94),('Happy / uplifting',96),('Happy / uplifting',97),('Happy / uplifting',98),('Happy / uplifting',99),('Happy / uplifting',105),('Happy / uplifting',106),('Happy / uplifting',108),('Happy / uplifting',112),('Happy / uplifting',114),('Happy / uplifting',116),('Happy / uplifting',118),('Happy / uplifting',119),('Happy / uplifting',120),('Happy / uplifting',125),('Happy / uplifting',141),('Happy / uplifting',145),('Happy / uplifting',148),('Happy / uplifting',149),('Happy / uplifting',150),('Happy / uplifting',152),('Happy / uplifting',154),('Happy / uplifting',156),('Happy / uplifting',158),('Happy / uplifting',162),('Happy / uplifting',163),('Happy / uplifting',164),('Happy / uplifting',166),('Happy / uplifting',168),('Happy / uplifting',177),('Happy / uplifting',178),('Happy / uplifting',179),('Happy / uplifting',180),('Happy / uplifting',182),('Happy / uplifting',185),('Happy / uplifting',190),('Happy / uplifting',192),('Happy / uplifting',193),('Happy / uplifting',196),('Happy / uplifting',198),('Happy / uplifting',203),('Happy / uplifting',204),('Happy / uplifting',207),('Happy / uplifting',208),('Happy / uplifting',211),('Happy / uplifting',212),('Happy / uplifting',213),('Happy / uplifting',215),('Happy / uplifting',222),('Happy / uplifting',223),('Happy / uplifting',226),('Happy / uplifting',228),('Happy / uplifting',230),('Happy / uplifting',243),('Happy / uplifting',244),('Happy / uplifting',246),('Happy / uplifting',248),('Happy / uplifting',249),('Happy / uplifting',251),('Happy / uplifting',262),('Happy / uplifting',265),('Happy / uplifting',273),('Happy / uplifting',275),('Happy / uplifting',287),('Happy / uplifting',288),('Happy / uplifting',291),('Happy / uplifting',294),('Happy / uplifting',295),('Happy / uplifting',296),('Happy / uplifting',299),('Happy / uplifting',301),('Happy / uplifting',302),('Happy / uplifting',303),('Happy / uplifting',304),('Happy / uplifting',305),('Happy / uplifting',306),('Happy / uplifting',315),('Happy / uplifting',316),('Happy / uplifting',324),('Happy / uplifting',325),('Happy / uplifting',341),('Happy / uplifting',342),('Happy / uplifting',346),('Happy / uplifting',347),('Happy / uplifting',348),('Happy / uplifting',353),('Happy / uplifting',356),('Happy / uplifting',358),('Happy / uplifting',361),('Happy / uplifting',365),('Happy / uplifting',368),('Happy / uplifting',370),('Happy / uplifting',373),('Happy / uplifting',374),('Happy / uplifting',376),('Happy / uplifting',377),('Happy / uplifting',378),('Happy / uplifting',379),('Inspirational',23),('Inspirational',33),('Inspirational',34),('Inspirational',35),('Inspirational',36),('Inspirational',38),('Inspirational',39),('Inspirational',41),('Inspirational',43),('Inspirational',45),('Inspirational',46),('Inspirational',49),('Inspirational',50),('Inspirational',52),('Inspirational',53),('Inspirational',58),('Inspirational',59),('Inspirational',63),('Inspirational',64),('Inspirational',66),('Inspirational',68),('Inspirational',69),('Inspirational',72),('Inspirational',74),('Inspirational',75),('Inspirational',78),('Inspirational',81),('Inspirational',82),('Inspirational',83),('Inspirational',85),('Inspirational',89),('Inspirational',93),('Inspirational',94),('Inspirational',95),('Inspirational',96),('Inspirational',97),('Inspirational',98),('Inspirational',105),('Inspirational',114),('Inspirational',115),('Inspirational',118),('Inspirational',120),('Inspirational',121),('Inspirational',129),('Inspirational',130),('Inspirational',141),('Inspirational',145),('Inspirational',150),('Inspirational',155),('Inspirational',168),('Inspirational',169),('Inspirational',175),('Inspirational',183),('Inspirational',185),('Inspirational',188),('Inspirational',189),('Inspirational',190),('Inspirational',192),('Inspirational',193),('Inspirational',199),('Inspirational',200),('Inspirational',203),('Inspirational',204),('Inspirational',215),('Inspirational',216),('Inspirational',226),('Inspirational',231),('Inspirational',232),('Inspirational',234),('Inspirational',241),('Inspirational',243),('Inspirational',245),('Inspirational',246),('Inspirational',248),('Inspirational',250),('Inspirational',252),('Inspirational',253),('Inspirational',254),('Inspirational',255),('Inspirational',258),('Inspirational',259),('Inspirational',260),('Inspirational',264),('Inspirational',265),('Inspirational',266),('Inspirational',267),('Inspirational',270),('Inspirational',273),('Inspirational',277),('Inspirational',280),('Inspirational',283),('Inspirational',288),('Inspirational',292),('Inspirational',297),('Inspirational',298),('Inspirational',300),('Inspirational',306),('Inspirational',307),('Inspirational',308),('Inspirational',312),('Inspirational',314),('Inspirational',315),('Inspirational',317),('Inspirational',321),('Inspirational',323),('Inspirational',328),('Inspirational',351),('Inspirational',354),('Inspirational',358),('Inspirational',359),('Inspirational',361),('Inspirational',367),('Inspirational',369),('Inspirational',370),('Inspirational',375),('Love / affection',25),('Love / affection',26),('Love / affection',40),('Love / affection',44),('Love / affection',47),('Love / affection',48),('Love / affection',49),('Love / affection',50),('Love / affection',55),('Love / affection',57),('Love / affection',63),('Love / affection',66),('Love / affection',67),('Love / affection',69),('Love / affection',74),('Love / affection',76),('Love / affection',77),('Love / affection',81),('Love / affection',84),('Love / affection',88),('Love / affection',90),('Love / affection',91),('Love / affection',92),('Love / affection',96),('Love / affection',98),('Love / affection',100),('Love / affection',103),('Love / affection',106),('Love / affection',107),('Love / affection',109),('Love / affection',111),('Love / affection',112),('Love / affection',116),('Love / affection',117),('Love / affection',119),('Love / affection',120),('Love / affection',121),('Love / affection',122),('Love / affection',125),('Love / affection',127),('Love / affection',128),('Love / affection',140),('Love / affection',142),('Love / affection',143),('Love / affection',146),('Love / affection',147),('Love / affection',149),('Love / affection',155),('Love / affection',156),('Love / affection',163),('Love / affection',165),('Love / affection',167),('Love / affection',168),('Love / affection',169),('Love / affection',171),('Love / affection',172),('Love / affection',176),('Love / affection',182),('Love / affection',203),('Love / affection',206),('Love / affection',210),('Love / affection',222),('Love / affection',229),('Love / affection',230),('Love / affection',241),('Love / affection',247),('Love / affection',248),('Love / affection',249),('Love / affection',251),('Love / affection',262),('Love / affection',274),('Love / affection',279),('Love / affection',286),('Love / affection',291),('Love / affection',294),('Love / affection',305),('Love / affection',320),('Love / affection',322),('Love / affection',325),('Love / affection',326),('Love / affection',327),('Love / affection',328),('Love / affection',329),('Love / affection',331),('Love / affection',352),('Love / affection',358),('Love / affection',362),('Love / affection',364),('Love / affection',365),('Love / affection',372),('Love / affection',373),('Love / affection',374),('Love / affection',375),('Love / affection',376),('Love / affection',377),('Love / affection',378),('Love / affection',382),('Peaceful',26),('Peaceful',44),('Peaceful',61),('Peaceful',67),('Peaceful',107),('Peaceful',128),('Peaceful',188),('Peaceful',191),('Peaceful',200),('Peaceful',206),('Peaceful',209),('Peaceful',220),('Peaceful',224),('Peaceful',225),('Peaceful',232),('Peaceful',236),('Peaceful',237),('Peaceful',238),('Peaceful',239),('Peaceful',241),('Peaceful',242),('Peaceful',243),('Peaceful',244),('Peaceful',245),('Peaceful',250),('Peaceful',263),('Peaceful',270),('Peaceful',286),('Peaceful',287),('Peaceful',300),('Peaceful',301),('Peaceful',303),('Peaceful',304),('Peaceful',307),('Peaceful',308),('Peaceful',309),('Peaceful',310),('Peaceful',311),('Peaceful',334),('Peaceful',337),('Peaceful',338),('Peaceful',339),('Peaceful',340),('Peaceful',353),('Peaceful',363),('Peaceful',368),('Peaceful',376),('Peaceful',378),('Quirky',30),('Quirky',36),('Quirky',45),('Quirky',51),('Quirky',53),('Quirky',56),('Quirky',59),('Quirky',62),('Quirky',70),('Quirky',71),('Quirky',86),('Quirky',87),('Quirky',102),('Quirky',113),('Quirky',123),('Quirky',132),('Quirky',134),('Quirky',135),('Quirky',137),('Quirky',144),('Quirky',148),('Quirky',153),('Quirky',157),('Quirky',164),('Quirky',166),('Quirky',177),('Quirky',180),('Quirky',201),('Quirky',207),('Quirky',208),('Quirky',211),('Quirky',212),('Quirky',213),('Quirky',214),('Quirky',217),('Quirky',225),('Quirky',233),('Quirky',272),('Quirky',280),('Quirky',302),('Quirky',313),('Quirky',344),('Quirky',356),('Quirky',357),('Quirky',359),('Quirky',379),('Sad / Melancholy',60),('Sad / Melancholy',117),('Sad / Melancholy',122),('Sad / Melancholy',128),('Sad / Melancholy',132),('Sad / Melancholy',133),('Sad / Melancholy',167),('Sad / Melancholy',169),('Sad / Melancholy',170),('Sad / Melancholy',171),('Sad / Melancholy',172),('Sad / Melancholy',175),('Sad / Melancholy',176),('Sad / Melancholy',194),('Sad / Melancholy',195),('Sad / Melancholy',228),('Sad / Melancholy',236),('Sad / Melancholy',237),('Sad / Melancholy',238),('Sad / Melancholy',239),('Sad / Melancholy',240),('Sad / Melancholy',247),('Sad / Melancholy',263),('Sad / Melancholy',269),('Sad / Melancholy',274),('Sad / Melancholy',285),('Sad / Melancholy',289),('Sad / Melancholy',290),('Sad / Melancholy',292),('Sad / Melancholy',293),('Sad / Melancholy',297),('Sad / Melancholy',298),('Sad / Melancholy',310),('Sad / Melancholy',311),('Sad / Melancholy',326),('Sad / Melancholy',327),('Sad / Melancholy',343),('Sad / Melancholy',360),('Sad / Melancholy',371),('Sad / Melancholy',372),('Scary',33),('Scary',58),('Scary',65),('Scary',101),('Scary',102),('Scary',124),('Scary',134),('Scary',184),('Scary',186),('Scary',235),('Scary',268),('Scary',271),('Scary',345),('Scary',355),('Scary',363),('Sensual / sexy',24),('Sensual / sexy',31),('Sensual / sexy',43),('Sensual / sexy',48),('Sensual / sexy',49),('Sensual / sexy',54),('Sensual / sexy',60),('Sensual / sexy',76),('Sensual / sexy',77),('Sensual / sexy',80),('Sensual / sexy',84),('Sensual / sexy',87),('Sensual / sexy',88),('Sensual / sexy',89),('Sensual / sexy',90),('Sensual / sexy',91),('Sensual / sexy',92),('Sensual / sexy',94),('Sensual / sexy',99),('Sensual / sexy',100),('Sensual / sexy',103),('Sensual / sexy',106),('Sensual / sexy',107),('Sensual / sexy',108),('Sensual / sexy',109),('Sensual / sexy',111),('Sensual / sexy',112),('Sensual / sexy',116),('Sensual / sexy',118),('Sensual / sexy',126),('Sensual / sexy',127),('Sensual / sexy',133),('Sensual / sexy',139),('Sensual / sexy',140),('Sensual / sexy',141),('Sensual / sexy',143),('Sensual / sexy',144),('Sensual / sexy',146),('Sensual / sexy',147),('Sensual / sexy',149),('Sensual / sexy',151),('Sensual / sexy',158),('Sensual / sexy',161),('Sensual / sexy',173),('Sensual / sexy',174),('Sensual / sexy',182),('Sensual / sexy',187),('Sensual / sexy',210),('Sensual / sexy',229),('Sensual / sexy',303),('Sensual / sexy',310),('Sensual / sexy',318),('Sensual / sexy',325),('Sensual / sexy',353),('Sensual / sexy',365),('Sensual / sexy',371),('Sensual / sexy',374),('Somber',78),('Somber',135),('Somber',170),('Somber',176),('Somber',184),('Somber',187),('Somber',191),('Somber',194),('Somber',195),('Somber',220),('Somber',277),('Somber',289),('Somber',290),('Somber',292),('Somber',293),('Somber',309),('Somber',311),('Somber',319),('Somber',323),('Somber',327),('Somber',360);
/*!40000 ALTER TABLE `moods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paypal_access`
--

DROP TABLE IF EXISTS `paypal_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paypal_access` (
  `client_id` varchar(128) NOT NULL,
  `access_token` varchar(128) NOT NULL,
  `expiry_timestamp` int NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paypal_access`
--

LOCK TABLES `paypal_access` WRITE;
/*!40000 ALTER TABLE `paypal_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `paypal_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_lifestyle`
--

DROP TABLE IF EXISTS `track_lifestyle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_lifestyle` (
  `lifestyle_id` int unsigned NOT NULL,
  `track_id` int unsigned NOT NULL,
  PRIMARY KEY (`lifestyle_id`,`track_id`),
  KEY `track_id` (`track_id`),
  CONSTRAINT `track_lifestyle_ibfk_1` FOREIGN KEY (`lifestyle_id`) REFERENCES `lifestyles` (`lifestyle_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_lifestyle_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_lifestyle`
--

LOCK TABLES `track_lifestyle` WRITE;
/*!40000 ALTER TABLE `track_lifestyle` DISABLE KEYS */;
/*!40000 ALTER TABLE `track_lifestyle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks`
--

DROP TABLE IF EXISTS `tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracks` (
  `track_id` int unsigned NOT NULL AUTO_INCREMENT,
  `checksum` varchar(64) NOT NULL,
  `title` varchar(256) NOT NULL,
  `artist` varchar(128) NOT NULL,
  `writer` varchar(128) DEFAULT NULL,
  `duration` double(32,4) NOT NULL,
  `type` enum('music','incidental','sfx') NOT NULL DEFAULT 'music',
  `copyright_year` year DEFAULT NULL,
  `date_added` datetime NOT NULL,
  `date_reviewed` datetime DEFAULT NULL,
  `reviewed` tinyint(1) NOT NULL DEFAULT '0',
  `accepted` tinyint(1) NOT NULL DEFAULT '0',
  `email` varchar(128) DEFAULT NULL,
  `tempo` int DEFAULT NULL,
  `file_name` varchar(128) DEFAULT NULL,
  `vocals` tinyint(1) NOT NULL DEFAULT '0',
  `style` enum('Music with vocals','Instrumental','Acapella','Poetry') DEFAULT NULL,
  `cae_number` varchar(128) DEFAULT NULL,
  `master_recording_owner` text,
  `commercial_licence_only` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`track_id`),
  KEY `checksum` (`checksum`),
  KEY `artist` (`artist`),
  KEY `writer` (`writer`)
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks`
--

LOCK TABLES `tracks` WRITE;
/*!40000 ALTER TABLE `tracks` DISABLE KEYS */;
INSERT INTO `tracks` VALUES (21,'2710dec0fe4e46eeb03f48c7ad4e46cb2822f832','Breathe ','Jay.J','Jay.j',242.5667,'music',2017,'2018-05-11 12:37:37','2018-05-11 12:37:37',1,1,'jaf15711@hotmail.co.uk',177,'Jay.J Breathe ',1,'Music with vocals',NULL,NULL,0),(23,'71a6e78b1f32b962e1714c7216224c3ef90289ec','Country Grammar','Tez-lee','Jay.J',163.4734,'music',2017,'2018-05-11 12:43:37','2018-05-11 12:43:37',1,1,'jaf15711@hotmail.co.uk',106,'Tez-lee Country Grammar',1,'Instrumental',NULL,NULL,0),(24,'23b98faf330df7d5da7d344d2ae8849acb8d65de','Do You Remember ','Jay.J','Jay.J',268.0000,'music',2017,'2018-05-11 12:47:49','2018-05-11 12:47:49',1,1,'jaf15711@hotmail.co.uk',144,'Jay.J Do You Remember ',0,'Instrumental',NULL,NULL,0),(25,'f4c94798a1a734ffc445b59952a4f8e67ed52de6','Falling','Jay.J','Jay.J',214.8250,'music',2017,'2018-05-11 13:43:03','2018-05-11 13:43:03',1,1,'jaf15711@hotmail.co.uk',97,'Jay.J Falling',1,'Instrumental',NULL,NULL,0),(26,'a5bd8fdfc0921b844bf83c3414199f0ab2732364','Fantasy','Jay.J','Jay.J',224.5484,'music',2017,'2018-05-11 13:46:57','2018-05-11 13:46:57',1,1,'jaf15711@hotmail.co.uk',173,'Jay.J Fantasy',1,'Instrumental',NULL,NULL,0),(27,'87a6792848375f42dd10211d416e83b18c19e827','Find The Galaxy','Jay.J','Jay.J',187.1745,'music',2017,'2018-05-11 13:50:11','2018-05-11 13:50:11',1,1,'jaf15711@hotmail.co.uk',113,'Jay.J Find The Galaxy',1,'Instrumental',NULL,NULL,0),(28,'5a9ab30b1bb55344314fa5a47b59ac317424f600','Girls x4','Jay.J','Jay.J',213.0021,'music',2017,'2018-05-11 13:53:55','2018-05-11 13:53:55',1,1,'jaf15711@hotmail.co.uk',107,'Jay.J Girls x4',1,NULL,NULL,NULL,0),(29,'fab259fb39277ac3ff9f5f69dfcb8234db74eb6e','I Need You Love','Jay.J','Jay.J',227.8911,'music',2017,'2018-05-11 13:57:18','2018-05-11 13:57:18',1,1,'jaf15711@hotmail.co.uk',106,'Jay.J I Need You Love',1,'Music with vocals',NULL,NULL,0),(30,'d685a83acaa65bbb45d40e12c3871475837d9f4d','In The Future','Jay.J','Jay.J',188.0859,'music',2017,'2018-05-11 14:00:41','2018-05-11 14:00:41',1,1,'jaf15711@hotmail.co.uk',135,'Jay.J In The Future',1,'Music with vocals',NULL,NULL,0),(31,'c4aa8e74c9032ad83816b3dc1d7dd38929cbd1ff','Inner World','Jay.J','Jay.J',207.8364,'music',2017,'2018-05-11 14:03:29','2018-05-11 14:03:29',1,1,'jaf15711@hotmail.co.uk',117,'Jay.J Inner World',1,'Instrumental',NULL,NULL,0),(32,'535d4d7702855fde7bd9a5caf99637e8a1ca75a2','Jam With Me 2nite','Jay.J','Jay.J',224.5484,'music',2017,'2018-05-11 14:06:49','2018-05-11 14:06:49',1,1,'jaf15711@hotmail.co.uk',106,'Jay.J Jam With Me 2nite',1,'Music with vocals',NULL,NULL,0),(33,'21c6c07903cec21ff81967cfe0101d5015eafcd3','Live My Life','Jay.J','Jay.J',235.1833,'music',2017,'2018-05-11 14:11:03','2018-05-11 14:11:03',1,1,'jaf15711@hotmail.co.uk',92,'Jay.J Live My Life',1,'Instrumental',NULL,NULL,0),(34,'03a62f1e9c1c03625924cfb843b25294ab371cb8','Never Give Up','Jay.J','Jay.J',220.0000,'music',0000,'2018-05-11 14:14:34','2018-05-11 14:14:34',1,1,'jaf15711@hotmail.co.uk',129,'Jay.J Never Give Up',1,'Instrumental',NULL,NULL,0),(35,'f2bf4f629e886827d14fcd66cea11a382aea0fcf','Off The Rails','Jay.J','Jay.J',214.5213,'music',2017,'2018-05-11 14:17:48','2018-05-11 14:17:48',1,1,'jaf15711@hotmail.co.uk',91,'Jay.J Off The Rails',0,'Instrumental',NULL,NULL,0),(36,'d47c6a4cf8515cb0439c9fcf74affc3c248eca4f','On The Run','Jay.J','Jay.J',207.2286,'music',2017,'2018-05-11 14:20:58','2018-05-11 14:20:58',1,1,'jaf15711@hotmail.co.uk',107,'Jay.J On The Run',1,'Instrumental',NULL,NULL,0),(37,'085fe40c30880e3d5d3a35460d67696c2dfd3b50','Party Tonight','Jay.J','Jay.J',222.7255,'music',2017,'2018-05-11 14:24:08','2018-05-11 14:24:08',1,1,'jaf15711@hotmail.co.uk',102,'Jay.J Party Tonight',1,'Music with vocals',NULL,NULL,1),(38,'c2d4887b84dcee3aa215bad70b6c9d2aa3729193','Please ','Jay.J','Jay.J',240.0000,'music',2017,'2018-05-11 14:26:53','2018-05-11 14:26:53',1,1,'jaf15711@hotmail.co.uk',105,'Jay.J Please ',1,'Instrumental',NULL,NULL,0),(39,'54b44577383e869864e4c2cc17c98f271c65cfb2','Pleasures Of The Soul','Jay.J','Jay.J',190.8208,'music',2017,'2018-05-11 14:30:15','2018-05-11 14:30:15',1,1,'jaf15711@hotmail.co.uk',122,'Jay.J Pleasures Of The Soul',1,'Instrumental',NULL,NULL,0),(40,'356f4e06b77554ce064c37a57e89476d2125ca45','Rene Sweet ','Jay.J','Jay.J',253.4146,'music',2017,'2018-05-11 14:33:52','2018-05-11 14:33:52',1,1,'jaf15711@hotmail.co.uk',90,'Jay.J Rene Sweet ',1,'Music with vocals',NULL,NULL,0),(41,'87653193ee43ccea743ff11ee96accdbf7c99b50','Should\'ve Let You Go','Jay.J','Jay.J',247.9453,'music',2017,'2018-05-11 14:38:03','2018-05-11 14:38:03',1,1,'jaf15711@hotmail.co.uk',104,'Jay.J Should\'ve Let You Go',1,'Instrumental',NULL,NULL,0),(42,'8b238c176810d280daf2b066cfd29825b83131e8','So Long Wow','Jay.J','Jay.J',192.0359,'music',2017,'2018-05-11 14:41:01','2018-05-11 14:41:01',1,1,'jaf15711@hotmail.co.uk',100,'Jay.J So Long Wow',1,'Instrumental',NULL,NULL,0),(43,'5bd56b6cbe8829c5774a41cfe80cc84b18642071','Social Network','Jay.J','Jay.J',243.8453,'music',2017,'2018-05-11 14:44:01','2018-05-11 14:44:01',1,1,'jaf15711@hotmail.co.uk',103,'Jay.J Social Network',1,'Instrumental',NULL,NULL,0),(44,'24d0105d0986af6735e7947ae227118d3f592dc6','Soft Chimes','Jay.J','Jay.J',212.2990,'music',2017,'2018-05-11 14:48:39','2018-05-11 14:48:39',1,1,'jaf15711@hotmail.co.uk',92,'Jay.J Soft Chimes',1,'Instrumental',NULL,NULL,0),(45,'515d76ec926b1a8d933f45d89a2991518fda28e7','Transmission','Jay.J','Jay.J',208.2922,'music',2017,'2018-05-11 14:51:59','2018-05-11 14:51:59',1,1,'jaf15711@hotmail.co.uk',126,'Jay.J Transmission',1,'Instrumental',NULL,NULL,0),(46,'d310a29040ca551c8b37bfb3c2506ac70434dcbf','WFM','Jay.J','Jay.J',260.0000,'music',2017,'2018-05-11 14:56:05','2018-05-11 14:56:05',1,1,'jaf15711@hotmail.co.uk',91,'Jay.J WFM',1,'Instrumental',NULL,NULL,0),(47,'6b1576935c445fed5bf7c1cc5a80a4b6bcca1bfd','What Can I Do','Jay.J','Jay.J',210.6120,'music',2017,'2018-05-11 14:58:44','2018-05-11 14:58:44',1,1,'jaf15711@hotmail.co.uk',100,'Jay.J What Can I Do',1,'Instrumental',NULL,NULL,0),(48,'95581d7d3afecdd46558b98961ad5f98cf9f7e3a','Will You Marry Me','Jay.J','Jay.J',216.5984,'music',2017,'2018-05-11 15:02:17','2018-05-11 15:02:17',1,1,'jaf15711@hotmail.co.uk',122,'Jay.J Will You Marry Me',1,'Instrumental',NULL,NULL,0),(49,'a3708e9c2a1de19b38805997e759edbee6ae6843','Da Bp','Jay.J','Jay.J',190.0000,'music',2017,'2018-05-11 15:05:55','2018-05-11 15:05:55',1,1,'jaf15711@hotmail.co.uk',108,'Jay.J Da Bp',1,'Instrumental',NULL,NULL,0),(50,'651b55db0a42313b103712a1895bf4b43bc623d4','Groove Your Body Jay Mix','Tez-lee Cynthia  Erivo','Jay.J',314.6120,'music',2009,'2018-05-11 15:13:13','2018-05-11 15:13:13',1,1,'jaf15711@hotmail.co.uk',125,'Tez-lee Cynthia  Erivo Groove Your Body Jay Mix',1,'Music with vocals',NULL,NULL,0),(51,'2ebed891acef17aa36ab24b4713ffe562b27a2d3','If The Feelings Right','Martell Mckenzie','Jay.J Martell ',231.4828,'music',2010,'2018-05-11 16:00:07','2018-05-11 16:00:07',1,1,'jaf15711@hotmail.co.uk',110,'Martell Mckenzie If The Feelings Right',1,'Music with vocals',NULL,NULL,0),(52,'399878a1ac428689f87b89045991d86b3f995a7a','Joe Joey GO','Jay.J','Jay.J',225.0880,'music',2010,'2018-05-11 16:02:20','2018-05-11 16:02:20',1,1,'jaf15711@hotmail.co.uk',98,'Jay.J Joe Joey GO',1,'Instrumental',NULL,NULL,0),(53,'acb282725d2773e9c2d970e1c1ed3fc2e7565324','Lady\'s and Gentlemen','Jay.J','Jay.J',161.5687,'music',2010,'2018-05-11 16:03:59','2018-05-11 16:03:59',1,1,'jaf15711@hotmail.co.uk',98,'Jay.J Lady\'s and Gentlemen',0,'Instrumental',NULL,NULL,0),(54,'36ca4fb0ac5a1ee94591b8ad1ff470b4d77bbc60','Let\'s Do IT','Tezlee Rene Byrd','Jay.J',188.0000,'music',2010,'2018-05-11 16:06:28','2018-05-11 16:06:28',1,1,'jaf15711@hotmail.co.uk',110,'Tezlee Rene Byrd Let\'s Do IT',1,'Instrumental',NULL,NULL,0),(55,'2db619b1748d5344297a89cde0593758f6059a49','Make It Happen','Jay.J','Jay.J',188.0000,'music',2016,'2018-05-11 16:08:41','2018-05-11 16:08:41',1,1,'jaf15711@hotmail.co.uk',128,'Jay.J Make It Happen',1,'Music with vocals',NULL,NULL,0),(56,'54843a06571c3517d2b1027f6fd63e017b757e42','Baby Girl Star Bright','Jay.J','Jay.J',24.2990,'music',2016,'2018-05-11 16:13:20','2018-05-11 16:13:20',1,1,'jaf15711@hotmail.co.uk',95,'Jay.J Baby Girl Star Bright',1,'Instrumental',NULL,NULL,0),(57,'7d16734e34db72540882c6e427cb4e6d0c61868c','Champagne','Jay.J','Jay.J',72.4713,'music',2016,'2018-05-11 16:15:12','2018-05-11 16:15:12',1,1,'jaf15711@hotmail.co.uk',110,'Jay.J Champagne',1,'Instrumental',NULL,NULL,0),(58,'c88aeedb9d1ce916c47d60630a9c669523f2c1d3','Climate','Jay.J','Jay.J',222.5302,'music',2016,'2018-05-11 16:17:52','2018-05-11 16:17:52',1,1,'jaf15711@hotmail.co.uk',105,'Jay.J Climate',1,'Instrumental',NULL,NULL,0),(59,'52ea464116397daa243e330af00572ad7a8b9959','Da Funk','Jay.J','Jay.J',70.0000,'music',2016,'2018-05-11 16:18:58','2018-05-11 16:18:58',1,1,'jaf15711@hotmail.co.uk',112,'Jay.J Da Funk',1,'Instrumental',NULL,NULL,0),(60,'7682cc819574d6e4f4025ae735d4662cc8ce7d31','Deep Climax','Jay.J','Jay.J',11.0000,'music',2016,'2018-05-11 16:19:47','2018-05-11 16:19:47',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Deep Climax',1,'Instrumental',NULL,NULL,0),(61,'b634ab6720c6d3711771c34bc85a317229c72d2d','Dimension Harps','Jay.J','Jay.J',11.0000,'music',2016,'2018-05-11 16:20:37','2018-05-11 16:20:37',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Dimension Harps',1,'Instrumental',NULL,NULL,0),(62,'db7ed2ed4ee151c8b3c33da52a3cf688b7db6966','Electricity In Space','Jay.J','Jay.J',6.2875,'music',2016,'2018-05-11 16:21:28','2018-05-11 16:21:28',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Electricity In Space',1,'Instrumental',NULL,NULL,0),(63,'b51082cd3ab09f4531ca586135169c6080c05de2','Go On A Journey','Jay.J','Jay.J',28.2958,'music',2016,'2018-05-11 16:22:25','2018-05-11 16:22:25',1,1,'jaf15711@hotmail.co.uk',150,'Jay.J Go On A Journey',1,'Instrumental',NULL,NULL,0),(65,'eac24f235e4a8063b92ae6662182eaf226bed9be','I Need To Let Go Stab','Tez-lee','Jay.J',13.3750,'music',2016,'2018-05-11 16:24:21','2018-05-11 16:24:21',1,1,'jaf15711@hotmail.co.uk',137,'Tez-lee I Need To Let Go Stab',1,'Music with vocals',NULL,NULL,0),(66,'7876faaa13a2112585af3f52f296be6afc83ade7','Impossible','Jay.J','Jay.J',10.6041,'music',2016,'2018-05-11 16:25:09','2018-05-11 16:25:09',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Impossible',1,'Instrumental',NULL,NULL,0),(70,'e19552399e689139eda69a1c7c5dbe2cfcaa8f05','So Long Wow1','Jay.J','Jay.J',193.9682,'music',2012,'2018-05-11 16:32:08','2018-05-11 16:32:08',1,1,'jaf15711@hotmail.co.uk',100,'Jay.J So Long Wow1',0,'Instrumental',NULL,NULL,0),(71,'4249cfbd23bcd11b21c034a3822a051c8a3f1f8c','Threw The Eyes Of A Eagle Part 2','Jay.J','Jay.J',20.0000,'music',2016,'2018-05-11 16:33:15','2018-05-11 16:33:15',1,1,'jaf15711@hotmail.co.uk',115,'Jay.J Threw The Eyes Of A Eagle Part 2',0,'Instrumental',NULL,NULL,0),(73,'ddd7ae01bffb6a357c0e04580e76be8db61e3b41','Threw The Eyes Of A Eagle ','Jay.J','Jay.J',25.5781,'music',2016,'2018-05-11 16:35:34','2018-05-11 16:35:34',1,1,'jaf15711@hotmail.co.uk',129,'Jay.J Threw The Eyes Of A Eagle ',1,'Instrumental',NULL,NULL,0),(74,'8b9f37bc9a5b38a1c4bc8b25f7c0a3f3803bf7fb','Anything You Wanna Be','King Bowza','Jay.J/ Dellion Laurent',206.2583,'music',2008,'2018-05-11 16:39:32','2018-05-11 16:39:32',1,1,'jaf15711@hotmail.co.uk',138,'King Bowza Anything You Wanna Be',1,'Music with vocals',NULL,NULL,0),(75,'940c3afd317a636bfaf7dea528c268b0e55dca19','Anything You Wanna Be Instrumental ','Jay.J','Jay.J',206.2583,'music',2008,'2018-05-11 16:43:21','2018-05-11 16:43:21',1,1,'jaf15711@hotmail.co.uk',138,'Jay.J Anything You Wanna Be Instrumental ',1,'Instrumental',NULL,NULL,0),(76,'2b9674ac92d6ecac3d43655f128575ba53352160','Baby Girl (club)','King Bowza Tezlee Jay.J','Jay.J Dellion Laurent',240.0000,'music',2008,'2018-05-11 16:46:23','2018-05-11 16:46:23',1,1,'jaf15711@hotmail.co.uk',95,'King Bowza Tezlee Jay.J Baby Girl (club)',1,'Instrumental',NULL,NULL,0),(77,'fa1681fa2cb9cd4bdd6a1dc7d5b6adb1f63aaa94','Baby Girl ','King Bowza Tez lee Jay.J','Jay.J Dellion Laurent',200.0000,'music',2008,'2018-05-11 16:49:20','2018-05-11 16:49:20',1,1,'jaf15711@hotmail.co.uk',95,'King Bowza Tez lee Jay.J Baby Girl ',1,'Music with vocals',NULL,NULL,0),(78,'08394676511300be933162596cc3201169d377f3','Deep Instrumental ','Jay.J','Jay.J',272.3760,'music',2003,'2018-05-11 16:53:54','2018-05-11 16:53:54',1,1,'jaf15711@hotmail.co.uk',97,'Jay.J Deep Instrumental ',0,NULL,NULL,NULL,0),(79,'e739da509294154f0147b529afe0c7d95cc636e4','Girl Like You','Jay.J','Jay.J',102.1026,'music',2010,'2018-05-11 16:56:24','2018-05-11 16:56:24',1,1,'jaf15711@hotmail.co.uk',95,'Jay.J Girl Like You',1,'Instrumental',NULL,NULL,0),(80,'3f76b77707433938e26be26e16b7668ed43ada1a','Lock In Lock Out','Tez-lee Martell Mckenzie','Jay.J Tez-lee Martell ',210.0000,'music',2008,'2018-05-11 16:58:40','2018-05-11 16:58:40',1,1,'jaf15711@hotmail.co.uk',98,'Tez-lee Martell Mckenzie Lock In Lock Out',1,'Music with vocals',NULL,NULL,0),(81,'b6550964b62e22886911d5b6db63359ca21225dc','Lovely Day','Natalia','Jay.J',216.7390,'music',2008,'2018-05-11 17:01:09','2018-05-11 17:01:09',1,1,'jaf15711@hotmail.co.uk',169,'Natalia Lovely Day',1,'Music with vocals',NULL,NULL,0),(82,'b510b4a06764ddac0276eb8039a0b6a879d245c8','Ohhhhh My','Jay.J','Jay.J',201.7599,'music',2005,'2018-05-11 17:03:05','2018-05-11 17:03:05',1,1,'jaf15711@hotmail.co.uk',101,'Jay.J Ohhhhh My',1,'Instrumental',NULL,NULL,0),(83,'6977a7894924db8790c8beb999019b402bb5205b','Snow','Jay.J','Jay.J',81.4682,'music',2008,'2018-05-11 17:04:58','2018-05-11 17:04:58',1,1,'jaf15711@hotmail.co.uk',90,'Jay.J Snow',1,'Instrumental',NULL,NULL,0),(84,'fb6fd8c11d83a69d0ba6dbe8466a31490153cfe3','Feeling It ','Da Specialists','Tez-lee',270.0000,'music',2004,'2018-05-11 17:08:48','2018-05-11 17:08:48',1,1,'tesley.francis@gmail.com',100,'Da Specialists Feeling It ',1,'Music with vocals',NULL,NULL,0),(85,'7e5d72ac400ab70c7712bef88d29b5528d9bb5ab','Feeling It JJ','Tez-lee','Tez-lee',255.4151,'music',2004,'2018-05-11 17:14:20','2018-05-11 17:14:20',1,1,'tesley.francis@gmail.com',100,'Tez-lee Feeling It JJ',1,'Instrumental',NULL,NULL,0),(86,'1f8bba8821ce649ce71e0694db93f196dc086413','Swagger Right','Tez-lee Martell Clipson Michael','Tez-lee',214.5656,'music',2012,'2018-05-11 17:17:18','2018-05-11 17:17:18',1,1,'tesley.francis@gmail.com',103,'Tez-lee Martell Clipson Michael Swagger Right',1,'Music with vocals',NULL,NULL,0),(87,'8d14743e4c487f4f5351451c79a0ee2d883d2c29','Swagger Right(instrumental Hook)','Tez-lee','Tez-lee',214.5656,'music',2012,'2018-05-11 17:19:24','2018-05-11 17:19:24',1,1,'tesley.francis@gmail.com',103,'Tez-lee Swagger Right(instrumental Hook)',1,'Music with vocals',NULL,NULL,0),(88,'fd2bb58310b6913c6d6423c190656130d43d384e','Tip Toe ','Tezlee Clipson','Tez-lee',197.3661,'music',2009,'2018-05-11 17:21:06','2018-05-11 17:21:06',1,1,'tesley.francis@gmail.com',169,'Tezlee Clipson Tip Toe ',1,'Music with vocals',NULL,NULL,0),(89,'6a6b22f863428a59671eac2412110ec34c3004ad','Christina Instrumental','Tez-lee','Tez-lee',251.3333,'music',2004,'2018-05-11 17:23:26','2018-05-11 17:23:26',1,1,'tesley.francis@gmail.com',105,'Tez-lee Christina Instrumental',0,'Instrumental',NULL,NULL,1),(90,'818a23c15eae58bc9c23742a73c3e7e82bbbc549','Love Letter','Tez-lee','Tez-lee',259.0000,'music',2004,'2018-05-11 17:25:33','2018-05-11 17:25:33',1,1,'tesley.francis@gmail.com',117,'Tez-lee Love Letter',1,'Music with vocals',NULL,NULL,0),(91,'f7f4d4d68a2e6107fbe6903ae86c336b0f0a9284','Being Without You','Tez-lee','Tez-lee',208.0000,'music',2004,'2018-05-11 17:27:18','2018-05-11 17:27:18',1,1,'tesley.francis@gmail.com',98,'Tez-lee Being Without You',1,NULL,NULL,NULL,1),(92,'7a32d020160da7e917b6c6df1b4cd3d9c553fef6','Booty','Tez-lee ','Tez-lee',234.9193,'music',2004,'2018-05-11 17:30:19','2018-05-11 17:30:19',1,1,'tesley.francis@gmail.com',95,'Tez-lee  Booty',1,'Music with vocals',NULL,NULL,0),(93,'5c8864db94f136761945689978b6adef5c8636c6','Champion','Tez-lee','Tez-lee',192.6890,'music',2012,'2018-05-11 17:32:47','2018-05-11 17:32:47',1,1,'tesley.francis@gmail.com',120,'Tez-lee Champion',1,'Music with vocals',NULL,NULL,0),(94,'8d0e644ba0aa33ddbdb18d11c4172b836feb37fe','Christina','Tez-lee','Tez-lee',233.0000,'music',2004,'2018-05-11 17:34:44','2018-05-11 17:34:44',1,1,'tesley.francis@gmail.com',105,'Tez-lee Christina',1,NULL,NULL,NULL,1),(95,'6462e2607c0e4eff03751f120a8af0ad42b25274','Close To You Instrumental','Tez-lee','Tez-lee',211.4958,'music',2012,'2018-05-11 17:37:05','2018-05-11 17:37:05',1,1,'tesley.francis@gmail.com',116,'Tez-lee Close To You Instrumental',0,'Instrumental',NULL,NULL,1),(96,'2b8ff0ec7cd6fcc04894ff619ae9455da5a531bd','Close To You','Tez-lee','Tez-lee',211.4958,'music',2012,'2018-05-11 17:38:58','2018-05-11 17:38:58',1,1,'tesley.francis@gmail.com',116,'Tez-lee Close To You',1,'Music with vocals',NULL,NULL,0),(97,'eb74805ca107717412011165d2ad09e3f29ac1a0','Everybody','Tez-lee Martell Mckenzie','Tez-lee',258.2818,'music',2010,'2018-05-11 17:41:53','2018-05-11 17:41:53',1,0,'tesley.francis@gmail.com',117,'Tez-lee Martell Mckenzie Everybody',1,NULL,NULL,NULL,1),(98,'1c64ca85fe1e9ac09ccf3a7f5ca11fc64a54cbde','Feels Good To Me','Tez-lee','Tez-lee',215.5698,'music',2004,'2018-05-11 17:44:06','2018-05-11 17:44:06',1,1,'tesley.francis@gmail.com',100,'Tez-lee Feels Good To Me',1,'Music with vocals',NULL,NULL,0),(99,'4b8726c7634c5f666ef864af7b38066c2c5f00be','I See','Cynthia Erivo','Tez-lee Cynthia Erivo',231.5854,'music',2008,'2018-05-11 17:46:39','2018-05-11 17:46:39',1,1,'tesley.francis@gmail.com',100,'Cynthia Erivo I See',1,'Music with vocals',NULL,NULL,1),(100,'bfdfdf66a7df782de13205b28e686cd65faad61e','Love Me No More ','Tez-lee','Tez-lee',215.6245,'music',2004,'2018-05-11 17:48:20','2018-05-11 17:48:20',1,1,'tesley.francis@gmail.com',94,'Tez-lee Love Me No More ',1,'Music with vocals',NULL,NULL,0),(101,'5e274250d8f83c76166f69d90604395e20628b54','Need To Let Go','Tez-lee','Tez-lee Jay.J',241.2604,'music',2004,'2018-05-11 17:51:24','2018-05-11 17:51:24',1,0,'tesley.francis@gmail.com',104,'Tez-lee Need To Let Go',1,NULL,NULL,NULL,0),(103,'b44da57e21b27e802edfa03194eabea504978857','Touch Me Slow ','Cynthia Erivo','Tez-lee',222.4213,'music',2004,'2018-05-11 17:58:00','2018-05-11 17:58:00',1,1,'tesley.francis@gmail.com',135,'Cynthia Erivo Touch Me Slow ',1,'Music with vocals',NULL,NULL,0),(104,'bdff39bedc64844d1d61a73c6652cc48803f09cf','Can\'t Stop Luvin You ','Tez-lee','Tez-lee',191.4104,'music',2008,'2018-05-11 18:01:51','2018-05-11 18:01:51',1,1,'tesley.francis@gmail.com',177,'Tez-lee Can\'t Stop Luvin You ',1,'Music with vocals',NULL,NULL,0),(105,'e9877300aa71dfc9d729eaf603b1100c9c066230','Bacardi','Tez-lee','Tez-lee Jay.J',233.1880,'music',2008,'2018-05-11 18:05:56','2018-05-11 18:05:56',1,1,'tesley.francis@gmail.com',105,'Tez-lee Bacardi',1,'Music with vocals',NULL,NULL,0),(106,'337dd75a070a50ceb09c7a58ba096c921f51ef76','Do You Believe In Love Instrumental?','Tez-lee','Tez-lee',221.6776,'music',2004,'2018-05-11 18:08:55','2018-05-11 18:08:55',1,1,'tesley.francis@gmail.com',180,'Tez-lee Do You Believe In Love Instrumental',0,'Instrumental',NULL,NULL,0),(107,'d045a0de7bcce79a94d0b7d4df817b83b84f5fcb','Do You Believe In Love?','Tez-lee','Tez-lee',221.6776,'music',2004,'2018-05-11 18:12:35','2018-05-11 18:12:35',1,1,'tesley.francis@gmail.com',180,'Tez-lee Do You Believe In Love',1,'Music with vocals',NULL,NULL,0),(108,'603f11bd617087ac9a5c816dbc8c81f8e3a27660','Dreams','Tez-lee','Tez-lee Raghav',272.8344,'music',2004,'2018-05-11 18:16:59','2018-05-11 18:16:59',1,0,'tesley.francis@gmail.com',120,'Tez-lee Dreams',1,NULL,NULL,NULL,1),(109,'5c564dff0dd00ff57b2b6593a9f38c5f46b02d11','Go On','Tez-lee','Tez-lee',254.5031,'music',2010,'2018-05-11 18:20:25','2018-05-11 18:20:25',1,1,'tesley.francis@gmail.com',152,'Tez-lee Go On',1,'Music with vocals',NULL,NULL,0),(110,'942776f0f80b4ba7b4bb1f6b70723a7a8d7e10ef','Go On Instrumental','Tez-lee','Tez-lee',232.7614,'music',2010,'2018-05-11 18:24:09','2018-05-11 18:24:09',1,1,'tesley.francis@gmail.com',152,'Tez-lee Go On Instrumental',1,'Instrumental',NULL,NULL,0),(111,'f1eb0e2b6507951f81dabc3ff6f5fa97a6ed4611','Living It Up','Tez-lee','Tez-lee',232.1448,'music',2008,'2018-05-11 18:28:53','2018-05-11 18:28:53',1,1,'tesley.francis@gmail.com',148,'Tez-lee Living It Up',1,'Music with vocals',NULL,NULL,0),(112,'fece6e9212ee8e482cdf663ed5c2e35cd1b39d5c','Push It Back ','Tez-lee','Tez-lee',237.2344,'music',2008,'2018-05-11 18:32:49','2018-05-11 18:32:49',1,1,'tesley.francis@gmail.com',123,'Tez-lee Push It Back ',1,'Music with vocals',NULL,NULL,0),(113,'e05b9b2a615ef2c66f1d493eddf1a36a551aac31','Push It Back (instrumental)','Tez-lee','Tez-lee',237.2344,'music',2008,'2018-05-11 18:36:30','2018-05-11 18:36:30',1,1,'tesley.francis@gmail.com',123,'Tez-lee Push It Back (instrumental)',1,'Instrumental',NULL,NULL,0),(114,'b1632b8ebccbdd2de37e2fef4c920c9d0ca3c30f','Left 2 Right','Tez-lee','Tez-lee',244.0000,'music',2004,'2018-05-11 18:41:42','2018-05-11 18:41:42',1,1,'tesley.francis@gmail.com',95,'Tez-lee Left 2 Right',1,NULL,NULL,NULL,1),(115,'d40bfd6aeb5c641591ee977b9d0aaaae1e8c93ba','It\'s Me And You ','Tez-Lee','Tez-Lee',174.0000,'music',2012,'2018-05-11 18:48:20','2018-05-11 18:48:20',1,1,'tesley.francis@gmail.com',132,'Tez-Lee It\'s Me And You ',1,'Music with vocals',NULL,NULL,0),(116,'0c76d97c369ba9196c0450ac2017e779a0eb3b5e','More Than Words','Rene Byrd','Rene Byrd',305.7031,'music',2010,'2018-05-11 19:00:14','2018-05-11 19:00:14',1,1,'renebyrd@gmail.com',129,'Rene Byrd More Than Words',1,'Music with vocals',NULL,NULL,1),(117,'faceb0860ebf6182f7eca648f31231b6f4a337d9','More Than Words Instrumental ','Rene Byrd ','Rene Byrd',305.7031,'music',2010,'2018-05-11 19:05:08','2018-05-11 19:05:08',1,1,'renebyrd@gmail.com',128,'Rene Byrd  More Than Words Instrumental ',0,'Instrumental',NULL,NULL,1),(126,'4088f6b80b7d0ad92f559eda3cbd158099d2bcf8','Connection (What\'s Your Game) Instrumental','Jay.J','Jay.J',232.7614,'music',2004,'2018-05-11 19:39:35','2018-05-11 19:39:35',1,1,'jaf15711@hotmail.co.uk',92,'Jay.J Connection (What\'s Your Game) Instrumental',1,'Instrumental',NULL,NULL,0),(127,'487294e2e3e2b638b9f83170ed5f35090e5a6c4b','Connection (What\'s Your Game)','Tez-Lee','Jay.J',232.7614,'music',2004,'2018-05-11 19:42:29','2018-05-11 19:42:29',1,1,'jaf15711@hotmail.co.uk',92,'Tez-Lee Connection (What\'s Your Game)',1,'Music with vocals',NULL,NULL,0),(133,'484d1561c488d0ab0676255d497c16f7de8cb1a2','Heavy Smash','Jay.J','Jay.J',2.4401,'music',2008,'2018-05-11 19:54:49','2018-05-11 19:54:49',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Heavy Smash',1,'Instrumental',NULL,NULL,0),(134,'95de8a1bacf07c9aff38279ba9f1336823e35ea6','Lift Off','Jay.J','Jay.J',7.0000,'music',2016,'2018-05-11 19:55:54','2018-05-11 19:55:54',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Lift Off',1,'Instrumental',NULL,NULL,0),(137,'90c0ad4363f31f817710cbc2d2e24d1ffc47bc43','Slam Dunk','Jay.J','Jay.J',3.4182,'music',2016,'2018-05-11 19:58:52','2018-05-11 19:58:52',1,1,'jaf15711@hotmail.co.uk',120,'Jay.J Slam Dunk',1,'Instrumental',NULL,NULL,0),(139,'059e354ac0d125df8ab9c4f97452eced0fd58869','Choice','Jay.J','Jay.J',254.9849,'music',2008,'2018-05-11 20:05:08','2018-05-11 20:05:08',1,1,'jaf15711@hotmail.co.uk',91,'Jay.J Choice',0,NULL,NULL,NULL,0),(140,'3f4f27f6f30b104ff66564963326db5577afbd52','Closer And Closer','T.J Philips','T.J Philips',320.0000,'music',1999,'2018-05-17 18:02:27','2018-05-17 18:02:27',1,1,'payments@sync-audio.com',108,'T.J Philips Closer And Closer',1,'Music with vocals',NULL,NULL,0),(141,'ae644cb971adbb05d750de5106364a5fed2451b0','Escape','T.J Philips','T.J Philips',222.7359,'music',1999,'2018-05-17 18:05:33','2018-05-17 18:05:33',1,1,'payments@sync-audio.com',95,'T.J Philips Escape',0,'Instrumental',NULL,NULL,0),(142,'d5403299734f88f53e27b67926988fa465597c86','For A Life Time ','T.J Philips','T.J Philips',230.0000,'music',1999,'2018-05-17 18:09:48','2018-05-17 18:09:48',1,1,'payments@sync-audio.com',96,'T.J Philips For A Life Time ',0,'Instrumental',NULL,NULL,0),(143,'593cb86188c1f9b26f438c66c0d888d454a7b653','Hide Away','T.J Philips','T.J Philips',384.3536,'music',1999,'2018-05-17 18:13:49','2018-05-17 18:13:49',1,1,'payments@sync-audio.com',106,'T.J Philips Hide Away',0,'Instrumental',NULL,NULL,0),(144,'25f33878c6efa5d6d7b513bc707174def0ef57c2','Moods','T.J Philips','T.J Philips',326.2219,'music',1999,'2018-05-17 18:16:32','2018-05-17 18:16:32',1,1,'payments@sync-audio.com',100,'T.J Philips Moods',0,'Instrumental',NULL,NULL,0),(145,'ce7d5179b409435febf4934569e00eaf5d268b97','Stay','T.J Philips','T.J Philips',271.0000,'music',1999,'2018-05-17 18:18:41','2018-05-17 18:18:41',1,1,'payments@sync-audio.com',100,'T.J Philips Stay',0,'Instrumental',NULL,NULL,0),(146,'8fbf4f36645ace8498fdc255255f7ae989ea4381','What You Want ','T.J Philips','T.J Philips',61.5552,'music',1999,'2018-05-17 18:19:58','2018-05-17 18:19:58',1,1,'payments@sync-audio.com',166,'T.J Philips What You Want ',0,'Music with vocals',NULL,NULL,0),(147,'629b2e44e5882a11a5d85d11f13ba1966f71ee2b','One Woman Man','Sign Of The Times','T.J Philips',287.8870,'music',1999,'2018-05-17 18:25:19','2018-05-17 18:25:19',1,1,'payments@sync-audio.com',109,'Sign Of The Times One Woman Man',1,'Music with vocals',NULL,NULL,1),(148,'474c17976c9bfedb19529e6f8153af8db39c3cc5','Right Stuff','Sign Of The Times','T.J Philips',209.7057,'music',1999,'2018-05-17 18:27:22','2018-05-17 18:27:22',1,1,'payments@sync-audio.com',109,'Sign Of The Times Right Stuff',1,'Music with vocals',NULL,NULL,0),(149,'7aa4834629638e016312e25aaef7660b3b705011','What I Wanna Do','Sign Of The Times','T.J Philips',226.3719,'music',1999,'2018-05-17 18:30:28','2018-05-17 18:30:28',1,1,'payments@sync-audio.com',100,'Sign Of The Times What I Wanna Do',1,NULL,NULL,NULL,0),(150,'da53c950f3b8ae2e550a7865e3009f76353eda13','Deep','Jah Recuit ','Jay.J Byron ',250.0000,'music',2003,'2018-05-17 21:38:07','2018-05-17 21:38:07',1,1,'jaf15711@hotmail.co.uk',97,'Jah Recuit  Deep',1,'Music with vocals',NULL,NULL,0),(151,'033e544320a336bf1ebb0cef1c872fd4f9951b67','Run Away With Me ','Rene Byrd','Jay.J ',242.9698,'music',2008,'2018-05-21 19:52:17','2018-05-21 19:52:17',1,1,'jaf15711@hotmail.co.uk',127,'Rene Byrd Run Away With Me ',0,'Instrumental',NULL,NULL,0),(152,'56a6a60568539ebfdc1cd09210ddc662e9983816','Time Machine','Tezlee ','Jay.J',184.0000,'music',2008,'2018-05-21 19:58:22','2018-05-21 19:58:22',1,1,'tesley.francis@gmail.com',100,'Tezlee  Time Machine',1,'Instrumental',NULL,NULL,0),(155,'fbcba0c1c1ac705bc6872956a8cc8a81b8807304','Change Your Ways','Rene Byrd','Jay J',210.3371,'music',NULL,'2018-06-30 12:26:23','2018-06-30 12:26:23',1,1,'jaf15711@hotmail.co.uk',178,'Rene Byrd Change Your Ways',0,'Instrumental','','tjn music',0),(158,'412be4efd1b2a9b2e51169437669fdbbd17483c5','Valentina','Jay J','Jay J',200.0000,'music',NULL,'2018-07-05 13:37:56','2018-07-05 13:37:56',1,0,'jaf15711@hotmail.co.uk',108,'Jay J Valentina',0,NULL,'','',0),(182,'f9f41d2a495b6d164cbd940a9119b1402794e461','So Natural ','SOULBOTS feat. Teedeevee','SOULBOTS/Teedeevee',212.0625,'music',NULL,'2020-04-06 12:38:08','2020-04-06 12:38:08',1,1,'elephantheadproductions@outlook.com',111,'SOULBOTS feat. Teedeevee So Natural',0,'Music with vocals','','SOULBOTS',0),(192,'35528404c11242244ed526d027d673f2acb8512a','Give Me Rain','Original Quigley','Robert Quigley',222.5000,'music',NULL,'2020-08-04 16:33:50','2020-08-04 16:33:50',1,1,'robertquigley1973@gmail.com',120,'Original Quigley Give Me Rain',0,NULL,'','Robert Quigley',0),(193,'26c65797bc68f3b29bb0e75f51b996d725fb0f23','Give Me Rain Instrumental','Original Quigley','Robert Quigley',222.5000,'music',NULL,'2020-08-04 16:36:55','2020-08-04 16:36:55',1,1,'robertquigley1973@gmail.com',120,'Original Quigley Give Me Rain Instrumental',0,NULL,'','Robert Quigley',0),(194,'d48e7d5e0531659c29b94e1505596bcb91c0851e','Too Long','Original Quigley','Robert Quigley',223.9773,'music',NULL,'2020-08-04 16:45:02','2020-08-04 16:45:02',1,1,'robertquigley1973@gmail.com',120,'Original Quigley Too Long',0,NULL,'','Robert Quigley',0),(195,'09f2e6a95764e7bd3e62fd9a57ef49093a033784','Too Long Instrumental','Original Quigley','Robert Quigley',225.4529,'music',NULL,'2020-08-04 16:46:42','2020-08-04 16:46:42',1,1,'robertquigley1973@gmail.com',120,'Original Quigley Too Long Instrumental',0,NULL,'','Robert Quigley',0),(196,'251d3f2a7f260748dfdae594d7ca0177863b46f9','The Oracle (Feat. Annastacia Monroe)','Policy/Annastacia Monroe','Mark Buchwald, Michael Zaremba, Staci Litten',236.0050,'music',NULL,'2020-08-16 12:59:53','2020-08-16 12:59:53',1,1,'mpolicy1@hotmail.com',100,'Policy Annastacia Monroe The Oracle (Feat. Annastacia Monroe)',0,NULL,'349637817','Mark Buchwald',0),(197,'ff63cb78f0dfe78a21151396d5b497165429773d','Reality (Feat. Tina Shest)','Policy/Tina Shest','Mark Buchwald, Michael Zaremba, Tina Shest',195.2390,'music',NULL,'2020-08-16 13:02:48','2020-08-16 13:02:48',1,1,'mpolicy1@hotmail.com',125,'Policy Tina Shest Reality (Feat. Tina Shest)',0,'Music with vocals','349637817','Mark Buchwald',0),(198,'ec168440a1be686dc41e39061a59039a4ec0f908','Push Pause (A & B Remixx Feat. Amy Jo Scott)','Policy/Amy Jo Scott','Mark Buchwald, Amy Jo Scott',208.7899,'music',NULL,'2020-08-16 13:05:37','2020-08-16 13:05:37',1,1,'mpolicy1@hotmail.com',130,'Policy Amy Jo Scott Push Pause (A & B Remixx Feat. Amy Jo Scott)',0,NULL,'349637817','Mark Buchwald',0),(199,'e9b15d0007c9ebbbf4ec2fdd3a264e8ea3b2feba','Art of Fact (Feat. Kelsey Hunter)','Policy/Kelsey Hunter','Mark Buchwald, Michael Zaremba, Kelsey Hunter',383.4606,'music',NULL,'2020-08-16 13:08:23','2020-08-16 13:08:23',1,1,'mpolicy1@hotmail.com',120,'Policy Kelsey Hunter Art of Fact (Feat. Kelsey Hunter)',0,NULL,'349637817','Mark Buchwald',0),(201,'489b36f5f7105395ff96d5d08ed7d07096543bf8','Test','Test','Test',1.4993,'music',NULL,'2020-09-30 13:12:10',NULL,0,0,'paypaluk@jakubdolejs.com',120,'Test Test',0,'Instrumental','','Test',0),(203,'7a9914a962fa0dc130988643e1371932b05f227a','Make This Moment Last','Jim Gaven','Jim Gaven',270.0481,'music',NULL,'2020-10-09 23:50:18','2020-10-09 23:50:18',1,1,'jim.gaven@gmail.com',120,'Jim Gaven Make This Moment Last',0,NULL,'659286005','Jim Gaven',0),(204,'e925bb534f124b58801760987d9dc0d4b6ffbaff','Something to Hope For ','Jim Gaven','Jim Gaven',237.8133,'music',NULL,'2020-10-09 23:58:24','2020-10-09 23:58:24',1,1,'jim.gaven@gmail.com',112,'Jim Gaven Something to Hope For',0,NULL,'659286005','Jim Gaven',0),(205,'4adb46f7db8126529ac9f7af56745be010900f6d','Stay','Jim Gaven','Jim Gaven',171.8000,'music',NULL,'2020-10-10 00:04:26','2020-10-10 00:04:26',1,1,'jim.gaven@gmail.com',120,'Jim Gaven Stay',0,NULL,'659286005','Jim Gaven ',0),(206,'71079e8b3dae25a3cfd503f5bb99f7d9ac821455','Forever in Love ','Jim Gaven ','Jim Gaven ',162.4270,'music',NULL,'2020-10-10 00:13:09','2020-10-10 00:13:09',1,1,'jim.gaven@gmail.com',116,'Jim Gaven  Forever in Love',0,'Music with vocals','659286005','Jim Gaven ',0),(207,'38aecd78a77e0dde5dacc8047a2fab03e573220e','The Girl from the Sand','Tony Mecca','Tony Mecca',255.9067,'music',NULL,'2020-10-28 21:07:13','2020-10-28 21:07:13',1,1,'tmecca11@aol.com',127,'Tony Mecca The Girl from the Sand',0,'Music with vocals','125060319','Tony Mecca',0),(208,'c427f207f4a7d3958608a00101ed9e26f4d1a119','New Green Shirt','Tony Mecca','Tony Mecca',228.9333,'music',NULL,'2020-10-28 21:12:35','2020-10-28 21:12:35',1,1,'tmecca11@aol.com',120,'Tony Mecca New Green Shirt',0,'Music with vocals','125060319','Tony Mecca',0),(215,'e6179ad1e532fe0a52381ae86ddb8eb183d5c5d6','Heads Up Stand Tall - Remix','Challan Carmichael ','Challan Carmichael',268.5618,'music',NULL,'2021-01-05 23:30:59','2021-01-05 23:30:59',1,1,'challan@moroni7.co.uk',127,'Challan Carmichael  Heads Up Stand Tall - Remix',0,NULL,'','Challan Carmichael ',0),(216,'4b62074fd3e10663478b84da3b5bce4088e3a353','Dream Is Calling','Precious Obimdi','Precious Obimdi',173.9655,'music',NULL,'2021-01-07 17:01:24','2021-01-07 17:01:24',1,1,'mushmusicservices@gmail.com',174,'Precious Obimdi Dream Is Calling',0,'Poetry','','Precious Obimdi',0),(217,'b6a5ea65c1716c76765480d76db292e1b6f84131','Fashion Tribe','K.Dub','Kgosietsile Daniel Wesi',246.3628,'music',NULL,'2021-01-11 13:17:32','2021-01-11 13:17:32',1,1,'wesikgosietsile@gmail.com',133,'K.Dub Fashion Tribe',0,'Instrumental','','Kgosietsile Daniel Wesi',0),(223,'a3556d357e9d28ef1f2c3e4876528910dbbf2b83','All That Stuff','Charlie DeYoung','Charlie DeYoung',130.5380,'music',NULL,'2021-02-06 20:12:16','2021-02-06 20:12:16',1,1,'cha_lee_d@yahoo.com',130,'Charlie DeYoung All That Stuff',0,'Instrumental','419816439','Charlie DeYoung',0),(226,'048a8d0e4e5f74f481b1567ec809aa837b641a84','You Are Here','Charlie DeYoung','Charlie DeYoung',98.5242,'music',NULL,'2021-02-06 20:34:34','2021-02-06 20:34:34',1,1,'cha_lee_d@yahoo.com',102,'Charlie DeYoung You Are Here',0,NULL,'419816439','Charlie DeYoung',0),(235,'ac1654aa926c7ad4d4772dd2729584f3f134b2a2','Judgement','XTaKeRuX','XTaKeRuX',187.6025,'music',NULL,'2021-06-07 10:07:06',NULL,1,1,'jacpot222@gmail.com',92,'XTaKeRuX Judgement',0,'Instrumental','','XTaKeRuX',0),(240,'293c2dda969d2ffd480b3bcbcdca2a47384b64ab','Glory For End','LVCAS','Ben Lucas Murphy',243.5019,'music',NULL,'2021-06-26 07:50:51',NULL,1,1,'benji.murphy.ireland@gmail.com',101,'LVCAS Glory For End',0,'Instrumental','01073543174','Ben Lucas Murphy',0),(248,'46a4692221b6c3e3284faae1d525737123d415ed','The Place That We Know','Original Quigley','Robert Quigley',229.4250,'music',NULL,'2021-08-06 06:35:46',NULL,1,1,'robertquigley1973@gmail.com',91,'Original Quigley The Place That We Know',0,'Music with vocals','','Robert Quigley',0),(249,'89905cd2643a6bb903927e4f7852be69ab32a3ef','Countdown to Christmas','Original Quigley','Robert Quigley',205.7500,'music',NULL,'2021-08-06 06:48:01',NULL,1,1,'robertquigley1973@gmail.com',100,'Original Quigley Countdown to Christmas',0,NULL,'','Robert Quigley',0),(250,'9f3a84a3543f0703ec1c39b27a68a61c5d04c63e','Grey','Original Quigley','Robert Quigley',200.0000,'music',NULL,'2021-08-06 06:50:12',NULL,1,1,'robertquigley1973@gmail.com',114,'Original Quigley Grey',0,NULL,'','Robert Quigley',0),(252,'0e38f0f18b2a2baebe2ac290a98acf4a1ee8702d','EVE','Leon Herbert ','Leon Herbert',95.1059,'music',NULL,'2021-08-19 18:28:33',NULL,1,1,'leonherbertuk@yahoo.com',119,'Leon Herbert  EVE',0,'Poetry','','Leon Herbert ',1),(259,'3c1d48cf0aaf250a2a607e4bf1c3f24c455ad5b6','In the beginning ','LEON HERBERT ','LEON HERBERT ',125.5706,'music',NULL,'2021-09-07 09:22:41',NULL,1,1,'leonherbertuk@yahoo.com',108,'LEON HERBERT  In the beginning - The Great Deceiver',0,'Poetry','','LEON HERBERT ',1),(260,'aa37e06d604ebd05cdf00a5adca8f285ca8df4da','WE ARE NOT BEINGS THAT BRING DISHONOUR  ','LEON HERBERT ','LEON HEREBRT ',131.8139,'music',NULL,'2021-09-07 09:28:53',NULL,1,1,'leonherbertuk@yahoo.com',111,'LEON HERBERT  WE ARE NOT BEINGS THAT BRING THIS HONOUR - THE GREAT DECEIVER',0,'Poetry','','LEON HERBERT ',1),(265,'a4001cdc7edaa03c0f71abec6fec32bc4cb6bd1d','I CHOOSE TO BE BLACK ','Leon Herbert','Leon Herbert, Raymond Wood',136.7161,'music',NULL,'2021-09-20 17:39:38',NULL,1,1,'leonherbertuk@yahoo.com',110,'Leon Herbert I CHOOSE TO BE BLACK',0,'Poetry','','LEON HERBERT ',0),(266,'c982537e2e2f3bfb2cfba36a675e631e0586c101','I DONT WANT TO WHITE ','LEON HERBERT ','Leon Herbert, Raymond Wood',121.8553,'music',NULL,'2021-09-20 17:42:28',NULL,1,1,'leonherbertuk@yahoo.com',97,'LEON HERBERT  I DONT WANT TO WHITE',0,'Poetry','','LEON HERBERT ',0),(267,'e84a77fb1dca040e11a05ac1cd8593494ce85af1','BEING BLACK IS  NOT IMMATERIAL ','LEON HERBERT ','LEON HARBERT / RAYMOND WOOD',101.1146,'music',NULL,'2021-09-20 17:45:49',NULL,1,1,'leonherbertuk@yahoo.com',99,'LEON HERBERT  BEING BLACK IS  NOT IMMATERIAL',0,'Poetry','','LEON HERBERT',0),(277,'e8161a9b4393a0130b9c654316ee7335bc9bd53f','Joliet (Clean Version)','TWAIN featuring Cariah Brinaé','A.Perkins, J.Anderson, L.Lucostic',170.7624,'music',NULL,'2022-02-09 16:28:27',NULL,1,1,'twain6@gmail.com',174,'TWAIN featuring Cariah Brinaé Joliet (Clean Version)',0,'Music with vocals','','Antoine Perkins',0),(278,'e163461bc849b8755f39e9cff5e9b9ad6a29abfd','Perspective (Explicit Version)','TWAIN','A.Perkins, J.Allen',196.6759,'music',NULL,'2022-02-09 16:31:07',NULL,1,1,'twain6@gmail.com',176,'TWAIN Perspective (Explicit Version)',0,NULL,'','Antoine Perkins',0),(279,'b2f63fce782d6b23d1280cc270eb4e2e73b5ed55','Searching For Mine Redux (feat. Chantel SinGs)','TWAIN','A.Perkins, H.Morrow, R.Mitchem',227.7355,'music',NULL,'2022-02-09 16:43:53',NULL,1,1,'twain6@gmail.com',93,'TWAIN Searching For Mine Redux (feat. Chantel SinGs)',0,NULL,'','Antoine Perkins',0),(280,'93cfb9061b36c3ba59258a92e692e72688ac64c1','Reality Check (Explicit Version)','TWAIN featuring Hailey Ward','A.Perkins, H.Ward, E.Goble',243.9576,'music',NULL,'2022-02-09 16:47:29',NULL,1,1,'twain6@gmail.com',105,'TWAIN featuring Hailey Ward Reality Check (Explicit Version)',0,NULL,'','Antoine Perkins',0),(281,'0ba7cc358698feba6f380467c276fe593a9c5106','Lost (Feat. Airinna Namara)','Policy/Airinna Namara','Mark Buchwald, Airinna Namara',251.4286,'music',NULL,'2022-02-17 23:42:03',NULL,1,1,'mpolicy1@hotmail.com',168,'Policy Airinna Namara Lost (Feat. Airinna Namara)',0,NULL,'349637817','Mark Buchwald',0),(282,'1efc29637f75e77c8f5fe43be5cd3ddbe5fcb368','Trick My Heart (Feat. Airinna Namara)','Policy/Airinna Namara','Mark Buchwald, Airinna Namara',220.5952,'music',NULL,'2022-02-17 23:45:58',NULL,1,1,'mpolicy1@hotmail.com',126,'Policy Airinna Namara Trick My Heart (Feat. Airinna Namara)',0,NULL,'349637817','Mark Buchwald',0),(283,'01957415bf0bddccad7b00b792679899e59961b4','Past The Upset - Policy XXimeR (Feat. Amy Jo Scott)','Policy/Amy Jo Scott','Mark Buchwald, Amy Jo Scott',274.2857,'music',NULL,'2022-02-17 23:48:27',NULL,1,1,'mpolicy1@hotmail.com',140,'Policy Amy Jo Scott Past The Upset - Policy XXimeR (Feat. Amy Jo Scott)',0,NULL,'349637817','Mark Buchwald',0),(284,'2fc74897e99cb6ac0030753b563f2d05dbfb22cc','Fade Away (Feat. Airinna Namara/H.Williams/Lil Bonk) - Clean','Policy/Airinna Namara/H.Williams/Lil Bonk','Mark Buchwald, Airinna Namara, Hunter Williams/ Nolan Shipley',215.6250,'music',NULL,'2022-02-17 23:55:56',NULL,1,1,'mpolicy1@hotmail.com',108,'Policy Airinna Namara H.Williams Lil Bonk Fade Away (Feat. Airinna Namara H.Williams Lil Bonk) - Clean',0,'Music with vocals','349637817','Mark Buchwald',0),(285,'85988a2c1bd5ad7a80febfa38b88a5bfcecce9be','Love and Fear','Garrett Barber','Garrett Barber',204.1379,'music',NULL,'2022-03-15 00:22:17',NULL,1,1,'gbarber96@hotmail.com',174,'Garrett Barber Love and Fear',0,NULL,'','Garrett Barber',0),(286,'587280aa13ef0438a134810cae8116651b2c527a','Heartfelt','Garrett Barber','Garrett Barber',174.1936,'music',NULL,'2022-03-15 00:24:22',NULL,1,1,'gbarber96@hotmail.com',146,'Garrett Barber Heartfelt',0,'Instrumental','','Garrett Barber',0),(287,'b6ef925896fd64abdd1779d8135a4cca4ba8b6dd','Satellites','Garrett Barber','Garrett Barber',187.5000,'music',NULL,'2022-03-15 00:32:19',NULL,1,1,'gbarber96@hotmail.com',128,'Garrett Barber Satellites',0,NULL,'','Garrett Barber',0),(306,'2148d83fd608c3c0d75b8b2efa5795781b2016c3','After Rain','Mikhail Gurbo','Mikhail Gurbo',214.8232,'music',NULL,'2022-10-03 11:10:55',NULL,1,1,'vasilisa-denisov@mail.ru',119,'Mikhail Gurbo After Rain',0,NULL,'','Mikhail Gurbo',0),(307,'1c1f07194cd943b12525ce0f96b5b010eea0d465','Trondheim. View from Pier','Mikhail Gurbo','Mikhail Gurbo',128.1214,'music',NULL,'2022-10-05 19:37:58',NULL,1,1,'vasilisa-denisov@mail.ru',120,'Mikhail Gurbo Trondheim. View from Pier',0,NULL,'','Mikhail Gurbo',0),(316,'48245ecadfd51875a9e962af27269cb85cf7673c','Its Alright ','Jay J ','Jay J',193.9739,'music',NULL,'2023-01-11 20:48:15',NULL,0,0,'jaf15711@hotmail.co.uk',92,'Jay J  Its Alright',0,'Instrumental','','TJN Music',0),(324,'ab7a12f584b83e653e779fd3cc5afd02bf74df6d','V.I.P.','Christina Sophia','Christina Sophia Fisher/Marvin Tyler',141.3515,'music',NULL,'2023-01-22 15:51:26',NULL,1,1,'StinaSophiaMusic@gmail.com',97,'Christina Sophia V.I.P.',0,NULL,'','Chrisitna Sophia Fisher',0),(325,'8a65cd96ecc73d7d1f8ff407d895c528013e5378','Me and You (Now)','Christina Sophia','Christina Sophia Fisher/Tone Shannon',260.9371,'music',NULL,'2023-01-22 15:58:48',NULL,1,1,'StinaSophiaMusic@gmail.com',104,'Christina Sophia Me and You (Now)',0,NULL,'','Chrisitna Sophia Fisher',0),(326,'822d7defe0967ffc7c3bdd6358ac048907a231ec','Your Love','Christina Sophia','Christina Sophia Fisher/Tone Shannon',300.0947,'music',NULL,'2023-01-22 16:01:21',NULL,1,1,'StinaSophiaMusic@gmail.com',120,'Christina Sophia Your Love',0,NULL,'','Chrisitna Sophia Fisher',0),(327,'cac49c215db3cb31a7ce0f7ed21eba8355d13da5','Show Me','Christina Sophia','Christina Sophia Fisher/Robert Mitchem',258.5742,'music',NULL,'2023-01-22 16:03:45',NULL,1,1,'StinaSophiaMusic@gmail.com',171,'Christina Sophia Show Me',0,NULL,'','Chrisitna Sophia Fisher',0),(328,'280e597846855345e3c5b373f22131473ba4b883','The Space (Acoustic)','Cariah Brinaé','Cariah Brinaé Hunter/Jibra\'il Abdul-Azeem/Sang Yun An',228.9633,'music',NULL,'2023-01-22 16:52:34',NULL,1,1,'illcountymusicgroup@gmail.com',160,'Cariah Brinaé The Space (Acoustic)',0,NULL,'','Cariah Brinaé Hunter',0),(329,'e3fb76a04cdfa731e119a576d5f04ccb549952f2','Signs ','D Smooth','D Smooth',139.7290,'music',NULL,'2023-02-08 09:36:58',NULL,1,1,'hugiedaunte@gmail.com',100,'D Smooth Signs',0,NULL,'','D Smooth',0),(330,'c0c9a55c35f6d184a72f6f4aca6ece42b8317a45','Let Me Love You','D Smooth','D Smooth',197.3029,'music',NULL,'2023-02-08 09:42:20',NULL,1,1,'hugiedaunte@gmail.com',102,'D Smooth Let Me Love You',0,NULL,'','D Smooth',0),(331,'2cbd73827b5aecccb01ed8350dae70d669bf9a96','In Control','D Smooth','D smooth',141.5314,'music',NULL,'2023-02-08 09:44:56',NULL,1,1,'hugiedaunte@gmail.com',97,'D Smooth In Control',0,NULL,'','D Smooth',0),(332,'27e26a57ae78b49070fb81ebffacfe395c200f5b','Stop Playing With Me','D Smooth','D Smooth',148.0359,'music',NULL,'2023-02-08 09:48:02',NULL,1,1,'hugiedaunte@gmail.com',94,'D Smooth Stop Playing With Me',0,NULL,'','D Smooth',0),(334,'311b768e2d928e3afc3f074d09fe77ded45f1541','Neanderthal','Adam George Brown','Adam George Brown',222.5455,'music',NULL,'2023-02-15 23:45:10',NULL,1,1,'rockstarlife@gmx.co.uk',110,'Adam George Brown Neanderthal',0,NULL,'','Adam George Brown',0),(335,'9405dde3cb6a58b22180688a1a3e9da81dcee326','Walking past the ivy tree','Adam George Brown','Adam George Brown',210.6514,'music',NULL,'2023-02-16 00:15:50',NULL,1,1,'rockstarlife@gmx.co.uk',120,'Adam George Brown Walking past the ivy tree',0,NULL,'','Adam George Brown',0),(336,'60f7b539a69b5cd7503eb233d2bab29bad0a4d12','Your untold future','Adam George Brown','Adam George Brown',202.0000,'music',NULL,'2023-02-16 00:20:14',NULL,1,1,'rockstarlife@gmx.co.uk',120,'Adam George Brown Your untold future',0,NULL,'','Adam George Brown',0),(341,'beb2b826ed846a735954ba9afecc4add9d2c6663','Torque','Ashisho','Dennis Kimani Wanjiku',83.2941,'music',NULL,'2023-02-28 04:37:11',NULL,1,1,'denniskimani237@gmail.com',170,'Ashisho Torque',0,NULL,'','Dennis Kimani Wanjiku',0),(342,'0484e2230f9dc8412c612ea5f265f7f4778bd322','Ross','Ashisho','Dennis Kimani Wanjiku',118.8000,'music',NULL,'2023-02-28 04:41:28',NULL,1,1,'denniskimani237@gmail.com',100,'Ashisho Ross',0,NULL,'','Dennis Kimani Wanjiku',0),(343,'7bbc9d5b7903e981efce998e9e9408edcb410a49','Baseball','Ashisho','Dennis Kimani Wanjiku',67.0968,'music',NULL,'2023-02-28 04:46:01',NULL,1,1,'denniskimani237@gmail.com',93,'Ashisho Baseball',0,NULL,'','Dennis Kimani Wanjiku',0),(344,'2a3ab1d3e2da95cf1d7e6756c807e1d09c3f693c','Micky','Ashisho','Dennis Kimani Wanjiku',72.0000,'music',NULL,'2023-02-28 04:51:56',NULL,1,1,'denniskimani237@gmail.com',110,'Ashisho Micky',0,NULL,'','Dennis Kimani Wanjiku',0),(364,'76043fea84b4939967ebc6509964022214d5b6bf','Glow','DA’RRELL','Darrell Muchapondwa',150.6898,'music',NULL,'2023-12-22 11:29:29',NULL,0,0,'deeeboii12@gmail.com',113,'DA’RRELL Glow',0,'Music with vocals','','Darrell Muchapondwa',0),(371,'f79da6006acdd0947cd666d003cfd1e77290978c','Practice','Demmy Sober','Demmy Sober, Whitney-Mikel Mitchell, Pedro Modrego',162.6667,'music',NULL,'2024-03-16 20:00:49',NULL,0,0,'sober@dasobercrew.com',109,'Demmy Sober Practice',0,'Music with vocals','','Demmy Sober, Whitney-Mikel Mitchell, Pedro Modrego',0),(372,'8a7e14b3009f9fe998f290a5885315cd8828345f','Man Eater','Popurr','Adi Ure',182.4000,'music',NULL,'2024-04-16 23:55:10',NULL,0,0,'thiagotolentinot@gmail.com',100,'Popurr Man Eater',0,'Music with vocals','','Adi Ure',0),(373,'5dd3d9654be4a5f8372bc5d36fe5b81a03c83c58','Austin','Popurr','Adi Ure',133.7405,'music',NULL,'2024-04-17 00:04:11',NULL,0,0,'thiagotolentinot@gmail.com',131,'Popurr Austin',0,'Music with vocals','','Adi Ure',0),(379,'b9362427d8cb364d7995114ba55845e0e6481585','Why Not Me','Tizane','Tizane',189.1083,'music',NULL,'2024-06-04 15:31:07',NULL,0,0,'tizanemusic@gmail.com',135,'Tizane Why Not Me',0,'Music with vocals','','Tizane',0),(380,'453c29fae896df78806cee57513b38dba42aa604','Meu avô era brasileiro','Francesco Redig de Campos','Francesco Redig de Campos',132.4180,'music',NULL,'2024-06-05 09:59:29',NULL,0,0,'fraredig@gmail.com',122,'Francesco Redig de Campos Meu avô era brasileiro',0,'Instrumental','848781093','Francesco Redig de Campos',0),(381,'fdb6773289f6ba1947347c3e26e5afb89f14c87c','The Nymph\'s reign','Francesco Redig de Campos','Francesco Redig de Campos',188.4615,'music',NULL,'2024-06-06 11:49:38',NULL,0,0,'fraredig@gmail.com',127,'Francesco Redig de Campos The Nymph\'s reign',0,'Instrumental','848781093','Francesco Redig de Campos',0),(382,'4fda5e8a1bb001f87a2ec913c1be30ace3cd5211','Can\'t be friends ','Trey songs','trey ',102.8571,'music',NULL,'2024-06-25 21:22:44',NULL,0,0,'jaf15711@hotmail.co.uk',114,'Trey songs Can\'t be friends',0,'Music with vocals','','n/a',0);
/*!40000 ALTER TABLE `tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_tracks`
--

DROP TABLE IF EXISTS `transaction_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_tracks` (
  `transaction_id` varchar(128) NOT NULL,
  `track_id` int unsigned NOT NULL,
  `amount` double(8,2) NOT NULL,
  `sender_item_id` int(10) unsigned zerofill DEFAULT NULL,
  `licence_type_id` int DEFAULT NULL,
  PRIMARY KEY (`transaction_id`,`track_id`),
  KEY `sender_item_id_fk` (`sender_item_id`),
  KEY `txn_tracks_licence_type_fk` (`licence_type_id`),
  CONSTRAINT `sender_item_id_fk` FOREIGN KEY (`sender_item_id`) REFERENCES `artist_payout` (`sender_item_id`),
  CONSTRAINT `transaction_tracks_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `txn_tracks_licence_type_fk` FOREIGN KEY (`licence_type_id`) REFERENCES `licence_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_tracks`
--

LOCK TABLES `transaction_tracks` WRITE;
/*!40000 ALTER TABLE `transaction_tracks` DISABLE KEYS */;
INSERT INTO `transaction_tracks` VALUES ('0825b3cc-4eb3-4373-8589-3b5aebab21b1',41,359.99,NULL,3),('1471ab2e-d84c-4a59-b021-36c37dcb6c3f',267,159.99,NULL,1),('241b3003-df1b-44c6-b158-9814d28c9130',85,209.00,NULL,16),('3773fdb9-ace3-41e6-8343-5877a533bf22',58,18.00,NULL,9),('4554b2ab-a979-4d5e-a1ac-a82cd3cdcfaa',141,30.00,NULL,6),('485a3274-e31a-43ad-85ff-de26d74eae68',155,159.99,NULL,1),('5138f19a-f745-454f-be95-c4a4e83c11a8',267,359.99,NULL,3),('541b90d2-4258-4dda-9562-9b0741c4108e',267,359.99,NULL,3),('562a2f13-79ea-4b60-b00a-643040987c01',267,159.99,NULL,1),('6602c43f-d4ba-4c8d-bcfe-b0bdcdb3cc38',51,29.99,NULL,5),('6602c43f-d4ba-4c8d-bcfe-b0bdcdb3cc38',85,209.00,NULL,16),('78e43d6e-4008-4d1f-8164-2544c0fe4998',141,29.99,NULL,5),('7d7535f0-136d-4f5a-ba5d-6fd40dab821b',51,29.99,NULL,5),('7d7535f0-136d-4f5a-ba5d-6fd40dab821b',85,209.00,NULL,16),('8165deb7-978d-4b2c-9069-dfe38bd92dda',80,30.00,NULL,6),('8165deb7-978d-4b2c-9069-dfe38bd92dda',92,30.00,NULL,9),('92c4b039-4778-4b51-8b93-e1eb5255d105',103,29.99,NULL,5),('92c4b039-4778-4b51-8b93-e1eb5255d105',143,18.00,NULL,9),('a1fe1f7f-ff2e-4fdd-a587-54931f93e7c1',146,160.00,NULL,7),('b7bf92a5-60a5-4493-b1ea-0d9205de6335',140,29.99,NULL,NULL),('c1ba1e89-6e27-49d8-9820-f88fa3c4c877',140,18.00,NULL,9),('ccaf524f-0c34-42b8-b6ff-3341a5b535ed',142,30.00,NULL,9),('cf0fc635-b170-4951-999e-57d743589115',96,259.99,NULL,1),('ed99d763-cc26-49c9-894a-d914a8326673',85,259.99,NULL,1),('ed99d763-cc26-49c9-894a-d914a8326673',113,259.99,NULL,1),('ffaf2bf4-9086-4df4-befb-6e5581a954ff',141,30.00,NULL,6);
/*!40000 ALTER TABLE `transaction_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` varchar(128) NOT NULL,
  `paypal_pay_key` varchar(128) DEFAULT NULL,
  `paypal_sender_email` varchar(256) DEFAULT NULL,
  `paypal_status` varchar(64) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES ('0825b3cc-4eb3-4373-8589-3b5aebab21b1','PAYID-MM552DQ4TY30661UK3323324',NULL,'created','2022-10-04 07:13:17'),('1471ab2e-d84c-4a59-b021-36c37dcb6c3f','PAYID-MOJZ3LQ0SW67347UU182841X',NULL,'created','2022-12-09 20:42:22'),('241b3003-df1b-44c6-b158-9814d28c9130','PAYID-MXMQ3AQ9177280130715802G',NULL,'created','2024-02-23 21:26:26'),('269c6e22-ba1f-49de-8fb4-adc532dbc662','PAYID-MPRMXTI0VJ088099U817305G',NULL,'created','2023-02-07 22:08:13'),('33183c46-215d-406a-ba90-0a290f244433','PAYID-MZNAFGI3NK38014KT5917306',NULL,'created','2024-05-31 17:02:16'),('3773fdb9-ace3-41e6-8343-5877a533bf22','PAYID-MVVRM6Q41B010322Y7321313',NULL,'created','2023-12-02 11:35:21'),('4554b2ab-a979-4d5e-a1ac-a82cd3cdcfaa','PAYID-MMHHBUQ2S832010S0009921U',NULL,'created','2022-08-30 20:19:29'),('485a3274-e31a-43ad-85ff-de26d74eae68','PAYID-MOCBAEQ5YB50241GV699213T',NULL,'created','2022-11-28 01:34:09'),('5138f19a-f745-454f-be95-c4a4e83c11a8','PAYID-MNEUUII0KY024697E5179156',NULL,'created','2022-10-14 11:38:09'),('541b90d2-4258-4dda-9562-9b0741c4108e','PAYID-MNEUUPY4GB86040B2373653W',NULL,'created','2022-10-14 11:38:39'),('562a2f13-79ea-4b60-b00a-643040987c01','PAYID-MOJZ3LY0VD61261161427416',NULL,'created','2022-12-09 20:42:23'),('5eae8772-5b91-4f34-ac9c-fa9341417b36','','','','2019-03-18 12:31:57'),('6602c43f-d4ba-4c8d-bcfe-b0bdcdb3cc38','PAYID-MYK5TUY588986064E080842T',NULL,'created','2024-04-10 00:14:11'),('78e43d6e-4008-4d1f-8164-2544c0fe4998','PAYID-MMHIKYA8LH425297X947541G',NULL,'created','2022-08-30 21:47:12'),('7d7535f0-136d-4f5a-ba5d-6fd40dab821b','PAYID-MYK5RRY6VD81228DD249914U',NULL,'created','2024-04-10 00:09:42'),('8165deb7-978d-4b2c-9069-dfe38bd92dda','PAYID-LXPRQKQ4XY47200TA722294P',NULL,'created','2019-11-28 00:43:21'),('92c4b039-4778-4b51-8b93-e1eb5255d105','PAYID-MZTQNCY6FL02603NJ7778226',NULL,'created','2024-06-10 13:58:34'),('a1fe1f7f-ff2e-4fdd-a587-54931f93e7c1','PAYID-MXMGBDA63B6145530756543A',NULL,'created','2024-02-23 09:08:27'),('b7bf92a5-60a5-4493-b1ea-0d9205de6335','PAYID-LRR5IYI2TU22905KS496425H','','created','2019-02-13 08:25:02'),('c1ba1e89-6e27-49d8-9820-f88fa3c4c877','PAYID-MW7HMZA5575149343288760A',NULL,'created','2024-02-03 17:22:43'),('cb2fbd39-045f-4e34-879a-9911a0d4e4f4','PAYID-MXMQ2VY9D662070KY887045K',NULL,'created','2024-02-23 21:25:42'),('ccaf524f-0c34-42b8-b6ff-3341a5b535ed','PAYID-MMHIMYY8JH823616P0237224',NULL,'created','2022-08-30 21:51:30'),('ce99b3c5-fd2f-4d30-a27e-79b41e03590c','PAYID-LSV2VGQ9NS228460V049170K',NULL,'created','2019-04-08 20:09:59'),('cf0fc635-b170-4951-999e-57d743589115','PAYID-MXOBX2Q5GN515338B263144H',NULL,'created','2024-02-26 05:04:41'),('ed905746-0c44-453e-897b-ea6713d49e44','','','','2019-03-15 17:39:59'),('ed99d763-cc26-49c9-894a-d914a8326673','PAYID-MZ5PPAA35S7228985065193U',NULL,'created','2024-06-25 16:59:43'),('ffaf2bf4-9086-4df4-befb-6e5581a954ff','PAYID-MMHJJKY0TB96501A80075921',NULL,'created','2022-08-30 22:52:27');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int unsigned NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `name` varchar(64) NOT NULL,
  `upload_limit` int NOT NULL DEFAULT '4',
  `paypal_access_token` varchar(256) NOT NULL,
  `paypal_refresh_token` varchar(256) NOT NULL,
  `paypal_id_token` varchar(256) NOT NULL,
  `paypal_token_expiry_timestamp` int unsigned NOT NULL,
  `paypal_account_id` varchar(256) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `email` (`email`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-27 16:18:33
