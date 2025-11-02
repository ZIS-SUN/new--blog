-- 个人博客系统数据库设计
-- 数据库版本: MySQL 8.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 创建数据库
-- ----------------------------
DROP DATABASE IF EXISTS `personal_blog`;
CREATE DATABASE `personal_blog` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `personal_blog`;

-- ----------------------------
-- 表结构: 用户表
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(64) NOT NULL COMMENT '密码(MD5加密)',
  `email` VARCHAR(100) NOT NULL COMMENT '邮箱',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `role` TINYINT(1) DEFAULT 0 COMMENT '角色: 0-普通用户, 1-管理员',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ----------------------------
-- 表结构: 分类表
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
  `article_count` INT(11) DEFAULT 0 COMMENT '文章数量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_category_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- ----------------------------
-- 表结构: 标签表
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `tag_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `article_count` INT(11) DEFAULT 0 COMMENT '文章数量',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_tag_name` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- ----------------------------
-- 表结构: 文章表
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `article_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '作者ID',
  `category_id` BIGINT(20) DEFAULT NULL COMMENT '分类ID',
  `title` VARCHAR(200) NOT NULL COMMENT '文章标题',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '文章摘要',
  `content` LONGTEXT NOT NULL COMMENT '文章内容(Markdown)',
  `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图片URL',
  `view_count` INT(11) DEFAULT 0 COMMENT '阅读数',
  `like_count` INT(11) DEFAULT 0 COMMENT '点赞数',
  `comment_count` INT(11) DEFAULT 0 COMMENT '评论数',
  `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶: 0-否, 1-是',
  `status` TINYINT(1) DEFAULT 0 COMMENT '状态: 0-草稿, 1-已发布',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_publish_time` (`publish_time`),
  FULLTEXT KEY `ft_title_content` (`title`, `content`) WITH PARSER ngram
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- ----------------------------
-- 表结构: 文章标签关联表
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `article_id` BIGINT(20) NOT NULL COMMENT '文章ID',
  `tag_id` BIGINT(20) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_tag` (`article_id`, `tag_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';

-- ----------------------------
-- 表结构: 评论表
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `article_id` BIGINT(20) NOT NULL COMMENT '文章ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '评论用户ID',
  `parent_id` BIGINT(20) DEFAULT NULL COMMENT '父评论ID(用于回复)',
  `content` TEXT NOT NULL COMMENT '评论内容',
  `status` TINYINT(1) DEFAULT 0 COMMENT '状态: 0-待审核, 1-已通过, 2-已屏蔽',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  PRIMARY KEY (`comment_id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- ----------------------------
-- 表结构: 留言表
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `message_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '留言ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '留言用户ID',
  `parent_id` BIGINT(20) DEFAULT NULL COMMENT '父留言ID(用于回复)',
  `content` TEXT NOT NULL COMMENT '留言内容',
  `status` TINYINT(1) DEFAULT 0 COMMENT '状态: 0-待审核, 1-已通过, 2-已屏蔽',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '留言时间',
  PRIMARY KEY (`message_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='留言表';

-- ----------------------------
-- 表结构: 公告表
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `announcement_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` VARCHAR(200) NOT NULL COMMENT '公告标题',
  `content` TEXT NOT NULL COMMENT '公告内容',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '公告摘要',
  `is_top` TINYINT(1) DEFAULT 0 COMMENT '是否置顶: 0-否, 1-是',
  `is_emergency` TINYINT(1) DEFAULT 0 COMMENT '是否紧急: 0-否, 1-是',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态: 0-隐藏, 1-发布',
  `publish_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`announcement_id`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_is_top` (`is_top`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';

-- ----------------------------
-- 表结构: 系统日志表
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `log_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` BIGINT(20) DEFAULT NULL COMMENT '操作用户ID',
  `username` VARCHAR(50) DEFAULT NULL COMMENT '操作用户名',
  `operation` VARCHAR(100) NOT NULL COMMENT '操作类型',
  `method` VARCHAR(200) DEFAULT NULL COMMENT '请求方法',
  `params` TEXT DEFAULT NULL COMMENT '请求参数',
  `ip` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
  `location` VARCHAR(100) DEFAULT NULL COMMENT 'IP归属地',
  `status` TINYINT(1) DEFAULT 1 COMMENT '状态: 0-失败, 1-成功',
  `error_msg` TEXT DEFAULT NULL COMMENT '错误信息',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统日志表';

-- ----------------------------
-- 表结构: 访问统计表
-- ----------------------------
DROP TABLE IF EXISTS `visit_log`;
CREATE TABLE `visit_log` (
  `visit_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `ip` VARCHAR(50) NOT NULL COMMENT 'IP地址',
  `page` VARCHAR(255) DEFAULT NULL COMMENT '访问页面',
  `device_type` VARCHAR(50) DEFAULT NULL COMMENT '设备类型',
  `browser` VARCHAR(100) DEFAULT NULL COMMENT '浏览器',
  `os` VARCHAR(100) DEFAULT NULL COMMENT '操作系统',
  `visit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
  PRIMARY KEY (`visit_id`),
  KEY `idx_visit_time` (`visit_time`),
  KEY `idx_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问统计表';

-- ----------------------------
-- 表结构: 系统配置表
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `config_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `config_value` TEXT DEFAULT NULL COMMENT '配置值',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '配置描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ----------------------------
-- 初始化管理员账户
-- 用户名: admin, 密码: admin123 (MD5加密)
-- ----------------------------
INSERT INTO `user` (`username`, `password`, `email`, `nickname`, `role`, `status`) 
VALUES ('admin', '0192023a7bbd73250516f069df18b500', 'admin@blog.com', '系统管理员', 1, 1);

-- ----------------------------
-- 初始化系统配置
-- ----------------------------
INSERT INTO `system_config` (`config_key`, `config_value`, `description`) VALUES
('blog_name', '个人技术博客', '博客名称'),
('blog_subtitle', '分享技术，记录生活', '博客副标题'),
('author_name', '博主', '作者名称'),
('author_email', 'author@blog.com', '作者邮箱'),
('author_avatar', '', '作者头像'),
('author_intro', '热爱技术，热爱生活', '作者简介'),
('social_github', '', 'GitHub链接'),
('social_wechat', '', '微信二维码'),
('social_qq', '', 'QQ号码'),
('jwt_expire_time', '86400', 'JWT过期时间(秒)'),
('upload_max_size', '2097152', '上传文件最大大小(字节)');

-- ----------------------------
-- 初始化示例分类
-- ----------------------------
INSERT INTO `category` (`category_name`, `description`) VALUES
('技术分享', '技术相关的文章'),
('生活随笔', '生活感悟与随笔'),
('学习笔记', '学习过程中的笔记整理');

-- ----------------------------
-- 初始化示例标签
-- ----------------------------
INSERT INTO `tag` (`tag_name`) VALUES
('Java'),
('Spring Boot'),
('Vue'),
('MySQL'),
('前端'),
('后端');

-- ----------------------------
-- 初始化示例公告
-- ----------------------------
INSERT INTO `announcement` (`title`, `content`, `summary`, `is_top`, `is_emergency`, `status`) VALUES
('欢迎来到个人博客系统', '这是一个基于Spring Boot和Vue 3开发的个人博客系统，采用鸿蒙设计语言，支持文章发布、评论互动、数据统计等功能。', '欢迎使用本博客系统', 1, 0, 1);

SET FOREIGN_KEY_CHECKS = 1;

