/*
 Navicat Premium Data Transfer

 Source Server         : 堡垒机-gatekeeper
 Source Server Type    : MySQL
 Source Server Version : 80020 (8.0.20)
 Source Host           : 10.16.30.200:13306
 Source Schema         : gatekeeper

 Target Server Type    : MySQL
 Target Server Version : 80020 (8.0.20)
 File Encoding         : 65001

 Date: 23/07/2025 10:55:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, '生产服务器', '描述1', '2025-03-21 16:22:15', '2025-03-24 10:37:20');
INSERT INTO `categories` VALUES (2, '阿里云服务器', '', '2025-04-22 16:59:10', '2025-04-22 16:59:10');
INSERT INTO `categories` VALUES (3, '运维服务器', '', '2025-04-22 17:25:04', '2025-04-22 17:25:04');
INSERT INTO `categories` VALUES (4, '测试服务器', '', '2025-04-30 15:41:11', '2025-04-30 15:41:11');
INSERT INTO `categories` VALUES (5, '技术支持中心', '', '2025-07-03 16:50:56', '2025-07-03 16:50:56');

-- ----------------------------
-- Table structure for clients
-- ----------------------------
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `port` int NOT NULL,
  `version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `hostname` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `os_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mac_address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `last_seen` datetime NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_clients_ip`(`ip` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clients
-- ----------------------------
INSERT INTO `clients` VALUES (1, '10.16.30.133', 45654, '1.0.0', NULL, NULL, 'e4:5e:37:b6:46:e3', '2025-07-23 10:55:18', '2025-04-21 08:00:03');
INSERT INTO `clients` VALUES (10, '10.16.30.110', 45654, '1.0.0', NULL, NULL, 'e9:4a:52:a3:e2:6f', '2025-07-23 10:55:18', '2025-06-24 02:18:26');
INSERT INTO `clients` VALUES (14, '10.16.30.44', 45654, '1.0.0', NULL, NULL, '8c:88:2b:60:03:0e', '2025-07-23 10:55:16', '2025-07-21 05:34:29');
INSERT INTO `clients` VALUES (15, '10.16.30.8', 45654, '1.0.0', NULL, NULL, '70:9c:d1:6b:59:8a', '2025-07-22 17:44:42', '2025-07-22 09:29:43');

-- ----------------------------
-- Table structure for credentials
-- ----------------------------
DROP TABLE IF EXISTS `credentials`;
CREATE TABLE `credentials`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of credentials
-- ----------------------------
INSERT INTO `credentials` VALUES (1, 'C端编译服务器', 'administrator', 'Z0FBQUFBQm9XMnpreFlJcWNMYWpTMTB1dV9sZDYtMTA5QWQ5aWhha1Rxa3FBck9Yai02SGRCUTI2YzhPMVY2eHFCSUh2dHJrLWQwMzlYWW93U3htaW9fWHd1T2VUcS1TdlE9PQ==', '');
INSERT INTO `credentials` VALUES (2, 'linux运维', 'root', 'Z0FBQUFBQm9ZaXdnS2FyNnd6dHJoYWxTQTVyQjRFcGFSSGZiOWtuRWRUTkN3d0NuU0I2aUVRUU92Uk5hVlpIZnFvOFN4ckQtVlhPOHl3VlZBSU83UTJobExRVlpMUlpHcHc9PQ==', 'na$i)csGqMD+');
INSERT INTO `credentials` VALUES (3, 'windows运维', 'administrator', 'Z0FBQUFBQm9Zakg0OTFTTEpyZWpuWXgwbnJwM3ZKMjBsdXFQbGQ5NFlWRFhBWVZJclJtWHY2Yk5wMXJRUHduQjFIMW9GR284UkZVQ3J6ZXM1TVlvUVBmOEE5WWxkOUs4VGc9PQ==', 'E$pRholQxYVa');
INSERT INTO `credentials` VALUES (4, '阿里云linux密钥1', 'kjc', 'Z0FBQUFBQm9aMllTVlp5b3pqcjNBZVNFbG9yOF83VkJvR1dZNTB5X1F1REdTeDI5R21YWDdDbjF2a3JFQmNfbW5Ec2hWbWF2Y2FmVUI2OC1vM2wzTlE4b3FCbkVpT2NETmc9PQ==', '^hfhds2LT8Rv7689');
INSERT INTO `credentials` VALUES (5, '阿里云linux密钥2', 'szkjc', 'Z0FBQUFBQm9aMlpPNkw5WmVISnRtbW43R2pldk9VN3Q4YTlUdkV0SkJTdnAxblk0MXlObFotWVZ2MzVuVXNQZm1ucElCLVBQc2xLdlBXSEtrTnV1aUxpVHRCbDlsM29BaUE9PQ==', '^hfhds2LT8Rv7689');

-- ----------------------------
-- Table structure for encryption_keys
-- ----------------------------
DROP TABLE IF EXISTS `encryption_keys`;
CREATE TABLE `encryption_keys`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `key_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `key_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `key_name`(`key_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of encryption_keys
-- ----------------------------

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `server_id` int NULL DEFAULT NULL,
  `operation_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `operation_content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `ip_address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `server_id`(`server_id` ASC) USING BTREE,
  CONSTRAINT `operation_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `operation_logs_ibfk_2` FOREIGN KEY (`server_id`) REFERENCES `servers` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_logs
-- ----------------------------

-- ----------------------------
-- Table structure for server_categories
-- ----------------------------
DROP TABLE IF EXISTS `server_categories`;
CREATE TABLE `server_categories`  (
  `server_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`server_id`, `category_id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `server_categories_ibfk_1` FOREIGN KEY (`server_id`) REFERENCES `servers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `server_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of server_categories
-- ----------------------------

-- ----------------------------
-- Table structure for server_users
-- ----------------------------
DROP TABLE IF EXISTS `server_users`;
CREATE TABLE `server_users`  (
  `user_id` int NOT NULL,
  `server_id` int NOT NULL,
  PRIMARY KEY (`user_id`, `server_id`) USING BTREE,
  INDEX `server_id`(`server_id` ASC) USING BTREE,
  CONSTRAINT `server_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `server_users_ibfk_2` FOREIGN KEY (`server_id`) REFERENCES `servers` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of server_users
-- ----------------------------
INSERT INTO `server_users` VALUES (11, 6);
INSERT INTO `server_users` VALUES (11, 8);
INSERT INTO `server_users` VALUES (3, 9);
INSERT INTO `server_users` VALUES (9, 9);
INSERT INTO `server_users` VALUES (11, 9);
INSERT INTO `server_users` VALUES (3, 11);
INSERT INTO `server_users` VALUES (11, 11);
INSERT INTO `server_users` VALUES (3, 15);
INSERT INTO `server_users` VALUES (3, 16);
INSERT INTO `server_users` VALUES (3, 17);
INSERT INTO `server_users` VALUES (9, 17);
INSERT INTO `server_users` VALUES (3, 18);
INSERT INTO `server_users` VALUES (3, 21);
INSERT INTO `server_users` VALUES (3, 22);
INSERT INTO `server_users` VALUES (8, 23);
INSERT INTO `server_users` VALUES (11, 23);
INSERT INTO `server_users` VALUES (11, 30);
INSERT INTO `server_users` VALUES (5, 31);
INSERT INTO `server_users` VALUES (3, 34);
INSERT INTO `server_users` VALUES (6, 34);
INSERT INTO `server_users` VALUES (3, 35);
INSERT INTO `server_users` VALUES (7, 36);
INSERT INTO `server_users` VALUES (8, 36);
INSERT INTO `server_users` VALUES (13, 36);
INSERT INTO `server_users` VALUES (11, 38);
INSERT INTO `server_users` VALUES (9, 40);
INSERT INTO `server_users` VALUES (8, 44);
INSERT INTO `server_users` VALUES (8, 45);
INSERT INTO `server_users` VALUES (9, 46);
INSERT INTO `server_users` VALUES (9, 47);
INSERT INTO `server_users` VALUES (9, 48);
INSERT INTO `server_users` VALUES (9, 49);
INSERT INTO `server_users` VALUES (9, 50);
INSERT INTO `server_users` VALUES (11, 55);

-- ----------------------------
-- Table structure for servers
-- ----------------------------
DROP TABLE IF EXISTS `servers`;
CREATE TABLE `servers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `port` int NULL DEFAULT 22,
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `password_encrypted` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `category_id` int NULL DEFAULT NULL,
  `in_use_by` int NULL DEFAULT NULL,
  `last_active` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `auth_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'password',
  `key_file` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `public_key` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `public_key_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器备注信息',
  `key_passphrase` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `credential_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `in_use_by`(`in_use_by` ASC) USING BTREE,
  INDEX `fk_servers_credential`(`credential_id` ASC) USING BTREE,
  CONSTRAINT `fk_servers_credential` FOREIGN KEY (`credential_id`) REFERENCES `credentials` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `servers_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `servers_ibfk_2` FOREIGN KEY (`in_use_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servers
-- ----------------------------
INSERT INTO `servers` VALUES (2, 'C端编译服务器', '10.16.30.180', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aMGNHU2paR1JJTlpPMWx1N1NXMDEtZ0JmbUYwaUU4QVZlSXpIOHJ1UzlnQ2RSQjc4VHZYYi1IWk5qV3RuWk9kRzRlRDRJdWI3M0pDTXotUXczZ2ZLUTk2SFE9PQ==', NULL, 3, NULL, NULL, '2025-03-21 16:22:32', '2025-07-17 16:18:17', 'password', NULL, NULL, NULL, '图新说、新引擎图新说、引擎SDK版本编译及版本库管理', NULL, NULL);
INSERT INTO `servers` VALUES (6, 'BIM服务器-2', '59.110.28.130', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9CMXFaaTFXTUNrLXlnX1k4UENSd1d3aEllM2dtX3ZnVUJiekY5UGRCRmZtdzVJMmdJVGxaTHBiLWwwTHpWR3dzcDhGZkY4cEZxNkwxRFU3bXhDNlgtSV9CYk4zbEFKYTZZQmZ3U3FSNlZCb1RRNjA9', NULL, 2, NULL, NULL, '2025-04-22 17:00:11', '2025-07-10 15:36:49', 'password', NULL, NULL, NULL, 'Revit：2022-2024', NULL, NULL);
INSERT INTO `servers` VALUES (7, '堡垒机', '10.16.30.223', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FRFJHMmJIUS00bVFTTlpmZUoxSkxpZEU2SHlJR2hOd2h2LVlDeTlxdC04dEgwb2xZYUdpbjJZQ2VQek9KdmI2bzZjNThNeUlOclR4X2I2QzlPeEZMTGt0NUE9PQ==', NULL, 3, 10, '2025-07-23 10:54:37', '2025-04-29 10:07:03', '2025-07-23 10:54:37', 'password', NULL, NULL, NULL, '堡垒机服务', NULL, NULL);
INSERT INTO `servers` VALUES (8, '项目案例', '123.56.161.149', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTJTNC1UaFhsbERqYThYdm44dERwWFdjR1BBMjNCX3ItN3ZCUW9XSGhWanNTaVJMUlp1QTBjajVWNHF6R2RuN09rTHkwUU1GM0JpQl83OHJsLU5vYTZSU0NoWkt0UnZTTU95YXlDRDhNVVVQc3c9', NULL, 2, NULL, NULL, '2025-04-30 10:40:19', '2025-07-10 15:37:07', 'password', NULL, NULL, NULL, '社区网格、官网等案例\n', NULL, NULL);
INSERT INTO `servers` VALUES (9, 'BIM服务器-1', '8.140.152.230', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTRvMU42Q09vLTAtVTZSNUN0NFZ0Qngxa1VjdFFHQzdncEFTXzZ5SklEbk02dGV3cjFPNHJyeXlHSW9yZEVOdmppRmRGblRNeEg1V1Z4R1JjVWhjSWpITFViTUpfdVpSLVZiekdJanQyaU1XR3c9', NULL, 2, NULL, NULL, '2025-04-30 10:42:48', '2025-07-15 10:05:14', 'password', NULL, NULL, NULL, 'Revit：2014-2020', NULL, NULL);
INSERT INTO `servers` VALUES (10, 'Git仓库/Jenkins', '101.201.239.52', 22, 'Linux', 'root', 'Z0FBQUFBQm9FWTVoandBaFFpUThnVF9hbm9nNE5BRWd5ZmZLYU5aSWtGWXQ5RjQzS21tTW5Rd1VfZUpsZzRZT3dGOGQweG10Q1lVTWhiT21ZajlDVFFLTnJFUkZvTklaZGFFTGo5OFJKWjE1c2k1cC1BLUg3ejg9', NULL, 2, NULL, NULL, '2025-04-30 10:43:45', '2025-07-17 13:08:39', 'password', NULL, NULL, NULL, '线上Jenkins、gitlab代码仓库', NULL, NULL);
INSERT INTO `servers` VALUES (11, '预生产-WIN', '47.94.213.245', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTZrUXBjazVjeVRRbzRUaTVYU0FjVnFvQkp2U3JKdDV4TTFDQ05nMUtKSEREdDJsUUViSDJPeUF4dFdMVHVLbjVkSTRPWjB1NDJOVG4tbWtJYkhjU0JHVV9XNXFTZWtJRXpkUEVKVi1laFotZzQ9', NULL, 2, NULL, NULL, '2025-04-30 10:44:53', '2025-07-10 15:34:39', 'password', NULL, NULL, NULL, 'Q运行的切片服务代理、位置共享', NULL, NULL);
INSERT INTO `servers` VALUES (12, '许可-CRM', '123.56.96.169', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FWThIbHRqbkRUeWc5WTVFcThOVTNCaHQwQ004cWhhSTQ1Y3JRa2c2d2lIb1VCT2FJdTU5V0ZEbjZjWTJfTHJIc1RyQnVvMVVuOC1HVUY3YzE4ZTFGVTRaRWRCVFRROUFhVzZOTURPVm4weUY2TzA9', NULL, 2, NULL, NULL, '2025-04-30 10:46:32', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, '许可服务', NULL, NULL);
INSERT INTO `servers` VALUES (14, '本地gitlab', '10.16.30.139', 22, 'Linux', 'root', 'Z0FBQUFBQm9ZaklpT1I1WXVzbkptYkZBZGtzSThVVWJGSU5HNjd0RlBRdzlScGNZU010emFtN2U3b0gwY1o5dDRQeE4ycmpGemM3b3JBOTV5dS1PNlQ0SkxCejJmRVdMUHc9PQ==', NULL, 3, NULL, NULL, '2025-04-30 10:49:32', '2025-07-22 14:21:29', 'password', NULL, NULL, NULL, '原gitlab还原环境、运维知识库', NULL, NULL);
INSERT INTO `servers` VALUES (15, '数据中心', '10.16.30.168', 3389, 'Windows', 'sjzx', 'Z0FBQUFBQm9FYlZFYTNsV1ZpMHUtYURkZzBCOVBmOEQ3cnllcHBCd2tfd0JZMTFBaG5XbG9wTlQwa21qSWVWUHlVU0x3WVBuNzZ2c3JjcVJyY0pMT2d4M3FFZ1BMRmZPcWc9PQ==', NULL, 1, NULL, NULL, '2025-04-30 13:29:40', '2025-07-22 16:16:01', 'password', NULL, NULL, NULL, '内网图新GIS云平台', NULL, NULL);
INSERT INTO `servers` VALUES (16, '图新云GIS开发联调环境-1', '10.16.30.27', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FYlc3aGNZZUpuVF9KdEprSTJtVU53cnR6anBFRzF1ZW5RaGUzMDdKZmVyako2WDViZkNYTlB4WjNpeVN6dXNVZlRvVlZnV2NXSUhVNlRKd1AwTGN2OGkzY3gzQlJEVjczVjlhMlhjY2d5RW5jRWs9', NULL, 4, NULL, NULL, '2025-04-30 13:31:40', '2025-06-25 10:32:53', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (17, '测试环境-1', '10.16.30.161', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FYmNfb0djUkM3RGl6UE53SGZIejFQWmFBN0NLX1RDTmtqc3I4dFNINDAyRlNSVEM5YnRCV0RtRHBCYlFHUlFHYUVxWDRHUERPejBycGppT1hPOTltMEFkWkE9PQ==', NULL, 4, NULL, NULL, '2025-04-30 13:32:24', '2025-07-14 15:36:48', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (18, '图新云GIS开发联调环境-2', '10.16.30.113', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FYllIYXpTazl5M0NTQU9jZnlGaHgwNVpnMjRCV2FyZWt6UDZsVjh4T19YZVBHUEppV3FqNkVvalNacXhlaldvcEhKWFJENjVTZlFoalJxcDItVXJONjlZS0E9PQ==', NULL, 4, NULL, NULL, '2025-04-30 13:32:55', '2025-05-15 11:27:40', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (19, '本地Mongodb', '10.16.30.200', 22, 'Linux', 'root', 'Z0FBQUFBQm9ZaklsNkhkMDREallYcmFCYzJsNUdvcXNHcldfNkhtN2U4LXFFc2k5UUFyZnhIRmt6aGcxSVVnMTNpV0NFMVZNWVVLWDY3WkFzZC1hLUVXbnFwV1FibXVsZkE9PQ==', NULL, 3, NULL, NULL, '2025-04-30 14:08:02', '2025-07-21 09:42:03', 'password', NULL, NULL, NULL, '线上Mongodb同步环境', NULL, NULL);
INSERT INTO `servers` VALUES (20, '夜莺监控服务器', '10.16.30.193', 22, 'Linux', 'root', 'Z0FBQUFBQm9Zakd2NEYxVlFkOVd3SDAzVW1hNUZrRXFaTFNDYl9KUlRQal9mM2VUQjZlM0phd1JFYnZGaXdpclMtdXJCNXdRRENvdnF3M2x6MFRUTG1sME8wVkpORjVWS1E9PQ==', NULL, 3, NULL, NULL, '2025-04-30 15:28:28', '2025-07-22 15:06:22', 'password', NULL, NULL, NULL, '内部服务器监控', NULL, NULL);
INSERT INTO `servers` VALUES (21, '本地Kylin10', '10.16.30.56', 22, 'Linux', 'root', 'Z0FBQUFBQm9FZEpBcm0yNkttUDVDalBPbEhrTTJEeW9ZMU9va1k2MzVNRGR2emE2VEhHa09YT0ZQbG1TR3l2TU95VkJwTzc0YzNMRmZfZ0E3dWtxQy1FanFhTmxIYm54OFZnQUxkdG5kVlVTTlRyRTVQWVlrbEU9', NULL, NULL, NULL, NULL, '2025-04-30 15:33:21', '2025-07-17 11:25:46', 'password', NULL, NULL, NULL, '银河麒麟V10测试服务器', NULL, NULL);
INSERT INTO `servers` VALUES (22, '内部数据库', '10.16.30.36', 22, 'Linux', 'root', 'Z0FBQUFBQm9FZE4yRVVWRE5RdFJpNHZIM2UwaExDSUZGMTF6ZjRmRkRhNHhOZ3ZySEs1Ujg0SW5uTW1kOGtldDJWNjFlTXdGOXR5NFdYMVJiZkw5WEg2NGRUbTlXYUxCa3c9PQ==', NULL, NULL, NULL, NULL, '2025-04-30 15:37:21', '2025-07-04 13:10:04', 'password', NULL, NULL, NULL, '测试数据库', NULL, NULL);
INSERT INTO `servers` VALUES (23, '研发测试', '10.16.30.172', 3389, 'Windows', 'tuxin', 'Z0FBQUFBQm9IVmY3am9GdkRXWl9nTXhORERCbzJ1MEpGMUFSbHYyTlBHVE50czJWcXNsS0MwN0FUSUI0NV9PN0sxZTVBbUxWc05GcGV3c1VFQzFfSnlPWDNZZzA3S0JtSlE9PQ==', NULL, 4, NULL, NULL, '2025-05-09 09:18:53', '2025-07-04 14:21:00', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (25, 'uat-linux', '39.105.106.222', 22, 'Linux', 'root', 'Z0FBQUFBQm9JWnhMMXBOT3BWWTNreHctYV9qUk5PWG4yU2pWQzh3TlJkWjdwOHd4LWg2dHhaa1c1bjZxM254NDVpQTllME9vbFl6eC1MdXp0MGRTbVRuSlc5bE5jdGRoNWUzVlNRMFg5NWkyYzlpOUw1ajRYbUU9', NULL, 2, NULL, NULL, '2025-05-12 14:28:27', '2025-07-04 13:32:55', 'password', NULL, '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-128-CBC,230971B3FDFCD772E4A54336CA54CC84\n\nbN+HZ8bQtV2b2WHtX8bvK5EJO3ij508HersVkoGdWViiVzIw2Lk7/u4BStqsGZCD\nST3177W6uZt75I0Ij9Px/C3CXN5qgIWuxVBXcQ/cNWPTQk7bpTzjLUNny+wg3TQi\nFTS7Vn9uUaba4izNFzP5siBuEAJsE/JB6Jezc9wxZ6Be3DjqwSXvhr32VeUazriz\nQLXnLHJU37HIfVBrZhL4pjHNSSyml+yTmLbXhHL3DFFUHO9KyrwTWY87Bd/oOUwY\nbKoxcnaBbt0wmGidJYBDy0B/B/IzHGdnj1XiSbEJ8lcg6ZM3+UZPzN4bOiuQ3CHW\n0n5p7yMU2ccT8srFNcO5zKYsKnkWqXHODs0/IsjXb0cXWJY5uHdDG5WL8AbYBVLX\nfcAnNmx0Hgqc1PU84j5OTqfoVzdnmdXYGD2MQuTLjceKfK5lDhlNbsRRG1GNGAG3\n75PRY/wyKt6iJqjoJlzPaVRaJkWcTy7m+F0eKv9L9mIVbGevqssJ/xiXuaM837HB\nz0QhPRKlJ8XXeS+E/hsbrQaQi1cliOGE7vpo6Yup0tmrBfu+xHJJOND/sljo0w6f\nqcXmeNV3ffmTy4QHnndJW8xa97qeApnK9GNHfFs5ps7cmH/GjSXO5bI6sGW5DSrm\ndVVmMGL5Psr4NueYg/8TMRu9OCD99698c/sR00Rdv6DnwoLprCMyqbn8n0D5nOV1\nHE2R49700BkDLhjnbry6N3jl91Sf/O5iwN+gMhHszhGw8m6En8HfhCuhQvcuRrFT\ngOXzuKvSmnCWATQTxUZ3iJ5JXz2tAHxAcx7Isu/zz41YIGpjDziAAQrQwvP+Pw3u\n7RfU/Lo9sX1TuPWDuYgBWRuZSu5GPuTfysi+YSgyVafpQAB5agdxyCjEZMVktGaH\nd6IR+IYC7KwZBbrdr2BE3BiZ+nqU5x61pB8oHiWP2rnFs5rxe9F10efTopcG2Vg6\nMHnWWtrRHQ4yqDcoyiZ6cXIIGWlf3rj9fQXsROzs85NJjiS9KARGrBxG43ZzVC5l\nay+rtcphgKHS3/0Sgfe1S3Fhj7Dv7XQ4+XGUA2srokyTJ7wte3Kss4+X96dXS2Dg\nGt8KGdH0v+96eBX+cxJNfiMmTEy6qS94y3MDLK6piDECqAgK2hYBKlfvJsBbcZY1\n7xJgYNMkt6vqor1O+8QE7KKXyGIJRqCwfXAfqYAmA1ocWw7VsMMxerJBu++KjtFx\n+xN6WayH4gBm8tdItjzQZJCiWuhpKMJvPS32u4SdRltC09p2xNIKl8j0eF9p38CS\nmwezU0463FD6CUfHAKm5qNlYcrl0Brk9DIwB++XlwR4zVF9OJiACeEKpJuUiJiwC\nvBe0VsMRfg3+tOd1OzPbkuGmlAMvrmY8rbZh5xUVTz71ApgW8r/eXaBiFAkd9OQO\nYo5qGiuaN4v5UJ2vR8FrC6GfrOjDSeNikHiqSn2F49cJ/wuvSEPY6o2NcHw9ztQI\nwreNBVLGlMXs2oLyFfUFlVplPTSTx1OfNVKjVQyFsFXnjMqrELVgMGEFnkXsrxqF\nk3Kln2xpAWyN/2L6/xbqL4RMktWS0Zo7n/ttf6PEn/jfDtrX8lJdbw9zHWs1oLjW\n-----END RSA PRIVATE KEY-----\n', 'd:\\gatekeeper', '用户中心预生产', 'Z0FBQUFBQm9JWnd5aUY3QUZTdEN3WWs4LVlIYzQ3Vkh5YlQ2WjhGZ1MyRjhHQ2t6V2NsVkE4MjZ2bU1VRGx4ZkdEYnlRenpRYzlqY0dBWnR3dkFqTHVpVS13a0FPU1lZQ0E9PQ==', NULL);
INSERT INTO `servers` VALUES (29, '内部服务', '39.96.38.239', 20000, 'Linux', 'szkjc', 'Z0FBQUFBQm9aMlpuZDdoRFBoZDdZVWdDZWMwQ09fanp1c2NPMzBGazhwb00yam9GalRKZXNnS1JVM0dMMlAyNnh5WUtteWFKdnY1a3ZwYXhnRHlocTJTTzlGdU9xcDJNSFE9PQ==', NULL, 2, NULL, NULL, '2025-05-12 15:50:14', '2025-07-18 10:32:45', 'password', NULL, NULL, NULL, '线上postgresql从库', NULL, 5);
INSERT INTO `servers` VALUES (30, '用户中心集群-1', '182.92.65.158', 20000, 'Linux', 'kjc', 'Z0FBQUFBQm9aMlp6cXNjZXFlUEZFWVdQdHA2TWJzRlc1djltTks3VDJnSGxsdkVPMVJWRi10T2NoaFV2TmNsR28wVTAwYWRsTXhmVTY4R05xR01NdlRNZnhNOTJ1QWs3N2c9PQ==', NULL, 2, NULL, NULL, '2025-05-12 15:54:01', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, 'sass用户中心', NULL, 4);
INSERT INTO `servers` VALUES (31, '中交测试环境', '10.16.30.109', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9KVjhqYmZ5b19ocWdEUWxONm51WE1qTXBKUGtjQXhVc3FGXzViUmhDa3NWd0tpYU9KUDh1MmVwNGQtd0ZJamJSeHczNGhUQ1d0ZFR2UTllNnpKQlNFN0ZMb3c9PQ==', NULL, 4, NULL, NULL, '2025-05-15 11:27:32', '2025-07-04 13:10:34', 'password', NULL, NULL, NULL, '中交', NULL, NULL);
INSERT INTO `servers` VALUES (34, '图新云GIS', '101.201.30.185', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9PVDBDdWUxRDE3ZWpNeHRBem0wZjNNbUYwWTVOVWVkMVJ3UFpJOVpZbGFLcUtBejRWSWpDd1R0TC10bko1dW0xN3poTDVwdFJGSXY4dzlTOFk0akFRT1ptOXc9PQ==', NULL, 2, NULL, NULL, '2025-05-30 13:07:15', '2025-07-16 13:48:37', 'password', NULL, NULL, NULL, '图新云GIS正式外网环境', NULL, NULL);
INSERT INTO `servers` VALUES (35, 'Earth主站', '60.205.201.247', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9PVDdiSjRFbVVscFpOb0FFTmg4OUZMajBRd1Zobk9nMnBkOHlfcGZGeEZzVFdGUGVJaGZoNzh4cFNZRkZ2NVNMeEtraVJUbXUxejd2NEtxOXQtUWJwdnQtcXB0VTF0Nm9pWG82dkN3M0dYQk1Zbk09', NULL, 2, NULL, NULL, '2025-05-30 13:15:09', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, 'wish3d、datamanage', NULL, NULL);
INSERT INTO `servers` VALUES (36, '知识库服务器', '10.16.30.239', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9QclZuVmpMbUF6YUFmWXRpS3VYQVdhdEpaUUdkSlZmTnlqUFMzQTN0UkFvWjhSU1dqTl9Dc1hPcXU5Tlc0b2ZVNURTWmNla1F6TXF1QWNvbzRoYXcyTUIxV3c9PQ==', NULL, 1, NULL, NULL, '2025-06-03 13:04:57', '2025-07-22 17:32:17', 'password', NULL, NULL, NULL, 'dify、ragflow', NULL, NULL);
INSERT INTO `servers` VALUES (38, '刀片机', '10.16.30.24', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9XMTdmQk5Uc0ZMNEhHdGhvYzBPSjNzMXN0Q2VOcXktbm1SMmFGYzc4UWM5cFl3SjcwbHBOYnQ0dzV6VzBIbzN0SUZ5TW5SX3hZNzgzZG0zT2NoblRaTTQ1b1htc3Rkcm4zWlFTaW5IUzdvVDdvdkk9', NULL, 3, NULL, NULL, '2025-06-25 10:28:47', '2025-07-17 14:37:33', 'password', NULL, NULL, NULL, 'VMware虚拟机', NULL, NULL);
INSERT INTO `servers` VALUES (39, '黄河源测试环境', '10.16.30.100', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9XMm1PbFF3TGwzY05mMmEtTWRYcXY3UEJQYnpqNVNwLVduSllqZDBOWHNTM0gyWXZRcDVTZFQtbkRvWlJrNGk2TkNWYlNyRVdmNjFpSkVZUXU1U1JNTUZiNXc9PQ==', NULL, 4, NULL, NULL, '2025-06-25 11:14:22', '2025-07-04 13:11:58', 'password', NULL, NULL, NULL, '黄河源一期', NULL, NULL);
INSERT INTO `servers` VALUES (40, 'BIM服务器-3', '10.16.30.171', 3389, 'Windows', 'tuxin', 'Z0FBQUFBQm9YS05rWEZSMk1TSTFpdmpyek44UWU4cXBDMmpkUWdwQ28ydFQ4TDBOdUxocnJnWWo0Y1k1bGxrVmJEdjQwajhkcTl4Vk04eGo1aVI5WGdvX252dFFZZGNsR3c9PQ==', NULL, NULL, NULL, NULL, '2025-06-26 09:33:26', '2025-07-22 09:27:30', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (43, 'docker镜像管理', '10.16.30.191', 22, 'Linux', 'root', 'Z0FBQUFBQm9ZakdfUTRxSnUwelJCZ2ZQMHpMWUdYNnYtMXE1UDJYUFl2MWxhZE9odzVPczNCd1NsbWtPRTRvMG5jeDVWcG9QQ3NmMU1UQXR4TFF3eEZSZHRTUkpER25yLWc9PQ==', NULL, 3, NULL, NULL, '2025-06-30 14:24:54', '2025-07-15 14:06:22', 'password', NULL, NULL, NULL, '虚拟机-docker镜像管理', NULL, NULL);
INSERT INTO `servers` VALUES (44, '测试服务器', '10.16.30.53', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aamJuWm5CQUpReXpDNm14cHhoZXBaRE5DVllwbi02TUdwRWtoWU1ZYlNXVUt1OUVmVjJQSEhpMnZrUjRFV2M3RmIxYjBLZ1BUVnVKUEdXSkh3akJaTWVENHc0VXBId0ZWNkNISnJMT2tBZERQaU09', NULL, 4, NULL, NULL, '2025-07-03 15:53:12', '2025-07-22 16:12:24', 'password', NULL, NULL, NULL, '广西电力,苏尼特,张铺', NULL, NULL);
INSERT INTO `servers` VALUES (45, '测试服务器', '10.16.30.6', 3389, 'Windows', 'tuxin', 'Z0FBQUFBQm9aamNCS01EaHNjcWtEcnhrdFN3UmI4Z1U2U1RsazRaN05YdHktNlZLU3Z6M0Ztb1pJVHJzd3ZreGVHRjBGdXJPV0MtTFJHeVNfM01ycE9fSlJFUjdSVHo3bFBQem0xd29iNGFXbkJYcE8wMXhmS0k9', NULL, 4, NULL, NULL, '2025-07-03 15:53:37', '2025-07-10 13:25:13', 'password', NULL, NULL, NULL, '九洲,黄河院二期', NULL, NULL);
INSERT INTO `servers` VALUES (46, '黑苹果', '10.16.30.166', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aa0JibUNBTXRxQmt6a1g1Q05JVXpKWktTUjZmdmt6V1ZuNldCN2dHWkV6RFNJTklCUmE5TXpHb1J6aWRzazhYajBKTDd6b1NnbHNXdHZaVDhmTEtDX3J0b2NULUJFbGp4LVI4ZDBRbjlsZlZ2SDQ9', NULL, 3, NULL, NULL, '2025-07-03 16:33:31', '2025-07-14 09:33:38', 'password', NULL, NULL, NULL, '百度网盘下载', NULL, NULL);
INSERT INTO `servers` VALUES (47, '数据生产', '10.16.30.167', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aa0Z5aVVBNm9HUE1lR3Z5T1VmVVJKdUFCVDViY09LcXBLTUFWQXVETlVaWWRUbU1qRWhCZWV6MUxvY0J1aE1QWHVqTHdiRDJyYUx6WlFoVld0YmpjOWc2VU1keUdKMmVsX2tNSjE0b1J1MXpuY1U9', NULL, 1, NULL, NULL, '2025-07-03 16:38:11', '2025-07-03 17:09:34', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (48, '技术支持中心', '10.16.30.170', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aa1NaYnNXN1JyUS0wREVCRm5oMXlfWWg4YWJnVnMzbDhuR09wUEdnaWhjazVVY0o2U3VnS0J6NVNSTWd2NWRYYVpxXzhfV3BZLVVQakZyOUwtcF80NzZoS3c9PQ==', NULL, 5, NULL, NULL, '2025-07-03 16:51:37', '2025-07-03 17:00:41', 'password', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (49, '技术支持中心-FTP', '10.16.30.226', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aa1hVaFRMNHNvZUU5MEVPTlJmMlRXajBSbV9USmYxQ19VeHlUTTJ4VFVWVXZvQUZZVi1BMUNKN2wyQ0N4bnJGY2JRWExnN1NXYWxJSFMweUdzbEgzUXVpUnc9PQ==', NULL, 5, NULL, NULL, '2025-07-03 16:56:52', '2025-07-04 13:07:24', 'password', NULL, NULL, NULL, '', NULL, NULL);
INSERT INTO `servers` VALUES (50, '技术支持中心-API', '10.16.30.228', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9aa1l3MmNkQkd6TXdERFVIcGhTZDFRWkVWUXBFVThrcXoyYmt4eEtOYUFNaVcwTWg0TE9SWjE0THo0R0RGUHcyYjJkYWd1dGthdjRIZkEtVldQWC1SaXZadk45bzZoQVFEUXRmLU9pYzhmZFhvanc9', NULL, 5, NULL, NULL, '2025-07-03 16:58:24', '2025-07-04 13:07:17', 'password', NULL, NULL, NULL, '', NULL, NULL);
INSERT INTO `servers` VALUES (51, '用户中心集群-2', '123.57.62.102', 20000, 'Linux', 'kjc', 'Z0FBQUFBQm9aMmFZSVVBYVljbTFXRlc4VV9Del9PM3g1Ml9rcmVLY1pkc1lsRjFsd2h0bC0wUGFrRzhHOUtaUTV1NGowa2UzZENjRTIwSWJnUE1WTGg0SE9raElnOW5QbGc9PQ==', NULL, 2, NULL, NULL, '2025-07-04 13:28:47', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, 'sass用户中心', NULL, 4);
INSERT INTO `servers` VALUES (52, 'postgresql', '39.105.119.126', 20000, 'Linux', 'szkjc', 'Z0FBQUFBQm9aMmJ0X2d4LWhzNWhnYjBZbUZZSzdKMF8xUnpISXFIUHBtd0pPWG5xVEVudDFSZFdES09xUVVvVFRHbjhqWlZmWEozMDRIcFE1VldseWZIV016dlVUSURtZnc9PQ==', NULL, 2, NULL, NULL, '2025-07-04 13:30:23', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, '线上postgresql正式环境', NULL, 5);
INSERT INTO `servers` VALUES (53, 'Mongodb', '47.93.183.174', 20000, 'Linux', 'szkjc', 'Z0FBQUFBQm9aMmNpV0NHck9FdU04aUc1VTBjWGlodk05RmtzSUJ6TFBuVEMzc2tzV1ZxX3c3ZUpvMWtMS09JelRWczdzeUZHQWhHcy1EdXVBSzJGLUhmbzd6RlhPcGI2U3c9PQ==', NULL, 2, NULL, NULL, '2025-07-04 13:31:16', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, '线上Mongodb正式环境', NULL, 5);
INSERT INTO `servers` VALUES (54, 'web服务器', '39.107.153.113', 20000, 'Linux', 'szkjc', 'Z0FBQUFBQm9aMmRCbWpja093eXRuVzI4N01PNGg0NEYyR2dfNFpQbmw1czIxSDlVM09oczdOU09FZklJb2NzMWZ1VEtlTy00VlY2ZmhjWjlmTXI2Q09ib3V4a3NNMFdtM1E9PQ==', NULL, 2, NULL, NULL, '2025-07-04 13:31:47', '2025-07-04 13:32:55', 'password', NULL, NULL, NULL, '线上nginx', NULL, 5);
INSERT INTO `servers` VALUES (55, 'BIM服务器', '10.16.30.196', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9iTFdsVjg3NTdmVmpmbEdLaTVhQjFZbXNZTlUwSlJTek81cTF4NmJMZk9qbU1vT3poOHc1ODI0T2E3cFR2c3dtaHZ6VEM4U1c2LTdocG1IUzRKekRZdk10WlE9PQ==', NULL, 1, NULL, NULL, '2025-07-08 14:07:36', '2025-07-08 14:11:40', 'password', NULL, NULL, NULL, 'Revit18，20，22\nCAD21，22\nms\nnw2021', NULL, NULL);
INSERT INTO `servers` VALUES (57, '内部数据库', '10.16.30.222', 22, 'Linux', 'root', 'Z0FBQUFBQm9kSlpKR2RteEdPeXlnTVZ2N2JZcmhFVTVOWUZRV2FNRGx3U0xWQUdiVjdRRHdKaFRnZ0puNFdEQzk3ZExsYnJGamIzV09SZk9BaEdiOEt6UXpuN0g2SUJqSEtLZ201YTFaazAyZnd6WjBHeTJxZjA9', NULL, 4, NULL, NULL, '2025-07-14 13:31:54', NULL, 'password', NULL, NULL, NULL, 'pg、mongo', NULL, NULL);
INSERT INTO `servers` VALUES (59, '测试服务器', '10.16.30.169', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9kSnFESE5QVXlIWUFVYWFFdHJlbjQ3YlFvczV2NFhERmlNZmJybXYyTC1Zak8wN2NNbGN6YTFJWWJjeWFfTkpEYzEtNGkwZHl6YmlOVEhTWXRhVGl5OWhHWXRXRzFYYktXZGxiSVBqTGF0YVhrX009', NULL, 4, NULL, NULL, '2025-07-14 13:49:57', NULL, 'password', NULL, NULL, NULL, '', NULL, NULL);

-- ----------------------------
-- Table structure for service_permissions
-- ----------------------------
DROP TABLE IF EXISTS `service_permissions`;
CREATE TABLE `service_permissions`  (
  `user_id` int NOT NULL,
  `service_id` int NOT NULL,
  `can_view` tinyint(1) NULL DEFAULT NULL,
  `can_edit` tinyint(1) NULL DEFAULT NULL,
  `can_delete` tinyint(1) NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `service_id`) USING BTREE,
  INDEX `service_id`(`service_id` ASC) USING BTREE,
  CONSTRAINT `service_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `service_permissions_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_permissions
-- ----------------------------
INSERT INTO `service_permissions` VALUES (3, 5, 1, 0, 0, '2025-07-16 07:08:36');
INSERT INTO `service_permissions` VALUES (12, 5, 1, 0, 0, '2025-07-16 07:03:01');

-- ----------------------------
-- Table structure for services
-- ----------------------------
DROP TABLE IF EXISTS `services`;
CREATE TABLE `services`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of services
-- ----------------------------
INSERT INTO `services` VALUES (5, '数据中心', 'http://10.16.30.168:8085/txcloud', 10, '2025-07-16 03:13:08', '2025-07-16 03:13:08', 0);

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `server_id` int NOT NULL,
  `start_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` timestamp NULL DEFAULT NULL,
  `duration` int NULL DEFAULT NULL,
  `ip_address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `client_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `server_id`(`server_id` ASC) USING BTREE,
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sessions_ibfk_2` FOREIGN KEY (`server_id`) REFERENCES `servers` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sessions
-- ----------------------------

-- ----------------------------
-- Table structure for settings
-- ----------------------------
DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `setting_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `setting_key`(`setting_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of settings
-- ----------------------------

-- ----------------------------
-- Table structure for user_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE `user_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `server_id` int NULL DEFAULT NULL,
  `server_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `server_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_server_id`(`server_id` ASC) USING BTREE,
  INDEX `idx_action`(`action` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_logs
-- ----------------------------
INSERT INTO `user_logs` VALUES (1, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:12:05');
INSERT INTO `user_logs` VALUES (2, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:12:08');
INSERT INTO `user_logs` VALUES (3, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:12:08');
INSERT INTO `user_logs` VALUES (4, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-24 09:12:32');
INSERT INTO `user_logs` VALUES (5, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:13:15');
INSERT INTO `user_logs` VALUES (6, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:13:17');
INSERT INTO `user_logs` VALUES (7, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:13:17');
INSERT INTO `user_logs` VALUES (8, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:13:32');
INSERT INTO `user_logs` VALUES (9, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:13:34');
INSERT INTO `user_logs` VALUES (10, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:13:34');
INSERT INTO `user_logs` VALUES (11, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:15:43');
INSERT INTO `user_logs` VALUES (12, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-03-24 09:16:16');
INSERT INTO `user_logs` VALUES (13, NULL, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-03-24 09:16:25');
INSERT INTO `user_logs` VALUES (14, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-03-24 09:17:25');
INSERT INTO `user_logs` VALUES (15, NULL, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-03-24 09:17:53');
INSERT INTO `user_logs` VALUES (16, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:17:56');
INSERT INTO `user_logs` VALUES (17, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:18:06');
INSERT INTO `user_logs` VALUES (18, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:18:09');
INSERT INTO `user_logs` VALUES (19, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-24 09:19:36');
INSERT INTO `user_logs` VALUES (20, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-24 09:19:41');
INSERT INTO `user_logs` VALUES (21, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-24 09:21:12');
INSERT INTO `user_logs` VALUES (22, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-24 09:27:08');
INSERT INTO `user_logs` VALUES (23, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-24 09:27:16');
INSERT INTO `user_logs` VALUES (24, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-24 09:27:34');
INSERT INTO `user_logs` VALUES (25, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-03-24 09:27:51');
INSERT INTO `user_logs` VALUES (26, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-24 09:28:06');
INSERT INTO `user_logs` VALUES (27, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-24 09:41:08');
INSERT INTO `user_logs` VALUES (28, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-24 09:41:27');
INSERT INTO `user_logs` VALUES (29, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-24 09:43:40');
INSERT INTO `user_logs` VALUES (30, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-25 01:18:04');
INSERT INTO `user_logs` VALUES (31, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-03-25 09:20:07');
INSERT INTO `user_logs` VALUES (32, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-25 09:21:07');
INSERT INTO `user_logs` VALUES (33, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 10:26:15');
INSERT INTO `user_logs` VALUES (34, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 10:26:29');
INSERT INTO `user_logs` VALUES (35, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 10:26:37');
INSERT INTO `user_logs` VALUES (36, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-25 10:26:40');
INSERT INTO `user_logs` VALUES (37, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 10:27:31');
INSERT INTO `user_logs` VALUES (38, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-03-25 10:41:43');
INSERT INTO `user_logs` VALUES (39, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 10:49:12');
INSERT INTO `user_logs` VALUES (40, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-25 10:49:20');
INSERT INTO `user_logs` VALUES (41, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 10:50:19');
INSERT INTO `user_logs` VALUES (42, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 10:51:00');
INSERT INTO `user_logs` VALUES (43, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-25 10:51:11');
INSERT INTO `user_logs` VALUES (44, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 10:52:10');
INSERT INTO `user_logs` VALUES (45, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 10:53:02');
INSERT INTO `user_logs` VALUES (46, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-03-25 11:06:11');
INSERT INTO `user_logs` VALUES (47, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:11:30');
INSERT INTO `user_logs` VALUES (48, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-25 11:11:39');
INSERT INTO `user_logs` VALUES (49, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:16:52');
INSERT INTO `user_logs` VALUES (50, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-25 11:17:08');
INSERT INTO `user_logs` VALUES (51, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 11:17:13');
INSERT INTO `user_logs` VALUES (52, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 11:17:30');
INSERT INTO `user_logs` VALUES (53, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-25 11:17:44');
INSERT INTO `user_logs` VALUES (54, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:21:25');
INSERT INTO `user_logs` VALUES (55, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 11:21:36');
INSERT INTO `user_logs` VALUES (56, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-25 11:21:47');
INSERT INTO `user_logs` VALUES (57, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 11:22:36');
INSERT INTO `user_logs` VALUES (58, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 11:26:46');
INSERT INTO `user_logs` VALUES (59, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:26:55');
INSERT INTO `user_logs` VALUES (60, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:27:14');
INSERT INTO `user_logs` VALUES (61, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-25 11:28:35');
INSERT INTO `user_logs` VALUES (62, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 11:28:35');
INSERT INTO `user_logs` VALUES (63, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-25 11:30:09');
INSERT INTO `user_logs` VALUES (64, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-03-25 11:32:11');
INSERT INTO `user_logs` VALUES (65, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', NULL, '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [超时自动断开]', '2025-03-25 11:45:09');
INSERT INTO `user_logs` VALUES (66, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-25 13:02:46');
INSERT INTO `user_logs` VALUES (67, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-03-25 13:02:55');
INSERT INTO `user_logs` VALUES (68, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.169', '用户 admin 登录系统', '2025-03-25 13:08:47');
INSERT INTO `user_logs` VALUES (69, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.169', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 13:08:54');
INSERT INTO `user_logs` VALUES (70, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 13:11:16');
INSERT INTO `user_logs` VALUES (71, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.169', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 13:12:43');
INSERT INTO `user_logs` VALUES (72, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 13:13:38');
INSERT INTO `user_logs` VALUES (73, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.228', '用户 admin 登录系统', '2025-03-25 13:31:28');
INSERT INTO `user_logs` VALUES (74, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.228', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 13:31:38');
INSERT INTO `user_logs` VALUES (75, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.228', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-25 13:31:57');
INSERT INTO `user_logs` VALUES (76, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 13:31:58');
INSERT INTO `user_logs` VALUES (77, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-03-25 13:32:13');
INSERT INTO `user_logs` VALUES (78, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-25 13:48:43');
INSERT INTO `user_logs` VALUES (79, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-25 13:49:20');
INSERT INTO `user_logs` VALUES (80, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-25 17:22:35');
INSERT INTO `user_logs` VALUES (81, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 11:15:54');
INSERT INTO `user_logs` VALUES (82, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 11:29:28');
INSERT INTO `user_logs` VALUES (83, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-26 11:29:58');
INSERT INTO `user_logs` VALUES (84, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-03-26 11:44:30');
INSERT INTO `user_logs` VALUES (85, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-26 13:52:27');
INSERT INTO `user_logs` VALUES (86, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 15:13:12');
INSERT INTO `user_logs` VALUES (87, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 15:14:06');
INSERT INTO `user_logs` VALUES (88, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-26 15:14:49');
INSERT INTO `user_logs` VALUES (89, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-03-26 15:15:01');
INSERT INTO `user_logs` VALUES (90, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-26 15:16:37');
INSERT INTO `user_logs` VALUES (91, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-26 15:17:05');
INSERT INTO `user_logs` VALUES (92, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 15:17:38');
INSERT INTO `user_logs` VALUES (93, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-26 15:18:03');
INSERT INTO `user_logs` VALUES (94, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-26 15:19:46');
INSERT INTO `user_logs` VALUES (95, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-26 17:27:31');
INSERT INTO `user_logs` VALUES (96, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-27 15:47:14');
INSERT INTO `user_logs` VALUES (97, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:09:55');
INSERT INTO `user_logs` VALUES (98, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:10:08');
INSERT INTO `user_logs` VALUES (99, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:21:32');
INSERT INTO `user_logs` VALUES (100, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:22:12');
INSERT INTO `user_logs` VALUES (101, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:29:45');
INSERT INTO `user_logs` VALUES (102, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:29:53');
INSERT INTO `user_logs` VALUES (103, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:37:03');
INSERT INTO `user_logs` VALUES (104, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:40:05');
INSERT INTO `user_logs` VALUES (105, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:40:17');
INSERT INTO `user_logs` VALUES (106, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:43:07');
INSERT INTO `user_logs` VALUES (107, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:43:16');
INSERT INTO `user_logs` VALUES (108, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:48:08');
INSERT INTO `user_logs` VALUES (109, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:48:22');
INSERT INTO `user_logs` VALUES (110, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 16:48:33');
INSERT INTO `user_logs` VALUES (111, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-27 16:48:52');
INSERT INTO `user_logs` VALUES (112, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-27 16:48:59');
INSERT INTO `user_logs` VALUES (113, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-03-27 16:49:10');
INSERT INTO `user_logs` VALUES (114, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 16:49:24');
INSERT INTO `user_logs` VALUES (115, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-27 16:49:32');
INSERT INTO `user_logs` VALUES (116, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 17:14:59');
INSERT INTO `user_logs` VALUES (117, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 17:15:06');
INSERT INTO `user_logs` VALUES (118, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-27 17:15:07');
INSERT INTO `user_logs` VALUES (119, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-27 17:15:18');
INSERT INTO `user_logs` VALUES (120, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 17:20:43');
INSERT INTO `user_logs` VALUES (121, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 17:21:14');
INSERT INTO `user_logs` VALUES (122, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-03-27 17:32:21');
INSERT INTO `user_logs` VALUES (123, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-03-27 17:32:27');
INSERT INTO `user_logs` VALUES (124, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-03-27 17:32:29');
INSERT INTO `user_logs` VALUES (125, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-03-27 17:32:39');
INSERT INTO `user_logs` VALUES (126, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-03-27 17:44:56');
INSERT INTO `user_logs` VALUES (127, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-03-27 17:59:58');
INSERT INTO `user_logs` VALUES (128, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-28 10:10:19');
INSERT INTO `user_logs` VALUES (129, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-28 14:56:57');
INSERT INTO `user_logs` VALUES (130, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-03-31 15:48:57');
INSERT INTO `user_logs` VALUES (131, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-01 09:45:21');
INSERT INTO `user_logs` VALUES (132, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-01 11:09:59');
INSERT INTO `user_logs` VALUES (133, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-04-01 11:10:03');
INSERT INTO `user_logs` VALUES (134, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-01 11:11:27');
INSERT INTO `user_logs` VALUES (135, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-01 11:11:53');
INSERT INTO `user_logs` VALUES (136, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-02 14:54:07');
INSERT INTO `user_logs` VALUES (137, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-03 15:43:46');
INSERT INTO `user_logs` VALUES (138, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-18 13:34:00');
INSERT INTO `user_logs` VALUES (139, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 13:54:34');
INSERT INTO `user_logs` VALUES (140, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-18 13:54:47');
INSERT INTO `user_logs` VALUES (141, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-18 13:56:56');
INSERT INTO `user_logs` VALUES (142, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 13:57:04');
INSERT INTO `user_logs` VALUES (143, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-18 14:11:58');
INSERT INTO `user_logs` VALUES (144, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-04-18 14:12:04');
INSERT INTO `user_logs` VALUES (145, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.170', '用户 admin 登录系统', '2025-04-18 16:43:03');
INSERT INTO `user_logs` VALUES (146, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.170', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 16:43:34');
INSERT INTO `user_logs` VALUES (147, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.170', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 16:50:01');
INSERT INTO `user_logs` VALUES (148, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.170', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 16:51:12');
INSERT INTO `user_logs` VALUES (149, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-18 17:05:57');
INSERT INTO `user_logs` VALUES (150, 1, 'admin', 'login', NULL, NULL, NULL, '127.0.0.1', '用户 admin 登录系统', '2025-04-18 17:10:51');
INSERT INTO `user_logs` VALUES (151, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-18 17:14:50');
INSERT INTO `user_logs` VALUES (152, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.228', '用户 admin 登录系统', '2025-04-18 17:16:46');
INSERT INTO `user_logs` VALUES (153, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-04-18 17:20:58');
INSERT INTO `user_logs` VALUES (154, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.228', '用户 admin 登录系统', '2025-04-18 17:21:09');
INSERT INTO `user_logs` VALUES (155, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 09:00:02');
INSERT INTO `user_logs` VALUES (156, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.24', '用户 zhuyiqing 登录系统', '2025-04-21 09:09:11');
INSERT INTO `user_logs` VALUES (157, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-21 09:53:13');
INSERT INTO `user_logs` VALUES (158, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-21 10:08:14');
INSERT INTO `user_logs` VALUES (159, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 10:16:44');
INSERT INTO `user_logs` VALUES (160, 1, 'admin', 'login', NULL, NULL, NULL, '127.0.0.1', '用户 admin 登录系统', '2025-04-21 11:00:08');
INSERT INTO `user_logs` VALUES (161, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 11:03:11');
INSERT INTO `user_logs` VALUES (162, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 11:10:30');
INSERT INTO `user_logs` VALUES (163, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 11:20:54');
INSERT INTO `user_logs` VALUES (164, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 11:21:47');
INSERT INTO `user_logs` VALUES (165, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 13:12:12');
INSERT INTO `user_logs` VALUES (166, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 13:44:06');
INSERT INTO `user_logs` VALUES (167, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 13:48:31');
INSERT INTO `user_logs` VALUES (168, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 14:36:21');
INSERT INTO `user_logs` VALUES (169, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-21 14:37:05');
INSERT INTO `user_logs` VALUES (170, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-21 14:39:07');
INSERT INTO `user_logs` VALUES (171, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 zhuyiqing 登录系统', '2025-04-21 14:39:27');
INSERT INTO `user_logs` VALUES (172, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 14:45:13');
INSERT INTO `user_logs` VALUES (173, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 14:51:10');
INSERT INTO `user_logs` VALUES (174, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-21 14:52:06');
INSERT INTO `user_logs` VALUES (175, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-04-21 14:54:08');
INSERT INTO `user_logs` VALUES (176, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 14:59:39');
INSERT INTO `user_logs` VALUES (177, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 15:52:40');
INSERT INTO `user_logs` VALUES (178, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 16:18:28');
INSERT INTO `user_logs` VALUES (179, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-21 17:36:46');
INSERT INTO `user_logs` VALUES (180, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 09:10:41');
INSERT INTO `user_logs` VALUES (181, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 admin 登录系统', '2025-04-22 09:24:16');
INSERT INTO `user_logs` VALUES (182, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 09:31:50');
INSERT INTO `user_logs` VALUES (183, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 10:16:38');
INSERT INTO `user_logs` VALUES (184, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 11:25:58');
INSERT INTO `user_logs` VALUES (185, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 11:26:02');
INSERT INTO `user_logs` VALUES (186, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.180) [超时自动断开]', '2025-04-22 11:40:59');
INSERT INTO `user_logs` VALUES (187, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-22 11:41:04');
INSERT INTO `user_logs` VALUES (188, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 13:05:05');
INSERT INTO `user_logs` VALUES (189, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 admin 登录系统', '2025-04-22 13:06:17');
INSERT INTO `user_logs` VALUES (190, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.180', '用户 admin 注销系统', '2025-04-22 13:08:35');
INSERT INTO `user_logs` VALUES (191, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 admin 登录系统', '2025-04-22 13:08:38');
INSERT INTO `user_logs` VALUES (192, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 admin 登录系统', '2025-04-22 13:34:45');
INSERT INTO `user_logs` VALUES (193, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 13:51:47');
INSERT INTO `user_logs` VALUES (194, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.180', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 14:27:25');
INSERT INTO `user_logs` VALUES (195, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 14:33:43');
INSERT INTO `user_logs` VALUES (196, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-22 14:42:26');
INSERT INTO `user_logs` VALUES (197, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 15:38:38');
INSERT INTO `user_logs` VALUES (198, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-22 17:00:12');
INSERT INTO `user_logs` VALUES (199, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-22 17:00:45');
INSERT INTO `user_logs` VALUES (200, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:03:52');
INSERT INTO `user_logs` VALUES (201, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:04:58');
INSERT INTO `user_logs` VALUES (202, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:05:01');
INSERT INTO `user_logs` VALUES (203, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:06:47');
INSERT INTO `user_logs` VALUES (204, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:07:35');
INSERT INTO `user_logs` VALUES (205, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:07:48');
INSERT INTO `user_logs` VALUES (206, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:07:55');
INSERT INTO `user_logs` VALUES (207, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-22 17:09:01');
INSERT INTO `user_logs` VALUES (208, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-04-22 17:09:06');
INSERT INTO `user_logs` VALUES (209, NULL, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhuyiqing 登录系统', '2025-04-22 17:10:41');
INSERT INTO `user_logs` VALUES (210, NULL, 'zhuyiqing', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.44', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:13:19');
INSERT INTO `user_logs` VALUES (211, NULL, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-04-22 17:13:47');
INSERT INTO `user_logs` VALUES (212, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:13:47');
INSERT INTO `user_logs` VALUES (213, NULL, 'zhuyiqing', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:13:48');
INSERT INTO `user_logs` VALUES (214, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 17:13:51');
INSERT INTO `user_logs` VALUES (215, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:14:17');
INSERT INTO `user_logs` VALUES (216, NULL, 'zhuyiqing', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.44', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:14:23');
INSERT INTO `user_logs` VALUES (217, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:14:37');
INSERT INTO `user_logs` VALUES (218, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-22 17:14:45');
INSERT INTO `user_logs` VALUES (219, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-22 17:14:51');
INSERT INTO `user_logs` VALUES (220, NULL, 'zhuyiqing', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:15:29');
INSERT INTO `user_logs` VALUES (221, NULL, 'zhuyiqing', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.44', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:15:37');
INSERT INTO `user_logs` VALUES (222, 1, 'admin', 'disconnect', 6, 'BIM服务器', '59.110.28.130', NULL, '用户 admin 断开Windows连接 BIM服务器(59.110.28.130) [超时自动断开]', '2025-04-22 17:15:45');
INSERT INTO `user_logs` VALUES (223, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-22 17:16:23');
INSERT INTO `user_logs` VALUES (224, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:17:01');
INSERT INTO `user_logs` VALUES (225, NULL, 'zhuyiqing', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:17:04');
INSERT INTO `user_logs` VALUES (226, NULL, 'zhuyiqing', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.44', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:17:11');
INSERT INTO `user_logs` VALUES (227, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:17:25');
INSERT INTO `user_logs` VALUES (228, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:17:31');
INSERT INTO `user_logs` VALUES (229, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:17:49');
INSERT INTO `user_logs` VALUES (230, NULL, 'zhuyiqing', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:18:19');
INSERT INTO `user_logs` VALUES (231, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:18:21');
INSERT INTO `user_logs` VALUES (232, NULL, 'zhuyiqing', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-22 17:18:29');
INSERT INTO `user_logs` VALUES (233, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:18:47');
INSERT INTO `user_logs` VALUES (234, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:18:48');
INSERT INTO `user_logs` VALUES (235, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:19:02');
INSERT INTO `user_logs` VALUES (236, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:19:29');
INSERT INTO `user_logs` VALUES (237, NULL, 'zhuyiqing', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-22 17:19:43');
INSERT INTO `user_logs` VALUES (238, NULL, 'zhuyiqing', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-22 17:20:05');
INSERT INTO `user_logs` VALUES (239, NULL, 'zhuyiqing', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-22 17:21:04');
INSERT INTO `user_logs` VALUES (240, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.44', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-22 17:21:35');
INSERT INTO `user_logs` VALUES (241, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-22 17:21:45');
INSERT INTO `user_logs` VALUES (242, NULL, 'zhuyiqing', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.44', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:22:33');
INSERT INTO `user_logs` VALUES (243, NULL, 'zhuyiqing', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:22:44');
INSERT INTO `user_logs` VALUES (244, NULL, 'zhuyiqing', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 zhuyiqing 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-04-22 17:22:50');
INSERT INTO `user_logs` VALUES (245, 1, 'admin', 'disconnect', 6, 'BIM服务器', '59.110.28.130', NULL, '用户 admin 断开Windows连接 BIM服务器(59.110.28.130) [超时自动断开]', '2025-04-22 17:31:24');
INSERT INTO `user_logs` VALUES (246, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.7', '用户 admin 登录系统', '2025-04-22 17:42:56');
INSERT INTO `user_logs` VALUES (247, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.7', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-22 17:43:50');
INSERT INTO `user_logs` VALUES (248, 1, 'admin', 'disconnect', 2, '刀片机', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 刀片机(10.16.30.180) [代理检测]', '2025-04-22 17:44:09');
INSERT INTO `user_logs` VALUES (249, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-23 09:28:54');
INSERT INTO `user_logs` VALUES (250, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-23 14:21:27');
INSERT INTO `user_logs` VALUES (251, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-23 14:56:14');
INSERT INTO `user_logs` VALUES (252, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-24 15:20:39');
INSERT INTO `user_logs` VALUES (253, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-24 15:22:08');
INSERT INTO `user_logs` VALUES (254, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-24 15:22:42');
INSERT INTO `user_logs` VALUES (255, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-24 15:22:45');
INSERT INTO `user_logs` VALUES (256, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-24 15:24:25');
INSERT INTO `user_logs` VALUES (257, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-24 15:24:27');
INSERT INTO `user_logs` VALUES (258, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-24 15:29:39');
INSERT INTO `user_logs` VALUES (259, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-25 16:49:26');
INSERT INTO `user_logs` VALUES (260, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-25 16:49:39');
INSERT INTO `user_logs` VALUES (261, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-25 17:10:42');
INSERT INTO `user_logs` VALUES (262, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.223', '用户 admin 注销系统', '2025-04-25 17:29:26');
INSERT INTO `user_logs` VALUES (263, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-25 17:29:37');
INSERT INTO `user_logs` VALUES (264, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.223', '用户 admin 注销系统', '2025-04-25 17:29:50');
INSERT INTO `user_logs` VALUES (265, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 08:50:47');
INSERT INTO `user_logs` VALUES (266, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-27 08:50:53');
INSERT INTO `user_logs` VALUES (267, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-27 08:51:04');
INSERT INTO `user_logs` VALUES (268, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.223', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-27 08:51:06');
INSERT INTO `user_logs` VALUES (269, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-27 08:54:20');
INSERT INTO `user_logs` VALUES (270, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-27 08:54:35');
INSERT INTO `user_logs` VALUES (271, 1, 'admin', 'connect', 2, '刀片机', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 刀片机(10.16.30.180)', '2025-04-27 08:54:52');
INSERT INTO `user_logs` VALUES (272, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 08:56:24');
INSERT INTO `user_logs` VALUES (273, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:03:19');
INSERT INTO `user_logs` VALUES (274, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:03:27');
INSERT INTO `user_logs` VALUES (275, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:03:35');
INSERT INTO `user_logs` VALUES (276, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:04:02');
INSERT INTO `user_logs` VALUES (277, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:04:48');
INSERT INTO `user_logs` VALUES (278, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:04:52');
INSERT INTO `user_logs` VALUES (279, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-27 09:06:08');
INSERT INTO `user_logs` VALUES (280, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:06:36');
INSERT INTO `user_logs` VALUES (281, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:11:50');
INSERT INTO `user_logs` VALUES (282, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 09:15:50');
INSERT INTO `user_logs` VALUES (283, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:20:06');
INSERT INTO `user_logs` VALUES (284, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:20:18');
INSERT INTO `user_logs` VALUES (285, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:20:39');
INSERT INTO `user_logs` VALUES (286, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:22:45');
INSERT INTO `user_logs` VALUES (287, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:22:54');
INSERT INTO `user_logs` VALUES (288, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:23:26');
INSERT INTO `user_logs` VALUES (289, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 09:25:46');
INSERT INTO `user_logs` VALUES (290, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:25:50');
INSERT INTO `user_logs` VALUES (291, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 09:30:24');
INSERT INTO `user_logs` VALUES (292, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.24', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-27 09:33:18');
INSERT INTO `user_logs` VALUES (293, NULL, 'zhuyiqing', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.24', '用户 zhuyiqing 连接SSH服务器 mongo(10.16.30.200)', '2025-04-27 09:33:31');
INSERT INTO `user_logs` VALUES (294, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-27 09:35:54');
INSERT INTO `user_logs` VALUES (295, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-04-27 09:36:08');
INSERT INTO `user_logs` VALUES (296, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.24', '用户 admin 登录系统', '2025-04-27 09:36:20');
INSERT INTO `user_logs` VALUES (297, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-27 09:45:26');
INSERT INTO `user_logs` VALUES (298, NULL, 'zhuyiqing', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 zhuyiqing 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-27 09:48:32');
INSERT INTO `user_logs` VALUES (299, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 09:48:44');
INSERT INTO `user_logs` VALUES (300, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 10:03:01');
INSERT INTO `user_logs` VALUES (301, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:04:08');
INSERT INTO `user_logs` VALUES (302, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 10:04:19');
INSERT INTO `user_logs` VALUES (303, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:04:22');
INSERT INTO `user_logs` VALUES (304, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:04:34');
INSERT INTO `user_logs` VALUES (305, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:04:48');
INSERT INTO `user_logs` VALUES (306, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:05:10');
INSERT INTO `user_logs` VALUES (307, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:07:28');
INSERT INTO `user_logs` VALUES (308, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:07:47');
INSERT INTO `user_logs` VALUES (309, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:07:58');
INSERT INTO `user_logs` VALUES (310, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:08:15');
INSERT INTO `user_logs` VALUES (311, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.223', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-27 10:08:32');
INSERT INTO `user_logs` VALUES (312, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 mongo(10.16.30.200) [代理检测]', '2025-04-27 10:08:55');
INSERT INTO `user_logs` VALUES (313, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 10:10:41');
INSERT INTO `user_logs` VALUES (314, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-27 10:25:42');
INSERT INTO `user_logs` VALUES (315, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 13:47:41');
INSERT INTO `user_logs` VALUES (316, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 13:48:15');
INSERT INTO `user_logs` VALUES (317, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 13:52:16');
INSERT INTO `user_logs` VALUES (318, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 13:52:33');
INSERT INTO `user_logs` VALUES (319, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 13:52:48');
INSERT INTO `user_logs` VALUES (320, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.24', '用户 admin 登录系统', '2025-04-27 14:06:31');
INSERT INTO `user_logs` VALUES (321, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:06:35');
INSERT INTO `user_logs` VALUES (322, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.24', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-27 14:06:48');
INSERT INTO `user_logs` VALUES (323, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-04-27 14:06:54');
INSERT INTO `user_logs` VALUES (324, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:09:38');
INSERT INTO `user_logs` VALUES (325, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:09:54');
INSERT INTO `user_logs` VALUES (326, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:10:11');
INSERT INTO `user_logs` VALUES (327, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:11:17');
INSERT INTO `user_logs` VALUES (328, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 14:15:54');
INSERT INTO `user_logs` VALUES (329, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:16:05');
INSERT INTO `user_logs` VALUES (330, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:16:16');
INSERT INTO `user_logs` VALUES (331, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:17:08');
INSERT INTO `user_logs` VALUES (332, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 14:21:31');
INSERT INTO `user_logs` VALUES (333, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 14:21:57');
INSERT INTO `user_logs` VALUES (334, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 14:22:07');
INSERT INTO `user_logs` VALUES (335, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.24', '用户 admin 登录系统', '2025-04-27 14:23:02');
INSERT INTO `user_logs` VALUES (336, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.24', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-27 14:23:11');
INSERT INTO `user_logs` VALUES (337, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-27 14:24:00');
INSERT INTO `user_logs` VALUES (338, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.223', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-27 14:24:11');
INSERT INTO `user_logs` VALUES (339, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.223', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-27 14:24:45');
INSERT INTO `user_logs` VALUES (340, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:24:53');
INSERT INTO `user_logs` VALUES (341, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:27:05');
INSERT INTO `user_logs` VALUES (342, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 14:37:53');
INSERT INTO `user_logs` VALUES (343, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-27 14:38:32');
INSERT INTO `user_logs` VALUES (344, 1, 'admin', 'disconnect', 6, 'BIM服务器', '59.110.28.130', NULL, '用户 admin 断开Windows连接 BIM服务器(59.110.28.130) [超时自动断开]', '2025-04-27 14:39:46');
INSERT INTO `user_logs` VALUES (345, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:41:50');
INSERT INTO `user_logs` VALUES (346, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-27 14:41:57');
INSERT INTO `user_logs` VALUES (347, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-27 14:56:58');
INSERT INTO `user_logs` VALUES (348, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-28 13:56:35');
INSERT INTO `user_logs` VALUES (349, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 13:57:07');
INSERT INTO `user_logs` VALUES (350, 1, 'admin', 'connect', NULL, 'mongo', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 mongo(10.16.30.200)', '2025-04-28 13:57:32');
INSERT INTO `user_logs` VALUES (351, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-28 13:57:37');
INSERT INTO `user_logs` VALUES (352, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-04-28 13:58:29');
INSERT INTO `user_logs` VALUES (353, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 13:59:58');
INSERT INTO `user_logs` VALUES (354, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:02:06');
INSERT INTO `user_logs` VALUES (355, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.24', '用户 admin 登录系统', '2025-04-28 14:03:23');
INSERT INTO `user_logs` VALUES (356, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:03:27');
INSERT INTO `user_logs` VALUES (357, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:03:38');
INSERT INTO `user_logs` VALUES (358, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:04:21');
INSERT INTO `user_logs` VALUES (359, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:05:54');
INSERT INTO `user_logs` VALUES (360, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:08:56');
INSERT INTO `user_logs` VALUES (361, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-28 14:09:33');
INSERT INTO `user_logs` VALUES (362, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:09:36');
INSERT INTO `user_logs` VALUES (363, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:10:47');
INSERT INTO `user_logs` VALUES (364, 1, 'admin', 'disconnect', NULL, 'mongo', '10.16.30.200', NULL, '用户 admin 断开Linux连接 mongo(10.16.30.200) [超时自动断开]', '2025-04-28 14:12:32');
INSERT INTO `user_logs` VALUES (365, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:20:22');
INSERT INTO `user_logs` VALUES (366, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:23:50');
INSERT INTO `user_logs` VALUES (367, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.24', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:24:31');
INSERT INTO `user_logs` VALUES (368, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:28:16');
INSERT INTO `user_logs` VALUES (369, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:28:21');
INSERT INTO `user_logs` VALUES (370, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:28:24');
INSERT INTO `user_logs` VALUES (371, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:28:34');
INSERT INTO `user_logs` VALUES (372, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:29:00');
INSERT INTO `user_logs` VALUES (373, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:29:43');
INSERT INTO `user_logs` VALUES (374, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:30:16');
INSERT INTO `user_logs` VALUES (375, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:30:29');
INSERT INTO `user_logs` VALUES (376, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:30:37');
INSERT INTO `user_logs` VALUES (377, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.223', '用户 admin 注销系统', '2025-04-28 14:42:53');
INSERT INTO `user_logs` VALUES (378, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-28 14:42:57');
INSERT INTO `user_logs` VALUES (379, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:00');
INSERT INTO `user_logs` VALUES (380, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:07');
INSERT INTO `user_logs` VALUES (381, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:13');
INSERT INTO `user_logs` VALUES (382, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:17');
INSERT INTO `user_logs` VALUES (383, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:24');
INSERT INTO `user_logs` VALUES (384, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:29');
INSERT INTO `user_logs` VALUES (385, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:44');
INSERT INTO `user_logs` VALUES (386, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:43:59');
INSERT INTO `user_logs` VALUES (387, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:07');
INSERT INTO `user_logs` VALUES (388, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:11');
INSERT INTO `user_logs` VALUES (389, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:13');
INSERT INTO `user_logs` VALUES (390, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:16');
INSERT INTO `user_logs` VALUES (391, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:23');
INSERT INTO `user_logs` VALUES (392, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:30');
INSERT INTO `user_logs` VALUES (393, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:38');
INSERT INTO `user_logs` VALUES (394, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:45:54');
INSERT INTO `user_logs` VALUES (395, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-28 14:48:16');
INSERT INTO `user_logs` VALUES (396, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:48:19');
INSERT INTO `user_logs` VALUES (397, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:49:30');
INSERT INTO `user_logs` VALUES (398, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:49:46');
INSERT INTO `user_logs` VALUES (399, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:50:13');
INSERT INTO `user_logs` VALUES (400, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:52:22');
INSERT INTO `user_logs` VALUES (401, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:52:41');
INSERT INTO `user_logs` VALUES (402, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:53:36');
INSERT INTO `user_logs` VALUES (403, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:54:26');
INSERT INTO `user_logs` VALUES (404, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-28 14:56:52');
INSERT INTO `user_logs` VALUES (405, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-28 14:56:54');
INSERT INTO `user_logs` VALUES (406, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-28 15:11:57');
INSERT INTO `user_logs` VALUES (407, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-28 16:14:18');
INSERT INTO `user_logs` VALUES (408, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.223', '用户 admin 登录系统', '2025-04-29 10:04:26');
INSERT INTO `user_logs` VALUES (409, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.223', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-29 10:04:30');
INSERT INTO `user_logs` VALUES (410, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-29 10:05:03');
INSERT INTO `user_logs` VALUES (411, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-29 10:05:50');
INSERT INTO `user_logs` VALUES (412, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-29 10:07:05');
INSERT INTO `user_logs` VALUES (413, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-29 10:07:24');
INSERT INTO `user_logs` VALUES (414, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-04-29 10:08:32');
INSERT INTO `user_logs` VALUES (415, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-29 10:08:41');
INSERT INTO `user_logs` VALUES (416, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-29 10:20:58');
INSERT INTO `user_logs` VALUES (417, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-29 10:23:06');
INSERT INTO `user_logs` VALUES (418, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-29 10:43:46');
INSERT INTO `user_logs` VALUES (419, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-04-29 10:58:47');
INSERT INTO `user_logs` VALUES (420, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-29 17:10:49');
INSERT INTO `user_logs` VALUES (421, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-29 17:10:51');
INSERT INTO `user_logs` VALUES (422, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-04-29 17:25:52');
INSERT INTO `user_logs` VALUES (423, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:06:11');
INSERT INTO `user_logs` VALUES (424, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-30 09:18:11');
INSERT INTO `user_logs` VALUES (425, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:18:14');
INSERT INTO `user_logs` VALUES (426, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-30 09:18:17');
INSERT INTO `user_logs` VALUES (427, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:18:23');
INSERT INTO `user_logs` VALUES (428, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:27:42');
INSERT INTO `user_logs` VALUES (429, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-30 09:27:44');
INSERT INTO `user_logs` VALUES (430, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:27:54');
INSERT INTO `user_logs` VALUES (431, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 09:29:42');
INSERT INTO `user_logs` VALUES (432, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 10:02:43');
INSERT INTO `user_logs` VALUES (433, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 10:34:19');
INSERT INTO `user_logs` VALUES (434, 1, 'admin', 'connect', 6, 'BIM服务器', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器(59.110.28.130)', '2025-04-30 10:34:23');
INSERT INTO `user_logs` VALUES (435, 1, 'admin', 'disconnect', 6, 'BIM服务器', '59.110.28.130', '59.110.28.130', '用户 admin 断开Windows连接 BIM服务器(59.110.28.130) [代理检测]', '2025-04-30 10:38:14');
INSERT INTO `user_logs` VALUES (436, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 10:53:06');
INSERT INTO `user_logs` VALUES (437, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-30 10:56:20');
INSERT INTO `user_logs` VALUES (438, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 10:56:34');
INSERT INTO `user_logs` VALUES (439, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-30 10:57:25');
INSERT INTO `user_logs` VALUES (440, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 11:00:53');
INSERT INTO `user_logs` VALUES (441, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-04-30 11:12:26');
INSERT INTO `user_logs` VALUES (442, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-30 11:15:55');
INSERT INTO `user_logs` VALUES (443, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 11:25:33');
INSERT INTO `user_logs` VALUES (444, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 12:24:43');
INSERT INTO `user_logs` VALUES (445, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 12:26:16');
INSERT INTO `user_logs` VALUES (446, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-04-30 12:41:17');
INSERT INTO `user_logs` VALUES (447, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 13:01:50');
INSERT INTO `user_logs` VALUES (448, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 13:02:19');
INSERT INTO `user_logs` VALUES (449, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 13:07:52');
INSERT INTO `user_logs` VALUES (450, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-04-30 13:08:09');
INSERT INTO `user_logs` VALUES (451, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-30 13:10:20');
INSERT INTO `user_logs` VALUES (452, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 13:10:23');
INSERT INTO `user_logs` VALUES (453, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-30 13:10:45');
INSERT INTO `user_logs` VALUES (454, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-04-30 13:12:17');
INSERT INTO `user_logs` VALUES (455, 1, 'admin', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-04-30 13:12:32');
INSERT INTO `user_logs` VALUES (456, 1, 'admin', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 admin 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-04-30 13:13:50');
INSERT INTO `user_logs` VALUES (457, 1, 'admin', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', '59.110.28.130', '用户 admin 断开Windows连接 BIM服务器-2(59.110.28.130) [代理检测]', '2025-04-30 13:14:38');
INSERT INTO `user_logs` VALUES (458, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-04-30 13:33:50');
INSERT INTO `user_logs` VALUES (459, 1, 'admin', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 admin 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-04-30 13:35:28');
INSERT INTO `user_logs` VALUES (460, 1, 'admin', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-04-30 13:35:33');
INSERT INTO `user_logs` VALUES (461, 1, 'admin', 'disconnect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.27', '用户 admin 断开Windows连接 图新云GIS开发联调环境-1(10.16.30.27) [代理检测]', '2025-04-30 13:36:35');
INSERT INTO `user_logs` VALUES (462, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-04-30 13:36:40');
INSERT INTO `user_logs` VALUES (463, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-04-30 13:38:09');
INSERT INTO `user_logs` VALUES (464, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-04-30 13:39:02');
INSERT INTO `user_logs` VALUES (465, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 13:49:00');
INSERT INTO `user_logs` VALUES (466, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-04-30 13:49:27');
INSERT INTO `user_logs` VALUES (467, 1, 'admin', 'disconnect', 17, '测试环境-1', '10.16.30.161', '10.16.30.161', '用户 admin 断开Windows连接 测试环境-1(10.16.30.161) [代理检测]', '2025-04-30 13:50:13');
INSERT INTO `user_logs` VALUES (468, 1, 'admin', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 admin 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-04-30 13:52:40');
INSERT INTO `user_logs` VALUES (469, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-04-30 13:52:56');
INSERT INTO `user_logs` VALUES (470, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-04-30 13:54:40');
INSERT INTO `user_logs` VALUES (471, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-04-30 13:54:42');
INSERT INTO `user_logs` VALUES (472, 1, 'admin', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', '59.110.28.130', '用户 admin 断开Windows连接 BIM服务器-2(59.110.28.130) [代理检测]', '2025-04-30 13:56:32');
INSERT INTO `user_logs` VALUES (473, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-30 13:56:42');
INSERT INTO `user_logs` VALUES (474, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-04-30 14:01:24');
INSERT INTO `user_logs` VALUES (475, 1, 'admin', 'connect', 8, '项目案例', '123.56.161.149', '10.16.30.133', '用户 admin 连接RDP服务器 项目案例(123.56.161.149)', '2025-04-30 14:01:27');
INSERT INTO `user_logs` VALUES (476, 1, 'admin', 'disconnect', 8, '项目案例', '123.56.161.149', '123.56.161.149', '用户 admin 断开Windows连接 项目案例(123.56.161.149) [代理检测]', '2025-04-30 14:03:42');
INSERT INTO `user_logs` VALUES (477, 1, 'admin', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-04-30 14:03:42');
INSERT INTO `user_logs` VALUES (478, 1, 'admin', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 admin 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-04-30 14:05:26');
INSERT INTO `user_logs` VALUES (479, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-04-30 14:05:34');
INSERT INTO `user_logs` VALUES (480, 1, 'admin', 'connect', NULL, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:05:45');
INSERT INTO `user_logs` VALUES (481, 1, 'admin', 'connect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 Nightlight监控(10.16.30.193)', '2025-04-30 14:07:20');
INSERT INTO `user_logs` VALUES (482, 1, 'admin', 'disconnect', NULL, 'Nightlight监控', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 Nightlight监控(10.16.30.193) [代理检测]', '2025-04-30 14:07:35');
INSERT INTO `user_logs` VALUES (483, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:08:07');
INSERT INTO `user_logs` VALUES (484, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:08:38');
INSERT INTO `user_logs` VALUES (485, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:20:05');
INSERT INTO `user_logs` VALUES (486, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-04-30 14:20:35');
INSERT INTO `user_logs` VALUES (487, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:24:23');
INSERT INTO `user_logs` VALUES (488, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:26:12');
INSERT INTO `user_logs` VALUES (489, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-04-30 14:26:18');
INSERT INTO `user_logs` VALUES (490, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-04-30 14:41:15');
INSERT INTO `user_logs` VALUES (491, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:41:18');
INSERT INTO `user_logs` VALUES (492, 1, 'admin', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 admin 断开Windows连接 测试环境-1(10.16.30.161) [超时自动断开]', '2025-04-30 14:41:20');
INSERT INTO `user_logs` VALUES (493, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:41:39');
INSERT INTO `user_logs` VALUES (494, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-04-30 14:42:25');
INSERT INTO `user_logs` VALUES (495, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-04-30 14:43:32');
INSERT INTO `user_logs` VALUES (496, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-04-30 14:44:25');
INSERT INTO `user_logs` VALUES (497, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-04-30 14:45:00');
INSERT INTO `user_logs` VALUES (498, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-04-30 14:45:10');
INSERT INTO `user_logs` VALUES (499, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-04-30 15:00:13');
INSERT INTO `user_logs` VALUES (500, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-04-30 15:13:56');
INSERT INTO `user_logs` VALUES (501, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-04-30 15:14:07');
INSERT INTO `user_logs` VALUES (502, 1, 'admin', 'connect', 11, '预生产-WIN', '47.94.213.245', '10.16.30.133', '用户 admin 连接RDP服务器 预生产-WIN(47.94.213.245)', '2025-04-30 15:14:11');
INSERT INTO `user_logs` VALUES (503, 1, 'admin', 'disconnect', 11, '预生产-WIN', '47.94.213.245', '47.94.213.245', '用户 admin 断开Windows连接 预生产-WIN(47.94.213.245) [代理检测]', '2025-04-30 15:18:20');
INSERT INTO `user_logs` VALUES (504, 1, 'admin', 'connect', 12, '许可-CRM', '123.56.96.169', '10.16.30.133', '用户 admin 连接RDP服务器 许可-CRM(123.56.96.169)', '2025-04-30 15:19:26');
INSERT INTO `user_logs` VALUES (505, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 15:22:17');
INSERT INTO `user_logs` VALUES (506, 1, 'admin', 'connect', 12, '许可-CRM', '123.56.96.169', '10.16.30.133', '用户 admin 连接RDP服务器 许可-CRM(123.56.96.169)', '2025-04-30 15:22:25');
INSERT INTO `user_logs` VALUES (507, 1, 'admin', 'disconnect', 12, '许可-CRM', '123.56.96.169', '123.56.96.169', '用户 admin 断开Windows连接 许可-CRM(123.56.96.169) [代理检测]', '2025-04-30 15:23:20');
INSERT INTO `user_logs` VALUES (508, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-04-30 15:23:26');
INSERT INTO `user_logs` VALUES (509, 1, 'admin', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-04-30 15:23:43');
INSERT INTO `user_logs` VALUES (510, 1, 'admin', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 admin 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-04-30 15:23:46');
INSERT INTO `user_logs` VALUES (511, 1, 'admin', 'disconnect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.27', '用户 admin 断开Windows连接 图新云GIS开发联调环境-1(10.16.30.27) [代理检测]', '2025-04-30 15:25:25');
INSERT INTO `user_logs` VALUES (512, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-04-30 15:25:30');
INSERT INTO `user_logs` VALUES (513, 1, 'admin', 'disconnect', 17, '测试环境-1', '10.16.30.161', '10.16.30.161', '用户 admin 断开Windows连接 测试环境-1(10.16.30.161) [代理检测]', '2025-04-30 15:25:49');
INSERT INTO `user_logs` VALUES (514, 1, 'admin', 'connect', 18, '图新云GIS开发联调环境-2', '10.16.30.113', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS开发联调环境-2(10.16.30.113)', '2025-04-30 15:25:52');
INSERT INTO `user_logs` VALUES (515, 1, 'admin', 'disconnect', 18, '图新云GIS开发联调环境-2', '10.16.30.113', '10.16.30.113', '用户 admin 断开Windows连接 图新云GIS开发联调环境-2(10.16.30.113) [代理检测]', '2025-04-30 15:27:52');
INSERT INTO `user_logs` VALUES (516, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-04-30 15:28:29');
INSERT INTO `user_logs` VALUES (517, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [代理检测]', '2025-04-30 15:28:46');
INSERT INTO `user_logs` VALUES (518, 1, 'admin', 'connect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.133', '用户 admin 连接SSH服务器 本地Kylin10(10.16.30.56)', '2025-04-30 15:34:37');
INSERT INTO `user_logs` VALUES (519, 1, 'admin', 'disconnect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.56', '用户 admin 断开Linux连接 本地Kylin10(10.16.30.56) [代理检测]', '2025-04-30 15:34:51');
INSERT INTO `user_logs` VALUES (520, 1, 'admin', 'connect', 22, '内部数据库', '10.16.30.36', '10.16.30.133', '用户 admin 连接SSH服务器 内部数据库(10.16.30.36)', '2025-04-30 15:37:22');
INSERT INTO `user_logs` VALUES (521, 1, 'admin', 'disconnect', 22, '内部数据库', '10.16.30.36', '10.16.30.36', '用户 admin 断开Linux连接 内部数据库(10.16.30.36) [代理检测]', '2025-04-30 15:39:37');
INSERT INTO `user_logs` VALUES (522, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-30 15:40:20');
INSERT INTO `user_logs` VALUES (523, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 登录系统', '2025-04-30 15:40:26');
INSERT INTO `user_logs` VALUES (524, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 注销系统', '2025-04-30 15:40:36');
INSERT INTO `user_logs` VALUES (525, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 15:40:39');
INSERT INTO `user_logs` VALUES (526, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-04-30 15:46:07');
INSERT INTO `user_logs` VALUES (527, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 登录系统', '2025-04-30 15:46:12');
INSERT INTO `user_logs` VALUES (528, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 注销系统', '2025-04-30 15:46:54');
INSERT INTO `user_logs` VALUES (529, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 登录系统', '2025-04-30 15:46:59');
INSERT INTO `user_logs` VALUES (530, 3, 'zhangshujun', 'connect', 18, '图新云GIS开发联调环境-2', '10.16.30.113', '10.16.30.133', '用户 zhangshujun 连接RDP服务器 图新云GIS开发联调环境-2(10.16.30.113)', '2025-04-30 15:47:11');
INSERT INTO `user_logs` VALUES (531, 3, 'zhangshujun', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.133', '用户 zhangshujun 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-04-30 15:47:27');
INSERT INTO `user_logs` VALUES (532, 3, 'zhangshujun', 'disconnect', 18, '图新云GIS开发联调环境-2', '10.16.30.113', '10.16.30.113', '用户 zhangshujun 断开Windows连接 图新云GIS开发联调环境-2(10.16.30.113) [代理检测]', '2025-04-30 15:47:53');
INSERT INTO `user_logs` VALUES (533, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 登录系统', '2025-04-30 15:48:00');
INSERT INTO `user_logs` VALUES (534, 3, 'zhangshujun', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.133', '用户 zhangshujun 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-04-30 15:48:10');
INSERT INTO `user_logs` VALUES (535, 3, 'zhangshujun', 'disconnect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.27', '用户 zhangshujun 断开Windows连接 图新云GIS开发联调环境-1(10.16.30.27) [代理检测]', '2025-04-30 15:48:25');
INSERT INTO `user_logs` VALUES (536, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 注销系统', '2025-04-30 15:48:59');
INSERT INTO `user_logs` VALUES (537, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-04-30 15:49:11');
INSERT INTO `user_logs` VALUES (538, 3, 'zhangshujun', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-04-30 15:49:51');
INSERT INTO `user_logs` VALUES (539, 3, 'zhangshujun', 'disconnect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.27', '用户 zhangshujun 断开Windows连接 图新云GIS开发联调环境-1(10.16.30.27) [代理检测]', '2025-04-30 15:50:05');
INSERT INTO `user_logs` VALUES (540, 3, 'zhangshujun', 'connect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.44', '用户 zhangshujun 连接SSH服务器 本地Kylin10(10.16.30.56)', '2025-04-30 15:50:16');
INSERT INTO `user_logs` VALUES (541, 3, 'zhangshujun', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-04-30 15:50:46');
INSERT INTO `user_logs` VALUES (542, 3, 'zhangshujun', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 zhangshujun 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-04-30 15:51:17');
INSERT INTO `user_logs` VALUES (543, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-04-30 15:51:22');
INSERT INTO `user_logs` VALUES (544, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-04-30 15:51:31');
INSERT INTO `user_logs` VALUES (545, 3, 'zhangshujun', 'connect', 11, '预生产-WIN', '47.94.213.245', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 预生产-WIN(47.94.213.245)', '2025-04-30 15:52:08');
INSERT INTO `user_logs` VALUES (546, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-04-30 16:04:47');
INSERT INTO `user_logs` VALUES (547, 3, 'zhangshujun', 'disconnect', 11, '预生产-WIN', '47.94.213.245', NULL, '用户 zhangshujun 断开Windows连接 预生产-WIN(47.94.213.245) [超时自动断开]', '2025-04-30 16:07:12');
INSERT INTO `user_logs` VALUES (548, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-06 08:47:10');
INSERT INTO `user_logs` VALUES (549, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-06 13:11:53');
INSERT INTO `user_logs` VALUES (550, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-05-06 13:12:00');
INSERT INTO `user_logs` VALUES (551, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-05-06 13:12:52');
INSERT INTO `user_logs` VALUES (552, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 13:43:07');
INSERT INTO `user_logs` VALUES (553, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 13:57:26');
INSERT INTO `user_logs` VALUES (554, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 13:57:37');
INSERT INTO `user_logs` VALUES (555, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-05-06 14:12:42');
INSERT INTO `user_logs` VALUES (556, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 14:22:28');
INSERT INTO `user_logs` VALUES (557, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-06 14:22:33');
INSERT INTO `user_logs` VALUES (558, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-06 15:24:05');
INSERT INTO `user_logs` VALUES (559, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 15:24:07');
INSERT INTO `user_logs` VALUES (560, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-05-06 15:39:10');
INSERT INTO `user_logs` VALUES (561, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-06 16:29:46');
INSERT INTO `user_logs` VALUES (562, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 16:29:56');
INSERT INTO `user_logs` VALUES (563, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-06 16:34:04');
INSERT INTO `user_logs` VALUES (564, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 16:34:08');
INSERT INTO `user_logs` VALUES (565, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-06 16:41:29');
INSERT INTO `user_logs` VALUES (566, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-06 16:41:29');
INSERT INTO `user_logs` VALUES (567, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-08 11:19:27');
INSERT INTO `user_logs` VALUES (568, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-08 13:06:34');
INSERT INTO `user_logs` VALUES (569, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-05-08 14:17:37');
INSERT INTO `user_logs` VALUES (570, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', NULL, '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [超时自动断开]', '2025-05-08 14:32:39');
INSERT INTO `user_logs` VALUES (571, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 09:18:31');
INSERT INTO `user_logs` VALUES (572, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-09 09:19:21');
INSERT INTO `user_logs` VALUES (573, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 09:19:24');
INSERT INTO `user_logs` VALUES (574, 1, 'admin', 'connect', 23, '10.16.30.172', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.172(10.16.30.172)', '2025-05-09 09:20:29');
INSERT INTO `user_logs` VALUES (575, 1, 'admin', 'disconnect', 23, '10.16.30.172', '10.16.30.172', NULL, '用户 admin 断开Windows连接 10.16.30.172(10.16.30.172) [超时自动断开]', '2025-05-09 09:35:29');
INSERT INTO `user_logs` VALUES (576, 1, 'admin', 'connect', 23, '10.16.30.172', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.172(10.16.30.172)', '2025-05-09 09:40:34');
INSERT INTO `user_logs` VALUES (577, 1, 'admin', 'disconnect', 23, '10.16.30.172', '10.16.30.172', NULL, '用户 admin 断开Windows连接 10.16.30.172(10.16.30.172) [超时自动断开]', '2025-05-09 09:55:37');
INSERT INTO `user_logs` VALUES (578, 1, 'admin', 'connect', 23, '10.16.30.172', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.172(10.16.30.172)', '2025-05-09 09:56:44');
INSERT INTO `user_logs` VALUES (579, 1, 'admin', 'disconnect', 23, '10.16.30.172', '10.16.30.172', NULL, '用户 admin 断开Windows连接 10.16.30.172(10.16.30.172) [监控自动检测]', '2025-05-09 09:56:55');
INSERT INTO `user_logs` VALUES (580, 1, 'admin', 'disconnect', 23, '10.16.30.172', '10.16.30.172', NULL, '用户 admin 断开Windows连接 10.16.30.172(10.16.30.172) [监控自动检测]', '2025-05-09 09:56:56');
INSERT INTO `user_logs` VALUES (581, 1, 'admin', 'connect', 23, '10.16.30.172', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.172(10.16.30.172)', '2025-05-09 09:59:03');
INSERT INTO `user_logs` VALUES (582, 1, 'admin', 'disconnect', 23, '10.16.30.172', '10.16.30.172', NULL, '用户 admin 断开Windows连接 10.16.30.172(10.16.30.172) [超时自动断开]', '2025-05-09 10:14:03');
INSERT INTO `user_logs` VALUES (583, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 13:25:24');
INSERT INTO `user_logs` VALUES (584, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 13:39:11');
INSERT INTO `user_logs` VALUES (585, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-09 13:57:49');
INSERT INTO `user_logs` VALUES (586, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-09 13:57:56');
INSERT INTO `user_logs` VALUES (587, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-09 13:58:18');
INSERT INTO `user_logs` VALUES (588, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-09 13:59:19');
INSERT INTO `user_logs` VALUES (589, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 13:59:36');
INSERT INTO `user_logs` VALUES (590, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-09 13:59:42');
INSERT INTO `user_logs` VALUES (591, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-09 14:00:54');
INSERT INTO `user_logs` VALUES (592, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 14:05:01');
INSERT INTO `user_logs` VALUES (593, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 15:30:39');
INSERT INTO `user_logs` VALUES (594, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 16:19:54');
INSERT INTO `user_logs` VALUES (595, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-09 17:15:54');
INSERT INTO `user_logs` VALUES (596, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-05-09 17:16:01');
INSERT INTO `user_logs` VALUES (597, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-05-09 17:31:04');
INSERT INTO `user_logs` VALUES (598, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 09:31:34');
INSERT INTO `user_logs` VALUES (599, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 10:05:32');
INSERT INTO `user_logs` VALUES (600, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 10:17:18');
INSERT INTO `user_logs` VALUES (601, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 11:22:07');
INSERT INTO `user_logs` VALUES (602, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 13:29:40');
INSERT INTO `user_logs` VALUES (603, 1, 'admin', 'connect', 22, '内部数据库', '10.16.30.36', '10.16.30.133', '用户 admin 连接SSH服务器 内部数据库(10.16.30.36)', '2025-05-12 14:28:51');
INSERT INTO `user_logs` VALUES (604, 1, 'admin', 'disconnect', 22, '内部数据库', '10.16.30.36', '10.16.30.36', '用户 admin 断开Linux连接 内部数据库(10.16.30.36) [代理检测]', '2025-05-12 14:29:28');
INSERT INTO `user_logs` VALUES (605, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-05-12 14:29:31');
INSERT INTO `user_logs` VALUES (606, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-05-12 14:30:16');
INSERT INTO `user_logs` VALUES (607, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 14:33:52');
INSERT INTO `user_logs` VALUES (608, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-12 14:33:53');
INSERT INTO `user_logs` VALUES (609, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:41:54');
INSERT INTO `user_logs` VALUES (610, 1, 'admin', 'connect', 22, '内部数据库', '10.16.30.36', '10.16.30.133', '用户 admin 连接SSH服务器 内部数据库(10.16.30.36)', '2025-05-12 14:42:05');
INSERT INTO `user_logs` VALUES (611, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:42:14');
INSERT INTO `user_logs` VALUES (612, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-12 14:42:47');
INSERT INTO `user_logs` VALUES (613, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-12 14:43:17');
INSERT INTO `user_logs` VALUES (614, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:45:01');
INSERT INTO `user_logs` VALUES (615, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:45:27');
INSERT INTO `user_logs` VALUES (616, 1, 'admin', 'connect', 22, '内部数据库', '10.16.30.36', '10.16.30.133', '用户 admin 连接SSH服务器 内部数据库(10.16.30.36)', '2025-05-12 14:47:20');
INSERT INTO `user_logs` VALUES (617, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:48:10');
INSERT INTO `user_logs` VALUES (618, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-05-12 14:48:54');
INSERT INTO `user_logs` VALUES (619, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:57:25');
INSERT INTO `user_logs` VALUES (620, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:59:02');
INSERT INTO `user_logs` VALUES (621, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 14:59:25');
INSERT INTO `user_logs` VALUES (622, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:00:47');
INSERT INTO `user_logs` VALUES (623, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:00:50');
INSERT INTO `user_logs` VALUES (624, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:00:51');
INSERT INTO `user_logs` VALUES (625, 1, 'admin', 'disconnect', 22, '内部数据库', '10.16.30.36', NULL, '用户 admin 断开Linux连接 内部数据库(10.16.30.36) [超时自动断开]', '2025-05-12 15:02:21');
INSERT INTO `user_logs` VALUES (626, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:03:02');
INSERT INTO `user_logs` VALUES (627, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:03:05');
INSERT INTO `user_logs` VALUES (628, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:05:09');
INSERT INTO `user_logs` VALUES (629, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:05:13');
INSERT INTO `user_logs` VALUES (630, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:05:14');
INSERT INTO `user_logs` VALUES (631, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:08:32');
INSERT INTO `user_logs` VALUES (632, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:08:37');
INSERT INTO `user_logs` VALUES (633, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:08:38');
INSERT INTO `user_logs` VALUES (634, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:09:00');
INSERT INTO `user_logs` VALUES (635, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:04');
INSERT INTO `user_logs` VALUES (636, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:05');
INSERT INTO `user_logs` VALUES (637, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:09:07');
INSERT INTO `user_logs` VALUES (638, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:12');
INSERT INTO `user_logs` VALUES (639, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:13');
INSERT INTO `user_logs` VALUES (640, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:09:18');
INSERT INTO `user_logs` VALUES (641, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:24');
INSERT INTO `user_logs` VALUES (642, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:09:25');
INSERT INTO `user_logs` VALUES (643, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:13:06');
INSERT INTO `user_logs` VALUES (644, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:13:08');
INSERT INTO `user_logs` VALUES (645, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:13:09');
INSERT INTO `user_logs` VALUES (646, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:14:11');
INSERT INTO `user_logs` VALUES (647, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:14:16');
INSERT INTO `user_logs` VALUES (648, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:14:17');
INSERT INTO `user_logs` VALUES (649, 1, 'admin', 'disconnect', 25, 'uat-linux', '39.105.106.222', NULL, '用户 admin 断开Linux连接 uat-linux(39.105.106.222) [超时自动断开]', '2025-05-12 15:14:25');
INSERT INTO `user_logs` VALUES (650, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:24:10');
INSERT INTO `user_logs` VALUES (651, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:24:14');
INSERT INTO `user_logs` VALUES (652, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:24:15');
INSERT INTO `user_logs` VALUES (653, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:24:28');
INSERT INTO `user_logs` VALUES (654, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:24:31');
INSERT INTO `user_logs` VALUES (655, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:24:32');
INSERT INTO `user_logs` VALUES (656, 1, 'admin', 'connect', NULL, '111', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 111(39.96.38.239)', '2025-05-12 15:34:06');
INSERT INTO `user_logs` VALUES (657, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:34:09');
INSERT INTO `user_logs` VALUES (658, 1, 'admin', 'disconnect', NULL, '111', '39.96.38.239', NULL, '用户 admin 断开Linux连接 111(39.96.38.239) [监控自动检测]', '2025-05-12 15:34:10');
INSERT INTO `user_logs` VALUES (659, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:36:15');
INSERT INTO `user_logs` VALUES (660, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:36:22');
INSERT INTO `user_logs` VALUES (661, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:36:22');
INSERT INTO `user_logs` VALUES (662, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:36:47');
INSERT INTO `user_logs` VALUES (663, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:36:50');
INSERT INTO `user_logs` VALUES (664, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-12 15:38:38');
INSERT INTO `user_logs` VALUES (665, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:38:53');
INSERT INTO `user_logs` VALUES (666, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:38:57');
INSERT INTO `user_logs` VALUES (667, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:38:59');
INSERT INTO `user_logs` VALUES (668, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:39:46');
INSERT INTO `user_logs` VALUES (669, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:39:49');
INSERT INTO `user_logs` VALUES (670, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:39:51');
INSERT INTO `user_logs` VALUES (671, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:40:04');
INSERT INTO `user_logs` VALUES (672, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:40:07');
INSERT INTO `user_logs` VALUES (673, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:40:09');
INSERT INTO `user_logs` VALUES (674, 1, 'admin', 'connect', NULL, '39.96.38.239', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 39.96.38.239(39.96.38.239)', '2025-05-12 15:43:00');
INSERT INTO `user_logs` VALUES (675, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:43:05');
INSERT INTO `user_logs` VALUES (676, 1, 'admin', 'disconnect', NULL, '39.96.38.239', '39.96.38.239', NULL, '用户 admin 断开Linux连接 39.96.38.239(39.96.38.239) [监控自动检测]', '2025-05-12 15:43:06');
INSERT INTO `user_logs` VALUES (677, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-12 15:44:21');
INSERT INTO `user_logs` VALUES (678, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-12 15:46:08');
INSERT INTO `user_logs` VALUES (679, 1, 'admin', 'connect', 25, 'uat-linux', '39.105.106.222', '10.16.30.133', '用户 admin 连接SSH服务器 uat-linux(39.105.106.222)', '2025-05-12 15:46:38');
INSERT INTO `user_logs` VALUES (680, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:50:17');
INSERT INTO `user_logs` VALUES (681, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:50:21');
INSERT INTO `user_logs` VALUES (682, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:50:27');
INSERT INTO `user_logs` VALUES (683, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:50:29');
INSERT INTO `user_logs` VALUES (684, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:50:43');
INSERT INTO `user_logs` VALUES (685, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:50:47');
INSERT INTO `user_logs` VALUES (686, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:50:49');
INSERT INTO `user_logs` VALUES (687, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:51:40');
INSERT INTO `user_logs` VALUES (688, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:51:45');
INSERT INTO `user_logs` VALUES (689, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:52:04');
INSERT INTO `user_logs` VALUES (690, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:52:07');
INSERT INTO `user_logs` VALUES (691, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:52:07');
INSERT INTO `user_logs` VALUES (692, 1, 'admin', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 admin 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-05-12 15:54:07');
INSERT INTO `user_logs` VALUES (693, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:54:10');
INSERT INTO `user_logs` VALUES (694, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:54:10');
INSERT INTO `user_logs` VALUES (695, 1, 'admin', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 admin 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-05-12 15:54:31');
INSERT INTO `user_logs` VALUES (696, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:54:38');
INSERT INTO `user_logs` VALUES (697, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:54:38');
INSERT INTO `user_logs` VALUES (698, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:55:08');
INSERT INTO `user_logs` VALUES (699, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:55:14');
INSERT INTO `user_logs` VALUES (700, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:55:15');
INSERT INTO `user_logs` VALUES (701, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:55:15');
INSERT INTO `user_logs` VALUES (702, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 15:55:32');
INSERT INTO `user_logs` VALUES (703, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:55:37');
INSERT INTO `user_logs` VALUES (704, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 15:55:38');
INSERT INTO `user_logs` VALUES (705, 1, 'admin', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 admin 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-05-12 15:59:34');
INSERT INTO `user_logs` VALUES (706, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:59:37');
INSERT INTO `user_logs` VALUES (707, 1, 'admin', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 admin 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-05-12 15:59:46');
INSERT INTO `user_logs` VALUES (708, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-12 15:59:49');
INSERT INTO `user_logs` VALUES (709, 1, 'admin', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 admin 连接SSH服务器 内部服务(39.96.38.239)', '2025-05-12 16:00:09');
INSERT INTO `user_logs` VALUES (710, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 16:00:12');
INSERT INTO `user_logs` VALUES (711, 1, 'admin', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 admin 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-05-12 16:00:12');
INSERT INTO `user_logs` VALUES (712, 1, 'admin', 'disconnect', 25, 'uat-linux', '39.105.106.222', NULL, '用户 admin 断开Linux连接 uat-linux(39.105.106.222) [超时自动断开]', '2025-05-12 16:01:43');
INSERT INTO `user_logs` VALUES (713, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-13 09:40:43');
INSERT INTO `user_logs` VALUES (714, 1, 'admin', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 admin 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-05-13 09:41:07');
INSERT INTO `user_logs` VALUES (715, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-13 09:41:10');
INSERT INTO `user_logs` VALUES (716, 1, 'admin', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 admin 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-05-13 09:41:11');
INSERT INTO `user_logs` VALUES (717, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-13 10:00:56');
INSERT INTO `user_logs` VALUES (718, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-14 09:21:31');
INSERT INTO `user_logs` VALUES (719, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-14 10:47:25');
INSERT INTO `user_logs` VALUES (720, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-05-14 10:47:31');
INSERT INTO `user_logs` VALUES (721, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-05-14 10:49:26');
INSERT INTO `user_logs` VALUES (722, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-14 13:38:17');
INSERT INTO `user_logs` VALUES (723, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-14 13:38:53');
INSERT INTO `user_logs` VALUES (724, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-14 13:38:56');
INSERT INTO `user_logs` VALUES (725, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-05-14 13:39:48');
INSERT INTO `user_logs` VALUES (726, 1, 'admin', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', '59.110.28.130', '用户 admin 断开Windows连接 BIM服务器-2(59.110.28.130) [代理检测]', '2025-05-14 13:42:09');
INSERT INTO `user_logs` VALUES (727, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-14 13:42:16');
INSERT INTO `user_logs` VALUES (728, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-05-14 13:57:19');
INSERT INTO `user_logs` VALUES (729, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-14 14:04:13');
INSERT INTO `user_logs` VALUES (730, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-14 14:04:20');
INSERT INTO `user_logs` VALUES (731, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-14 14:04:24');
INSERT INTO `user_logs` VALUES (732, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-05-14 14:16:43');
INSERT INTO `user_logs` VALUES (733, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-05-14 14:16:49');
INSERT INTO `user_logs` VALUES (734, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-14 14:47:21');
INSERT INTO `user_logs` VALUES (735, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-05-14 14:47:27');
INSERT INTO `user_logs` VALUES (736, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-05-14 14:47:31');
INSERT INTO `user_logs` VALUES (737, 1, 'admin', 'disconnect', 14, '本地gitlab/知识库', '10.16.30.139', NULL, '用户 admin 断开Linux连接 本地gitlab/知识库(10.16.30.139) [超时自动断开]', '2025-05-14 15:02:32');
INSERT INTO `user_logs` VALUES (738, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-15 09:23:39');
INSERT INTO `user_logs` VALUES (739, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-15 10:59:05');
INSERT INTO `user_logs` VALUES (740, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-15 11:28:55');
INSERT INTO `user_logs` VALUES (741, NULL, 'chenziming', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 chenziming 登录系统', '2025-05-15 11:29:17');
INSERT INTO `user_logs` VALUES (742, NULL, 'chenziming', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 chenziming 注销系统', '2025-05-15 11:29:29');
INSERT INTO `user_logs` VALUES (743, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-15 11:29:42');
INSERT INTO `user_logs` VALUES (744, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-15 11:30:19');
INSERT INTO `user_logs` VALUES (745, 5, 'chenziming', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 chenziming 登录系统', '2025-05-15 11:30:26');
INSERT INTO `user_logs` VALUES (746, 5, 'chenziming', 'login', NULL, NULL, NULL, '10.16.30.59', '用户 chenziming 登录系统', '2025-05-15 11:30:34');
INSERT INTO `user_logs` VALUES (747, 5, 'chenziming', 'connect', 31, '中交测试环境', '10.16.30.109', '10.16.30.59', '用户 chenziming 连接RDP服务器 中交测试环境(10.16.30.109)', '2025-05-15 11:31:35');
INSERT INTO `user_logs` VALUES (748, 5, 'chenziming', 'disconnect', 31, '中交测试环境', '10.16.30.109', NULL, '用户 chenziming 断开Windows连接 中交测试环境(10.16.30.109) [超时自动断开]', '2025-05-15 11:46:38');
INSERT INTO `user_logs` VALUES (749, 5, 'chenziming', 'disconnect', 31, '中交测试环境', '10.16.30.109', NULL, '用户 chenziming 断开Windows连接 中交测试环境(10.16.30.109) [超时自动断开]', '2025-05-15 11:46:38');
INSERT INTO `user_logs` VALUES (750, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-16 13:06:03');
INSERT INTO `user_logs` VALUES (751, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-16 13:12:47');
INSERT INTO `user_logs` VALUES (752, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-16 13:20:48');
INSERT INTO `user_logs` VALUES (753, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-05-16 13:35:48');
INSERT INTO `user_logs` VALUES (754, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-16 14:18:49');
INSERT INTO `user_logs` VALUES (755, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-19 14:50:22');
INSERT INTO `user_logs` VALUES (756, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-19 14:50:35');
INSERT INTO `user_logs` VALUES (757, 1, 'admin', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 研发测试(10.16.30.172)', '2025-05-19 14:50:38');
INSERT INTO `user_logs` VALUES (758, 1, 'admin', 'disconnect', 23, '研发测试', '10.16.30.172', NULL, '用户 admin 断开Windows连接 研发测试(10.16.30.172) [超时自动断开]', '2025-05-19 15:05:40');
INSERT INTO `user_logs` VALUES (759, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 14:55:13');
INSERT INTO `user_logs` VALUES (760, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 15:06:54');
INSERT INTO `user_logs` VALUES (761, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-20 15:06:57');
INSERT INTO `user_logs` VALUES (762, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 15:10:55');
INSERT INTO `user_logs` VALUES (763, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 15:11:01');
INSERT INTO `user_logs` VALUES (764, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-05-20 15:21:59');
INSERT INTO `user_logs` VALUES (765, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 15:53:22');
INSERT INTO `user_logs` VALUES (766, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 16:17:00');
INSERT INTO `user_logs` VALUES (767, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 16:19:34');
INSERT INTO `user_logs` VALUES (768, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 16:19:58');
INSERT INTO `user_logs` VALUES (769, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 16:26:46');
INSERT INTO `user_logs` VALUES (770, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-20 16:28:28');
INSERT INTO `user_logs` VALUES (771, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-20 16:28:31');
INSERT INTO `user_logs` VALUES (772, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-20 16:29:04');
INSERT INTO `user_logs` VALUES (773, 1, 'admin', 'connect', NULL, '180', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 180(10.16.30.180)', '2025-05-20 16:29:14');
INSERT INTO `user_logs` VALUES (774, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-20 16:29:55');
INSERT INTO `user_logs` VALUES (775, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-20 16:30:42');
INSERT INTO `user_logs` VALUES (776, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-20 16:30:58');
INSERT INTO `user_logs` VALUES (777, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-20 16:31:30');
INSERT INTO `user_logs` VALUES (778, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-21 09:46:02');
INSERT INTO `user_logs` VALUES (779, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-21 13:07:20');
INSERT INTO `user_logs` VALUES (780, 1, 'admin', 'connect', NULL, '10.16.30.180', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.180(10.16.30.180)', '2025-05-21 13:07:39');
INSERT INTO `user_logs` VALUES (781, 1, 'admin', 'disconnect', NULL, '10.16.30.180', '10.16.30.180', NULL, '用户 admin 断开Windows连接 10.16.30.180(10.16.30.180) [超时自动断开]', '2025-05-21 13:22:41');
INSERT INTO `user_logs` VALUES (782, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-21 13:25:15');
INSERT INTO `user_logs` VALUES (783, 1, 'admin', 'connect', NULL, '10.16.30.180', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.180(10.16.30.180)', '2025-05-21 13:27:01');
INSERT INTO `user_logs` VALUES (784, 1, 'admin', 'connect', NULL, '10.16.30.180', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 10.16.30.180(10.16.30.180)', '2025-05-21 13:27:29');
INSERT INTO `user_logs` VALUES (785, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-21 13:28:55');
INSERT INTO `user_logs` VALUES (786, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-21 13:28:59');
INSERT INTO `user_logs` VALUES (787, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-21 13:29:46');
INSERT INTO `user_logs` VALUES (788, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-21 13:29:54');
INSERT INTO `user_logs` VALUES (789, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-21 13:30:14');
INSERT INTO `user_logs` VALUES (790, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-21 14:14:15');
INSERT INTO `user_logs` VALUES (791, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-26 09:37:43');
INSERT INTO `user_logs` VALUES (792, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-26 13:46:51');
INSERT INTO `user_logs` VALUES (793, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-26 14:38:12');
INSERT INTO `user_logs` VALUES (794, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-28 16:02:06');
INSERT INTO `user_logs` VALUES (795, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-28 16:02:08');
INSERT INTO `user_logs` VALUES (796, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-28 16:02:19');
INSERT INTO `user_logs` VALUES (797, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-28 16:02:22');
INSERT INTO `user_logs` VALUES (798, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-28 16:07:24');
INSERT INTO `user_logs` VALUES (799, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-28 16:08:23');
INSERT INTO `user_logs` VALUES (800, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-28 16:09:09');
INSERT INTO `user_logs` VALUES (801, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-28 16:42:08');
INSERT INTO `user_logs` VALUES (802, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-28 16:42:10');
INSERT INTO `user_logs` VALUES (803, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-28 16:50:50');
INSERT INTO `user_logs` VALUES (804, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-29 11:03:35');
INSERT INTO `user_logs` VALUES (805, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-29 11:03:37');
INSERT INTO `user_logs` VALUES (806, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-29 11:04:20');
INSERT INTO `user_logs` VALUES (807, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-29 13:23:46');
INSERT INTO `user_logs` VALUES (808, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-29 13:46:15');
INSERT INTO `user_logs` VALUES (809, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-29 13:48:01');
INSERT INTO `user_logs` VALUES (810, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-29 13:51:21');
INSERT INTO `user_logs` VALUES (811, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-29 13:52:37');
INSERT INTO `user_logs` VALUES (812, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-05-29 13:57:08');
INSERT INTO `user_logs` VALUES (813, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-05-29 13:57:37');
INSERT INTO `user_logs` VALUES (814, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 11:10:46');
INSERT INTO `user_logs` VALUES (815, 1, 'admin', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.133', '用户 admin 连接RDP服务器 研发测试(10.16.30.172)', '2025-05-30 11:10:53');
INSERT INTO `user_logs` VALUES (816, 1, 'admin', 'disconnect', 23, '研发测试', '10.16.30.172', NULL, '用户 admin 断开Windows连接 研发测试(10.16.30.172) [超时自动断开]', '2025-05-30 11:25:55');
INSERT INTO `user_logs` VALUES (817, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 13:01:48');
INSERT INTO `user_logs` VALUES (818, 1, 'admin', 'connect', NULL, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:01:59');
INSERT INTO `user_logs` VALUES (819, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-05-30 13:02:56');
INSERT INTO `user_logs` VALUES (820, 1, 'admin', 'connect', 8, '项目案例', '123.56.161.149', '10.16.30.133', '用户 admin 连接RDP服务器 项目案例(123.56.161.149)', '2025-05-30 13:03:04');
INSERT INTO `user_logs` VALUES (821, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-05-30 13:03:13');
INSERT INTO `user_logs` VALUES (822, 1, 'admin', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', '59.110.28.130', '用户 admin 断开Windows连接 BIM服务器-2(59.110.28.130) [代理检测]', '2025-05-30 13:06:16');
INSERT INTO `user_logs` VALUES (823, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-30 13:07:28');
INSERT INTO `user_logs` VALUES (824, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 13:08:17');
INSERT INTO `user_logs` VALUES (825, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-05-30 13:08:30');
INSERT INTO `user_logs` VALUES (826, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 登录系统', '2025-05-30 13:08:34');
INSERT INTO `user_logs` VALUES (827, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 13:09:00');
INSERT INTO `user_logs` VALUES (828, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:09:12');
INSERT INTO `user_logs` VALUES (829, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:09:16');
INSERT INTO `user_logs` VALUES (830, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-05-30 13:09:42');
INSERT INTO `user_logs` VALUES (831, 1, 'admin', 'connect', NULL, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:09:43');
INSERT INTO `user_logs` VALUES (832, 1, 'admin', 'connect', 8, '项目案例', '123.56.161.149', '10.16.30.133', '用户 admin 连接RDP服务器 项目案例(123.56.161.149)', '2025-05-30 13:09:59');
INSERT INTO `user_logs` VALUES (833, 1, 'admin', 'disconnect', 8, '项目案例', '123.56.161.149', '123.56.161.149', '用户 admin 断开Windows连接 项目案例(123.56.161.149) [代理检测]', '2025-05-30 13:10:35');
INSERT INTO `user_logs` VALUES (834, 1, 'admin', 'connect', 8, '项目案例', '123.56.161.149', '10.16.30.133', '用户 admin 连接RDP服务器 项目案例(123.56.161.149)', '2025-05-30 13:10:44');
INSERT INTO `user_logs` VALUES (835, 1, 'admin', 'connect', NULL, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:12:38');
INSERT INTO `user_logs` VALUES (836, 1, 'admin', 'disconnect', 8, '项目案例', '123.56.161.149', '123.56.161.149', '用户 admin 断开Windows连接 项目案例(123.56.161.149) [代理检测]', '2025-05-30 13:13:10');
INSERT INTO `user_logs` VALUES (837, 1, 'admin', 'connect', NULL, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:13:14');
INSERT INTO `user_logs` VALUES (838, 1, 'admin', 'connect', 35, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:15:14');
INSERT INTO `user_logs` VALUES (839, 1, 'admin', 'connect', 35, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:15:52');
INSERT INTO `user_logs` VALUES (840, 1, 'admin', 'connect', 35, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:15:55');
INSERT INTO `user_logs` VALUES (841, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-05-30 13:16:11');
INSERT INTO `user_logs` VALUES (842, 1, 'admin', 'connect', 35, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 admin 连接RDP服务器 Earth主站(60.205.201.247)', '2025-05-30 13:16:43');
INSERT INTO `user_logs` VALUES (843, 1, 'admin', 'disconnect', 35, 'Earth主站', '60.205.201.247', '60.205.201.247', '用户 admin 断开Windows连接 Earth主站(60.205.201.247) [代理检测]', '2025-05-30 13:20:04');
INSERT INTO `user_logs` VALUES (844, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-05-30 13:20:22');
INSERT INTO `user_logs` VALUES (845, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhangshujun 注销系统', '2025-05-30 13:21:31');
INSERT INTO `user_logs` VALUES (846, 6, 'sunyj', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 sunyj 登录系统', '2025-05-30 13:21:35');
INSERT INTO `user_logs` VALUES (847, 6, 'sunyj', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 sunyj 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:21:38');
INSERT INTO `user_logs` VALUES (848, 6, 'sunyj', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 sunyj 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:21:43');
INSERT INTO `user_logs` VALUES (849, 6, 'sunyj', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 sunyj 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-05-30 13:21:57');
INSERT INTO `user_logs` VALUES (850, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:24:43');
INSERT INTO `user_logs` VALUES (851, 3, 'zhangshujun', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-05-30 13:24:59');
INSERT INTO `user_logs` VALUES (852, 6, 'sunyj', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 sunyj 注销系统', '2025-05-30 13:25:06');
INSERT INTO `user_logs` VALUES (853, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 13:25:11');
INSERT INTO `user_logs` VALUES (854, 3, 'zhangshujun', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 zhangshujun 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-05-30 13:25:13');
INSERT INTO `user_logs` VALUES (855, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:25:21');
INSERT INTO `user_logs` VALUES (856, 1, 'admin', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-05-30 13:29:05');
INSERT INTO `user_logs` VALUES (857, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-05-30 13:40:23');
INSERT INTO `user_logs` VALUES (858, 1, 'admin', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', NULL, '用户 admin 断开Windows连接 BIM服务器-1(8.140.152.230) [超时自动断开]', '2025-05-30 13:44:06');
INSERT INTO `user_logs` VALUES (859, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 13:50:50');
INSERT INTO `user_logs` VALUES (860, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 13:50:56');
INSERT INTO `user_logs` VALUES (861, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-05-30 14:05:57');
INSERT INTO `user_logs` VALUES (862, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-05-30 14:41:22');
INSERT INTO `user_logs` VALUES (863, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 14:41:26');
INSERT INTO `user_logs` VALUES (864, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-05-30 14:46:19');
INSERT INTO `user_logs` VALUES (865, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 14:46:27');
INSERT INTO `user_logs` VALUES (866, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-05-30 14:46:29');
INSERT INTO `user_logs` VALUES (867, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 14:46:34');
INSERT INTO `user_logs` VALUES (868, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-05-30 14:46:38');
INSERT INTO `user_logs` VALUES (869, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-05-30 14:46:38');
INSERT INTO `user_logs` VALUES (870, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-05-30 14:49:26');
INSERT INTO `user_logs` VALUES (871, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 14:49:33');
INSERT INTO `user_logs` VALUES (872, 3, 'zhangshujun', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 数据中心(10.16.30.168)', '2025-05-30 14:49:50');
INSERT INTO `user_logs` VALUES (873, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-05-30 14:52:37');
INSERT INTO `user_logs` VALUES (874, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-05-30 14:52:57');
INSERT INTO `user_logs` VALUES (875, 3, 'zhangshujun', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhangshujun 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-05-30 14:55:05');
INSERT INTO `user_logs` VALUES (876, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-05-30 15:07:58');
INSERT INTO `user_logs` VALUES (877, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 08:58:50');
INSERT INTO `user_logs` VALUES (878, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 08:59:19');
INSERT INTO `user_logs` VALUES (879, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 09:00:00');
INSERT INTO `user_logs` VALUES (880, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-03 09:13:09');
INSERT INTO `user_logs` VALUES (881, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 09:13:12');
INSERT INTO `user_logs` VALUES (882, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 09:13:20');
INSERT INTO `user_logs` VALUES (883, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 09:14:55');
INSERT INTO `user_logs` VALUES (884, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 10:34:12');
INSERT INTO `user_logs` VALUES (885, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-03 10:43:54');
INSERT INTO `user_logs` VALUES (886, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 10:44:45');
INSERT INTO `user_logs` VALUES (887, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 10:45:02');
INSERT INTO `user_logs` VALUES (888, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 11:00:02');
INSERT INTO `user_logs` VALUES (889, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 11:55:39');
INSERT INTO `user_logs` VALUES (890, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 11:55:42');
INSERT INTO `user_logs` VALUES (891, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 12:08:12');
INSERT INTO `user_logs` VALUES (892, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-03 12:10:11');
INSERT INTO `user_logs` VALUES (893, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-06-03 12:10:16');
INSERT INTO `user_logs` VALUES (894, 1, 'admin', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 admin 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-06-03 12:10:36');
INSERT INTO `user_logs` VALUES (895, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 12:15:19');
INSERT INTO `user_logs` VALUES (896, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 12:15:31');
INSERT INTO `user_logs` VALUES (897, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 12:30:32');
INSERT INTO `user_logs` VALUES (898, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-03 13:04:37');
INSERT INTO `user_logs` VALUES (899, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 13:04:59');
INSERT INTO `user_logs` VALUES (900, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-03 13:20:01');
INSERT INTO `user_logs` VALUES (901, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 13:22:22');
INSERT INTO `user_logs` VALUES (902, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 13:34:32');
INSERT INTO `user_logs` VALUES (903, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 13:34:32');
INSERT INTO `user_logs` VALUES (904, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 13:34:33');
INSERT INTO `user_logs` VALUES (905, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 13:34:54');
INSERT INTO `user_logs` VALUES (906, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 13:35:00');
INSERT INTO `user_logs` VALUES (907, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 13:35:01');
INSERT INTO `user_logs` VALUES (908, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 13:35:06');
INSERT INTO `user_logs` VALUES (909, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 13:47:32');
INSERT INTO `user_logs` VALUES (910, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 13:48:20');
INSERT INTO `user_logs` VALUES (911, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 14:02:37');
INSERT INTO `user_logs` VALUES (912, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:10:53');
INSERT INTO `user_logs` VALUES (913, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:11:03');
INSERT INTO `user_logs` VALUES (914, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 14:12:45');
INSERT INTO `user_logs` VALUES (915, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:32:17');
INSERT INTO `user_logs` VALUES (916, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:32:24');
INSERT INTO `user_logs` VALUES (917, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:32:32');
INSERT INTO `user_logs` VALUES (918, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:32:41');
INSERT INTO `user_logs` VALUES (919, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-03 14:32:50');
INSERT INTO `user_logs` VALUES (920, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 14:33:08');
INSERT INTO `user_logs` VALUES (921, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 14:33:10');
INSERT INTO `user_logs` VALUES (922, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 14:48:13');
INSERT INTO `user_logs` VALUES (923, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 15:48:05');
INSERT INTO `user_logs` VALUES (924, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 15:48:08');
INSERT INTO `user_logs` VALUES (925, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 16:03:11');
INSERT INTO `user_logs` VALUES (926, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 16:07:39');
INSERT INTO `user_logs` VALUES (927, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-03 16:14:22');
INSERT INTO `user_logs` VALUES (928, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-03 16:34:34');
INSERT INTO `user_logs` VALUES (929, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-03 16:34:36');
INSERT INTO `user_logs` VALUES (930, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-06-03 16:36:51');
INSERT INTO `user_logs` VALUES (931, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-03 16:37:15');
INSERT INTO `user_logs` VALUES (932, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-06-03 16:39:11');
INSERT INTO `user_logs` VALUES (933, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-03 16:39:13');
INSERT INTO `user_logs` VALUES (934, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-06-03 16:39:21');
INSERT INTO `user_logs` VALUES (935, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 16:40:17');
INSERT INTO `user_logs` VALUES (936, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-03 16:42:12');
INSERT INTO `user_logs` VALUES (937, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-03 16:42:57');
INSERT INTO `user_logs` VALUES (938, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 16:43:20');
INSERT INTO `user_logs` VALUES (939, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-03 16:43:25');
INSERT INTO `user_logs` VALUES (940, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-03 16:43:42');
INSERT INTO `user_logs` VALUES (941, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 16:45:27');
INSERT INTO `user_logs` VALUES (942, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-03 16:45:32');
INSERT INTO `user_logs` VALUES (943, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-03 17:00:33');
INSERT INTO `user_logs` VALUES (944, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 17:02:45');
INSERT INTO `user_logs` VALUES (945, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-03 17:07:32');
INSERT INTO `user_logs` VALUES (946, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 17:07:36');
INSERT INTO `user_logs` VALUES (947, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 17:07:41');
INSERT INTO `user_logs` VALUES (948, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 17:07:43');
INSERT INTO `user_logs` VALUES (949, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 17:07:44');
INSERT INTO `user_logs` VALUES (950, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 17:07:49');
INSERT INTO `user_logs` VALUES (951, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [监控自动检测]', '2025-06-03 17:07:51');
INSERT INTO `user_logs` VALUES (952, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-03 17:08:04');
INSERT INTO `user_logs` VALUES (953, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-03 17:23:07');
INSERT INTO `user_logs` VALUES (954, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 09:27:21');
INSERT INTO `user_logs` VALUES (955, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 09:27:29');
INSERT INTO `user_logs` VALUES (956, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 09:27:32');
INSERT INTO `user_logs` VALUES (957, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 09:27:35');
INSERT INTO `user_logs` VALUES (958, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 09:37:27');
INSERT INTO `user_logs` VALUES (959, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 09:38:24');
INSERT INTO `user_logs` VALUES (960, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 09:38:29');
INSERT INTO `user_logs` VALUES (961, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-04 09:53:30');
INSERT INTO `user_logs` VALUES (962, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 10:39:57');
INSERT INTO `user_logs` VALUES (963, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-04 10:40:17');
INSERT INTO `user_logs` VALUES (964, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 10:40:22');
INSERT INTO `user_logs` VALUES (965, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 11:29:13');
INSERT INTO `user_logs` VALUES (966, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 11:29:16');
INSERT INTO `user_logs` VALUES (967, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 11:29:19');
INSERT INTO `user_logs` VALUES (968, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 11:29:21');
INSERT INTO `user_logs` VALUES (969, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 11:29:43');
INSERT INTO `user_logs` VALUES (970, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:02:49');
INSERT INTO `user_logs` VALUES (971, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 13:03:21');
INSERT INTO `user_logs` VALUES (972, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-04 13:06:28');
INSERT INTO `user_logs` VALUES (973, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-06-04 13:07:12');
INSERT INTO `user_logs` VALUES (974, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 13:07:19');
INSERT INTO `user_logs` VALUES (975, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-04 13:07:20');
INSERT INTO `user_logs` VALUES (976, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-06-04 13:07:21');
INSERT INTO `user_logs` VALUES (977, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:07:28');
INSERT INTO `user_logs` VALUES (978, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-04 13:07:41');
INSERT INTO `user_logs` VALUES (979, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:07:44');
INSERT INTO `user_logs` VALUES (980, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-04 13:07:47');
INSERT INTO `user_logs` VALUES (981, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:07:51');
INSERT INTO `user_logs` VALUES (982, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 13:07:51');
INSERT INTO `user_logs` VALUES (983, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-06-04 13:07:54');
INSERT INTO `user_logs` VALUES (984, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-06-04 13:08:37');
INSERT INTO `user_logs` VALUES (985, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:08:44');
INSERT INTO `user_logs` VALUES (986, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:09:59');
INSERT INTO `user_logs` VALUES (987, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 13:10:26');
INSERT INTO `user_logs` VALUES (988, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-06-04 13:21:30');
INSERT INTO `user_logs` VALUES (989, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-06-04 13:21:30');
INSERT INTO `user_logs` VALUES (990, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-04 13:25:27');
INSERT INTO `user_logs` VALUES (991, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 13:28:54');
INSERT INTO `user_logs` VALUES (992, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 13:28:56');
INSERT INTO `user_logs` VALUES (993, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 13:29:01');
INSERT INTO `user_logs` VALUES (994, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-04 13:44:05');
INSERT INTO `user_logs` VALUES (995, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 13:53:44');
INSERT INTO `user_logs` VALUES (996, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-04 13:54:48');
INSERT INTO `user_logs` VALUES (997, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-04 13:56:10');
INSERT INTO `user_logs` VALUES (998, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 13:56:43');
INSERT INTO `user_logs` VALUES (999, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 14:05:17');
INSERT INTO `user_logs` VALUES (1000, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 14:08:00');
INSERT INTO `user_logs` VALUES (1001, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 14:24:22');
INSERT INTO `user_logs` VALUES (1002, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 14:24:56');
INSERT INTO `user_logs` VALUES (1003, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 14:44:04');
INSERT INTO `user_logs` VALUES (1004, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 14:44:16');
INSERT INTO `user_logs` VALUES (1005, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 14:58:36');
INSERT INTO `user_logs` VALUES (1006, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 15:52:06');
INSERT INTO `user_logs` VALUES (1007, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-04 15:52:19');
INSERT INTO `user_logs` VALUES (1008, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 15:52:45');
INSERT INTO `user_logs` VALUES (1009, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-04 15:55:40');
INSERT INTO `user_logs` VALUES (1010, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 16:25:10');
INSERT INTO `user_logs` VALUES (1011, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 16:35:38');
INSERT INTO `user_logs` VALUES (1012, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 16:36:28');
INSERT INTO `user_logs` VALUES (1013, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 17:31:56');
INSERT INTO `user_logs` VALUES (1014, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-04 17:33:10');
INSERT INTO `user_logs` VALUES (1015, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-04 20:16:03');
INSERT INTO `user_logs` VALUES (1016, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-04 20:16:07');
INSERT INTO `user_logs` VALUES (1017, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-04 20:31:10');
INSERT INTO `user_logs` VALUES (1018, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-04 21:13:45');
INSERT INTO `user_logs` VALUES (1019, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-06-04 21:13:49');
INSERT INTO `user_logs` VALUES (1020, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-06-04 21:28:51');
INSERT INTO `user_logs` VALUES (1021, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 08:55:56');
INSERT INTO `user_logs` VALUES (1022, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 08:56:12');
INSERT INTO `user_logs` VALUES (1023, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 08:56:18');
INSERT INTO `user_logs` VALUES (1024, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-05 09:11:19');
INSERT INTO `user_logs` VALUES (1025, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-05 09:24:37');
INSERT INTO `user_logs` VALUES (1026, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 09:25:06');
INSERT INTO `user_logs` VALUES (1027, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.133', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 09:26:03');
INSERT INTO `user_logs` VALUES (1028, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-05 09:26:24');
INSERT INTO `user_logs` VALUES (1029, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 09:39:55');
INSERT INTO `user_logs` VALUES (1030, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 09:39:58');
INSERT INTO `user_logs` VALUES (1031, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-05 09:55:00');
INSERT INTO `user_logs` VALUES (1032, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 11:15:33');
INSERT INTO `user_logs` VALUES (1033, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 12:59:42');
INSERT INTO `user_logs` VALUES (1034, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 14:16:04');
INSERT INTO `user_logs` VALUES (1035, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-05 14:44:36');
INSERT INTO `user_logs` VALUES (1036, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-06-05 14:45:02');
INSERT INTO `user_logs` VALUES (1037, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 gaof 登录系统', '2025-06-05 14:45:06');
INSERT INTO `user_logs` VALUES (1038, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.147', '用户 gaof 登录系统', '2025-06-05 14:48:24');
INSERT INTO `user_logs` VALUES (1039, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-05 14:54:10');
INSERT INTO `user_logs` VALUES (1040, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.8', '用户 gaof 登录系统', '2025-06-05 15:13:30');
INSERT INTO `user_logs` VALUES (1041, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 15:27:10');
INSERT INTO `user_logs` VALUES (1042, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-05 15:32:52');
INSERT INTO `user_logs` VALUES (1043, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-05 15:32:53');
INSERT INTO `user_logs` VALUES (1044, 7, 'gaof', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.147', '用户 gaof 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-05 15:43:56');
INSERT INTO `user_logs` VALUES (1045, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-06-05 15:47:56');
INSERT INTO `user_logs` VALUES (1046, 7, 'gaof', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 gaof 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-05 15:58:58');
INSERT INTO `user_logs` VALUES (1047, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.147', '用户 gaof 登录系统', '2025-06-05 17:02:20');
INSERT INTO `user_logs` VALUES (1048, 7, 'gaof', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.147', '用户 gaof 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-05 17:02:22');
INSERT INTO `user_logs` VALUES (1049, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-05 17:09:12');
INSERT INTO `user_logs` VALUES (1050, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.8', '用户 gaof 登录系统', '2025-06-05 17:09:44');
INSERT INTO `user_logs` VALUES (1051, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-05 17:37:12');
INSERT INTO `user_logs` VALUES (1052, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-05 17:37:36');
INSERT INTO `user_logs` VALUES (1053, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-05 17:52:37');
INSERT INTO `user_logs` VALUES (1054, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-06 09:05:38');
INSERT INTO `user_logs` VALUES (1055, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-06 09:38:06');
INSERT INTO `user_logs` VALUES (1056, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-06 13:02:33');
INSERT INTO `user_logs` VALUES (1057, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-06 14:23:30');
INSERT INTO `user_logs` VALUES (1058, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-06 16:11:14');
INSERT INTO `user_logs` VALUES (1059, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-06 16:11:17');
INSERT INTO `user_logs` VALUES (1060, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-06 16:11:20');
INSERT INTO `user_logs` VALUES (1061, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-06 16:26:22');
INSERT INTO `user_logs` VALUES (1062, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-06 17:00:22');
INSERT INTO `user_logs` VALUES (1063, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-06 17:00:59');
INSERT INTO `user_logs` VALUES (1064, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-06 17:02:15');
INSERT INTO `user_logs` VALUES (1065, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-08 10:33:37');
INSERT INTO `user_logs` VALUES (1066, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-06-08 10:33:41');
INSERT INTO `user_logs` VALUES (1067, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-06-08 10:48:41');
INSERT INTO `user_logs` VALUES (1068, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-09 08:49:51');
INSERT INTO `user_logs` VALUES (1069, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-09 10:33:21');
INSERT INTO `user_logs` VALUES (1070, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-09 17:36:47');
INSERT INTO `user_logs` VALUES (1071, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-09 17:36:58');
INSERT INTO `user_logs` VALUES (1072, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-09 17:51:58');
INSERT INTO `user_logs` VALUES (1073, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 09:01:31');
INSERT INTO `user_logs` VALUES (1074, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-10 09:35:31');
INSERT INTO `user_logs` VALUES (1075, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-10 09:36:16');
INSERT INTO `user_logs` VALUES (1076, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-10 09:41:36');
INSERT INTO `user_logs` VALUES (1077, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-10 09:56:38');
INSERT INTO `user_logs` VALUES (1078, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 10:38:42');
INSERT INTO `user_logs` VALUES (1079, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 12:06:16');
INSERT INTO `user_logs` VALUES (1080, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-10 12:06:18');
INSERT INTO `user_logs` VALUES (1081, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-10 12:11:49');
INSERT INTO `user_logs` VALUES (1082, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 13:00:51');
INSERT INTO `user_logs` VALUES (1083, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 14:42:46');
INSERT INTO `user_logs` VALUES (1084, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 15:31:33');
INSERT INTO `user_logs` VALUES (1085, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-10 15:48:25');
INSERT INTO `user_logs` VALUES (1086, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-06-10 15:58:24');
INSERT INTO `user_logs` VALUES (1087, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-06-10 15:58:25');
INSERT INTO `user_logs` VALUES (1088, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-10 17:39:29');
INSERT INTO `user_logs` VALUES (1089, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-11 09:33:27');
INSERT INTO `user_logs` VALUES (1090, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-11 10:41:58');
INSERT INTO `user_logs` VALUES (1091, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-11 13:41:37');
INSERT INTO `user_logs` VALUES (1092, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-11 13:41:39');
INSERT INTO `user_logs` VALUES (1093, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-11 13:48:49');
INSERT INTO `user_logs` VALUES (1094, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-11 14:28:00');
INSERT INTO `user_logs` VALUES (1095, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-11 14:44:11');
INSERT INTO `user_logs` VALUES (1096, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-11 14:44:50');
INSERT INTO `user_logs` VALUES (1097, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-11 16:47:26');
INSERT INTO `user_logs` VALUES (1098, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-11 16:47:29');
INSERT INTO `user_logs` VALUES (1099, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-11 16:47:35');
INSERT INTO `user_logs` VALUES (1100, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-11 16:47:52');
INSERT INTO `user_logs` VALUES (1101, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-11 17:40:29');
INSERT INTO `user_logs` VALUES (1102, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-11 17:47:28');
INSERT INTO `user_logs` VALUES (1103, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 08:54:43');
INSERT INTO `user_logs` VALUES (1104, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 08:55:03');
INSERT INTO `user_logs` VALUES (1105, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-13 08:55:54');
INSERT INTO `user_logs` VALUES (1106, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 10:29:16');
INSERT INTO `user_logs` VALUES (1107, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 10:29:26');
INSERT INTO `user_logs` VALUES (1108, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-13 10:44:29');
INSERT INTO `user_logs` VALUES (1109, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 13:14:11');
INSERT INTO `user_logs` VALUES (1110, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 13:14:15');
INSERT INTO `user_logs` VALUES (1111, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-13 13:14:29');
INSERT INTO `user_logs` VALUES (1112, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 15:28:57');
INSERT INTO `user_logs` VALUES (1113, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 16:10:40');
INSERT INTO `user_logs` VALUES (1114, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 16:10:43');
INSERT INTO `user_logs` VALUES (1115, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 16:10:48');
INSERT INTO `user_logs` VALUES (1116, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 16:10:52');
INSERT INTO `user_logs` VALUES (1117, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-13 16:25:54');
INSERT INTO `user_logs` VALUES (1118, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-13 17:39:02');
INSERT INTO `user_logs` VALUES (1119, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-13 17:39:04');
INSERT INTO `user_logs` VALUES (1120, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-13 17:54:05');
INSERT INTO `user_logs` VALUES (1121, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.147', '用户 gaof 登录系统', '2025-06-14 16:35:07');
INSERT INTO `user_logs` VALUES (1122, 7, 'gaof', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.147', '用户 gaof 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-14 16:35:09');
INSERT INTO `user_logs` VALUES (1123, 7, 'gaof', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 gaof 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-14 16:50:09');
INSERT INTO `user_logs` VALUES (1124, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-16 08:56:15');
INSERT INTO `user_logs` VALUES (1125, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-16 13:18:07');
INSERT INTO `user_logs` VALUES (1126, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-16 13:18:10');
INSERT INTO `user_logs` VALUES (1127, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-16 13:20:36');
INSERT INTO `user_logs` VALUES (1128, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-16 16:30:01');
INSERT INTO `user_logs` VALUES (1129, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-16 16:30:17');
INSERT INTO `user_logs` VALUES (1130, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-16 16:30:20');
INSERT INTO `user_logs` VALUES (1131, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-16 16:33:00');
INSERT INTO `user_logs` VALUES (1132, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-16 16:41:09');
INSERT INTO `user_logs` VALUES (1133, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-16 16:56:09');
INSERT INTO `user_logs` VALUES (1134, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-17 09:04:46');
INSERT INTO `user_logs` VALUES (1135, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.147', '用户 gaof 登录系统', '2025-06-17 09:14:46');
INSERT INTO `user_logs` VALUES (1136, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.147', '用户 gaof 登录系统', '2025-06-17 09:16:11');
INSERT INTO `user_logs` VALUES (1137, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-17 10:12:24');
INSERT INTO `user_logs` VALUES (1138, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-17 10:52:16');
INSERT INTO `user_logs` VALUES (1139, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-17 10:54:59');
INSERT INTO `user_logs` VALUES (1140, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-17 11:16:54');
INSERT INTO `user_logs` VALUES (1141, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-17 11:31:56');
INSERT INTO `user_logs` VALUES (1142, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-17 12:19:53');
INSERT INTO `user_logs` VALUES (1143, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-17 13:52:32');
INSERT INTO `user_logs` VALUES (1144, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-17 14:28:36');
INSERT INTO `user_logs` VALUES (1145, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-17 14:44:42');
INSERT INTO `user_logs` VALUES (1146, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-17 14:44:47');
INSERT INTO `user_logs` VALUES (1147, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-17 14:59:50');
INSERT INTO `user_logs` VALUES (1148, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-18 09:42:57');
INSERT INTO `user_logs` VALUES (1149, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-18 09:43:32');
INSERT INTO `user_logs` VALUES (1150, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-18 09:58:10');
INSERT INTO `user_logs` VALUES (1151, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-23 09:11:53');
INSERT INTO `user_logs` VALUES (1152, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-23 09:11:59');
INSERT INTO `user_logs` VALUES (1153, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-06-23 09:13:52');
INSERT INTO `user_logs` VALUES (1154, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 09:46:09');
INSERT INTO `user_logs` VALUES (1155, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-23 09:46:33');
INSERT INTO `user_logs` VALUES (1156, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 09:52:19');
INSERT INTO `user_logs` VALUES (1157, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-23 09:59:38');
INSERT INTO `user_logs` VALUES (1158, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 10:27:43');
INSERT INTO `user_logs` VALUES (1159, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 10:27:47');
INSERT INTO `user_logs` VALUES (1160, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 10:27:54');
INSERT INTO `user_logs` VALUES (1161, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-23 10:27:58');
INSERT INTO `user_logs` VALUES (1162, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-23 10:43:02');
INSERT INTO `user_logs` VALUES (1163, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-23 13:38:33');
INSERT INTO `user_logs` VALUES (1164, 1, 'admin', 'connect', NULL, '测试服务器', '10.16.30.6', '10.16.30.235', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-06-23 13:39:43');
INSERT INTO `user_logs` VALUES (1165, 1, 'admin', 'disconnect', NULL, '测试服务器', '10.16.30.6', NULL, '用户 admin 断开Windows连接 测试服务器(10.16.30.6) [超时自动断开]', '2025-06-23 13:54:44');
INSERT INTO `user_logs` VALUES (1166, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-24 09:36:26');
INSERT INTO `user_logs` VALUES (1167, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-24 09:38:15');
INSERT INTO `user_logs` VALUES (1168, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.235', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-24 09:42:14');
INSERT INTO `user_logs` VALUES (1169, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-24 09:50:29');
INSERT INTO `user_logs` VALUES (1170, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-24 09:51:48');
INSERT INTO `user_logs` VALUES (1171, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-24 09:52:28');
INSERT INTO `user_logs` VALUES (1172, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [监控自动检测]', '2025-06-24 09:52:32');
INSERT INTO `user_logs` VALUES (1173, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-24 09:52:54');
INSERT INTO `user_logs` VALUES (1174, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [监控自动检测]', '2025-06-24 09:52:59');
INSERT INTO `user_logs` VALUES (1175, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [监控自动检测]', '2025-06-24 09:52:59');
INSERT INTO `user_logs` VALUES (1176, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-24 09:53:28');
INSERT INTO `user_logs` VALUES (1177, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-24 09:54:51');
INSERT INTO `user_logs` VALUES (1178, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-06-24 09:57:15');
INSERT INTO `user_logs` VALUES (1179, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.180', '用户 admin 登录系统', '2025-06-24 10:01:12');
INSERT INTO `user_logs` VALUES (1180, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-24 10:15:03');
INSERT INTO `user_logs` VALUES (1181, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-24 10:18:31');
INSERT INTO `user_logs` VALUES (1182, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-24 10:33:35');
INSERT INTO `user_logs` VALUES (1183, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-24 10:55:23');
INSERT INTO `user_logs` VALUES (1184, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-24 11:10:25');
INSERT INTO `user_logs` VALUES (1185, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-24 13:13:47');
INSERT INTO `user_logs` VALUES (1186, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-06-24 13:13:51');
INSERT INTO `user_logs` VALUES (1187, 8, 'jingchen', 'disconnect', 23, '研发测试', '10.16.30.172', NULL, '用户 jingchen 断开Windows连接 研发测试(10.16.30.172) [超时自动断开]', '2025-06-24 13:28:53');
INSERT INTO `user_logs` VALUES (1188, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-24 13:51:23');
INSERT INTO `user_logs` VALUES (1189, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-24 13:51:26');
INSERT INTO `user_logs` VALUES (1190, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-24 13:52:43');
INSERT INTO `user_logs` VALUES (1191, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 13:52:45');
INSERT INTO `user_logs` VALUES (1192, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 13:52:49');
INSERT INTO `user_logs` VALUES (1193, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 13:52:53');
INSERT INTO `user_logs` VALUES (1194, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-24 13:58:28');
INSERT INTO `user_logs` VALUES (1195, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-24 14:07:55');
INSERT INTO `user_logs` VALUES (1196, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-24 14:07:55');
INSERT INTO `user_logs` VALUES (1197, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 16:04:29');
INSERT INTO `user_logs` VALUES (1198, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 16:04:34');
INSERT INTO `user_logs` VALUES (1199, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 16:04:38');
INSERT INTO `user_logs` VALUES (1200, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-24 16:19:42');
INSERT INTO `user_logs` VALUES (1201, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-24 16:46:34');
INSERT INTO `user_logs` VALUES (1202, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-24 16:46:38');
INSERT INTO `user_logs` VALUES (1203, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-24 16:47:54');
INSERT INTO `user_logs` VALUES (1204, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-24 16:58:42');
INSERT INTO `user_logs` VALUES (1205, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-24 17:19:26');
INSERT INTO `user_logs` VALUES (1206, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.235', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-24 17:35:58');
INSERT INTO `user_logs` VALUES (1207, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-06-24 17:40:47');
INSERT INTO `user_logs` VALUES (1208, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-24 17:43:18');
INSERT INTO `user_logs` VALUES (1209, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-24 17:44:30');
INSERT INTO `user_logs` VALUES (1210, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 08:57:00');
INSERT INTO `user_logs` VALUES (1211, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 09:01:26');
INSERT INTO `user_logs` VALUES (1212, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-25 09:16:27');
INSERT INTO `user_logs` VALUES (1213, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-25 09:43:21');
INSERT INTO `user_logs` VALUES (1214, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.235', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 09:43:25');
INSERT INTO `user_logs` VALUES (1215, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-25 09:58:27');
INSERT INTO `user_logs` VALUES (1216, 3, 'zhangshujun', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-06-25 10:08:46');
INSERT INTO `user_logs` VALUES (1217, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:08:55');
INSERT INTO `user_logs` VALUES (1218, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:08:59');
INSERT INTO `user_logs` VALUES (1219, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.235', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-25 10:09:03');
INSERT INTO `user_logs` VALUES (1220, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:09:04');
INSERT INTO `user_logs` VALUES (1221, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:09:08');
INSERT INTO `user_logs` VALUES (1222, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-25 10:10:02');
INSERT INTO `user_logs` VALUES (1223, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [监控自动检测]', '2025-06-25 10:10:04');
INSERT INTO `user_logs` VALUES (1224, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-25 10:10:04');
INSERT INTO `user_logs` VALUES (1225, 1, 'admin', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.235', '用户 admin 连接RDP服务器 研发测试(10.16.30.172)', '2025-06-25 10:13:48');
INSERT INTO `user_logs` VALUES (1226, 1, 'admin', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.235', '用户 admin 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:14:47');
INSERT INTO `user_logs` VALUES (1227, 3, 'zhangshujun', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', NULL, '用户 zhangshujun 断开Windows连接 BIM服务器-1(8.140.152.230) [超时自动断开]', '2025-06-25 10:23:50');
INSERT INTO `user_logs` VALUES (1228, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-25 10:25:06');
INSERT INTO `user_logs` VALUES (1229, 1, 'admin', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 admin 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-25 10:26:49');
INSERT INTO `user_logs` VALUES (1230, 1, 'admin', 'disconnect', 23, '研发测试', '10.16.30.172', NULL, '用户 admin 断开Windows连接 研发测试(10.16.30.172) [超时自动断开]', '2025-06-25 10:28:52');
INSERT INTO `user_logs` VALUES (1231, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:29:05');
INSERT INTO `user_logs` VALUES (1232, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-25 10:29:09');
INSERT INTO `user_logs` VALUES (1233, 1, 'admin', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.235', '用户 admin 连接RDP服务器 刀片机(10.16.30.24)', '2025-06-25 10:29:10');
INSERT INTO `user_logs` VALUES (1234, 1, 'admin', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.235', '用户 admin 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-06-25 10:31:02');
INSERT INTO `user_logs` VALUES (1235, 1, 'admin', 'disconnect', 17, '测试环境-1', '10.16.30.161', '10.16.30.161', '用户 admin 断开Windows连接 测试环境-1(10.16.30.161) [代理检测]', '2025-06-25 10:31:07');
INSERT INTO `user_logs` VALUES (1236, 1, 'admin', 'connect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.235', '用户 admin 连接RDP服务器 图新云GIS开发联调环境-1(10.16.30.27)', '2025-06-25 10:31:51');
INSERT INTO `user_logs` VALUES (1237, 1, 'admin', 'disconnect', 16, '图新云GIS开发联调环境-1', '10.16.30.27', '10.16.30.27', '用户 admin 断开Windows连接 图新云GIS开发联调环境-1(10.16.30.27) [代理检测]', '2025-06-25 10:32:53');
INSERT INTO `user_logs` VALUES (1238, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-25 10:44:09');
INSERT INTO `user_logs` VALUES (1239, 1, 'admin', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-06-25 10:44:13');
INSERT INTO `user_logs` VALUES (1240, 1, 'admin', 'connect', 39, '黄河源测试环境', '10.16.30.100', '10.16.30.235', '用户 admin 连接RDP服务器 黄河源测试环境(10.16.30.100)', '2025-06-25 11:14:45');
INSERT INTO `user_logs` VALUES (1241, 1, 'admin', 'connect', NULL, '测试服务器', '10.16.30.6', '10.16.30.235', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-06-25 11:15:08');
INSERT INTO `user_logs` VALUES (1242, 1, 'admin', 'connect', 31, '中交测试环境', '10.16.30.109', '10.16.30.235', '用户 admin 连接RDP服务器 中交测试环境(10.16.30.109)', '2025-06-25 11:15:16');
INSERT INTO `user_logs` VALUES (1243, 1, 'admin', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.235', '用户 admin 连接RDP服务器 研发测试(10.16.30.172)', '2025-06-25 11:15:36');
INSERT INTO `user_logs` VALUES (1244, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.235', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-06-25 11:16:57');
INSERT INTO `user_logs` VALUES (1245, 1, 'admin', 'disconnect', 23, '研发测试', '10.16.30.172', '10.16.30.172', '用户 admin 断开Windows连接 研发测试(10.16.30.172) [代理检测]', '2025-06-25 11:18:34');
INSERT INTO `user_logs` VALUES (1246, 1, 'admin', 'disconnect', 31, '中交测试环境', '10.16.30.109', '10.16.30.109', '用户 admin 断开Windows连接 中交测试环境(10.16.30.109) [代理检测]', '2025-06-25 11:19:57');
INSERT INTO `user_logs` VALUES (1247, 1, 'admin', 'connect', 39, '黄河源测试环境', '10.16.30.100', '10.16.30.235', '用户 admin 连接RDP服务器 黄河源测试环境(10.16.30.100)', '2025-06-25 11:20:10');
INSERT INTO `user_logs` VALUES (1248, 1, 'admin', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 admin 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-06-25 11:24:11');
INSERT INTO `user_logs` VALUES (1249, 1, 'admin', 'disconnect', 39, '黄河源测试环境', '10.16.30.100', '10.16.30.100', '用户 admin 断开Windows连接 黄河源测试环境(10.16.30.100) [代理检测]', '2025-06-25 11:27:36');
INSERT INTO `user_logs` VALUES (1250, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-25 11:27:39');
INSERT INTO `user_logs` VALUES (1251, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-25 11:28:45');
INSERT INTO `user_logs` VALUES (1252, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-25 11:29:05');
INSERT INTO `user_logs` VALUES (1253, 1, 'admin', 'disconnect', NULL, '测试服务器', '10.16.30.6', NULL, '用户 admin 断开Windows连接 测试服务器(10.16.30.6) [超时自动断开]', '2025-06-25 11:30:11');
INSERT INTO `user_logs` VALUES (1254, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 12:49:55');
INSERT INTO `user_logs` VALUES (1255, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 13:45:19');
INSERT INTO `user_logs` VALUES (1256, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-25 14:10:38');
INSERT INTO `user_logs` VALUES (1257, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.235', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-25 14:10:42');
INSERT INTO `user_logs` VALUES (1258, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-06-25 14:25:43');
INSERT INTO `user_logs` VALUES (1259, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 16:10:41');
INSERT INTO `user_logs` VALUES (1260, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 16:54:04');
INSERT INTO `user_logs` VALUES (1261, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-25 18:38:08');
INSERT INTO `user_logs` VALUES (1262, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-26 08:57:44');
INSERT INTO `user_logs` VALUES (1263, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-26 09:11:02');
INSERT INTO `user_logs` VALUES (1264, 1, 'admin', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.235', '用户 admin 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-06-26 09:11:04');
INSERT INTO `user_logs` VALUES (1265, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-26 09:12:22');
INSERT INTO `user_logs` VALUES (1266, 1, 'admin', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.235', '用户 admin 连接RDP服务器 刀片机(10.16.30.24)', '2025-06-26 09:12:36');
INSERT INTO `user_logs` VALUES (1267, 1, 'admin', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', NULL, '用户 admin 断开Windows连接 BIM服务器-1(8.140.152.230) [超时自动断开]', '2025-06-26 09:26:04');
INSERT INTO `user_logs` VALUES (1268, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-06-26 09:27:24');
INSERT INTO `user_logs` VALUES (1269, 1, 'admin', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-06-26 09:27:39');
INSERT INTO `user_logs` VALUES (1270, 1, 'admin', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.235', '用户 admin 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-06-26 09:33:31');
INSERT INTO `user_logs` VALUES (1271, 1, 'admin', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', NULL, '用户 admin 断开Windows连接 BIM服务器-3(10.16.30.171) [监控自动检测]', '2025-06-26 09:33:37');
INSERT INTO `user_logs` VALUES (1272, 1, 'admin', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', NULL, '用户 admin 断开Windows连接 BIM服务器-3(10.16.30.171) [监控自动检测]', '2025-06-26 09:33:38');
INSERT INTO `user_logs` VALUES (1273, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-26 09:48:19');
INSERT INTO `user_logs` VALUES (1274, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-06-26 09:48:22');
INSERT INTO `user_logs` VALUES (1275, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-26 09:48:25');
INSERT INTO `user_logs` VALUES (1276, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-26 09:51:14');
INSERT INTO `user_logs` VALUES (1277, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-26 10:03:08');
INSERT INTO `user_logs` VALUES (1278, 8, 'jingchen', 'disconnect', 23, '研发测试', '10.16.30.172', NULL, '用户 jingchen 断开Windows连接 研发测试(10.16.30.172) [超时自动断开]', '2025-06-26 10:03:22');
INSERT INTO `user_logs` VALUES (1279, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-26 10:03:56');
INSERT INTO `user_logs` VALUES (1280, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.235', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-06-26 10:17:13');
INSERT INTO `user_logs` VALUES (1281, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-06-26 10:19:53');
INSERT INTO `user_logs` VALUES (1282, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-26 13:00:01');
INSERT INTO `user_logs` VALUES (1283, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.235', '用户 admin 登录系统', '2025-06-26 13:04:55');
INSERT INTO `user_logs` VALUES (1284, 1, 'admin', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.235', '用户 admin 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-06-26 13:05:07');
INSERT INTO `user_logs` VALUES (1285, 1, 'admin', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.235', '用户 admin 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-26 13:05:19');
INSERT INTO `user_logs` VALUES (1286, 1, 'admin', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.171', '用户 admin 断开Windows连接 BIM服务器-3(10.16.30.171) [代理检测]', '2025-06-26 13:07:02');
INSERT INTO `user_logs` VALUES (1287, 1, 'admin', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 admin 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-26 13:07:10');
INSERT INTO `user_logs` VALUES (1288, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-26 13:10:35');
INSERT INTO `user_logs` VALUES (1289, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-26 13:10:38');
INSERT INTO `user_logs` VALUES (1290, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.235', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-26 13:18:44');
INSERT INTO `user_logs` VALUES (1291, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', NULL, '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [超时自动断开]', '2025-06-26 13:33:48');
INSERT INTO `user_logs` VALUES (1292, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-26 13:40:32');
INSERT INTO `user_logs` VALUES (1293, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-26 13:43:26');
INSERT INTO `user_logs` VALUES (1294, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-26 16:00:22');
INSERT INTO `user_logs` VALUES (1295, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-26 16:19:55');
INSERT INTO `user_logs` VALUES (1296, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-26 16:19:58');
INSERT INTO `user_logs` VALUES (1297, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-26 16:35:00');
INSERT INTO `user_logs` VALUES (1298, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-26 16:35:00');
INSERT INTO `user_logs` VALUES (1299, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-26 17:39:04');
INSERT INTO `user_logs` VALUES (1300, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-26 17:39:06');
INSERT INTO `user_logs` VALUES (1301, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-26 17:39:10');
INSERT INTO `user_logs` VALUES (1302, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-26 17:39:13');
INSERT INTO `user_logs` VALUES (1303, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-26 17:41:08');
INSERT INTO `user_logs` VALUES (1304, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-27 09:01:11');
INSERT INTO `user_logs` VALUES (1305, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:26');
INSERT INTO `user_logs` VALUES (1306, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:30');
INSERT INTO `user_logs` VALUES (1307, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:38');
INSERT INTO `user_logs` VALUES (1308, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:42');
INSERT INTO `user_logs` VALUES (1309, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:46');
INSERT INTO `user_logs` VALUES (1310, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:49');
INSERT INTO `user_logs` VALUES (1311, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 09:01:53');
INSERT INTO `user_logs` VALUES (1312, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-06-27 09:02:44');
INSERT INTO `user_logs` VALUES (1313, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-27 10:11:26');
INSERT INTO `user_logs` VALUES (1314, 1, 'admin', 'connect', NULL, 'Mongodb服务器', '47.93.183.174', '10.16.30.133', '用户 admin 连接SSH服务器 Mongodb服务器(47.93.183.174)', '2025-06-27 10:36:07');
INSERT INTO `user_logs` VALUES (1315, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:36:11');
INSERT INTO `user_logs` VALUES (1316, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:36:13');
INSERT INTO `user_logs` VALUES (1317, 1, 'admin', 'connect', NULL, 'Mongodb服务器', '47.93.183.174', '10.16.30.133', '用户 admin 连接SSH服务器 Mongodb服务器(47.93.183.174)', '2025-06-27 10:36:32');
INSERT INTO `user_logs` VALUES (1318, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:36:36');
INSERT INTO `user_logs` VALUES (1319, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:36:39');
INSERT INTO `user_logs` VALUES (1320, 1, 'admin', 'connect', NULL, 'Mongodb服务器', '47.93.183.174', '10.16.30.133', '用户 admin 连接SSH服务器 Mongodb服务器(47.93.183.174)', '2025-06-27 10:37:06');
INSERT INTO `user_logs` VALUES (1321, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:37:09');
INSERT INTO `user_logs` VALUES (1322, 1, 'admin', 'disconnect', NULL, 'Mongodb服务器', '47.93.183.174', NULL, '用户 admin 断开Linux连接 Mongodb服务器(47.93.183.174) [监控自动检测]', '2025-06-27 10:37:12');
INSERT INTO `user_logs` VALUES (1323, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-27 13:41:39');
INSERT INTO `user_logs` VALUES (1324, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-27 13:42:00');
INSERT INTO `user_logs` VALUES (1325, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-27 13:42:08');
INSERT INTO `user_logs` VALUES (1326, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-06-27 13:57:11');
INSERT INTO `user_logs` VALUES (1327, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-06-27 17:24:35');
INSERT INTO `user_logs` VALUES (1328, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:37');
INSERT INTO `user_logs` VALUES (1329, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:40');
INSERT INTO `user_logs` VALUES (1330, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:45');
INSERT INTO `user_logs` VALUES (1331, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:49');
INSERT INTO `user_logs` VALUES (1332, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:52');
INSERT INTO `user_logs` VALUES (1333, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:24:56');
INSERT INTO `user_logs` VALUES (1334, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-06-27 17:25:00');
INSERT INTO `user_logs` VALUES (1335, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-06-27 17:40:01');
INSERT INTO `user_logs` VALUES (1336, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-30 09:12:01');
INSERT INTO `user_logs` VALUES (1337, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-30 09:12:05');
INSERT INTO `user_logs` VALUES (1338, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-06-30 09:27:07');
INSERT INTO `user_logs` VALUES (1339, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-30 09:56:54');
INSERT INTO `user_logs` VALUES (1340, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-30 13:09:09');
INSERT INTO `user_logs` VALUES (1341, 1, 'admin', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.24)', '2025-06-30 13:10:11');
INSERT INTO `user_logs` VALUES (1342, 1, 'admin', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 admin 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-06-30 13:25:14');
INSERT INTO `user_logs` VALUES (1343, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-06-30 14:00:39');
INSERT INTO `user_logs` VALUES (1344, 1, 'admin', 'connect', NULL, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:13:48');
INSERT INTO `user_logs` VALUES (1345, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-30 14:19:30');
INSERT INTO `user_logs` VALUES (1346, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [代理检测]', '2025-06-30 14:20:11');
INSERT INTO `user_logs` VALUES (1347, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-30 14:20:16');
INSERT INTO `user_logs` VALUES (1348, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-30 14:20:24');
INSERT INTO `user_logs` VALUES (1349, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [代理检测]', '2025-06-30 14:22:55');
INSERT INTO `user_logs` VALUES (1350, 1, 'admin', 'connect', NULL, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:23:11');
INSERT INTO `user_logs` VALUES (1351, 1, 'admin', 'connect', NULL, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:24:29');
INSERT INTO `user_logs` VALUES (1352, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:24:57');
INSERT INTO `user_logs` VALUES (1353, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:25:21');
INSERT INTO `user_logs` VALUES (1354, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:25:35');
INSERT INTO `user_logs` VALUES (1355, 1, 'admin', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.24)', '2025-06-30 14:26:33');
INSERT INTO `user_logs` VALUES (1356, 1, 'admin', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 admin 连接RDP服务器 刀片机(10.16.30.24)', '2025-06-30 14:27:55');
INSERT INTO `user_logs` VALUES (1357, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-30 14:29:32');
INSERT INTO `user_logs` VALUES (1358, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-06-30 14:30:04');
INSERT INTO `user_logs` VALUES (1359, 1, 'admin', 'disconnect', 38, '刀片机', '10.16.30.24', '10.16.30.24', '用户 admin 断开Windows连接 刀片机(10.16.30.24) [代理检测]', '2025-06-30 14:36:21');
INSERT INTO `user_logs` VALUES (1360, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:36:29');
INSERT INTO `user_logs` VALUES (1361, 1, 'admin', 'disconnect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.191', '用户 admin 断开Linux连接 docker镜像管理(10.16.30.191) [代理检测]', '2025-06-30 14:38:56');
INSERT INTO `user_logs` VALUES (1362, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-06-30 14:39:07');
INSERT INTO `user_logs` VALUES (1363, 1, 'admin', 'disconnect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.191', '用户 admin 断开Linux连接 docker镜像管理(10.16.30.191) [代理检测]', '2025-06-30 14:39:18');
INSERT INTO `user_logs` VALUES (1364, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-30 14:41:05');
INSERT INTO `user_logs` VALUES (1365, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [代理检测]', '2025-06-30 14:42:17');
INSERT INTO `user_logs` VALUES (1366, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-06-30 14:42:19');
INSERT INTO `user_logs` VALUES (1367, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.193', '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [代理检测]', '2025-06-30 14:42:33');
INSERT INTO `user_logs` VALUES (1368, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-30 14:42:39');
INSERT INTO `user_logs` VALUES (1369, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-06-30 14:43:21');
INSERT INTO `user_logs` VALUES (1370, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-06-30 14:43:53');
INSERT INTO `user_logs` VALUES (1371, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-06-30 14:44:00');
INSERT INTO `user_logs` VALUES (1372, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-06-30 14:44:02');
INSERT INTO `user_logs` VALUES (1373, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-06-30 14:46:25');
INSERT INTO `user_logs` VALUES (1374, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-06-30 14:46:31');
INSERT INTO `user_logs` VALUES (1375, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-06-30 14:46:39');
INSERT INTO `user_logs` VALUES (1376, 1, 'admin', 'connect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.133', '用户 admin 连接SSH服务器 本地gitlab/知识库(10.16.30.139)', '2025-06-30 14:47:41');
INSERT INTO `user_logs` VALUES (1377, 1, 'admin', 'disconnect', 14, '本地gitlab/知识库', '10.16.30.139', '10.16.30.139', '用户 admin 断开Linux连接 本地gitlab/知识库(10.16.30.139) [代理检测]', '2025-06-30 14:48:24');
INSERT INTO `user_logs` VALUES (1378, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-06-30 14:55:51');
INSERT INTO `user_logs` VALUES (1379, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-30 14:55:54');
INSERT INTO `user_logs` VALUES (1380, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-06-30 14:56:04');
INSERT INTO `user_logs` VALUES (1381, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-06-30 14:57:15');
INSERT INTO `user_logs` VALUES (1382, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-06-30 15:55:20');
INSERT INTO `user_logs` VALUES (1383, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-06-30 15:57:35');
INSERT INTO `user_logs` VALUES (1384, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 09:31:07');
INSERT INTO `user_logs` VALUES (1385, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 10:02:25');
INSERT INTO `user_logs` VALUES (1386, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 13:09:37');
INSERT INTO `user_logs` VALUES (1387, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 14:01:21');
INSERT INTO `user_logs` VALUES (1388, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-01 14:34:13');
INSERT INTO `user_logs` VALUES (1389, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:15');
INSERT INTO `user_logs` VALUES (1390, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:19');
INSERT INTO `user_logs` VALUES (1391, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:22');
INSERT INTO `user_logs` VALUES (1392, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:26');
INSERT INTO `user_logs` VALUES (1393, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:29');
INSERT INTO `user_logs` VALUES (1394, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:32');
INSERT INTO `user_logs` VALUES (1395, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:35');
INSERT INTO `user_logs` VALUES (1396, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:38');
INSERT INTO `user_logs` VALUES (1397, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:34:42');
INSERT INTO `user_logs` VALUES (1398, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-01 14:35:44');
INSERT INTO `user_logs` VALUES (1399, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 14:37:57');
INSERT INTO `user_logs` VALUES (1400, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-01 14:48:10');
INSERT INTO `user_logs` VALUES (1401, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-01 14:55:35');
INSERT INTO `user_logs` VALUES (1402, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-01 16:17:43');
INSERT INTO `user_logs` VALUES (1403, 1, 'admin', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 admin 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-07-01 16:17:48');
INSERT INTO `user_logs` VALUES (1404, 1, 'admin', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', NULL, '用户 admin 断开Linux连接 夜莺监控服务器(10.16.30.193) [超时自动断开]', '2025-07-01 16:32:51');
INSERT INTO `user_logs` VALUES (1405, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-01 17:30:37');
INSERT INTO `user_logs` VALUES (1406, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-07-01 17:30:44');
INSERT INTO `user_logs` VALUES (1407, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-01 17:31:01');
INSERT INTO `user_logs` VALUES (1408, 3, 'zhangshujun', 'logout', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 注销系统', '2025-07-01 17:31:09');
INSERT INTO `user_logs` VALUES (1409, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-01 17:31:11');
INSERT INTO `user_logs` VALUES (1410, 3, 'zhangshujun', 'connect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.44', '用户 zhangshujun 连接SSH服务器 本地Kylin10(10.16.30.56)', '2025-07-01 17:31:44');
INSERT INTO `user_logs` VALUES (1411, 3, 'zhangshujun', 'connect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.44', '用户 zhangshujun 连接SSH服务器 本地Kylin10(10.16.30.56)', '2025-07-01 17:31:47');
INSERT INTO `user_logs` VALUES (1412, 3, 'zhangshujun', 'disconnect', 21, '本地Kylin10', '10.16.30.56', NULL, '用户 zhangshujun 断开Linux连接 本地Kylin10(10.16.30.56) [超时自动断开]', '2025-07-01 17:46:51');
INSERT INTO `user_logs` VALUES (1413, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 08:56:05');
INSERT INTO `user_logs` VALUES (1414, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 08:57:20');
INSERT INTO `user_logs` VALUES (1415, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 08:57:25');
INSERT INTO `user_logs` VALUES (1416, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-02 09:12:28');
INSERT INTO `user_logs` VALUES (1417, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-02 09:15:21');
INSERT INTO `user_logs` VALUES (1418, 1, 'admin', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 admin 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-07-02 09:15:24');
INSERT INTO `user_logs` VALUES (1419, 1, 'admin', 'disconnect', 43, 'docker镜像管理', '10.16.30.191', NULL, '用户 admin 断开Linux连接 docker镜像管理(10.16.30.191) [超时自动断开]', '2025-07-02 09:30:26');
INSERT INTO `user_logs` VALUES (1420, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 10:04:26');
INSERT INTO `user_logs` VALUES (1421, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 10:10:22');
INSERT INTO `user_logs` VALUES (1422, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-02 10:22:50');
INSERT INTO `user_logs` VALUES (1423, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-02 10:25:22');
INSERT INTO `user_logs` VALUES (1424, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-02 10:30:45');
INSERT INTO `user_logs` VALUES (1425, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-02 10:30:54');
INSERT INTO `user_logs` VALUES (1426, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-02 10:44:22');
INSERT INTO `user_logs` VALUES (1427, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-02 10:44:26');
INSERT INTO `user_logs` VALUES (1428, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 10:44:28');
INSERT INTO `user_logs` VALUES (1429, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-02 10:44:37');
INSERT INTO `user_logs` VALUES (1430, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-02 10:55:23');
INSERT INTO `user_logs` VALUES (1431, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-07-02 10:58:53');
INSERT INTO `user_logs` VALUES (1432, 5, 'chenziming', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 chenziming 登录系统', '2025-07-02 10:59:05');
INSERT INTO `user_logs` VALUES (1433, 5, 'chenziming', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 chenziming 注销系统', '2025-07-02 10:59:12');
INSERT INTO `user_logs` VALUES (1434, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-02 10:59:35');
INSERT INTO `user_logs` VALUES (1435, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-02 10:59:42');
INSERT INTO `user_logs` VALUES (1436, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 11:26:21');
INSERT INTO `user_logs` VALUES (1437, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 14:21:58');
INSERT INTO `user_logs` VALUES (1438, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 14:43:50');
INSERT INTO `user_logs` VALUES (1439, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 14:43:55');
INSERT INTO `user_logs` VALUES (1440, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 14:43:58');
INSERT INTO `user_logs` VALUES (1441, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-02 14:44:01');
INSERT INTO `user_logs` VALUES (1442, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-02 14:59:01');
INSERT INTO `user_logs` VALUES (1443, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-02 17:07:16');
INSERT INTO `user_logs` VALUES (1444, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-02 17:21:33');
INSERT INTO `user_logs` VALUES (1445, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-07-02 17:21:53');
INSERT INTO `user_logs` VALUES (1446, 8, 'jingchen', 'disconnect', 23, '研发测试', '10.16.30.172', '10.16.30.172', '用户 jingchen 断开Windows连接 研发测试(10.16.30.172) [代理检测]', '2025-07-02 17:21:57');
INSERT INTO `user_logs` VALUES (1447, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-02 17:21:58');
INSERT INTO `user_logs` VALUES (1448, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-02 17:22:09');
INSERT INTO `user_logs` VALUES (1449, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-02 17:23:04');
INSERT INTO `user_logs` VALUES (1450, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 09:50:01');
INSERT INTO `user_logs` VALUES (1451, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-03 09:50:09');
INSERT INTO `user_logs` VALUES (1452, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-03 09:50:16');
INSERT INTO `user_logs` VALUES (1453, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-03 09:50:29');
INSERT INTO `user_logs` VALUES (1454, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-03 09:51:01');
INSERT INTO `user_logs` VALUES (1455, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-03 09:51:18');
INSERT INTO `user_logs` VALUES (1456, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-03 09:52:04');
INSERT INTO `user_logs` VALUES (1457, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-03 09:52:16');
INSERT INTO `user_logs` VALUES (1458, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-03 09:53:20');
INSERT INTO `user_logs` VALUES (1459, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-03 09:53:35');
INSERT INTO `user_logs` VALUES (1460, 1, 'admin', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 admin 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-03 09:53:39');
INSERT INTO `user_logs` VALUES (1461, 1, 'admin', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 admin 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-03 09:53:57');
INSERT INTO `user_logs` VALUES (1462, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 10:31:38');
INSERT INTO `user_logs` VALUES (1463, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-03 10:51:10');
INSERT INTO `user_logs` VALUES (1464, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-03 11:05:37');
INSERT INTO `user_logs` VALUES (1465, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-03 11:05:44');
INSERT INTO `user_logs` VALUES (1466, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-07-03 11:06:10');
INSERT INTO `user_logs` VALUES (1467, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-03 11:06:48');
INSERT INTO `user_logs` VALUES (1468, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 13:15:36');
INSERT INTO `user_logs` VALUES (1469, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-03 13:36:48');
INSERT INTO `user_logs` VALUES (1470, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-03 13:36:54');
INSERT INTO `user_logs` VALUES (1471, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-03 13:38:34');
INSERT INTO `user_logs` VALUES (1472, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-03 13:47:36');
INSERT INTO `user_logs` VALUES (1473, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-03 13:47:54');
INSERT INTO `user_logs` VALUES (1474, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-03 14:02:57');
INSERT INTO `user_logs` VALUES (1475, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-03 14:03:09');
INSERT INTO `user_logs` VALUES (1476, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-03 14:18:09');
INSERT INTO `user_logs` VALUES (1477, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 14:49:07');
INSERT INTO `user_logs` VALUES (1478, 1, 'admin', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 admin 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-03 14:49:10');
INSERT INTO `user_logs` VALUES (1479, 1, 'admin', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 admin 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-03 15:04:11');
INSERT INTO `user_logs` VALUES (1480, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 15:49:59');
INSERT INTO `user_logs` VALUES (1481, 1, 'admin', 'connect', NULL, '测试服务器', '10.16.30.6', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-03 15:53:13');
INSERT INTO `user_logs` VALUES (1482, 1, 'admin', 'connect', NULL, '测试服务器', '10.16.30.6', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-03 15:53:17');
INSERT INTO `user_logs` VALUES (1483, 1, 'admin', 'connect', 45, '测试服务器', '10.16.30.6', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-03 15:53:39');
INSERT INTO `user_logs` VALUES (1484, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-03 15:57:18');
INSERT INTO `user_logs` VALUES (1485, 8, 'jingchen', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-03 15:57:26');
INSERT INTO `user_logs` VALUES (1486, 8, 'jingchen', 'logout', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 注销系统', '2025-07-03 15:58:55');
INSERT INTO `user_logs` VALUES (1487, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-03 15:58:56');
INSERT INTO `user_logs` VALUES (1488, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-07-03 15:59:06');
INSERT INTO `user_logs` VALUES (1489, 8, 'jingchen', 'disconnect', 23, '研发测试', '10.16.30.172', '10.16.30.172', '用户 jingchen 断开Windows连接 研发测试(10.16.30.172) [代理检测]', '2025-07-03 16:00:23');
INSERT INTO `user_logs` VALUES (1490, 1, 'admin', 'disconnect', 45, '测试服务器', '10.16.30.6', NULL, '用户 admin 断开Windows连接 测试服务器(10.16.30.6) [超时自动断开]', '2025-07-03 16:08:42');
INSERT INTO `user_logs` VALUES (1491, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-03 16:10:10');
INSERT INTO `user_logs` VALUES (1492, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-03 16:12:25');
INSERT INTO `user_logs` VALUES (1493, 8, 'jingchen', 'disconnect', 44, '测试服务器', '10.16.30.53', NULL, '用户 jingchen 断开Windows连接 测试服务器(10.16.30.53) [超时自动断开]', '2025-07-03 16:12:28');
INSERT INTO `user_logs` VALUES (1494, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 16:17:00');
INSERT INTO `user_logs` VALUES (1495, 1, 'admin', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-03 16:17:22');
INSERT INTO `user_logs` VALUES (1496, 1, 'admin', 'connect', 39, '黄河源测试环境', '10.16.30.100', '10.16.30.133', '用户 admin 连接RDP服务器 黄河源测试环境(10.16.30.100)', '2025-07-03 16:17:27');
INSERT INTO `user_logs` VALUES (1497, 1, 'admin', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-03 16:17:38');
INSERT INTO `user_logs` VALUES (1498, 1, 'admin', 'connect', 45, '测试服务器', '10.16.30.6', '10.16.30.133', '用户 admin 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-03 16:22:07');
INSERT INTO `user_logs` VALUES (1499, 1, 'admin', 'disconnect', 45, '测试服务器', '10.16.30.6', '10.16.30.6', '用户 admin 断开Windows连接 测试服务器(10.16.30.6) [代理检测]', '2025-07-03 16:23:31');
INSERT INTO `user_logs` VALUES (1500, 1, 'admin', 'disconnect', 39, '黄河源测试环境', '10.16.30.100', '10.16.30.100', '用户 admin 断开Windows连接 黄河源测试环境(10.16.30.100) [代理检测]', '2025-07-03 16:23:43');
INSERT INTO `user_logs` VALUES (1501, 1, 'admin', 'disconnect', 44, '测试服务器', '10.16.30.53', '10.16.30.53', '用户 admin 断开Windows连接 测试服务器(10.16.30.53) [代理检测]', '2025-07-03 16:23:58');
INSERT INTO `user_logs` VALUES (1502, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 16:31:10');
INSERT INTO `user_logs` VALUES (1503, 1, 'admin', 'connect', 46, '黑苹果', '10.16.30.166', '10.16.30.133', '用户 admin 连接RDP服务器 黑苹果(10.16.30.166)', '2025-07-03 16:33:35');
INSERT INTO `user_logs` VALUES (1504, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-03 16:34:05');
INSERT INTO `user_logs` VALUES (1505, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-03 16:34:44');
INSERT INTO `user_logs` VALUES (1506, 1, 'admin', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 admin 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-03 16:35:02');
INSERT INTO `user_logs` VALUES (1507, 1, 'admin', 'disconnect', 46, '黑苹果', '10.16.30.166', '10.16.30.166', '用户 admin 断开Windows连接 黑苹果(10.16.30.166) [代理检测]', '2025-07-03 16:37:03');
INSERT INTO `user_logs` VALUES (1508, 1, 'admin', 'connect', 47, '数据生产', '10.16.30.167', '10.16.30.133', '用户 admin 连接RDP服务器 数据生产(10.16.30.167)', '2025-07-03 16:38:14');
INSERT INTO `user_logs` VALUES (1509, 1, 'admin', 'connect', 47, '数据生产', '10.16.30.167', '10.16.30.133', '用户 admin 连接RDP服务器 数据生产(10.16.30.167)', '2025-07-03 16:40:12');
INSERT INTO `user_logs` VALUES (1510, 1, 'admin', 'disconnect', 47, '数据生产', '10.16.30.167', '10.16.30.167', '用户 admin 断开Windows连接 数据生产(10.16.30.167) [代理检测]', '2025-07-03 16:49:48');
INSERT INTO `user_logs` VALUES (1511, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 16:50:44');
INSERT INTO `user_logs` VALUES (1512, 1, 'admin', 'connect', 48, '技术支持中心', '10.16.30.170', '10.16.30.133', '用户 admin 连接RDP服务器 技术支持中心(10.16.30.170)', '2025-07-03 16:51:39');
INSERT INTO `user_logs` VALUES (1513, 1, 'admin', 'connect', 48, '技术支持中心', '10.16.30.170', '10.16.30.133', '用户 admin 连接RDP服务器 技术支持中心(10.16.30.170)', '2025-07-03 16:52:26');
INSERT INTO `user_logs` VALUES (1514, 1, 'admin', 'connect', 48, '技术支持中心', '10.16.30.170', '10.16.30.133', '用户 admin 连接RDP服务器 技术支持中心(10.16.30.170)', '2025-07-03 16:54:35');
INSERT INTO `user_logs` VALUES (1515, 1, 'admin', 'disconnect', 48, '技术支持中心', '10.16.30.170', '10.16.30.170', '用户 admin 断开Windows连接 技术支持中心(10.16.30.170) [代理检测]', '2025-07-03 16:56:20');
INSERT INTO `user_logs` VALUES (1516, 1, 'admin', 'connect', 49, '技术支持中心', '10.16.30.226', '10.16.30.133', '用户 admin 连接RDP服务器 技术支持中心(10.16.30.226)', '2025-07-03 16:56:56');
INSERT INTO `user_logs` VALUES (1517, 1, 'admin', 'disconnect', 49, '技术支持中心', '10.16.30.226', '10.16.30.226', '用户 admin 断开Windows连接 技术支持中心(10.16.30.226) [代理检测]', '2025-07-03 16:57:57');
INSERT INTO `user_logs` VALUES (1518, 1, 'admin', 'connect', 50, '技术支持中心', '10.16.30.228', '10.16.30.133', '用户 admin 连接RDP服务器 技术支持中心(10.16.30.228)', '2025-07-03 16:58:26');
INSERT INTO `user_logs` VALUES (1519, 1, 'admin', 'disconnect', 50, '技术支持中心', '10.16.30.228', '10.16.30.228', '用户 admin 断开Windows连接 技术支持中心(10.16.30.228) [代理检测]', '2025-07-03 16:59:59');
INSERT INTO `user_logs` VALUES (1520, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-07-03 17:02:13');
INSERT INTO `user_logs` VALUES (1521, 9, 'zhaoyy', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhaoyy 登录系统', '2025-07-03 17:02:18');
INSERT INTO `user_logs` VALUES (1522, 9, 'zhaoyy', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhaoyy 注销系统', '2025-07-03 17:02:29');
INSERT INTO `user_logs` VALUES (1523, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-03 17:02:59');
INSERT INTO `user_logs` VALUES (1524, 9, 'zhaoyy', 'login', NULL, NULL, NULL, '10.16.30.17', '用户 zhaoyy 登录系统', '2025-07-03 17:03:48');
INSERT INTO `user_logs` VALUES (1525, 9, 'zhaoyy', 'connect', 47, '数据生产', '10.16.30.167', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 数据生产(10.16.30.167)', '2025-07-03 17:08:28');
INSERT INTO `user_logs` VALUES (1526, 9, 'zhaoyy', 'connect', 47, '数据生产', '10.16.30.167', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 数据生产(10.16.30.167)', '2025-07-03 17:08:52');
INSERT INTO `user_logs` VALUES (1527, 9, 'zhaoyy', 'disconnect', 47, '数据生产', '10.16.30.167', '10.16.30.167', '用户 zhaoyy 断开Windows连接 数据生产(10.16.30.167) [代理检测]', '2025-07-03 17:09:34');
INSERT INTO `user_logs` VALUES (1528, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-07-03 17:09:45');
INSERT INTO `user_logs` VALUES (1529, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-03 17:09:50');
INSERT INTO `user_logs` VALUES (1530, 9, 'zhaoyy', 'login', NULL, NULL, NULL, '10.16.30.17', '用户 zhaoyy 登录系统', '2025-07-03 17:14:36');
INSERT INTO `user_logs` VALUES (1531, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-04 08:46:17');
INSERT INTO `user_logs` VALUES (1532, 8, 'jingchen', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-04 08:46:21');
INSERT INTO `user_logs` VALUES (1533, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 09:00:37');
INSERT INTO `user_logs` VALUES (1534, 8, 'jingchen', 'disconnect', 44, '测试服务器', '10.16.30.53', NULL, '用户 jingchen 断开Windows连接 测试服务器(10.16.30.53) [超时自动断开]', '2025-07-04 09:01:25');
INSERT INTO `user_logs` VALUES (1535, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 09:47:03');
INSERT INTO `user_logs` VALUES (1536, 1, 'admin', 'login', NULL, NULL, NULL, '127.0.0.1', '用户 admin 登录系统', '2025-07-04 10:03:53');
INSERT INTO `user_logs` VALUES (1537, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 10:17:26');
INSERT INTO `user_logs` VALUES (1538, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 10:28:30');
INSERT INTO `user_logs` VALUES (1539, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-04 10:28:31');
INSERT INTO `user_logs` VALUES (1540, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-04 10:32:44');
INSERT INTO `user_logs` VALUES (1541, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 10:40:48');
INSERT INTO `user_logs` VALUES (1542, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 10:41:23');
INSERT INTO `user_logs` VALUES (1543, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 10:42:20');
INSERT INTO `user_logs` VALUES (1544, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 11:02:04');
INSERT INTO `user_logs` VALUES (1545, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-04 11:15:42');
INSERT INTO `user_logs` VALUES (1546, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-04 11:16:58');
INSERT INTO `user_logs` VALUES (1547, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-04 11:17:01');
INSERT INTO `user_logs` VALUES (1548, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-04 11:17:02');
INSERT INTO `user_logs` VALUES (1549, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-04 11:17:14');
INSERT INTO `user_logs` VALUES (1550, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-04 11:17:17');
INSERT INTO `user_logs` VALUES (1551, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-04 11:22:04');
INSERT INTO `user_logs` VALUES (1552, 1, 'admin', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 admin 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-04 11:22:05');
INSERT INTO `user_logs` VALUES (1553, 1, 'admin', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 admin 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-04 11:22:27');
INSERT INTO `user_logs` VALUES (1554, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-04 11:24:20');
INSERT INTO `user_logs` VALUES (1555, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-04 11:25:04');
INSERT INTO `user_logs` VALUES (1556, 1, 'admin', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 admin 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-04 11:26:54');
INSERT INTO `user_logs` VALUES (1557, 1, 'admin', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 admin 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-04 11:28:00');
INSERT INTO `user_logs` VALUES (1558, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 13:01:48');
INSERT INTO `user_logs` VALUES (1559, 10, 'zhuyiqing', 'connect', 50, '技术支持中心', '10.16.30.228', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 技术支持中心(10.16.30.228)', '2025-07-04 13:05:51');
INSERT INTO `user_logs` VALUES (1560, 10, 'zhuyiqing', 'disconnect', 50, '技术支持中心', '10.16.30.228', '10.16.30.228', '用户 zhuyiqing 断开Windows连接 技术支持中心(10.16.30.228) [代理检测]', '2025-07-04 13:07:01');
INSERT INTO `user_logs` VALUES (1561, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-04 13:09:07');
INSERT INTO `user_logs` VALUES (1562, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-04 13:09:13');
INSERT INTO `user_logs` VALUES (1563, 10, 'zhuyiqing', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-07-04 13:12:22');
INSERT INTO `user_logs` VALUES (1564, 10, 'zhuyiqing', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', '59.110.28.130', '用户 zhuyiqing 断开Windows连接 BIM服务器-2(59.110.28.130) [代理检测]', '2025-07-04 13:13:21');
INSERT INTO `user_logs` VALUES (1565, 10, 'zhuyiqing', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-07-04 13:13:22');
INSERT INTO `user_logs` VALUES (1566, 10, 'zhuyiqing', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-07-04 13:14:16');
INSERT INTO `user_logs` VALUES (1567, 10, 'zhuyiqing', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhuyiqing 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-04 13:14:20');
INSERT INTO `user_logs` VALUES (1568, 10, 'zhuyiqing', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 zhuyiqing 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-07-04 13:14:26');
INSERT INTO `user_logs` VALUES (1569, 10, 'zhuyiqing', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-07-04 13:20:31');
INSERT INTO `user_logs` VALUES (1570, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:20:36');
INSERT INTO `user_logs` VALUES (1571, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:20:37');
INSERT INTO `user_logs` VALUES (1572, 10, 'zhuyiqing', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-07-04 13:20:58');
INSERT INTO `user_logs` VALUES (1573, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:21:04');
INSERT INTO `user_logs` VALUES (1574, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:21:04');
INSERT INTO `user_logs` VALUES (1575, 10, 'zhuyiqing', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-07-04 13:21:41');
INSERT INTO `user_logs` VALUES (1576, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:21:46');
INSERT INTO `user_logs` VALUES (1577, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:21:47');
INSERT INTO `user_logs` VALUES (1578, 10, 'zhuyiqing', 'connect', 30, '用户中心集群-1', '182.92.65.158', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 用户中心集群-1(182.92.65.158)', '2025-07-04 13:23:05');
INSERT INTO `user_logs` VALUES (1579, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:23:09');
INSERT INTO `user_logs` VALUES (1580, 10, 'zhuyiqing', 'disconnect', 30, '用户中心集群-1', '182.92.65.158', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-1(182.92.65.158) [监控自动检测]', '2025-07-04 13:23:10');
INSERT INTO `user_logs` VALUES (1581, 10, 'zhuyiqing', 'connect', 35, 'Earth主站', '60.205.201.247', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 Earth主站(60.205.201.247)', '2025-07-04 13:23:21');
INSERT INTO `user_logs` VALUES (1582, 10, 'zhuyiqing', 'disconnect', 35, 'Earth主站', '60.205.201.247', '60.205.201.247', '用户 zhuyiqing 断开Windows连接 Earth主站(60.205.201.247) [代理检测]', '2025-07-04 13:23:44');
INSERT INTO `user_logs` VALUES (1583, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 13:23:45');
INSERT INTO `user_logs` VALUES (1584, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-07-04 13:24:00');
INSERT INTO `user_logs` VALUES (1585, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-04 13:24:15');
INSERT INTO `user_logs` VALUES (1586, 10, 'zhuyiqing', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 内部服务(39.96.38.239)', '2025-07-04 13:24:27');
INSERT INTO `user_logs` VALUES (1587, 10, 'zhuyiqing', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 zhuyiqing 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-07-04 13:24:33');
INSERT INTO `user_logs` VALUES (1588, 10, 'zhuyiqing', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 zhuyiqing 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-07-04 13:24:33');
INSERT INTO `user_logs` VALUES (1589, 10, 'zhuyiqing', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 内部服务(39.96.38.239)', '2025-07-04 13:24:59');
INSERT INTO `user_logs` VALUES (1590, 10, 'zhuyiqing', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 内部服务(39.96.38.239)', '2025-07-04 13:25:04');
INSERT INTO `user_logs` VALUES (1591, 10, 'zhuyiqing', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 zhuyiqing 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-07-04 13:25:05');
INSERT INTO `user_logs` VALUES (1592, 10, 'zhuyiqing', 'disconnect', 29, '内部服务', '39.96.38.239', NULL, '用户 zhuyiqing 断开Linux连接 内部服务(39.96.38.239) [监控自动检测]', '2025-07-04 13:25:05');
INSERT INTO `user_logs` VALUES (1593, 10, 'zhuyiqing', 'connect', 51, '用户中心集群-2', '123.57.62.102', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 用户中心集群-2(123.57.62.102)', '2025-07-04 13:28:59');
INSERT INTO `user_logs` VALUES (1594, 10, 'zhuyiqing', 'disconnect', 51, '用户中心集群-2', '123.57.62.102', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-2(123.57.62.102) [监控自动检测]', '2025-07-04 13:29:03');
INSERT INTO `user_logs` VALUES (1595, 10, 'zhuyiqing', 'disconnect', 51, '用户中心集群-2', '123.57.62.102', NULL, '用户 zhuyiqing 断开Linux连接 用户中心集群-2(123.57.62.102) [监控自动检测]', '2025-07-04 13:29:03');
INSERT INTO `user_logs` VALUES (1596, 10, 'zhuyiqing', 'connect', 52, 'postgresql', '39.105.119.126', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 postgresql(39.105.119.126)', '2025-07-04 13:30:23');
INSERT INTO `user_logs` VALUES (1597, 10, 'zhuyiqing', 'disconnect', 52, 'postgresql', '39.105.119.126', NULL, '用户 zhuyiqing 断开Linux连接 postgresql(39.105.119.126) [监控自动检测]', '2025-07-04 13:30:26');
INSERT INTO `user_logs` VALUES (1598, 10, 'zhuyiqing', 'disconnect', 52, 'postgresql', '39.105.119.126', NULL, '用户 zhuyiqing 断开Linux连接 postgresql(39.105.119.126) [监控自动检测]', '2025-07-04 13:30:26');
INSERT INTO `user_logs` VALUES (1599, 10, 'zhuyiqing', 'connect', 52, 'postgresql', '39.105.119.126', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 postgresql(39.105.119.126)', '2025-07-04 13:30:28');
INSERT INTO `user_logs` VALUES (1600, 10, 'zhuyiqing', 'disconnect', 52, 'postgresql', '39.105.119.126', NULL, '用户 zhuyiqing 断开Linux连接 postgresql(39.105.119.126) [监控自动检测]', '2025-07-04 13:30:34');
INSERT INTO `user_logs` VALUES (1601, 10, 'zhuyiqing', 'disconnect', 52, 'postgresql', '39.105.119.126', NULL, '用户 zhuyiqing 断开Linux连接 postgresql(39.105.119.126) [监控自动检测]', '2025-07-04 13:30:34');
INSERT INTO `user_logs` VALUES (1602, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 14:05:33');
INSERT INTO `user_logs` VALUES (1603, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 14:05:38');
INSERT INTO `user_logs` VALUES (1604, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [监控自动检测]', '2025-07-04 14:15:56');
INSERT INTO `user_logs` VALUES (1605, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-04 14:18:43');
INSERT INTO `user_logs` VALUES (1606, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-07-04 14:18:46');
INSERT INTO `user_logs` VALUES (1607, 8, 'jingchen', 'connect', 23, '研发测试', '10.16.30.172', '10.16.30.110', '用户 jingchen 连接RDP服务器 研发测试(10.16.30.172)', '2025-07-04 14:18:50');
INSERT INTO `user_logs` VALUES (1608, 8, 'jingchen', 'disconnect', 23, '研发测试', '10.16.30.172', '10.16.30.172', '用户 jingchen 断开Windows连接 研发测试(10.16.30.172) [代理检测]', '2025-07-04 14:20:58');
INSERT INTO `user_logs` VALUES (1609, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-04 14:41:16');
INSERT INTO `user_logs` VALUES (1610, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-04 15:03:47');
INSERT INTO `user_logs` VALUES (1611, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-04 15:10:34');
INSERT INTO `user_logs` VALUES (1612, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 15:10:40');
INSERT INTO `user_logs` VALUES (1613, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-04 15:10:48');
INSERT INTO `user_logs` VALUES (1614, 7, 'gaof', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 gaof 登录系统', '2025-07-04 15:11:06');
INSERT INTO `user_logs` VALUES (1615, 7, 'gaof', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 gaof 注销系统', '2025-07-04 15:11:15');
INSERT INTO `user_logs` VALUES (1616, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 15:11:18');
INSERT INTO `user_logs` VALUES (1617, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-04 15:11:42');
INSERT INTO `user_logs` VALUES (1618, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 15:30:11');
INSERT INTO `user_logs` VALUES (1619, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-04 15:34:06');
INSERT INTO `user_logs` VALUES (1620, 8, 'jingchen', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-04 15:34:10');
INSERT INTO `user_logs` VALUES (1621, 8, 'jingchen', 'disconnect', 44, '测试服务器', '10.16.30.53', '10.16.30.53', '用户 jingchen 断开Windows连接 测试服务器(10.16.30.53) [代理检测]', '2025-07-04 15:35:34');
INSERT INTO `user_logs` VALUES (1622, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-04 15:45:12');
INSERT INTO `user_logs` VALUES (1623, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 16:14:37');
INSERT INTO `user_logs` VALUES (1624, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 16:14:39');
INSERT INTO `user_logs` VALUES (1625, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [监控自动检测]', '2025-07-04 16:20:06');
INSERT INTO `user_logs` VALUES (1626, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [监控自动检测]', '2025-07-04 16:20:07');
INSERT INTO `user_logs` VALUES (1627, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-04 16:26:40');
INSERT INTO `user_logs` VALUES (1628, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-04 16:41:42');
INSERT INTO `user_logs` VALUES (1629, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-04 17:29:16');
INSERT INTO `user_logs` VALUES (1630, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-04 17:40:08');
INSERT INTO `user_logs` VALUES (1631, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-07 09:02:36');
INSERT INTO `user_logs` VALUES (1632, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-07 09:19:29');
INSERT INTO `user_logs` VALUES (1633, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-07 09:19:31');
INSERT INTO `user_logs` VALUES (1634, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-07 09:26:56');
INSERT INTO `user_logs` VALUES (1635, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-07 09:27:01');
INSERT INTO `user_logs` VALUES (1636, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-07 09:27:11');
INSERT INTO `user_logs` VALUES (1637, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-07 09:27:47');
INSERT INTO `user_logs` VALUES (1638, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-07 09:34:32');
INSERT INTO `user_logs` VALUES (1639, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-07 09:34:32');
INSERT INTO `user_logs` VALUES (1640, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-07 10:02:55');
INSERT INTO `user_logs` VALUES (1641, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-07 10:39:50');
INSERT INTO `user_logs` VALUES (1642, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-07 10:39:52');
INSERT INTO `user_logs` VALUES (1643, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-07 10:39:58');
INSERT INTO `user_logs` VALUES (1644, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-07 10:42:12');
INSERT INTO `user_logs` VALUES (1645, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-07 10:49:35');
INSERT INTO `user_logs` VALUES (1646, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-07 13:03:59');
INSERT INTO `user_logs` VALUES (1647, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-07 13:09:37');
INSERT INTO `user_logs` VALUES (1648, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-07 13:09:43');
INSERT INTO `user_logs` VALUES (1649, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-07-07 13:24:44');
INSERT INTO `user_logs` VALUES (1650, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-07 13:51:25');
INSERT INTO `user_logs` VALUES (1651, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-07 13:58:23');
INSERT INTO `user_logs` VALUES (1652, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-07 14:00:00');
INSERT INTO `user_logs` VALUES (1653, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-07-07 14:01:02');
INSERT INTO `user_logs` VALUES (1654, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-07 14:21:29');
INSERT INTO `user_logs` VALUES (1655, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-07-07 14:36:32');
INSERT INTO `user_logs` VALUES (1656, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-07 15:49:30');
INSERT INTO `user_logs` VALUES (1657, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-07 15:49:31');
INSERT INTO `user_logs` VALUES (1658, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-07 15:49:39');
INSERT INTO `user_logs` VALUES (1659, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-07 16:00:35');
INSERT INTO `user_logs` VALUES (1660, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-07 16:00:39');
INSERT INTO `user_logs` VALUES (1661, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-07 16:04:40');
INSERT INTO `user_logs` VALUES (1662, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-07 16:04:50');
INSERT INTO `user_logs` VALUES (1663, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-07 16:59:10');
INSERT INTO `user_logs` VALUES (1664, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-07 17:36:38');
INSERT INTO `user_logs` VALUES (1665, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', NULL, '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [超时自动断开]', '2025-07-07 17:51:38');
INSERT INTO `user_logs` VALUES (1666, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-08 09:06:15');
INSERT INTO `user_logs` VALUES (1667, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-08 10:48:03');
INSERT INTO `user_logs` VALUES (1668, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 13:53:04');
INSERT INTO `user_logs` VALUES (1669, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 14:07:12');
INSERT INTO `user_logs` VALUES (1670, 10, 'zhuyiqing', 'connect', 55, 'BIM服务器', '10.16.30.196', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器(10.16.30.196)', '2025-07-08 14:07:38');
INSERT INTO `user_logs` VALUES (1671, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-08 14:10:22');
INSERT INTO `user_logs` VALUES (1672, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-08 14:11:36');
INSERT INTO `user_logs` VALUES (1673, 10, 'zhuyiqing', 'disconnect', 55, 'BIM服务器', '10.16.30.196', '10.16.30.196', '用户 zhuyiqing 断开Windows连接 BIM服务器(10.16.30.196) [代理检测]', '2025-07-08 14:11:38');
INSERT INTO `user_logs` VALUES (1674, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-08 14:11:53');
INSERT INTO `user_logs` VALUES (1675, 11, 'xiangzf', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 xiangzf 登录系统', '2025-07-08 14:11:58');
INSERT INTO `user_logs` VALUES (1676, 11, 'xiangzf', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 xiangzf 注销系统', '2025-07-08 14:12:35');
INSERT INTO `user_logs` VALUES (1677, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 14:13:21');
INSERT INTO `user_logs` VALUES (1678, 11, 'xiangzf', 'login', NULL, NULL, NULL, '10.16.30.28', '用户 xiangzf 登录系统', '2025-07-08 14:15:08');
INSERT INTO `user_logs` VALUES (1679, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:16:27');
INSERT INTO `user_logs` VALUES (1680, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:16:48');
INSERT INTO `user_logs` VALUES (1681, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:19:50');
INSERT INTO `user_logs` VALUES (1682, 11, 'xiangzf', 'disconnect', 38, '刀片机', '10.16.30.24', '10.16.30.24', '用户 xiangzf 断开Windows连接 刀片机(10.16.30.24) [代理检测]', '2025-07-08 14:20:21');
INSERT INTO `user_logs` VALUES (1683, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:21:03');
INSERT INTO `user_logs` VALUES (1684, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:21:12');
INSERT INTO `user_logs` VALUES (1685, 11, 'xiangzf', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.28', '用户 xiangzf 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-08 14:21:21');
INSERT INTO `user_logs` VALUES (1686, 11, 'xiangzf', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 xiangzf 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-07-08 14:36:23');
INSERT INTO `user_logs` VALUES (1687, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-08 15:01:25');
INSERT INTO `user_logs` VALUES (1688, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-08 15:01:28');
INSERT INTO `user_logs` VALUES (1689, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-08 15:04:09');
INSERT INTO `user_logs` VALUES (1690, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-08 15:07:12');
INSERT INTO `user_logs` VALUES (1691, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-08 15:22:14');
INSERT INTO `user_logs` VALUES (1692, 1, 'admin', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 admin 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-07-08 15:34:41');
INSERT INTO `user_logs` VALUES (1693, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 15:34:55');
INSERT INTO `user_logs` VALUES (1694, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-08 15:35:04');
INSERT INTO `user_logs` VALUES (1695, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-08 15:38:19');
INSERT INTO `user_logs` VALUES (1696, 1, 'admin', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', NULL, '用户 admin 断开Windows连接 BIM服务器-2(59.110.28.130) [超时自动断开]', '2025-07-08 15:49:41');
INSERT INTO `user_logs` VALUES (1697, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-08 15:55:26');
INSERT INTO `user_logs` VALUES (1698, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 16:04:29');
INSERT INTO `user_logs` VALUES (1699, 10, 'zhuyiqing', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-08 16:04:36');
INSERT INTO `user_logs` VALUES (1700, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-08 16:10:43');
INSERT INTO `user_logs` VALUES (1701, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-08 16:10:47');
INSERT INTO `user_logs` VALUES (1702, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-08 16:10:50');
INSERT INTO `user_logs` VALUES (1703, 10, 'zhuyiqing', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', NULL, '用户 zhuyiqing 断开Windows连接 C端编译服务器(10.16.30.180) [超时自动断开]', '2025-07-08 16:19:39');
INSERT INTO `user_logs` VALUES (1704, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-08 17:26:18');
INSERT INTO `user_logs` VALUES (1705, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-09 09:07:45');
INSERT INTO `user_logs` VALUES (1706, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-09 09:07:50');
INSERT INTO `user_logs` VALUES (1707, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-09 09:08:19');
INSERT INTO `user_logs` VALUES (1708, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-09 09:32:15');
INSERT INTO `user_logs` VALUES (1709, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-09 09:32:22');
INSERT INTO `user_logs` VALUES (1710, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', NULL, '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [超时自动断开]', '2025-07-09 09:47:22');
INSERT INTO `user_logs` VALUES (1711, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:20:25');
INSERT INTO `user_logs` VALUES (1712, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:20:36');
INSERT INTO `user_logs` VALUES (1713, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:20:52');
INSERT INTO `user_logs` VALUES (1714, 9, 'zhaoyy', 'connect', 46, '黑苹果', '10.16.30.166', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 黑苹果(10.16.30.166)', '2025-07-09 10:20:59');
INSERT INTO `user_logs` VALUES (1715, 9, 'zhaoyy', 'disconnect', 46, '黑苹果', '10.16.30.166', '10.16.30.166', '用户 zhaoyy 断开Windows连接 黑苹果(10.16.30.166) [代理检测]', '2025-07-09 10:21:12');
INSERT INTO `user_logs` VALUES (1716, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:22:25');
INSERT INTO `user_logs` VALUES (1717, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:23:13');
INSERT INTO `user_logs` VALUES (1718, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:31:59');
INSERT INTO `user_logs` VALUES (1719, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-09 10:33:00');
INSERT INTO `user_logs` VALUES (1720, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-09 10:33:47');
INSERT INTO `user_logs` VALUES (1721, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-09 10:34:07');
INSERT INTO `user_logs` VALUES (1722, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:34:28');
INSERT INTO `user_logs` VALUES (1723, 9, 'zhaoyy', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-07-09 10:34:35');
INSERT INTO `user_logs` VALUES (1724, 9, 'zhaoyy', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhaoyy 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-09 10:34:38');
INSERT INTO `user_logs` VALUES (1725, 9, 'zhaoyy', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhaoyy 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-09 10:34:40');
INSERT INTO `user_logs` VALUES (1726, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:34:42');
INSERT INTO `user_logs` VALUES (1727, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-09 10:35:00');
INSERT INTO `user_logs` VALUES (1728, 9, 'zhaoyy', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', NULL, '用户 zhaoyy 断开Windows连接 BIM服务器-3(10.16.30.171) [超时自动断开]', '2025-07-09 10:50:01');
INSERT INTO `user_logs` VALUES (1729, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-09 13:05:55');
INSERT INTO `user_logs` VALUES (1730, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-09 13:28:37');
INSERT INTO `user_logs` VALUES (1731, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-09 13:29:28');
INSERT INTO `user_logs` VALUES (1732, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-09 13:29:30');
INSERT INTO `user_logs` VALUES (1733, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-09 13:29:43');
INSERT INTO `user_logs` VALUES (1734, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-09 13:46:10');
INSERT INTO `user_logs` VALUES (1735, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-09 14:01:10');
INSERT INTO `user_logs` VALUES (1736, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-09 14:23:49');
INSERT INTO `user_logs` VALUES (1737, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-09 14:27:26');
INSERT INTO `user_logs` VALUES (1738, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-09 14:27:30');
INSERT INTO `user_logs` VALUES (1739, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-09 14:27:39');
INSERT INTO `user_logs` VALUES (1740, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-09 14:28:27');
INSERT INTO `user_logs` VALUES (1741, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-09 16:52:44');
INSERT INTO `user_logs` VALUES (1742, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-09 16:53:12');
INSERT INTO `user_logs` VALUES (1743, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-09 16:53:13');
INSERT INTO `user_logs` VALUES (1744, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-09 17:28:32');
INSERT INTO `user_logs` VALUES (1745, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-09 17:28:37');
INSERT INTO `user_logs` VALUES (1746, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-09 17:29:02');
INSERT INTO `user_logs` VALUES (1747, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-09 17:34:12');
INSERT INTO `user_logs` VALUES (1748, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-09 17:40:30');
INSERT INTO `user_logs` VALUES (1749, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-09 17:40:32');
INSERT INTO `user_logs` VALUES (1750, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-09 17:45:04');
INSERT INTO `user_logs` VALUES (1751, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 08:59:40');
INSERT INTO `user_logs` VALUES (1752, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-10 08:59:44');
INSERT INTO `user_logs` VALUES (1753, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-10 09:13:25');
INSERT INTO `user_logs` VALUES (1754, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-10 09:14:43');
INSERT INTO `user_logs` VALUES (1755, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 09:42:15');
INSERT INTO `user_logs` VALUES (1756, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-10 09:54:32');
INSERT INTO `user_logs` VALUES (1757, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 09:54:49');
INSERT INTO `user_logs` VALUES (1758, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 09:59:29');
INSERT INTO `user_logs` VALUES (1759, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-10 10:05:06');
INSERT INTO `user_logs` VALUES (1760, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 10:05:22');
INSERT INTO `user_logs` VALUES (1761, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-10 10:06:20');
INSERT INTO `user_logs` VALUES (1762, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 10:10:12');
INSERT INTO `user_logs` VALUES (1763, 9, 'zhaoyy', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.17', '用户 zhaoyy 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-10 10:15:04');
INSERT INTO `user_logs` VALUES (1764, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-10 10:15:45');
INSERT INTO `user_logs` VALUES (1765, 8, 'jingchen', 'connect', 45, '测试服务器', '10.16.30.6', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-10 10:15:48');
INSERT INTO `user_logs` VALUES (1766, 8, 'jingchen', 'connect', 45, '测试服务器', '10.16.30.6', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-10 10:15:54');
INSERT INTO `user_logs` VALUES (1767, 9, 'zhaoyy', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.171', '用户 zhaoyy 断开Windows连接 BIM服务器-3(10.16.30.171) [代理检测]', '2025-07-10 10:16:11');
INSERT INTO `user_logs` VALUES (1768, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 10:16:30');
INSERT INTO `user_logs` VALUES (1769, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-10 10:16:33');
INSERT INTO `user_logs` VALUES (1770, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 10:17:38');
INSERT INTO `user_logs` VALUES (1771, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 10:18:31');
INSERT INTO `user_logs` VALUES (1772, 8, 'jingchen', 'disconnect', 45, '测试服务器', '10.16.30.6', '10.16.30.6', '用户 jingchen 断开Windows连接 测试服务器(10.16.30.6) [代理检测]', '2025-07-10 10:26:58');
INSERT INTO `user_logs` VALUES (1773, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-10 10:27:40');
INSERT INTO `user_logs` VALUES (1774, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-10 10:30:53');
INSERT INTO `user_logs` VALUES (1775, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-10 10:37:45');
INSERT INTO `user_logs` VALUES (1776, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-10 10:41:38');
INSERT INTO `user_logs` VALUES (1777, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-10 10:41:40');
INSERT INTO `user_logs` VALUES (1778, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-07-10 10:56:41');
INSERT INTO `user_logs` VALUES (1779, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 11:09:07');
INSERT INTO `user_logs` VALUES (1780, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-10 11:11:31');
INSERT INTO `user_logs` VALUES (1781, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-10 11:56:04');
INSERT INTO `user_logs` VALUES (1782, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 11:56:06');
INSERT INTO `user_logs` VALUES (1783, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-10 12:11:07');
INSERT INTO `user_logs` VALUES (1784, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 13:02:35');
INSERT INTO `user_logs` VALUES (1785, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 13:03:51');
INSERT INTO `user_logs` VALUES (1786, 3, 'zhangshujun', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-10 13:03:56');
INSERT INTO `user_logs` VALUES (1787, 3, 'zhangshujun', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhangshujun 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-10 13:05:40');
INSERT INTO `user_logs` VALUES (1788, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-10 13:10:09');
INSERT INTO `user_logs` VALUES (1789, 8, 'jingchen', 'connect', 45, '测试服务器', '10.16.30.6', '10.16.30.110', '用户 jingchen 连接RDP服务器 测试服务器(10.16.30.6)', '2025-07-10 13:10:11');
INSERT INTO `user_logs` VALUES (1790, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 13:13:40');
INSERT INTO `user_logs` VALUES (1791, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-10 13:24:37');
INSERT INTO `user_logs` VALUES (1792, 8, 'jingchen', 'disconnect', 45, '测试服务器', '10.16.30.6', NULL, '用户 jingchen 断开Windows连接 测试服务器(10.16.30.6) [超时自动断开]', '2025-07-10 13:25:12');
INSERT INTO `user_logs` VALUES (1793, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 13:26:26');
INSERT INTO `user_logs` VALUES (1794, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 13:29:26');
INSERT INTO `user_logs` VALUES (1795, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 13:29:32');
INSERT INTO `user_logs` VALUES (1796, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-10 13:29:37');
INSERT INTO `user_logs` VALUES (1797, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-10 13:44:40');
INSERT INTO `user_logs` VALUES (1798, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 14:49:36');
INSERT INTO `user_logs` VALUES (1799, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-10 14:50:48');
INSERT INTO `user_logs` VALUES (1800, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-10 14:50:50');
INSERT INTO `user_logs` VALUES (1801, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-10 14:51:07');
INSERT INTO `user_logs` VALUES (1802, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-10 15:11:16');
INSERT INTO `user_logs` VALUES (1803, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 15:13:14');
INSERT INTO `user_logs` VALUES (1804, 10, 'zhuyiqing', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-07-10 15:18:38');
INSERT INTO `user_logs` VALUES (1805, 10, 'zhuyiqing', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-07-10 15:18:42');
INSERT INTO `user_logs` VALUES (1806, 10, 'zhuyiqing', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-07-10 15:18:56');
INSERT INTO `user_logs` VALUES (1807, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-10 15:19:13');
INSERT INTO `user_logs` VALUES (1808, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-10 15:19:13');
INSERT INTO `user_logs` VALUES (1809, 10, 'zhuyiqing', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-07-10 15:19:23');
INSERT INTO `user_logs` VALUES (1810, 10, 'zhuyiqing', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-07-10 15:19:26');
INSERT INTO `user_logs` VALUES (1811, 10, 'zhuyiqing', 'connect', 11, '预生产-WIN', '47.94.213.245', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 预生产-WIN(47.94.213.245)', '2025-07-10 15:19:37');
INSERT INTO `user_logs` VALUES (1812, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-07-10 15:20:00');
INSERT INTO `user_logs` VALUES (1813, 10, 'zhuyiqing', 'connect', 6, 'BIM服务器-2', '59.110.28.130', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-2(59.110.28.130)', '2025-07-10 15:21:47');
INSERT INTO `user_logs` VALUES (1814, 10, 'zhuyiqing', 'connect', 8, '项目案例', '123.56.161.149', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 项目案例(123.56.161.149)', '2025-07-10 15:22:05');
INSERT INTO `user_logs` VALUES (1815, 10, 'zhuyiqing', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-10 15:22:33');
INSERT INTO `user_logs` VALUES (1816, 10, 'zhuyiqing', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-10 15:22:44');
INSERT INTO `user_logs` VALUES (1817, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-10 15:24:48');
INSERT INTO `user_logs` VALUES (1818, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-07-10 15:24:53');
INSERT INTO `user_logs` VALUES (1819, 10, 'zhuyiqing', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 zhuyiqing 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-07-10 15:28:10');
INSERT INTO `user_logs` VALUES (1820, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-10 15:28:43');
INSERT INTO `user_logs` VALUES (1821, 10, 'zhuyiqing', 'disconnect', 11, '预生产-WIN', '47.94.213.245', NULL, '用户 zhuyiqing 断开Windows连接 预生产-WIN(47.94.213.245) [超时自动断开]', '2025-07-10 15:34:38');
INSERT INTO `user_logs` VALUES (1822, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-10 15:34:58');
INSERT INTO `user_logs` VALUES (1823, 10, 'zhuyiqing', 'disconnect', 6, 'BIM服务器-2', '59.110.28.130', NULL, '用户 zhuyiqing 断开Windows连接 BIM服务器-2(59.110.28.130) [超时自动断开]', '2025-07-10 15:36:47');
INSERT INTO `user_logs` VALUES (1824, 10, 'zhuyiqing', 'disconnect', 8, '项目案例', '123.56.161.149', NULL, '用户 zhuyiqing 断开Windows连接 项目案例(123.56.161.149) [超时自动断开]', '2025-07-10 15:37:05');
INSERT INTO `user_logs` VALUES (1825, 10, 'zhuyiqing', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-07-10 15:43:44');
INSERT INTO `user_logs` VALUES (1826, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-10 15:52:34');
INSERT INTO `user_logs` VALUES (1827, 10, 'zhuyiqing', 'connect', 46, '黑苹果', '10.16.30.166', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 黑苹果(10.16.30.166)', '2025-07-10 15:55:42');
INSERT INTO `user_logs` VALUES (1828, 10, 'zhuyiqing', 'connect', 46, '黑苹果', '10.16.30.166', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 黑苹果(10.16.30.166)', '2025-07-10 15:55:45');
INSERT INTO `user_logs` VALUES (1829, 10, 'zhuyiqing', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-07-10 16:07:37');
INSERT INTO `user_logs` VALUES (1830, 10, 'zhuyiqing', 'disconnect', 46, '黑苹果', '10.16.30.166', NULL, '用户 zhuyiqing 断开Windows连接 黑苹果(10.16.30.166) [超时自动断开]', '2025-07-10 16:10:45');
INSERT INTO `user_logs` VALUES (1831, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-10 17:01:57');
INSERT INTO `user_logs` VALUES (1832, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-10 17:03:15');
INSERT INTO `user_logs` VALUES (1833, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.66.228', '用户 admin 登录系统', '2025-07-10 17:03:38');
INSERT INTO `user_logs` VALUES (1834, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 17:03:52');
INSERT INTO `user_logs` VALUES (1835, 1, 'admin', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 admin 注销系统', '2025-07-10 17:22:22');
INSERT INTO `user_logs` VALUES (1836, 1, 'admin', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 admin 登录系统', '2025-07-10 17:24:24');
INSERT INTO `user_logs` VALUES (1837, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-10 17:26:14');
INSERT INTO `user_logs` VALUES (1838, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-10 17:26:41');
INSERT INTO `user_logs` VALUES (1839, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-11 09:25:44');
INSERT INTO `user_logs` VALUES (1840, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-11 09:37:49');
INSERT INTO `user_logs` VALUES (1841, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-11 10:00:10');
INSERT INTO `user_logs` VALUES (1842, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-11 10:00:16');
INSERT INTO `user_logs` VALUES (1843, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-11 10:00:18');
INSERT INTO `user_logs` VALUES (1844, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-11 10:01:05');
INSERT INTO `user_logs` VALUES (1845, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-11 11:17:02');
INSERT INTO `user_logs` VALUES (1846, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-11 11:17:06');
INSERT INTO `user_logs` VALUES (1847, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-11 11:28:36');
INSERT INTO `user_logs` VALUES (1848, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-11 13:27:22');
INSERT INTO `user_logs` VALUES (1849, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-11 15:42:11');
INSERT INTO `user_logs` VALUES (1850, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-11 15:50:30');
INSERT INTO `user_logs` VALUES (1851, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-11 15:50:34');
INSERT INTO `user_logs` VALUES (1852, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', NULL, '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [超时自动断开]', '2025-07-11 16:05:35');
INSERT INTO `user_logs` VALUES (1853, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-11 16:19:25');
INSERT INTO `user_logs` VALUES (1854, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-11 16:26:15');
INSERT INTO `user_logs` VALUES (1855, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-11 16:41:10');
INSERT INTO `user_logs` VALUES (1856, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-11 16:50:25');
INSERT INTO `user_logs` VALUES (1857, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-11 16:50:44');
INSERT INTO `user_logs` VALUES (1858, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-11 17:05:45');
INSERT INTO `user_logs` VALUES (1859, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-14 08:56:22');
INSERT INTO `user_logs` VALUES (1860, 3, 'zhangshujun', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-14 09:03:45');
INSERT INTO `user_logs` VALUES (1861, 3, 'zhangshujun', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhangshujun 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-14 09:04:26');
INSERT INTO `user_logs` VALUES (1862, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-14 09:15:06');
INSERT INTO `user_logs` VALUES (1863, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-14 09:15:12');
INSERT INTO `user_logs` VALUES (1864, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-14 09:15:47');
INSERT INTO `user_logs` VALUES (1865, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-14 09:27:51');
INSERT INTO `user_logs` VALUES (1866, 10, 'zhuyiqing', 'connect', 46, '黑苹果', '10.16.30.166', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 黑苹果(10.16.30.166)', '2025-07-14 09:28:25');
INSERT INTO `user_logs` VALUES (1867, 10, 'zhuyiqing', 'disconnect', 46, '黑苹果', '10.16.30.166', '10.16.30.166', '用户 zhuyiqing 断开Windows连接 黑苹果(10.16.30.166) [代理检测]', '2025-07-14 09:33:38');
INSERT INTO `user_logs` VALUES (1868, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-14 09:40:55');
INSERT INTO `user_logs` VALUES (1869, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', NULL, '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [超时自动断开]', '2025-07-14 09:55:56');
INSERT INTO `user_logs` VALUES (1870, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-14 10:23:39');
INSERT INTO `user_logs` VALUES (1871, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 10:28:12');
INSERT INTO `user_logs` VALUES (1872, 10, 'zhuyiqing', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhuyiqing 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-14 10:30:17');
INSERT INTO `user_logs` VALUES (1873, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-14 10:55:05');
INSERT INTO `user_logs` VALUES (1874, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:00:31');
INSERT INTO `user_logs` VALUES (1875, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:00:33');
INSERT INTO `user_logs` VALUES (1876, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:00:36');
INSERT INTO `user_logs` VALUES (1877, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:00:41');
INSERT INTO `user_logs` VALUES (1878, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-14 11:00:41');
INSERT INTO `user_logs` VALUES (1879, 10, 'zhuyiqing', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhuyiqing 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-14 11:01:58');
INSERT INTO `user_logs` VALUES (1880, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-14 11:12:42');
INSERT INTO `user_logs` VALUES (1881, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-14 11:22:45');
INSERT INTO `user_logs` VALUES (1882, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:22:48');
INSERT INTO `user_logs` VALUES (1883, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 11:22:56');
INSERT INTO `user_logs` VALUES (1884, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-14 11:23:58');
INSERT INTO `user_logs` VALUES (1885, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-14 13:03:57');
INSERT INTO `user_logs` VALUES (1886, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-14 13:04:45');
INSERT INTO `user_logs` VALUES (1887, 10, 'zhuyiqing', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-14 13:16:17');
INSERT INTO `user_logs` VALUES (1888, 10, 'zhuyiqing', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-14 13:16:20');
INSERT INTO `user_logs` VALUES (1889, 10, 'zhuyiqing', 'disconnect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.171', '用户 zhuyiqing 断开Windows连接 BIM服务器-3(10.16.30.171) [代理检测]', '2025-07-14 13:17:12');
INSERT INTO `user_logs` VALUES (1890, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-14 13:28:24');
INSERT INTO `user_logs` VALUES (1891, 10, 'zhuyiqing', 'connect', NULL, 'pagenow', '10.16.30.105', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 pagenow(10.16.30.105)', '2025-07-14 13:33:41');
INSERT INTO `user_logs` VALUES (1892, 10, 'zhuyiqing', 'disconnect', NULL, 'pagenow', '10.16.30.105', NULL, '用户 zhuyiqing 断开Windows连接 pagenow(10.16.30.105) [监控自动检测]', '2025-07-14 13:33:45');
INSERT INTO `user_logs` VALUES (1893, 10, 'zhuyiqing', 'connect', NULL, 'pagenow', '10.16.30.105', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 pagenow(10.16.30.105)', '2025-07-14 13:34:09');
INSERT INTO `user_logs` VALUES (1894, 10, 'zhuyiqing', 'disconnect', 38, '刀片机', '10.16.30.24', '10.16.30.24', '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.24) [代理检测]', '2025-07-14 13:35:10');
INSERT INTO `user_logs` VALUES (1895, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-14 14:53:31');
INSERT INTO `user_logs` VALUES (1896, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-14 15:30:16');
INSERT INTO `user_logs` VALUES (1897, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-14 15:30:19');
INSERT INTO `user_logs` VALUES (1898, 10, 'zhuyiqing', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-07-14 15:36:07');
INSERT INTO `user_logs` VALUES (1899, 10, 'zhuyiqing', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhuyiqing 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-14 15:36:09');
INSERT INTO `user_logs` VALUES (1900, 10, 'zhuyiqing', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhuyiqing 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-14 15:36:10');
INSERT INTO `user_logs` VALUES (1901, 10, 'zhuyiqing', 'connect', 17, '测试环境-1', '10.16.30.161', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试环境-1(10.16.30.161)', '2025-07-14 15:36:43');
INSERT INTO `user_logs` VALUES (1902, 10, 'zhuyiqing', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhuyiqing 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-14 15:36:47');
INSERT INTO `user_logs` VALUES (1903, 10, 'zhuyiqing', 'disconnect', 17, '测试环境-1', '10.16.30.161', NULL, '用户 zhuyiqing 断开Windows连接 测试环境-1(10.16.30.161) [监控自动检测]', '2025-07-14 15:36:47');
INSERT INTO `user_logs` VALUES (1904, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-14 15:45:23');
INSERT INTO `user_logs` VALUES (1905, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-15 10:00:13');
INSERT INTO `user_logs` VALUES (1906, 10, 'zhuyiqing', 'connect', 9, 'BIM服务器-1', '8.140.152.230', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-1(8.140.152.230)', '2025-07-15 10:01:13');
INSERT INTO `user_logs` VALUES (1907, 10, 'zhuyiqing', 'disconnect', 9, 'BIM服务器-1', '8.140.152.230', '8.140.152.230', '用户 zhuyiqing 断开Windows连接 BIM服务器-1(8.140.152.230) [代理检测]', '2025-07-15 10:05:15');
INSERT INTO `user_logs` VALUES (1908, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-15 10:48:37');
INSERT INTO `user_logs` VALUES (1909, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-15 10:59:02');
INSERT INTO `user_logs` VALUES (1910, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 10:59:04');
INSERT INTO `user_logs` VALUES (1911, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 10:59:07');
INSERT INTO `user_logs` VALUES (1912, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', NULL, '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [超时自动断开]', '2025-07-15 11:03:38');
INSERT INTO `user_logs` VALUES (1913, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-15 11:08:21');
INSERT INTO `user_logs` VALUES (1914, 10, 'zhuyiqing', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-15 11:17:09');
INSERT INTO `user_logs` VALUES (1915, 10, 'zhuyiqing', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-15 11:18:16');
INSERT INTO `user_logs` VALUES (1916, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-15 13:27:11');
INSERT INTO `user_logs` VALUES (1917, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-15 13:37:51');
INSERT INTO `user_logs` VALUES (1918, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:37:53');
INSERT INTO `user_logs` VALUES (1919, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:37:56');
INSERT INTO `user_logs` VALUES (1920, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:37:58');
INSERT INTO `user_logs` VALUES (1921, 10, 'zhuyiqing', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-07-15 13:45:24');
INSERT INTO `user_logs` VALUES (1922, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-15 13:47:07');
INSERT INTO `user_logs` VALUES (1923, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:47:49');
INSERT INTO `user_logs` VALUES (1924, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:47:52');
INSERT INTO `user_logs` VALUES (1925, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-15 13:48:32');
INSERT INTO `user_logs` VALUES (1926, 10, 'zhuyiqing', 'connect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 docker镜像管理(10.16.30.191)', '2025-07-15 13:53:52');
INSERT INTO `user_logs` VALUES (1927, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-15 13:54:32');
INSERT INTO `user_logs` VALUES (1928, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 13:56:52');
INSERT INTO `user_logs` VALUES (1929, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-15 13:59:32');
INSERT INTO `user_logs` VALUES (1930, 10, 'zhuyiqing', 'disconnect', 20, '夜莺监控服务器', '10.16.30.193', NULL, '用户 zhuyiqing 断开Linux连接 夜莺监控服务器(10.16.30.193) [超时自动断开]', '2025-07-15 14:00:26');
INSERT INTO `user_logs` VALUES (1931, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-15 14:05:30');
INSERT INTO `user_logs` VALUES (1932, 10, 'zhuyiqing', 'disconnect', 43, 'docker镜像管理', '10.16.30.191', '10.16.30.191', '用户 zhuyiqing 断开Linux连接 docker镜像管理(10.16.30.191) [代理检测]', '2025-07-15 14:06:23');
INSERT INTO `user_logs` VALUES (1933, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-15 15:09:55');
INSERT INTO `user_logs` VALUES (1934, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-15 15:10:34');
INSERT INTO `user_logs` VALUES (1935, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-15 15:10:59');
INSERT INTO `user_logs` VALUES (1936, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-15 15:12:31');
INSERT INTO `user_logs` VALUES (1937, 10, 'zhuyiqing', 'disconnect', 44, '测试服务器', '10.16.30.53', NULL, '用户 zhuyiqing 断开Windows连接 测试服务器(10.16.30.53) [监控自动检测]', '2025-07-15 15:12:37');
INSERT INTO `user_logs` VALUES (1938, 10, 'zhuyiqing', 'disconnect', 44, '测试服务器', '10.16.30.53', NULL, '用户 zhuyiqing 断开Windows连接 测试服务器(10.16.30.53) [监控自动检测]', '2025-07-15 15:12:39');
INSERT INTO `user_logs` VALUES (1939, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-15 15:16:11');
INSERT INTO `user_logs` VALUES (1940, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-15 15:32:31');
INSERT INTO `user_logs` VALUES (1941, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 15:32:34');
INSERT INTO `user_logs` VALUES (1942, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 15:32:37');
INSERT INTO `user_logs` VALUES (1943, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 15:32:39');
INSERT INTO `user_logs` VALUES (1944, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-15 15:47:42');
INSERT INTO `user_logs` VALUES (1945, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-15 16:13:03');
INSERT INTO `user_logs` VALUES (1946, 10, 'zhuyiqing', 'connect', 14, '本地gitlab', '10.16.30.139', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地gitlab(10.16.30.139)', '2025-07-15 16:13:10');
INSERT INTO `user_logs` VALUES (1947, 10, 'zhuyiqing', 'disconnect', 14, '本地gitlab', '10.16.30.139', NULL, '用户 zhuyiqing 断开Linux连接 本地gitlab(10.16.30.139) [超时自动断开]', '2025-07-15 16:28:12');
INSERT INTO `user_logs` VALUES (1948, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-15 17:57:21');
INSERT INTO `user_logs` VALUES (1949, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 17:57:25');
INSERT INTO `user_logs` VALUES (1950, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 17:57:28');
INSERT INTO `user_logs` VALUES (1951, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 17:57:34');
INSERT INTO `user_logs` VALUES (1952, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-15 17:57:37');
INSERT INTO `user_logs` VALUES (1953, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-15 18:07:34');
INSERT INTO `user_logs` VALUES (1954, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-16 08:54:13');
INSERT INTO `user_logs` VALUES (1955, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 08:54:14');
INSERT INTO `user_logs` VALUES (1956, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-16 09:07:05');
INSERT INTO `user_logs` VALUES (1957, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-16 10:05:23');
INSERT INTO `user_logs` VALUES (1958, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 10:05:26');
INSERT INTO `user_logs` VALUES (1959, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-16 10:18:01');
INSERT INTO `user_logs` VALUES (1960, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 10:22:15');
INSERT INTO `user_logs` VALUES (1961, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-16 10:37:16');
INSERT INTO `user_logs` VALUES (1962, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 11:01:27');
INSERT INTO `user_logs` VALUES (1963, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-16 11:01:30');
INSERT INTO `user_logs` VALUES (1964, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-16 11:13:12');
INSERT INTO `user_logs` VALUES (1965, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-16 11:15:09');
INSERT INTO `user_logs` VALUES (1966, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 13:21:16');
INSERT INTO `user_logs` VALUES (1967, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-16 13:22:36');
INSERT INTO `user_logs` VALUES (1968, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-16 13:24:05');
INSERT INTO `user_logs` VALUES (1969, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-07-16 13:39:05');
INSERT INTO `user_logs` VALUES (1970, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-16 13:46:04');
INSERT INTO `user_logs` VALUES (1971, 3, 'zhangshujun', 'connect', 34, '图新云GIS', '101.201.30.185', '10.16.30.44', '用户 zhangshujun 连接RDP服务器 图新云GIS(101.201.30.185)', '2025-07-16 13:46:08');
INSERT INTO `user_logs` VALUES (1972, 3, 'zhangshujun', 'disconnect', 34, '图新云GIS', '101.201.30.185', '101.201.30.185', '用户 zhangshujun 断开Windows连接 图新云GIS(101.201.30.185) [代理检测]', '2025-07-16 13:48:36');
INSERT INTO `user_logs` VALUES (1973, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 14:28:20');
INSERT INTO `user_logs` VALUES (1974, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-16 14:28:29');
INSERT INTO `user_logs` VALUES (1975, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', NULL, '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [超时自动断开]', '2025-07-16 14:43:32');
INSERT INTO `user_logs` VALUES (1976, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-16 15:02:31');
INSERT INTO `user_logs` VALUES (1977, 12, 'test', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 test 登录系统', '2025-07-16 15:02:34');
INSERT INTO `user_logs` VALUES (1978, 12, 'test', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 test 注销系统', '2025-07-16 15:02:38');
INSERT INTO `user_logs` VALUES (1979, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 15:02:46');
INSERT INTO `user_logs` VALUES (1980, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-16 15:03:04');
INSERT INTO `user_logs` VALUES (1981, 12, 'test', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 test 登录系统', '2025-07-16 15:03:08');
INSERT INTO `user_logs` VALUES (1982, 12, 'test', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 test 注销系统', '2025-07-16 15:06:19');
INSERT INTO `user_logs` VALUES (1983, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 15:06:22');
INSERT INTO `user_logs` VALUES (1984, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-16 15:06:31');
INSERT INTO `user_logs` VALUES (1985, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-16 15:06:35');
INSERT INTO `user_logs` VALUES (1986, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-16 15:09:25');
INSERT INTO `user_logs` VALUES (1987, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-16 15:16:41');
INSERT INTO `user_logs` VALUES (1988, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-16 15:17:27');
INSERT INTO `user_logs` VALUES (1989, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-16 15:18:38');
INSERT INTO `user_logs` VALUES (1990, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 15:18:39');
INSERT INTO `user_logs` VALUES (1991, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-16 15:19:39');
INSERT INTO `user_logs` VALUES (1992, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', NULL, '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [超时自动断开]', '2025-07-16 15:21:36');
INSERT INTO `user_logs` VALUES (1993, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-16 16:34:07');
INSERT INTO `user_logs` VALUES (1994, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-16 17:41:44');
INSERT INTO `user_logs` VALUES (1995, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 17:41:46');
INSERT INTO `user_logs` VALUES (1996, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-16 17:41:50');
INSERT INTO `user_logs` VALUES (1997, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', NULL, '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [超时自动断开]', '2025-07-16 17:56:51');
INSERT INTO `user_logs` VALUES (1998, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-17 09:06:34');
INSERT INTO `user_logs` VALUES (1999, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-17 09:07:14');
INSERT INTO `user_logs` VALUES (2000, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-17 09:09:06');
INSERT INTO `user_logs` VALUES (2001, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-17 09:34:46');
INSERT INTO `user_logs` VALUES (2002, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 09:34:53');
INSERT INTO `user_logs` VALUES (2003, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-17 09:36:47');
INSERT INTO `user_logs` VALUES (2004, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-17 10:45:50');
INSERT INTO `user_logs` VALUES (2005, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-17 11:25:11');
INSERT INTO `user_logs` VALUES (2006, 3, 'zhangshujun', 'connect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.44', '用户 zhangshujun 连接SSH服务器 本地Kylin10(10.16.30.56)', '2025-07-17 11:25:28');
INSERT INTO `user_logs` VALUES (2007, 3, 'zhangshujun', 'disconnect', 21, '本地Kylin10', '10.16.30.56', '10.16.30.56', '用户 zhangshujun 断开Linux连接 本地Kylin10(10.16.30.56) [代理检测]', '2025-07-17 11:25:45');
INSERT INTO `user_logs` VALUES (2008, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-17 13:05:15');
INSERT INTO `user_logs` VALUES (2009, 10, 'zhuyiqing', 'connect', 10, 'Git仓库/Jenkins', '101.201.239.52', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 Git仓库/Jenkins(101.201.239.52)', '2025-07-17 13:05:40');
INSERT INTO `user_logs` VALUES (2010, 10, 'zhuyiqing', 'disconnect', 10, 'Git仓库/Jenkins', '101.201.239.52', '101.201.239.52', '用户 zhuyiqing 断开Linux连接 Git仓库/Jenkins(101.201.239.52) [代理检测]', '2025-07-17 13:08:38');
INSERT INTO `user_logs` VALUES (2011, 13, 'zhanglongkun', 'login', NULL, NULL, NULL, '10.16.30.8', '用户 zhanglongkun 登录系统', '2025-07-17 14:08:20');
INSERT INTO `user_logs` VALUES (2012, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 14:09:34');
INSERT INTO `user_logs` VALUES (2013, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 14:09:46');
INSERT INTO `user_logs` VALUES (2014, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 14:11:14');
INSERT INTO `user_logs` VALUES (2015, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 14:11:23');
INSERT INTO `user_logs` VALUES (2016, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 14:13:00');
INSERT INTO `user_logs` VALUES (2017, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-17 14:17:30');
INSERT INTO `user_logs` VALUES (2018, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 14:17:56');
INSERT INTO `user_logs` VALUES (2019, 10, 'zhuyiqing', 'connect', 14, '本地gitlab', '10.16.30.139', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地gitlab(10.16.30.139)', '2025-07-17 14:19:02');
INSERT INTO `user_logs` VALUES (2020, 10, 'zhuyiqing', 'disconnect', 14, '本地gitlab', '10.16.30.139', '10.16.30.139', '用户 zhuyiqing 断开Linux连接 本地gitlab(10.16.30.139) [代理检测]', '2025-07-17 14:19:11');
INSERT INTO `user_logs` VALUES (2021, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:18');
INSERT INTO `user_logs` VALUES (2022, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:39');
INSERT INTO `user_logs` VALUES (2023, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:41');
INSERT INTO `user_logs` VALUES (2024, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:49');
INSERT INTO `user_logs` VALUES (2025, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:51');
INSERT INTO `user_logs` VALUES (2026, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:19:55');
INSERT INTO `user_logs` VALUES (2027, 10, 'zhuyiqing', 'connect', 38, '刀片机', '10.16.30.24', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 刀片机(10.16.30.24)', '2025-07-17 14:22:32');
INSERT INTO `user_logs` VALUES (2028, 13, 'zhanglongkun', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhanglongkun 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-17 14:26:54');
INSERT INTO `user_logs` VALUES (2029, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', NULL, '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [超时自动断开]', '2025-07-17 14:32:56');
INSERT INTO `user_logs` VALUES (2030, 10, 'zhuyiqing', 'disconnect', 38, '刀片机', '10.16.30.24', NULL, '用户 zhuyiqing 断开Windows连接 刀片机(10.16.30.24) [超时自动断开]', '2025-07-17 14:37:32');
INSERT INTO `user_logs` VALUES (2031, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-17 15:37:42');
INSERT INTO `user_logs` VALUES (2032, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:35');
INSERT INTO `user_logs` VALUES (2033, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 15:40:43');
INSERT INTO `user_logs` VALUES (2034, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:43');
INSERT INTO `user_logs` VALUES (2035, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:45');
INSERT INTO `user_logs` VALUES (2036, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:47');
INSERT INTO `user_logs` VALUES (2037, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:49');
INSERT INTO `user_logs` VALUES (2038, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:50');
INSERT INTO `user_logs` VALUES (2039, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:52');
INSERT INTO `user_logs` VALUES (2040, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:54');
INSERT INTO `user_logs` VALUES (2041, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:40:58');
INSERT INTO `user_logs` VALUES (2042, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:10');
INSERT INTO `user_logs` VALUES (2043, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 15:41:13');
INSERT INTO `user_logs` VALUES (2044, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:14');
INSERT INTO `user_logs` VALUES (2045, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:17');
INSERT INTO `user_logs` VALUES (2046, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:20');
INSERT INTO `user_logs` VALUES (2047, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:22');
INSERT INTO `user_logs` VALUES (2048, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:24');
INSERT INTO `user_logs` VALUES (2049, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:26');
INSERT INTO `user_logs` VALUES (2050, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:29');
INSERT INTO `user_logs` VALUES (2051, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:31');
INSERT INTO `user_logs` VALUES (2052, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:41:32');
INSERT INTO `user_logs` VALUES (2053, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:47:09');
INSERT INTO `user_logs` VALUES (2054, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 15:48:38');
INSERT INTO `user_logs` VALUES (2055, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:41');
INSERT INTO `user_logs` VALUES (2056, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:43');
INSERT INTO `user_logs` VALUES (2057, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:45');
INSERT INTO `user_logs` VALUES (2058, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:47');
INSERT INTO `user_logs` VALUES (2059, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:48');
INSERT INTO `user_logs` VALUES (2060, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:50');
INSERT INTO `user_logs` VALUES (2061, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:48:52');
INSERT INTO `user_logs` VALUES (2062, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:49:10');
INSERT INTO `user_logs` VALUES (2063, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:49:20');
INSERT INTO `user_logs` VALUES (2064, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:49:23');
INSERT INTO `user_logs` VALUES (2065, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 15:49:31');
INSERT INTO `user_logs` VALUES (2066, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:13:07');
INSERT INTO `user_logs` VALUES (2067, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 16:13:53');
INSERT INTO `user_logs` VALUES (2068, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:13:58');
INSERT INTO `user_logs` VALUES (2069, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:00');
INSERT INTO `user_logs` VALUES (2070, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:03');
INSERT INTO `user_logs` VALUES (2071, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:05');
INSERT INTO `user_logs` VALUES (2072, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:07');
INSERT INTO `user_logs` VALUES (2073, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:09');
INSERT INTO `user_logs` VALUES (2074, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:11');
INSERT INTO `user_logs` VALUES (2075, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:12');
INSERT INTO `user_logs` VALUES (2076, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:14');
INSERT INTO `user_logs` VALUES (2077, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:14:46');
INSERT INTO `user_logs` VALUES (2078, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 16:15:08');
INSERT INTO `user_logs` VALUES (2079, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:16:35');
INSERT INTO `user_logs` VALUES (2080, 10, 'zhuyiqing', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-17 16:16:53');
INSERT INTO `user_logs` VALUES (2081, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-17 16:17:33');
INSERT INTO `user_logs` VALUES (2082, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-17 16:17:44');
INSERT INTO `user_logs` VALUES (2083, 10, 'zhuyiqing', 'connect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 C端编译服务器(10.16.30.180)', '2025-07-17 16:18:00');
INSERT INTO `user_logs` VALUES (2084, 10, 'zhuyiqing', 'disconnect', 2, 'C端编译服务器', '10.16.30.180', '10.16.30.180', '用户 zhuyiqing 断开Windows连接 C端编译服务器(10.16.30.180) [代理检测]', '2025-07-17 16:18:15');
INSERT INTO `user_logs` VALUES (2085, 10, 'zhuyiqing', 'logout', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 注销系统', '2025-07-17 16:25:05');
INSERT INTO `user_logs` VALUES (2086, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-17 16:25:21');
INSERT INTO `user_logs` VALUES (2087, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 17:09:46');
INSERT INTO `user_logs` VALUES (2088, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 17:09:54');
INSERT INTO `user_logs` VALUES (2089, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-17 17:18:46');
INSERT INTO `user_logs` VALUES (2090, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-17 17:55:27');
INSERT INTO `user_logs` VALUES (2091, 13, 'zhanglongkun', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhanglongkun 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-17 18:00:43');
INSERT INTO `user_logs` VALUES (2092, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-18 09:40:28');
INSERT INTO `user_logs` VALUES (2093, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-18 09:40:30');
INSERT INTO `user_logs` VALUES (2094, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-18 09:40:48');
INSERT INTO `user_logs` VALUES (2095, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-18 10:17:07');
INSERT INTO `user_logs` VALUES (2096, 10, 'zhuyiqing', 'connect', 29, '内部服务', '39.96.38.239', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 内部服务(39.96.38.239)', '2025-07-18 10:17:14');
INSERT INTO `user_logs` VALUES (2097, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-18 10:53:32');
INSERT INTO `user_logs` VALUES (2098, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-18 14:39:33');
INSERT INTO `user_logs` VALUES (2099, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-18 14:39:54');
INSERT INTO `user_logs` VALUES (2100, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-18 15:10:05');
INSERT INTO `user_logs` VALUES (2101, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-18 15:10:26');
INSERT INTO `user_logs` VALUES (2102, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-18 15:49:47');
INSERT INTO `user_logs` VALUES (2103, 10, 'zhuyiqing', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-18 15:49:51');
INSERT INTO `user_logs` VALUES (2104, 10, 'zhuyiqing', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhuyiqing 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-18 15:50:02');
INSERT INTO `user_logs` VALUES (2105, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-18 17:22:39');
INSERT INTO `user_logs` VALUES (2106, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-18 17:22:40');
INSERT INTO `user_logs` VALUES (2107, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-21 08:54:49');
INSERT INTO `user_logs` VALUES (2108, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-21 09:40:52');
INSERT INTO `user_logs` VALUES (2109, 10, 'zhuyiqing', 'connect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地Mongodb(10.16.30.200)', '2025-07-21 09:40:56');
INSERT INTO `user_logs` VALUES (2110, 10, 'zhuyiqing', 'disconnect', 19, '本地Mongodb', '10.16.30.200', '10.16.30.200', '用户 zhuyiqing 断开Linux连接 本地Mongodb(10.16.30.200) [代理检测]', '2025-07-21 09:42:02');
INSERT INTO `user_logs` VALUES (2111, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-21 10:45:22');
INSERT INTO `user_logs` VALUES (2112, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-21 10:45:39');
INSERT INTO `user_logs` VALUES (2113, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-21 10:47:19');
INSERT INTO `user_logs` VALUES (2114, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-21 13:34:16');
INSERT INTO `user_logs` VALUES (2115, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-21 13:41:07');
INSERT INTO `user_logs` VALUES (2116, 10, 'zhuyiqing', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-21 13:41:17');
INSERT INTO `user_logs` VALUES (2117, 10, 'zhuyiqing', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-21 13:41:20');
INSERT INTO `user_logs` VALUES (2118, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-21 14:02:19');
INSERT INTO `user_logs` VALUES (2119, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-21 14:02:21');
INSERT INTO `user_logs` VALUES (2120, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-21 14:50:20');
INSERT INTO `user_logs` VALUES (2121, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-21 15:58:07');
INSERT INTO `user_logs` VALUES (2122, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-21 16:49:39');
INSERT INTO `user_logs` VALUES (2123, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-22 09:11:22');
INSERT INTO `user_logs` VALUES (2124, 10, 'zhuyiqing', 'connect', 40, 'BIM服务器-3', '10.16.30.171', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 BIM服务器-3(10.16.30.171)', '2025-07-22 09:11:30');
INSERT INTO `user_logs` VALUES (2125, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-22 09:13:17');
INSERT INTO `user_logs` VALUES (2126, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-22 09:13:20');
INSERT INTO `user_logs` VALUES (2127, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-22 09:22:27');
INSERT INTO `user_logs` VALUES (2128, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-22 10:08:01');
INSERT INTO `user_logs` VALUES (2129, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-22 10:08:03');
INSERT INTO `user_logs` VALUES (2130, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-22 10:09:43');
INSERT INTO `user_logs` VALUES (2131, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-22 14:20:10');
INSERT INTO `user_logs` VALUES (2132, 10, 'zhuyiqing', 'connect', 14, '本地gitlab', '10.16.30.139', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 本地gitlab(10.16.30.139)', '2025-07-22 14:20:13');
INSERT INTO `user_logs` VALUES (2133, 10, 'zhuyiqing', 'disconnect', 14, '本地gitlab', '10.16.30.139', '10.16.30.139', '用户 zhuyiqing 断开Linux连接 本地gitlab(10.16.30.139) [代理检测]', '2025-07-22 14:21:28');
INSERT INTO `user_logs` VALUES (2134, 10, 'zhuyiqing', 'connect', 20, '夜莺监控服务器', '10.16.30.193', '10.16.30.133', '用户 zhuyiqing 连接SSH服务器 夜莺监控服务器(10.16.30.193)', '2025-07-22 14:21:31');
INSERT INTO `user_logs` VALUES (2135, 8, 'jingchen', 'login', NULL, NULL, NULL, '10.16.30.110', '用户 jingchen 登录系统', '2025-07-22 15:06:21');
INSERT INTO `user_logs` VALUES (2136, 8, 'jingchen', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.110', '用户 jingchen 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-22 15:06:22');
INSERT INTO `user_logs` VALUES (2137, 8, 'jingchen', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 jingchen 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-22 15:12:10');
INSERT INTO `user_logs` VALUES (2138, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-22 15:19:36');
INSERT INTO `user_logs` VALUES (2139, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-22 15:19:39');
INSERT INTO `user_logs` VALUES (2140, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-22 15:21:34');
INSERT INTO `user_logs` VALUES (2141, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-22 15:33:04');
INSERT INTO `user_logs` VALUES (2142, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-22 15:57:47');
INSERT INTO `user_logs` VALUES (2143, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-22 15:58:19');
INSERT INTO `user_logs` VALUES (2144, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-22 16:10:25');
INSERT INTO `user_logs` VALUES (2145, 10, 'zhuyiqing', 'disconnect', 44, '测试服务器', '10.16.30.53', '10.16.30.53', '用户 zhuyiqing 断开Windows连接 测试服务器(10.16.30.53) [代理检测]', '2025-07-22 16:10:32');
INSERT INTO `user_logs` VALUES (2146, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-22 16:10:39');
INSERT INTO `user_logs` VALUES (2147, 10, 'zhuyiqing', 'disconnect', 44, '测试服务器', '10.16.30.53', '10.16.30.53', '用户 zhuyiqing 断开Windows连接 测试服务器(10.16.30.53) [代理检测]', '2025-07-22 16:10:47');
INSERT INTO `user_logs` VALUES (2148, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-22 16:12:04');
INSERT INTO `user_logs` VALUES (2149, 10, 'zhuyiqing', 'connect', 44, '测试服务器', '10.16.30.53', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 测试服务器(10.16.30.53)', '2025-07-22 16:12:07');
INSERT INTO `user_logs` VALUES (2150, 10, 'zhuyiqing', 'disconnect', 44, '测试服务器', '10.16.30.53', '10.16.30.53', '用户 zhuyiqing 断开Windows连接 测试服务器(10.16.30.53) [代理检测]', '2025-07-22 16:12:23');
INSERT INTO `user_logs` VALUES (2151, 10, 'zhuyiqing', 'connect', 15, '数据中心', '10.16.30.168', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 数据中心(10.16.30.168)', '2025-07-22 16:14:15');
INSERT INTO `user_logs` VALUES (2152, 10, 'zhuyiqing', 'disconnect', 15, '数据中心', '10.16.30.168', '10.16.30.168', '用户 zhuyiqing 断开Windows连接 数据中心(10.16.30.168) [代理检测]', '2025-07-22 16:16:00');
INSERT INTO `user_logs` VALUES (2153, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-22 16:20:11');
INSERT INTO `user_logs` VALUES (2154, 13, 'zhanglongkun', 'login', NULL, NULL, NULL, '10.16.30.8', '用户 zhanglongkun 登录系统', '2025-07-22 17:29:30');
INSERT INTO `user_logs` VALUES (2155, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-22 17:29:31');
INSERT INTO `user_logs` VALUES (2156, 13, 'zhanglongkun', 'connect', 36, '知识库服务器', '10.16.30.239', '10.16.30.8', '用户 zhanglongkun 连接RDP服务器 知识库服务器(10.16.30.239)', '2025-07-22 17:29:47');
INSERT INTO `user_logs` VALUES (2157, 13, 'zhanglongkun', 'disconnect', 36, '知识库服务器', '10.16.30.239', '10.16.30.239', '用户 zhanglongkun 断开Windows连接 知识库服务器(10.16.30.239) [代理检测]', '2025-07-22 17:32:16');
INSERT INTO `user_logs` VALUES (2158, 13, 'zhanglongkun', 'login', NULL, NULL, NULL, '10.16.30.8', '用户 zhanglongkun 登录系统', '2025-07-23 09:01:13');
INSERT INTO `user_logs` VALUES (2159, 3, 'zhangshujun', 'login', NULL, NULL, NULL, '10.16.30.44', '用户 zhangshujun 登录系统', '2025-07-23 09:17:04');
INSERT INTO `user_logs` VALUES (2160, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-23 09:35:21');
INSERT INTO `user_logs` VALUES (2161, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-23 09:35:23');
INSERT INTO `user_logs` VALUES (2162, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-23 09:35:58');
INSERT INTO `user_logs` VALUES (2163, 10, 'zhuyiqing', 'login', NULL, NULL, NULL, '10.16.30.133', '用户 zhuyiqing 登录系统', '2025-07-23 10:54:15');
INSERT INTO `user_logs` VALUES (2164, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-23 10:54:33');
INSERT INTO `user_logs` VALUES (2165, 10, 'zhuyiqing', 'disconnect', 7, '堡垒机', '10.16.30.223', '10.16.30.223', '用户 zhuyiqing 断开Windows连接 堡垒机(10.16.30.223) [代理检测]', '2025-07-23 10:54:35');
INSERT INTO `user_logs` VALUES (2166, 10, 'zhuyiqing', 'connect', 7, '堡垒机', '10.16.30.223', '10.16.30.133', '用户 zhuyiqing 连接RDP服务器 堡垒机(10.16.30.223)', '2025-07-23 10:54:37');

-- ----------------------------
-- Table structure for user_server_permissions
-- ----------------------------
DROP TABLE IF EXISTS `user_server_permissions`;
CREATE TABLE `user_server_permissions`  (
  `user_id` int NOT NULL,
  `server_id` int NOT NULL,
  `can_access` tinyint(1) NULL DEFAULT 1,
  `can_modify` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `server_id`) USING BTREE,
  INDEX `server_id`(`server_id` ASC) USING BTREE,
  CONSTRAINT `user_server_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_server_permissions_ibfk_2` FOREIGN KEY (`server_id`) REFERENCES `servers` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_server_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password_hash` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_admin` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'scrypt:32768:8:1$aNuiYqHxuyVQ2ELy$109b438d11eceb23655fb41c802909727c3d0d2e6a1e5e8866afb6ae987b436d057d47786509902a9aa43e3a508410ff36613556c407fba1123000be28bd7db0', NULL, 1, '2025-03-21 16:12:09', NULL);
INSERT INTO `users` VALUES (3, 'zhangshujun', 'scrypt:32768:8:1$CkZITlX0zxIPfZhh$7798d3879335649c68a77ce2a96d93cc18acd73432ea19f9b48aa3865a5a3fe9e1ecb0bd9e4b8ccca0aab0a0e5c3d025ca55b34743925c106779ac6d2f2e0fbc', NULL, 0, '2025-04-30 15:30:02', NULL);
INSERT INTO `users` VALUES (5, 'chenziming', 'scrypt:32768:8:1$CC3vA9f45dgIZ33t$e3b463994831c90dd0d0466c8cb07158a91568b93dc3abaacd64f7877fed386c2b87809131fc1bfc2fec4e0855a1a4fb65184ba665c5b446f6c6abd545619bb6', NULL, 0, '2025-05-15 11:30:11', NULL);
INSERT INTO `users` VALUES (6, 'sunyj', 'scrypt:32768:8:1$NkvYrUMi513VCg3j$49de3d2f8b946c506b0ee384ff6e2c087f76aef52908cc1266f90bedf5538a408d290461c69bc8ff5b532e19443f57736a2ef7a6d9afa44d4343fe2636f24e90', NULL, 0, '2025-05-30 13:21:18', NULL);
INSERT INTO `users` VALUES (7, 'gaof', 'scrypt:32768:8:1$R9IBPq9XW0FIhFHj$db565387e92cc865e6d6c3530c8598cc87a40985e4665b630c45a06accf9f1248f46cfa249546f87b8a2d4b56b3863f2f4810d6883e12ea402687616a8a17be4', NULL, 0, '2025-06-05 14:44:53', NULL);
INSERT INTO `users` VALUES (8, 'jingchen', 'scrypt:32768:8:1$TteNbCx3KIuW5fm9$4f4e2615c12f03aebaa626b1b7f4cc4b8e2dfb3835fc6f217a19a088371fd755a43493193922fb414d3705f9bcb597b3b9b0c0b84e2a41ef618545b8a85b2b62', NULL, 0, '2025-06-24 09:37:01', NULL);
INSERT INTO `users` VALUES (9, 'zhaoyy', 'scrypt:32768:8:1$cC7KRF1ac6izRrPt$393e7913d2c43efe7c7bee8002cf6d3147d2117e3a672e9d7410086bb6e4e6f3082006ecf9b1eda31d72705f75576fecb1dab4a2c62090953a8c47594f46173a', NULL, 0, '2025-07-03 16:31:33', NULL);
INSERT INTO `users` VALUES (10, 'zhuyiqing', 'scrypt:32768:8:1$8XZfjx7SmPyv6fz9$bc276095eb9ff444cfcb7b2c4abc3cf2a59f845718fdb912b92304345f2530bca2766e3b7a0fdd7b6250bf1fc58e70b6200dd2a3f3e888ff5cad1090029a9554', NULL, 1, '2025-07-03 17:09:42', NULL);
INSERT INTO `users` VALUES (11, 'xiangzf', 'scrypt:32768:8:1$UcG1ZfhBljHHlAsf$2a98e36dd4a32141fd91d7f8b2b57e6358e8b34da2246f23acd8e5bda996e59da4e8eee772ef8f3c4ee46fc852ad76ff71c18a96731b95b9d3eb5cb7ac8367d8', NULL, 0, '2025-07-08 13:53:17', NULL);
INSERT INTO `users` VALUES (12, 'test', 'scrypt:32768:8:1$RtYrTMycSsRSwncP$1391347b154309969350a69958921153924195c1713b9d38c9b43bd8e3c1acb7e51fd03899a36ebd9d9519f49ca0940b5a428828e0c4ad1fd48a7fbe96496929', NULL, 0, '2025-07-16 15:02:27', NULL);
INSERT INTO `users` VALUES (13, 'zhanglongkun', 'scrypt:32768:8:1$Erh641JWwu2t6YQ1$cf7dfe6cf74bb3468e54848e92b0ee3ffd0d88f353f9d132a0ce27e675b78cdef108352c38505d7ada3ea9f6283aa490d809a67343bc9c7d84c66a4261eb8533', NULL, 0, '2025-07-17 14:07:29', NULL);

SET FOREIGN_KEY_CHECKS = 1;
