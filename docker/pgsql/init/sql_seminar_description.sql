-- MySQL dump 10.13  Distrib 5.7.28, for osx10.14 (x86_64)
--
-- Host: localhost    Database: sql_seminar
-- ------------------------------------------------------
-- Server version	5.7.28
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table "baseball"
--

DROP TABLE IF EXISTS baseball;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE baseball (
  team varchar(10) NOT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "courseMaster"
--

DROP TABLE IF EXISTS courseMaster;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE courseMaster (
  course_id int NOT NULL,
  course_name varchar(32) NOT NULL,
  PRIMARY KEY (course_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "customers"
--

DROP TABLE IF EXISTS customers;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE customers (
  customer_id int NOT NULL,
  customer_name varchar(20) NOT NULL,
  zip varchar(7) NOT NULL,
  PRIMARY KEY (customer_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "items"
--

DROP TABLE IF EXISTS items;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE items (
  item varchar(16) NOT NULL,
  PRIMARY KEY (item)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "openCourses"
--

DROP TABLE IF EXISTS openCourses;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE openCourses (
  "month" int NOT NULL,
  course_id int NOT NULL,
  PRIMARY KEY ("month",course_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "order_item"
--

DROP TABLE IF EXISTS order_item;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE order_item (
  order_item_id int NOT NULL,
  order_id int NOT NULL,
  item_id int NOT NULL,
  amount int NOT NULL,
  price int NOT NULL,
  total int NOT NULL,
  PRIMARY KEY (order_item_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "orders"
--

DROP TABLE IF EXISTS orders;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE orders (
  order_id int NOT NULL,
  customer_id int NOT NULL,
  purchase_day date DEFAULT NULL,
  PRIMARY KEY (order_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "population"
--

DROP TABLE IF EXISTS population;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE population (
  pref varchar(10) NOT NULL,
  population int NOT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "postcode"
--

DROP TABLE IF EXISTS postcode;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE postcode (
  jis varchar(5) DEFAULT NULL,
  old_zip varchar(5) DEFAULT NULL,
  zip varchar(7) DEFAULT NULL,
  pref_kana varchar(100) DEFAULT NULL,
  city_kana varchar(100) DEFAULT NULL,
  town_kana varchar(100) DEFAULT NULL,
  pref varchar(100) DEFAULT NULL,
  city varchar(100) DEFAULT NULL,
  town varchar(100) DEFAULT NULL,
  comment1 smallint  DEFAULT NULL,
  comment2 smallint  DEFAULT NULL,
  comment3 smallint  DEFAULT NULL,
  comment4 smallint  DEFAULT NULL,
  comment5 smallint  DEFAULT NULL,
  comment6 smallint  DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "products"
--

DROP TABLE IF EXISTS products;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE products (
  "name" char(16) DEFAULT NULL,
  price int DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "sales"
--

DROP TABLE IF EXISTS sales;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE sales (
  "year" int NOT NULL,
  sale int NOT NULL,
  PRIMARY KEY ("year")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "sales2"
--

DROP TABLE IF EXISTS sales2;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE sales2 (
  "year" int NOT NULL,
  sale int NOT NULL,
  PRIMARY KEY ("year")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "shopItems"
--

DROP TABLE IF EXISTS shopItems;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE shopItems (
  shop varchar(16) NOT NULL,
  item varchar(16) NOT NULL,
  PRIMARY KEY (shop,item)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "students"
--

DROP TABLE IF EXISTS students;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE students (
  student_id int NOT NULL,
  class varchar(10) NOT NULL,
  PRIMARY KEY (student_id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "tainousha"
--

DROP TABLE IF EXISTS tainousha;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE tainousha (
  customer_id int NOT NULL,
  invoice_month date NOT NULL,
  payment_status smallint NOT NULL,
  PRIMARY KEY (customer_id,invoice_month)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "tblAge"
--

DROP TABLE IF EXISTS tblAge;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE tblAge (
  age_class char(1) NOT NULL,
  age_range varchar(30) DEFAULT NULL,
  PRIMARY KEY (age_class)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "tblPop"
--

DROP TABLE IF EXISTS tblPop;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE tblPop (
  pref_name varchar(30) NOT NULL,
  age_class char(1) NOT NULL,
  sex_cd char(1) NOT NULL,
  population int DEFAULT NULL,
  PRIMARY KEY (pref_name,age_class,sex_cd)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "tblSex"
--

DROP TABLE IF EXISTS tblSex;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE tblSex (
  sex_cd char(1) NOT NULL,
  sex varchar(5) DEFAULT NULL,
  PRIMARY KEY (sex_cd)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "testScores"
--

DROP TABLE IF EXISTS testScores;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE testScores (
  student_id int NOT NULL,
  "subject" varchar(32) NOT NULL,
  score int DEFAULT NULL,
  PRIMARY KEY (student_id,"subject")
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-23 11:36:28
