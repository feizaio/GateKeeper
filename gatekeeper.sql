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

 Date: 16/05/2025 14:10:59
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, '生产服务器', '描述1', '2025-03-21 16:22:15', '2025-03-24 10:37:20');
INSERT INTO `categories` VALUES (2, '阿里云服务器', '', '2025-04-22 16:59:10', '2025-04-22 16:59:10');
INSERT INTO `categories` VALUES (3, '运维服务器', '', '2025-04-22 17:25:04', '2025-04-22 17:25:04');
INSERT INTO `categories` VALUES (4, '测试服务器', '', '2025-04-30 15:41:11', '2025-04-30 15:41:11');

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clients
-- ----------------------------
INSERT INTO `clients` VALUES (1, '10.16.30.133', 45654, '1.0.0', NULL, NULL, NULL, '2025-05-16 14:10:11', '2025-04-21 08:00:03');
INSERT INTO `clients` VALUES (2, '10.16.30.180', 45654, '1.0.0', NULL, NULL, NULL, '2025-04-24 16:00:38', '2025-04-22 06:25:32');
INSERT INTO `clients` VALUES (3, '10.16.30.44', 45654, '1.0.0', NULL, NULL, NULL, '2025-04-30 16:53:21', '2025-04-22 09:11:21');
INSERT INTO `clients` VALUES (4, '10.16.30.7', 45654, '1.0.0', NULL, NULL, NULL, '2025-04-30 13:35:38', '2025-04-22 09:43:36');
INSERT INTO `clients` VALUES (5, '10.16.30.223', 45654, '1.0.0', NULL, NULL, NULL, '2025-05-16 14:10:54', '2025-04-27 01:25:26');
INSERT INTO `clients` VALUES (6, '10.16.30.24', 45654, '1.0.0', NULL, NULL, NULL, '2025-05-15 11:15:04', '2025-04-27 01:33:13');
INSERT INTO `clients` VALUES (7, '10.16.30.235', 45654, '1.0.0', NULL, NULL, NULL, '2025-04-30 13:06:25', '2025-04-30 02:33:41');
INSERT INTO `clients` VALUES (8, '10.16.30.59', 45654, '1.0.0', NULL, NULL, NULL, '2025-05-15 23:41:53', '2025-05-15 03:31:34');

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
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of credentials
-- ----------------------------

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
INSERT INTO `server_users` VALUES (3, 9);
INSERT INTO `server_users` VALUES (3, 11);
INSERT INTO `server_users` VALUES (3, 13);
INSERT INTO `server_users` VALUES (3, 15);
INSERT INTO `server_users` VALUES (3, 16);
INSERT INTO `server_users` VALUES (3, 17);
INSERT INTO `server_users` VALUES (3, 18);
INSERT INTO `server_users` VALUES (3, 21);
INSERT INTO `server_users` VALUES (3, 22);
INSERT INTO `server_users` VALUES (5, 31);

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
  `key_passphrase` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `in_use_by`(`in_use_by` ASC) USING BTREE,
  CONSTRAINT `servers_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `servers_ibfk_2` FOREIGN KEY (`in_use_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servers
