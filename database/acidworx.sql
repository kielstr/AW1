-- MySQL dump 10.13  Distrib 5.5.54, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: acidworx
-- ------------------------------------------------------
-- Server version	5.5.54-0+deb8u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artist` (
  `artist_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `artist_name` varchar(45) NOT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `address_line3` varchar(255) DEFAULT NULL,
  `country_id` int(11) NOT NULL,
  `email` varchar(45) NOT NULL,
  `payment_email` varchar(45) NOT NULL,
  `soundcloud_url` varchar(255) DEFAULT NULL,
  `ra_url` varchar(255) DEFAULT NULL,
  `beatport_url` varchar(255) DEFAULT NULL,
  `facebook_page` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `token` varchar(255) NOT NULL,
  `signed` tinyint(4) NOT NULL DEFAULT '0',
  `email_confirmed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`artist_id`),
  UNIQUE KEY `artist_id_UNIQUE` (`artist_id`),
  UNIQUE KEY `artist_name_UNIQUE` (`artist_name`),
  UNIQUE KEY `token_UNIQUE` (`token`),
  KEY `artist_country_code_fk_idx` (`country_id`),
  CONSTRAINT `artist_country_code_fk` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Kiel Stirling','Acid Child','60 Hoffmans Rd','Essendon','Melbourne',13,'kielstirling@gmail.com','kielstirling@gmail.com','https://soundcloud.com/acidchild303','https://www.residentadvisor.net/dj/acidchild','https://www.beatport.com/artist/acid-child/429353','https://www.facebook.com/MelbAcidChild/','','Acid Child is an Australian recording artist and producer. He started his carrer as a DJ in the Sydney underground seen in the early 90\'s. \r\n\r\nHis quest to create music started in the 90\'s ultlising tracking software and Cubase. Addicted to all the things','2017-06-04 05:36:47','73JnTQSFx2AGf6y9HDW7jMVdP7zMC9KqFWLDZEqbgGp',1,0),(23,'Kiel R Stirling','BassBoy','60 Hoffmans Rd','Essendon','Melbourne',13,'kielstirling@gmail.com','kielstirling@gmail.com','https://soundcloud.com/acidchild303','https://www.residentadvisor.net/dj/acidchild','https://www.beatport.com/artist/acid-child/429353','https://www.facebook.com/MelbAcidChild/','','Acid freak','2017-06-04 06:52:59','i9X8Pq3s7YtPEL8amucF3Hki9PBqJkVR1YSVlplbKCU',1,0),(24,'Tippy Kiel','Tripper Acid','60 Hoffmans Rd','','Essendon',13,'kielstirling@gmail.com','kielstirling@gmail.com','','','','','','','2017-06-02 06:47:56','BZj9QZAIsGm5jmH0dpLVlGD4NnW34H7c0m5DseVFU7V',1,1),(25,'Kiel Stirling','Bassist','60 Hoffmans Rd','','Essendon',13,'kielstirling@gmail.com','kielstirling@gmail.com','','','','','','','2017-06-02 06:47:55','XUaHOOa5mFquZ2i8AYyv5NN3jWmkyXB9U0wc3k44TuD',1,0),(26,'Pierre','DJ Pierre','','','',2,'labels@elektraxmusic.com','acidchild@paypal.com','','','','','','So i assume the email would have a link to this page...nice !','2017-06-02 10:57:44','MBbTvVuUbBaPrwczKqulE9nm9MBe6g5mJ2Ndj9dAcEw',0,0),(27,'Robert Smith','The Cure','60 Hoffmans Rd','','Essendon',13,'kielstirling@gmail.com','kielstirling@gmail.com','','','','','','','2017-06-03 02:25:12','LMGNgZeKG1qR0fWKa3gtkyIJZLdZLN7kN3CvLL1Q5P6',0,0),(28,'Kiel Stirling','The Smiths ','60 Hoffmans Rd','','Essendon',13,'kielstirling@gmail.com','kielstirling@gmail.com','','','','','','','2017-06-03 02:26:57','H6skMoY8bFKYEDbOLihBfI0E8Opz6WeKCtHTKCQEqSx',1,0),(29,'Kiel Stirling','Kiel Stirling','60 Hoffmans Rd','','Essendon',13,'kielstirling@gmail.com','kielstirling@gmail.com','','','','','','','2017-06-03 08:37:11','kzMyDZNokdDq8Yj4DFGyNBTRaskMh4YCGSmbEoHmdtj',0,0);
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `country_id` int(11) NOT NULL AUTO_INCREMENT,
  `country_code` varchar(2) NOT NULL DEFAULT '',
  `country_name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'AF','Afghanistan'),(2,'AL','Albania'),(3,'DZ','Algeria'),(4,'DS','American Samoa'),(5,'AD','Andorra'),(6,'AO','Angola'),(7,'AI','Anguilla'),(8,'AQ','Antarctica'),(9,'AG','Antigua and Barbuda'),(10,'AR','Argentina'),(11,'AM','Armenia'),(12,'AW','Aruba'),(13,'AU','Australia'),(14,'AT','Austria'),(15,'AZ','Azerbaijan'),(16,'BS','Bahamas'),(17,'BH','Bahrain'),(18,'BD','Bangladesh'),(19,'BB','Barbados'),(20,'BY','Belarus'),(21,'BE','Belgium'),(22,'BZ','Belize'),(23,'BJ','Benin'),(24,'BM','Bermuda'),(25,'BT','Bhutan'),(26,'BO','Bolivia'),(27,'BA','Bosnia and Herzegovina'),(28,'BW','Botswana'),(29,'BV','Bouvet Island'),(30,'BR','Brazil'),(31,'IO','British Indian Ocean Territory'),(32,'BN','Brunei Darussalam'),(33,'BG','Bulgaria'),(34,'BF','Burkina Faso'),(35,'BI','Burundi'),(36,'KH','Cambodia'),(37,'CM','Cameroon'),(38,'CA','Canada'),(39,'CV','Cape Verde'),(40,'KY','Cayman Islands'),(41,'CF','Central African Republic'),(42,'TD','Chad'),(43,'CL','Chile'),(44,'CN','China'),(45,'CX','Christmas Island'),(46,'CC','Cocos (Keeling) Islands'),(47,'CO','Colombia'),(48,'KM','Comoros'),(49,'CG','Congo'),(50,'CK','Cook Islands'),(51,'CR','Costa Rica'),(52,'HR','Croatia (Hrvatska)'),(53,'CU','Cuba'),(54,'CY','Cyprus'),(55,'CZ','Czech Republic'),(56,'DK','Denmark'),(57,'DJ','Djibouti'),(58,'DM','Dominica'),(59,'DO','Dominican Republic'),(60,'TP','East Timor'),(61,'EC','Ecuador'),(62,'EG','Egypt'),(63,'SV','El Salvador'),(64,'GQ','Equatorial Guinea'),(65,'ER','Eritrea'),(66,'EE','Estonia'),(67,'ET','Ethiopia'),(68,'FK','Falkland Islands (Malvinas)'),(69,'FO','Faroe Islands'),(70,'FJ','Fiji'),(71,'FI','Finland'),(72,'FR','France'),(73,'FX','France, Metropolitan'),(74,'GF','French Guiana'),(75,'PF','French Polynesia'),(76,'TF','French Southern Territories'),(77,'GA','Gabon'),(78,'GM','Gambia'),(79,'GE','Georgia'),(80,'DE','Germany'),(81,'GH','Ghana'),(82,'GI','Gibraltar'),(83,'GK','Guernsey'),(84,'GR','Greece'),(85,'GL','Greenland'),(86,'GD','Grenada'),(87,'GP','Guadeloupe'),(88,'GU','Guam'),(89,'GT','Guatemala'),(90,'GN','Guinea'),(91,'GW','Guinea-Bissau'),(92,'GY','Guyana'),(93,'HT','Haiti'),(94,'HM','Heard and Mc Donald Islands'),(95,'HN','Honduras'),(96,'HK','Hong Kong'),(97,'HU','Hungary'),(98,'IS','Iceland'),(99,'IN','India'),(100,'IM','Isle of Man'),(101,'ID','Indonesia'),(102,'IR','Iran (Islamic Republic of)'),(103,'IQ','Iraq'),(104,'IE','Ireland'),(105,'IL','Israel'),(106,'IT','Italy'),(107,'CI','Ivory Coast'),(108,'JE','Jersey'),(109,'JM','Jamaica'),(110,'JP','Japan'),(111,'JO','Jordan'),(112,'KZ','Kazakhstan'),(113,'KE','Kenya'),(114,'KI','Kiribati'),(115,'KP','Korea, Democratic People\'s Republic of'),(116,'KR','Korea, Republic of'),(117,'XK','Kosovo'),(118,'KW','Kuwait'),(119,'KG','Kyrgyzstan'),(120,'LA','Lao People\'s Democratic Republic'),(121,'LV','Latvia'),(122,'LB','Lebanon'),(123,'LS','Lesotho'),(124,'LR','Liberia'),(125,'LY','Libyan Arab Jamahiriya'),(126,'LI','Liechtenstein'),(127,'LT','Lithuania'),(128,'LU','Luxembourg'),(129,'MO','Macau'),(130,'MK','Macedonia'),(131,'MG','Madagascar'),(132,'MW','Malawi'),(133,'MY','Malaysia'),(134,'MV','Maldives'),(135,'ML','Mali'),(136,'MT','Malta'),(137,'MH','Marshall Islands'),(138,'MQ','Martinique'),(139,'MR','Mauritania'),(140,'MU','Mauritius'),(141,'TY','Mayotte'),(142,'MX','Mexico'),(143,'FM','Micronesia, Federated States of'),(144,'MD','Moldova, Republic of'),(145,'MC','Monaco'),(146,'MN','Mongolia'),(147,'ME','Montenegro'),(148,'MS','Montserrat'),(149,'MA','Morocco'),(150,'MZ','Mozambique'),(151,'MM','Myanmar'),(152,'NA','Namibia'),(153,'NR','Nauru'),(154,'NP','Nepal'),(155,'NL','Netherlands'),(156,'AN','Netherlands Antilles'),(157,'NC','New Caledonia'),(158,'NZ','New Zealand'),(159,'NI','Nicaragua'),(160,'NE','Niger'),(161,'NG','Nigeria'),(162,'NU','Niue'),(163,'NF','Norfolk Island'),(164,'MP','Northern Mariana Islands'),(165,'NO','Norway'),(166,'OM','Oman'),(167,'PK','Pakistan'),(168,'PW','Palau'),(169,'PS','Palestine'),(170,'PA','Panama'),(171,'PG','Papua New Guinea'),(172,'PY','Paraguay'),(173,'PE','Peru'),(174,'PH','Philippines'),(175,'PN','Pitcairn'),(176,'PL','Poland'),(177,'PT','Portugal'),(178,'PR','Puerto Rico'),(179,'QA','Qatar'),(180,'RE','Reunion'),(181,'RO','Romania'),(182,'RU','Russian Federation'),(183,'RW','Rwanda'),(184,'KN','Saint Kitts and Nevis'),(185,'LC','Saint Lucia'),(186,'VC','Saint Vincent and the Grenadines'),(187,'WS','Samoa'),(188,'SM','San Marino'),(189,'ST','Sao Tome and Principe'),(190,'SA','Saudi Arabia'),(191,'SN','Senegal'),(192,'RS','Serbia'),(193,'SC','Seychelles'),(194,'SL','Sierra Leone'),(195,'SG','Singapore'),(196,'SK','Slovakia'),(197,'SI','Slovenia'),(198,'SB','Solomon Islands'),(199,'SO','Somalia'),(200,'ZA','South Africa'),(201,'GS','South Georgia South Sandwich Islands'),(202,'ES','Spain'),(203,'LK','Sri Lanka'),(204,'SH','St. Helena'),(205,'PM','St. Pierre and Miquelon'),(206,'SD','Sudan'),(207,'SR','Suriname'),(208,'SJ','Svalbard and Jan Mayen Islands'),(209,'SZ','Swaziland'),(210,'SE','Sweden'),(211,'CH','Switzerland'),(212,'SY','Syrian Arab Republic'),(213,'TW','Taiwan'),(214,'TJ','Tajikistan'),(215,'TZ','Tanzania, United Republic of'),(216,'TH','Thailand'),(217,'TG','Togo'),(218,'TK','Tokelau'),(219,'TO','Tonga'),(220,'TT','Trinidad and Tobago'),(221,'TN','Tunisia'),(222,'TR','Turkey'),(223,'TM','Turkmenistan'),(224,'TC','Turks and Caicos Islands'),(225,'TV','Tuvalu'),(226,'UG','Uganda'),(227,'UA','Ukraine'),(228,'AE','United Arab Emirates'),(229,'GB','United Kingdom'),(230,'US','United States'),(231,'UM','United States minor outlying islands'),(232,'UY','Uruguay'),(233,'UZ','Uzbekistan'),(234,'VU','Vanuatu'),(235,'VA','Vatican City State'),(236,'VE','Venezuela'),(237,'VN','Vietnam'),(238,'VG','Virgin Islands (British)'),(239,'VI','Virgin Islands (U.S.)'),(240,'WF','Wallis and Futuna Islands'),(241,'EH','Western Sahara'),(242,'YE','Yemen'),(243,'ZR','Zaire'),(244,'ZM','Zambia'),(245,'ZW','Zimbabwe');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demo`
--

DROP TABLE IF EXISTS `demo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `demo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `artist_name` varchar(100) NOT NULL,
  `email` varchar(45) NOT NULL,
  `country_id` int(11) NOT NULL,
  `sent_to_other` tinyint(4) NOT NULL,
  `released_on` varchar(45) DEFAULT NULL,
  `link` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `submited_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `token` varchar(100) NOT NULL,
  `approved` tinyint(4) DEFAULT '0',
  `email_confirmed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `demo_country_id_fk_idx` (`country_id`),
  CONSTRAINT `demo_country_id_fk` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demo`
