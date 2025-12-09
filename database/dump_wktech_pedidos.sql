CREATE DATABASE  IF NOT EXISTS `wk_pedidos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `wk_pedidos`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: wk_pedidos
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int NOT NULL,
  `nome` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cidade` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uf` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Maria Souza','São Paulo','SP'),(2,'João Silva','Campinas','SP'),(3,'Carlos Pereira','Belo Horizonte','MG'),(4,'Ana Oliveira','Porto Alegre','RS'),(5,'Paulo Santos','Curitiba','PR'),(6,'Fernanda Costa','Recife','PE'),(7,'Ricardo Lima','Fortaleza','CE'),(8,'Patrícia Almeida','Salvador','BA'),(9,'Bruno Ribeiro','Brasília','DF'),(10,'Camila Nunes','Goiânia','GO'),(11,'Diego Martins','Manaus','AM'),(12,'Aline Rocha','Natal','RN'),(13,'Sérgio Fernandes','Maceió','AL'),(14,'Juliana Carvalho','Vitoria','ES'),(15,'Marcelo Araujo','Florianópolis','SC'),(16,'Beatriz Moreira','São José dos Campos','SP'),(17,'Rafael Castro','Santos','SP'),(18,'Larissa Ramos','Uberlândia','MG'),(19,'Eduardo Pinto','Cuiabá','MT'),(20,'Simone Dias','João Pessoa','PB');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_produtos`
--

DROP TABLE IF EXISTS `pedido_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_produtos` (
  `autoincrem` bigint NOT NULL AUTO_INCREMENT,
  `numero_pedido` bigint NOT NULL,
  `codigo_produto` int NOT NULL,
  `quantidade` decimal(13,3) NOT NULL,
  `valor_unitario` decimal(13,4) NOT NULL,
  `valor_total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`autoincrem`),
  KEY `idx_pp_numero_pedido` (`numero_pedido`),
  KEY `idx_pp_codigo_produto` (`codigo_produto`),
  CONSTRAINT `fk_pp_pedido` FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos` (`numero_pedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pp_produto` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_produtos`
--

LOCK TABLES `pedido_produtos` WRITE;
/*!40000 ALTER TABLE `pedido_produtos` DISABLE KEYS */;
INSERT INTO `pedido_produtos` VALUES (3,2,1010,2.000,100.0000,200.00),(4,2,1019,3.000,25.0000,75.00),(5,2,1010,1.000,100.0000,100.00),(6,3,1004,10.000,100.0000,1000.00),(7,3,1017,5.000,200.0000,1000.00),(8,3,1003,2.000,235.0000,470.00),(9,3,1012,32.000,50.0000,1600.00),(10,4,1002,1.000,100.0000,100.00),(11,4,1007,3.000,1500.0000,4500.00),(12,5,1003,1.000,100.0000,100.00),(13,5,1008,1.000,100.0000,100.00),(14,5,1017,1.000,100.0000,100.00),(15,5,1012,2.000,200.0000,400.00),(16,6,1012,10.000,100.0000,1000.00);
/*!40000 ALTER TABLE `pedido_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_seq`
--

DROP TABLE IF EXISTS `pedido_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_seq` (
  `id` int NOT NULL,
  `last_no` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_seq`
--

LOCK TABLES `pedido_seq` WRITE;
/*!40000 ALTER TABLE `pedido_seq` DISABLE KEYS */;
INSERT INTO `pedido_seq` VALUES (1,7);
/*!40000 ALTER TABLE `pedido_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `numero_pedido` bigint NOT NULL,
  `data_emissao` datetime NOT NULL,
  `codigo_cliente` int NOT NULL,
  `valor_total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `idx_pedidos_cliente` (`codigo_cliente`),
  KEY `idx_pedidos_data` (`data_emissao`),
  CONSTRAINT `fk_pedidos_cliente` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (2,'2025-12-08 20:42:02',10,375.00),(3,'2025-12-08 21:06:01',10,4070.00),(4,'2025-12-09 06:32:56',20,4600.00),(5,'2025-12-09 07:34:29',10,700.00),(6,'2025-12-09 07:38:15',7,1000.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `codigo` int NOT NULL,
  `descricao` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `preco_venda` decimal(13,2) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1001,'Parafuso 5x20mm - pacote 100',0.50),(1002,'Porca 5mm - pacote 100',0.30),(1003,'Chave Phillips PH2',12.00),(1004,'Alicate universal 8\"',35.00),(1005,'Fita isolante 20m',4.50),(1006,'Cabo USB 2.0 - 1m',8.90),(1007,'Conector RJ45',1.20),(1008,'Placa mãe ATX básica',320.00),(1009,'Memória RAM 8GB DDR4',180.00),(1010,'SSD 240GB',240.00),(1011,'Teclado USB',45.00),(1012,'Mouse óptico USB',25.00),(1013,'Monitor 19\" LED',420.00),(1014,'Fonte ATX 500W',220.00),(1015,'Cooler 120mm',28.50),(1016,'Gabinete ATX sem fonte',150.00),(1017,'HD 1TB',290.00),(1018,'Cabo HDMI 1.5m',18.00),(1019,'Placa de vídeo básica',650.00),(1020,'Adaptador Bluetooth USB',39.90);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'wk_pedidos'
--

--
-- Dumping routines for database 'wk_pedidos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-09  7:44:16