-- ----------------------------
INSERT INTO `servers` VALUES (2, 'C端编译服务器', '10.16.30.180', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm4zU0hZY1ZuSWxvMkczbUU5MFJLLWRyZzRYSDJETlYyWnNBQ3RzV0pXWTBJbUdma1FyWjRLNVltZWQwZlpiOXo5c3hOajdRa2gwY1UtR29Pc1h1N0RMSzJiS1E9PQ==', NULL, NULL, NULL, NULL, '2025-03-21 16:22:32', '2025-05-14 13:38:58', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (6, 'BIM服务器-2', '59.110.28.130', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9CMXFaaTFXTUNrLXlnX1k4UENSd1d3aEllM2dtX3ZnVUJiekY5UGRCRmZtdzVJMmdJVGxaTHBiLWwwTHpWR3dzcDhGZkY4cEZxNkwxRFU3bXhDNlgtSV9CYk4zbEFKYTZZQmZ3U3FSNlZCb1RRNjA9', NULL, 2, NULL, NULL, '2025-04-22 17:00:11', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (7, '堡垒机', '10.16.30.223', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FRFJHMmJIUS00bVFTTlpmZUoxSkxpZEU2SHlJR2hOd2h2LVlDeTlxdC04dEgwb2xZYUdpbjJZQ2VQek9KdmI2bzZjNThNeUlOclR4X2I2QzlPeEZMTGt0NUE9PQ==', NULL, 3, NULL, NULL, '2025-04-29 10:07:03', '2025-05-16 13:35:48', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (8, '项目案例', '123.56.161.149', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTJTNC1UaFhsbERqYThYdm44dERwWFdjR1BBMjNCX3ItN3ZCUW9XSGhWanNTaVJMUlp1QTBjajVWNHF6R2RuN09rTHkwUU1GM0JpQl83OHJsLU5vYTZSU0NoWkt0UnZTTU95YXlDRDhNVVVQc3c9', NULL, 2, NULL, NULL, '2025-04-30 10:40:19', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (9, 'BIM服务器-1', '8.140.152.230', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTRvMU42Q09vLTAtVTZSNUN0NFZ0Qngxa1VjdFFHQzdncEFTXzZ5SklEbk02dGV3cjFPNHJyeXlHSW9yZEVOdmppRmRGblRNeEg1V1Z4R1JjVWhjSWpITFViTUpfdVpSLVZiekdJanQyaU1XR3c9', NULL, 2, NULL, NULL, '2025-04-30 10:42:48', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (10, 'Git仓库/Jenkins', '101.201.239.52', 22, 'Linux', 'root', 'Z0FBQUFBQm9FWTVoandBaFFpUThnVF9hbm9nNE5BRWd5ZmZLYU5aSWtGWXQ5RjQzS21tTW5Rd1VfZUpsZzRZT3dGOGQweG10Q1lVTWhiT21ZajlDVFFLTnJFUkZvTklaZGFFTGo5OFJKWjE1c2k1cC1BLUg3ejg9', NULL, 2, NULL, NULL, '2025-04-30 10:43:45', '2025-05-14 14:19:21', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (11, '预生产-WIN', '47.94.213.245', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTZrUXBjazVjeVRRbzRUaTVYU0FjVnFvQkp2U3JKdDV4TTFDQ05nMUtKSEREdDJsUUViSDJPeUF4dFdMVHVLbjVkSTRPWjB1NDJOVG4tbWtJYkhjU0JHVV9XNXFTZWtJRXpkUEVKVi1laFotZzQ9', NULL, 2, NULL, NULL, '2025-04-30 10:44:53', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (12, '许可-CRM', '123.56.96.169', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FWThIbHRqbkRUeWc5WTVFcThOVTNCaHQwQ004cWhhSTQ1Y3JRa2c2d2lIb1VCT2FJdTU5V0ZEbjZjWTJfTHJIc1RyQnVvMVVuOC1HVUY3YzE4ZTFGVTRaRWRCVFRROUFhVzZOTURPVm4weUY2TzA9', NULL, 2, NULL, NULL, '2025-04-30 10:46:32', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (13, 'Earth主站', '60.205.201.247', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FWTg4eW1ta0M4clhIMmVPazRpWkhaVXA3MVMwbmE2NmhOUkRnNUhvTW9OcG40M016VDdDa1VfeTRYa1VFQlF1U1p2NnRadTRnWk5BemZKSUxHbFVOaUl6Z2hoZEU0SHl3b2VmLWF5REJVbVV2UE09', NULL, 2, NULL, NULL, '2025-04-30 10:47:24', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (14, '本地gitlab/知识库', '10.16.30.139', 22, 'Linux', 'root', 'Z0FBQUFBQm9FWS04SF9Pb2RpdGNWQkhmZEJJMEIzYkdSdVdBUjAtaHVYcGdrM0JoTFIweHNVMUtFRXI3VzY5MzRWc2psOHNFNWg0TnBHa3VHVWtSSWk2T1JoUmtubjhCRC1pNlpZcTRTYzQ5eFB3eGZBOWUybGc9', NULL, 3, NULL, NULL, '2025-04-30 10:49:32', '2025-05-14 15:02:32', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (15, '数据中心', '10.16.30.168', 22, 'Windows', 'sjzx', 'Z0FBQUFBQm9FYlZFYTNsV1ZpMHUtYURkZzBCOVBmOEQ3cnllcHBCd2tfd0JZMTFBaG5XbG9wTlQwa21qSWVWUHlVU0x3WVBuNzZ2c3JjcVJyY0pMT2d4M3FFZ1BMRmZPcWc9PQ==', NULL, 1, NULL, NULL, '2025-04-30 13:29:40', '2025-04-30 15:45:59', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (16, '图新云GIS开发联调环境-1', '10.16.30.27', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FYlc3aGNZZUpuVF9KdEprSTJtVU53cnR6anBFRzF1ZW5RaGUzMDdKZmVyako2WDViZkNYTlB4WjNpeVN6dXNVZlRvVlZnV2NXSUhVNlRKd1AwTGN2OGkzY3gzQlJEVjczVjlhMlhjY2d5RW5jRWs9', NULL, 4, NULL, NULL, '2025-04-30 13:31:40', '2025-05-15 11:27:40', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (17, '测试环境-1', '10.16.30.161', 3389, 'Windows', 'administrator', 'Z0FBQUFBQm9FYmNfb0djUkM3RGl6UE53SGZIejFQWmFBN0NLX1RDTmtqc3I4dFNINDAyRlNSVEM5YnRCV0RtRHBCYlFHUlFHYUVxWDRHUERPejBycGppT1hPOTltMEFkWkE9PQ==', NULL, 4, NULL, NULL, '2025-04-30 13:32:24', '2025-05-15 11:27:40', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (18, '图新云GIS开发联调环境-2', '10.16.30.113', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9FYllIYXpTazl5M0NTQU9jZnlGaHgwNVpnMjRCV2FyZWt6UDZsVjh4T19YZVBHUEppV3FqNkVvalNacXhlaldvcEhKWFJENjVTZlFoalJxcDItVXJONjlZS0E9PQ==', NULL, 4, NULL, NULL, '2025-04-30 13:32:55', '2025-05-15 11:27:40', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (19, '本地Mongodb', '10.16.30.200', 22, 'Linux', 'root', 'Z0FBQUFBQm9FYjVCTFVNM1dzVXJuYS1UVXE1elBDcXdhYWxueVp1dThCa2Uybk9PTVNFYklocGZNRjVjcjR3WlNQQlZaeUYtV2xkblE0TWN5SnpsTnVEbjIzTERBSldpUUliSXhvb2xadTlTVWtKczUxbmtnTG89', NULL, 1, NULL, NULL, '2025-04-30 14:08:02', '2025-05-14 10:49:28', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (20, '夜莺监控服务器', '10.16.30.193', 22, 'Linux', 'root', 'Z0FBQUFBQm9FZEViWXozMGxuMkJtNXJKZHg3RGRJVDFycGRCSHZXVUR2SWNmTExoc1ZHYlFiWERyc3BYTFQxNi1TSHB5bHl3WEpNTGNzbS12emdfckd1c0lZSlJLQlhWbEMxeGtSaVNyYW9vM2labTZtenVlMFU9', NULL, 3, NULL, NULL, '2025-04-30 15:28:28', '2025-05-08 14:32:40', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (21, '本地Kylin10', '10.16.30.56', 22, 'Linux', 'root', 'Z0FBQUFBQm9FZEpBcm0yNkttUDVDalBPbEhrTTJEeW9ZMU9va1k2MzVNRGR2emE2VEhHa09YT0ZQbG1TR3l2TU95VkJwTzc0YzNMRmZfZ0E3dWtxQy1FanFhTmxIYm54OFZnQUxkdG5kVlVTTlRyRTVQWVlrbEU9', NULL, NULL, NULL, NULL, '2025-04-30 15:33:21', '2025-04-30 16:05:17', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (22, '内部数据库', '10.16.30.36', 22, 'Linux', 'root', 'Z0FBQUFBQm9FZE4yRVVWRE5RdFJpNHZIM2UwaExDSUZGMTF6ZjRmRkRhNHhOZ3ZySEs1Ujg0SW5uTW1kOGtldDJWNjFlTXdGOXR5NFdYMVJiZkw5WEg2NGRUbTlXYUxCa3c9PQ==', NULL, NULL, NULL, NULL, '2025-04-30 15:37:21', '2025-05-12 15:02:21', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (23, '研发测试', '10.16.30.172', 3389, 'Windows', 'tuxin', 'Z0FBQUFBQm9IVmY3am9GdkRXWl9nTXhORERCbzJ1MEpGMUFSbHYyTlBHVE50czJWcXNsS0MwN0FUSUI0NV9PN0sxZTVBbUxWc05GcGV3c1VFQzFfSnlPWDNZZzA3S0JtSlE9PQ==', NULL, 4, NULL, NULL, '2025-05-09 09:18:53', '2025-05-15 11:27:40', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (25, 'uat-linux', '39.105.106.222', 22, 'Linux', 'root', 'Z0FBQUFBQm9JWnhMMXBOT3BWWTNreHctYV9qUk5PWG4yU2pWQzh3TlJkWjdwOHd4LWg2dHhaa1c1bjZxM254NDVpQTllME9vbFl6eC1MdXp0MGRTbVRuSlc5bE5jdGRoNWUzVlNRMFg5NWkyYzlpOUw1ajRYbUU9', NULL, 2, NULL, NULL, '2025-05-12 14:28:27', '2025-05-14 14:14:47', 'password', NULL, '-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-128-CBC,230971B3FDFCD772E4A54336CA54CC84\n\nbN+HZ8bQtV2b2WHtX8bvK5EJO3ij508HersVkoGdWViiVzIw2Lk7/u4BStqsGZCD\nST3177W6uZt75I0Ij9Px/C3CXN5qgIWuxVBXcQ/cNWPTQk7bpTzjLUNny+wg3TQi\nFTS7Vn9uUaba4izNFzP5siBuEAJsE/JB6Jezc9wxZ6Be3DjqwSXvhr32VeUazriz\nQLXnLHJU37HIfVBrZhL4pjHNSSyml+yTmLbXhHL3DFFUHO9KyrwTWY87Bd/oOUwY\nbKoxcnaBbt0wmGidJYBDy0B/B/IzHGdnj1XiSbEJ8lcg6ZM3+UZPzN4bOiuQ3CHW\n0n5p7yMU2ccT8srFNcO5zKYsKnkWqXHODs0/IsjXb0cXWJY5uHdDG5WL8AbYBVLX\nfcAnNmx0Hgqc1PU84j5OTqfoVzdnmdXYGD2MQuTLjceKfK5lDhlNbsRRG1GNGAG3\n75PRY/wyKt6iJqjoJlzPaVRaJkWcTy7m+F0eKv9L9mIVbGevqssJ/xiXuaM837HB\nz0QhPRKlJ8XXeS+E/hsbrQaQi1cliOGE7vpo6Yup0tmrBfu+xHJJOND/sljo0w6f\nqcXmeNV3ffmTy4QHnndJW8xa97qeApnK9GNHfFs5ps7cmH/GjSXO5bI6sGW5DSrm\ndVVmMGL5Psr4NueYg/8TMRu9OCD99698c/sR00Rdv6DnwoLprCMyqbn8n0D5nOV1\nHE2R49700BkDLhjnbry6N3jl91Sf/O5iwN+gMhHszhGw8m6En8HfhCuhQvcuRrFT\ngOXzuKvSmnCWATQTxUZ3iJ5JXz2tAHxAcx7Isu/zz41YIGpjDziAAQrQwvP+Pw3u\n7RfU/Lo9sX1TuPWDuYgBWRuZSu5GPuTfysi+YSgyVafpQAB5agdxyCjEZMVktGaH\nd6IR+IYC7KwZBbrdr2BE3BiZ+nqU5x61pB8oHiWP2rnFs5rxe9F10efTopcG2Vg6\nMHnWWtrRHQ4yqDcoyiZ6cXIIGWlf3rj9fQXsROzs85NJjiS9KARGrBxG43ZzVC5l\nay+rtcphgKHS3/0Sgfe1S3Fhj7Dv7XQ4+XGUA2srokyTJ7wte3Kss4+X96dXS2Dg\nGt8KGdH0v+96eBX+cxJNfiMmTEy6qS94y3MDLK6piDECqAgK2hYBKlfvJsBbcZY1\n7xJgYNMkt6vqor1O+8QE7KKXyGIJRqCwfXAfqYAmA1ocWw7VsMMxerJBu++KjtFx\n+xN6WayH4gBm8tdItjzQZJCiWuhpKMJvPS32u4SdRltC09p2xNIKl8j0eF9p38CS\nmwezU0463FD6CUfHAKm5qNlYcrl0Brk9DIwB++XlwR4zVF9OJiACeEKpJuUiJiwC\nvBe0VsMRfg3+tOd1OzPbkuGmlAMvrmY8rbZh5xUVTz71ApgW8r/eXaBiFAkd9OQO\nYo5qGiuaN4v5UJ2vR8FrC6GfrOjDSeNikHiqSn2F49cJ/wuvSEPY6o2NcHw9ztQI\nwreNBVLGlMXs2oLyFfUFlVplPTSTx1OfNVKjVQyFsFXnjMqrELVgMGEFnkXsrxqF\nk3Kln2xpAWyN/2L6/xbqL4RMktWS0Zo7n/ttf6PEn/jfDtrX8lJdbw9zHWs1oLjW\n-----END RSA PRIVATE KEY-----\n', 'd:\\gatekeeper', 'Z0FBQUFBQm9JWnd5aUY3QUZTdEN3WWs4LVlIYzQ3Vkh5YlQ2WjhGZ1MyRjhHQ2t6V2NsVkE4MjZ2bU1VRGx4ZkdEYnlRenpRYzlqY0dBWnR3dkFqTHVpVS13a0FPU1lZQ0E9PQ==');
INSERT INTO `servers` VALUES (29, '内部服务', '39.96.38.239', 20000, 'Linux', 'szkjc', 'Z0FBQUFBQm9JYWcwTVRDX0xrNkJEQUQ5VlFqdUhsa0tYS29pRW1nblRXQVJJNzc1VTl3dkItM0lhS0hxbGlodk9TbnRyTmZKNkVRY1gyemVXbk1aYUhhTGtmYUQtOXVwSGc9PQ==', NULL, 2, NULL, NULL, '2025-05-12 15:50:14', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (30, '用户中心集群-1', '182.92.65.158', 20000, 'Linux', 'kjc', 'Z0FBQUFBQm9JYXBsNk1kQ3NKeDEteFBlNkJfZjJuN2pDdXJFdlA0d0FzQ2Z4T3NNUkJkYVlsWUFIQnRfUVZZTWZXLXB3WFZmMlUtblQ2ZU5oVHBCdGpqRlZ6VUo2V1h6MWNoWHJ6dVdCc2JCaDlhNWgwYlE5Mjg9', NULL, 2, NULL, NULL, '2025-05-12 15:54:01', '2025-05-14 14:14:47', 'password', NULL, NULL, NULL, NULL);
INSERT INTO `servers` VALUES (31, '中交测试环境', '10.16.30.109', 22, 'Windows', 'administrator', 'Z0FBQUFBQm9KVjhqYmZ5b19ocWdEUWxONm51WE1qTXBKUGtjQXhVc3FGXzViUmhDa3NWd0tpYU9KUDh1MmVwNGQtd0ZJamJSeHczNGhUQ1d0ZFR2UTllNnpKQlNFN0ZMb3c9PQ==', NULL, 4, NULL, NULL, '2025-05-15 11:27:32', '2025-05-15 11:46:38', 'password', NULL, NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 754 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'scrypt:32768:8:1$aNuiYqHxuyVQ2ELy$109b438d11eceb23655fb41c802909727c3d0d2e6a1e5e8866afb6ae987b436d057d47786509902a9aa43e3a508410ff36613556c407fba1123000be28bd7db0', NULL, 1, '2025-03-21 16:12:09', NULL);
INSERT INTO `users` VALUES (3, 'zhangshujun', 'scrypt:32768:8:1$yyaqCCMNTW3uaKHf$09105986cd079ea8f8282d6090981be096555eff6a1dd2a9d54bc9cedd24fe5cb430cd26b4a53b191b3e91f0d199540fed9dc0285a35c918eab2b496aa273224', NULL, 0, '2025-04-30 15:30:02', NULL);
INSERT INTO `users` VALUES (5, 'chenziming', 'scrypt:32768:8:1$CC3vA9f45dgIZ33t$e3b463994831c90dd0d0466c8cb07158a91568b93dc3abaacd64f7877fed386c2b87809131fc1bfc2fec4e0855a1a4fb65184ba665c5b446f6c6abd545619bb6', NULL, 0, '2025-05-15 11:30:11', NULL);

SET FOREIGN_KEY_CHECKS = 1;