--

LOCK TABLES `demo` WRITE;
/*!40000 ALTER TABLE `demo` DISABLE KEYS */;
INSERT INTO `demo` VALUES (11,'Robert Stirling','BassBoy','acidchild303@gmail.com',13,0,'','https://www.dropbox.com/s/o81mvcspo5ilquw/02%20SHOT%20GUN%28Original%20Mix%29.mp3?dl=0',NULL,'2017-06-03 12:10:41','fegrQZZIYEf5zos96DjJmEqOxqgU1tMAiCYKVq20COY',1,0),(12,'Kiel Stirling','BassBoy','kielstirling@gmail.com',13,0,'','https://www.dropbox.com/s/o81mvcspo5ilquw/02%20SHOT%20GUN%28Original%20Mix%29.mp3?dl=0',NULL,'2017-06-01 11:56:21','h1t5fLQ9d8se0bzj5IV4lOPAceK3Gg6MYxfIRvmsFMu',1,0),(13,'Kiel Stirling','Bassist','kielstirling@gmail.com',13,0,'','http://dropbox.com',NULL,'2017-06-02 05:06:02','jZ1mvlSe4LZ2zwqmff0NwBnGMYL8YTRUp5EyIB46SGy',1,0),(14,'Kiel Stirling','Bassist','kielstirling@gmail.com',13,0,'','http://dropbox.com',NULL,'2017-06-03 12:34:45','bAkc1C35se4RhbtFauXBMZFLp8coCgsb7Fwns8Jd2sH',1,0),(15,'Sarah Baker','Sarah Baker','kielstirling@gmail.com',13,0,'','http://dropbox.com',NULL,'2017-06-02 04:18:44','f5sMQL1YYWPrvQuXV4YJaNg3eUQoqE5VukLW4mqGw6W',1,0),(16,'Pierre','DJ Pierre','elektraxmusic@gmail.com',1,0,'No','Later',NULL,'2017-06-02 11:00:34','nrR44ja9kk3fheSDgo8mq7dUMLmgbRK05m1p1nGGCOn',1,0),(17,'Freaky','Freaky','kielstirling@gmail.com',13,0,'','http://dropbox.com',NULL,'2017-06-02 10:50:53','xcguRJ0O7eShv0KPxLjkMI8CQBJQFN4uPocyh4fjKVM',1,0),(18,'Kiel Stirling','Bixxx','kielstirling@gmail.com',13,0,'','https://www.dropbox.com/s/o81mvcspo5ilquw/02%20SHOT%20GUN%28Original%20Mix%29.mp3?dl=0',NULL,'2017-06-03 08:59:59','FqvE7PdFrptrsBXPkHLzftIUuCy9vKThhPlHJiw4Npl',1,0),(19,'Kiel Stirling','Wooper','kielstirling@gmail.com',13,0,'','http://dropbox.com',NULL,'2017-06-03 12:07:29','fXbdednqxZv6dpJzRRrSBgixshrrd8vBzzaJBbmDZGY',1,0);
/*!40000 ALTER TABLE `demo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `format_ref`
--

DROP TABLE IF EXISTS `format_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `format_ref` (
  `format_id` int(11) NOT NULL,
  `text` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`format_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `format_ref`
--

LOCK TABLES `format_ref` WRITE;
/*!40000 ALTER TABLE `format_ref` DISABLE KEYS */;
INSERT INTO `format_ref` VALUES (1,'Digital'),(2,'Vinyl'),(3,'CD'),(4,'USB');
/*!40000 ALTER TABLE `format_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `release`
--

DROP TABLE IF EXISTS `release`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `release` (
  `release_id` int(11) NOT NULL AUTO_INCREMENT,
  `artist_id` int(11) NOT NULL,
  `release_number` int(11) DEFAULT NULL,
  `name` varchar(45) NOT NULL,
  `release_date` date NOT NULL,
  `format` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`release_id`),
  KEY `artist_fk_idx` (`artist_id`),
  KEY `release_format_fk_idx` (`format`),
  CONSTRAINT `release_artist_fk` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `release_format_fk` FOREIGN KEY (`format`) REFERENCES `format_ref` (`format_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `release`
--

LOCK TABLES `release` WRITE;
/*!40000 ALTER TABLE `release` DISABLE KEYS */;
INSERT INTO `release` VALUES (1,1,13,'Pea Soup','2014-09-16',1,NULL,NULL,'2017-05-28 08:00:33');
/*!40000 ALTER TABLE `release` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Admin'),(2,'Artist');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track`
--

DROP TABLE IF EXISTS `track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `track` (
  `track_id` int(11) NOT NULL AUTO_INCREMENT,
  `release_id` int(11) NOT NULL,
  `artitst_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  KEY `release_fk_idx` (`release_id`),
  KEY `artist_fk_idx` (`artitst_id`),
  KEY `track_artist_fk_idx` (`artitst_id`),
  CONSTRAINT `track_artist_fk` FOREIGN KEY (`artitst_id`) REFERENCES `artist` (`artist_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `track_release_fk` FOREIGN KEY (`release_id`) REFERENCES `release` (`release_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track`
--

LOCK TABLES `track` WRITE;
/*!40000 ALTER TABLE `track` DISABLE KEYS */;
INSERT INTO `track` VALUES (1,1,1,'Pea Soup (Original Mix)','2017-05-28 08:13:36',1),(2,1,1,'Pea Soup (Ground Loop Remix)','2017-05-28 08:14:02',2),(3,1,1,'Pea Soup (SERi Remix)','2017-05-28 08:14:02',3),(4,1,1,'Pea Soup (Mitaka Sound Remix)','2017-05-28 08:14:02',4),(5,1,1,'Pea Soup (Classic Acid Mix)','2017-05-28 08:14:15',5);
/*!40000 ALTER TABLE `track` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `user_id` bigint(20) NOT NULL,
  `role_id` int(11) NOT NULL,
  UNIQUE KEY `user_role` (`user_id`,`role_id`),
  KEY `user_roles_role_id_fk_idx` (`role_id`),
  CONSTRAINT `user_roles_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'acidchild','Testing');
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

-- Dump completed on 2017-06-04 21:01:49
