-- 个人博客系统测试数据
-- 在导入 blog_schema.sql 后执行此脚本

USE `personal_blog`;

-- ----------------------------
-- 插入测试用户数据
-- 密码都是: test123 (MD5加密后的值)
-- ----------------------------
INSERT INTO `user` (`username`, `password`, `email`, `nickname`, `role`, `status`) VALUES
('testuser1', 'cc03e747a6afbbcbf8be7668acfebee5', 'user1@test.com', '测试用户1', 0, 1),
('testuser2', 'cc03e747a6afbbcbf8be7668acfebee5', 'user2@test.com', '测试用户2', 0, 1),
('testuser3', 'cc03e747a6afbbcbf8be7668acfebee5', 'user3@test.com', '技术博主', 0, 1),
('testuser4', 'cc03e747a6afbbcbf8be7668acfebee5', 'user4@test.com', '代码爱好者', 0, 1),
('testuser5', 'cc03e747a6afbbcbf8be7668acfebee5', 'user5@test.com', 'Java开发者', 0, 0);

-- ----------------------------
-- 插入更多分类
-- ----------------------------
INSERT INTO `category` (`category_name`, `description`, `article_count`) VALUES
('前端开发', '前端技术相关文章', 0),
('后端开发', '后端技术相关文章', 0),
('数据库', '数据库相关知识', 0),
('运维部署', '服务器运维与部署', 0),
('算法学习', '数据结构与算法', 0);

-- ----------------------------
-- 插入更多标签
-- ----------------------------
INSERT INTO `tag` (`tag_name`, `article_count`) VALUES
('React', 0),
('TypeScript', 0),
('Node.js', 0),
('Python', 0),
('Docker', 0),
('Kubernetes', 0),
('Redis', 0),
('MongoDB', 0),
('Linux', 0),
('Git', 0),
('微服务', 0),
('云计算', 0);

-- ----------------------------
-- 插入测试文章
-- ----------------------------
INSERT INTO `article` (`user_id`, `category_id`, `title`, `summary`, `content`, `cover_image`, `view_count`, `like_count`, `comment_count`, `is_top`, `status`, `publish_time`) VALUES
(1, 4, 'Spring Boot 入门教程', '本文介绍Spring Boot框架的基础知识和快速上手方法', '# Spring Boot 入门教程

## 什么是 Spring Boot

Spring Boot 是由 Pivotal 团队提供的全新框架，其设计目的是用来简化新 Spring 应用的初始搭建以及开发过程。

## 主要特性

1. **独立运行** - 内嵌Tomcat、Jetty等容器
2. **简化配置** - 自动配置Spring和第三方库
3. **无代码生成** - 无需XML配置
4. **生产就绪** - 提供健康检查、指标监控等功能

## 快速开始

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

## 总结

Spring Boot 大大简化了 Spring 应用的开发流程，让开发者可以专注于业务逻辑的实现。', NULL, 156, 23, 8, 1, 1, NOW()),

(1, 5, 'Vue 3 Composition API 详解', 'Vue 3 带来了全新的 Composition API，让代码组织更加灵活', '# Vue 3 Composition API 详解

## 为什么需要 Composition API

在 Vue 2 中，我们使用 Options API 来组织代码，但当组件变得复杂时，相关逻辑会分散在不同的选项中。

## 核心概念

### 1. setup 函数

```javascript
export default {
  setup() {
    const count = ref(0)
    const increment = () => count.value++
    
    return { count, increment }
  }
}
```

### 2. reactive 和 ref

- `reactive`: 用于对象
- `ref`: 用于基本类型

### 3. computed 和 watch

```javascript
const doubled = computed(() => count.value * 2)

watch(count, (newVal, oldVal) => {
  console.log(`count changed: ${oldVal} -> ${newVal}`)
})
```

## 优势

1. 更好的代码复用
2. 更清晰的代码组织
3. 更好的 TypeScript 支持

## 结论

Composition API 是 Vue 3 的重要特性，值得深入学习。', NULL, 234, 45, 12, 1, 1, NOW()),

(1, 6, 'MySQL 性能优化实战', '分享MySQL数据库性能优化的实用技巧和经验', '# MySQL 性能优化实战

## 索引优化

### 1. 选择合适的索引类型

- 普通索引
- 唯一索引
- 全文索引
- 组合索引

### 2. 索引使用原则

```sql
-- 好的索引使用
SELECT * FROM users WHERE username = ''admin'';

-- 避免索引失效
SELECT * FROM users WHERE LEFT(username, 3) = ''adm'';
```

## 查询优化

### 使用 EXPLAIN 分析

```sql
EXPLAIN SELECT * FROM articles WHERE category_id = 1;
```

### 避免 SELECT *

只查询需要的字段可以减少数据传输量。

## 表结构优化

1. 选择合适的数据类型
2. 适当的表分区
3. 垂直分表和水平分表

## 配置优化

- innodb_buffer_pool_size
- max_connections
- query_cache_size

## 总结

性能优化是一个持续的过程，需要根据实际情况不断调整。', NULL, 189, 34, 6, 0, 1, NOW()),

(1, 4, 'Docker 容器化部署指南', '使用Docker容器化部署Spring Boot应用', '# Docker 容器化部署指南

## Docker 简介

Docker 是一个开源的容器化平台，可以将应用及其依赖打包成标准化的容器。

## 安装 Docker

```bash
# Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 验证安装
docker --version
```

## 创建 Dockerfile

```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## 构建镜像

```bash
docker build -t my-app:1.0 .
```

## 运行容器

```bash
docker run -d -p 8080:8080 --name my-app my-app:1.0
```

## Docker Compose

```yaml
version: ''3''
services:
  app:
    build: .
    ports:
      - "8080:8080"
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
```

## 最佳实践

1. 使用多阶段构建
2. 最小化镜像大小
3. 不在镜像中存储敏感信息
4. 使用 .dockerignore

## 总结

Docker 让应用部署变得简单和一致。', NULL, 278, 56, 15, 0, 1, NOW()),

(1, 8, 'Redis 缓存应用实战', 'Redis在实际项目中的应用场景和最佳实践', '# Redis 缓存应用实战

## Redis 介绍

Redis 是一个开源的内存数据结构存储系统，可以用作数据库、缓存和消息代理。

## 常见应用场景

### 1. 缓存热点数据

```java
@Cacheable(value = "articles", key = "#id")
public Article getArticle(Long id) {
    return articleRepository.findById(id);
}
```

### 2. 分布式锁

```java
Boolean locked = redisTemplate.opsForValue()
    .setIfAbsent("lock:order:" + orderId, "1", 10, TimeUnit.SECONDS);
```

### 3. 计数器

```java
redisTemplate.opsForValue().increment("article:view:" + articleId);
```

### 4. 排行榜

```java
redisTemplate.opsForZSet().add("hot:articles", articleId, score);
```

## 数据类型

1. String - 字符串
2. Hash - 哈希表
3. List - 列表
4. Set - 集合
5. Sorted Set - 有序集合

## 持久化

- RDB - 快照
- AOF - 追加文件

## 最佳实践

1. 设置合理的过期时间
2. 使用连接池
3. 避免大key
4. 选择合适的数据类型

## 总结

Redis 是现代应用架构中不可或缺的组件。', NULL, 167, 28, 7, 0, 1, NOW()),

(2, 5, 'React Hooks 完全指南', 'React Hooks 让函数组件拥有状态管理能力', '# React Hooks 完全指南

## 什么是 Hooks

Hooks 是 React 16.8 引入的新特性，让你在不编写 class 的情况下使用 state 和其他 React 特性。

## 常用 Hooks

### useState

```jsx
const [count, setCount] = useState(0);
```

### useEffect

```jsx
useEffect(() => {
  document.title = `You clicked ${count} times`;
}, [count]);
```

### useContext

```jsx
const theme = useContext(ThemeContext);
```

### useReducer

```jsx
const [state, dispatch] = useReducer(reducer, initialState);
```

## 自定义 Hooks

```jsx
function useWindowSize() {
  const [size, setSize] = useState([window.innerWidth, window.innerHeight]);
  
  useEffect(() => {
    const handleResize = () => {
      setSize([window.innerWidth, window.innerHeight]);
    };
    window.addEventListener(''resize'', handleResize);
    return () => window.removeEventListener(''resize'', handleResize);
  }, []);
  
  return size;
}
```

## Hooks 规则

1. 只在最顶层使用 Hooks
2. 只在 React 函数中调用 Hooks

## 总结

Hooks 让函数组件变得更加强大和灵活。', NULL, 198, 41, 9, 0, 1, NOW()),

(2, 7, 'Node.js 异步编程详解', '深入理解Node.js的异步编程模型', '# Node.js 异步编程详解

## 异步编程的重要性

Node.js 采用事件驱动、非阻塞 I/O 模型，这使得它轻量且高效。

## 回调函数

```javascript
fs.readFile(''file.txt'', ''utf8'', (err, data) => {
  if (err) throw err;
  console.log(data);
});
```

## Promise

```javascript
const readFile = (path) => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, ''utf8'', (err, data) => {
      if (err) reject(err);
      else resolve(data);
    });
  });
};
```

## Async/Await

```javascript
async function readFiles() {
  try {
    const data1 = await readFile(''file1.txt'');
    const data2 = await readFile(''file2.txt'');
    console.log(data1, data2);
  } catch (err) {
    console.error(err);
  }
}
```

## Event Loop

Node.js 的 Event Loop 是其异步机制的核心。

## 最佳实践

1. 避免回调地狱
2. 合理使用 Promise.all
3. 错误处理要完善
4. 注意异步操作的顺序

## 总结

掌握异步编程是 Node.js 开发的基础。', NULL, 145, 22, 5, 0, 1, NOW()),

(3, 8, '算法与数据结构 - 二叉树', '二叉树的基本概念和常见操作', '# 算法与数据结构 - 二叉树

## 二叉树基础

二叉树是每个节点最多有两个子节点的树结构。

## 二叉树的类型

1. 满二叉树
2. 完全二叉树
3. 二叉搜索树
4. 平衡二叉树

## 树的遍历

### 前序遍历

```python
def preorder(root):
    if not root:
        return
    print(root.val)
    preorder(root.left)
    preorder(root.right)
```

### 中序遍历

```python
def inorder(root):
    if not root:
        return
    inorder(root.left)
    print(root.val)
    inorder(root.right)
```

### 后序遍历

```python
def postorder(root):
    if not root:
        return
    postorder(root.left)
    postorder(root.right)
    print(root.val)
```

### 层序遍历

```python
def levelorder(root):
    if not root:
        return
    queue = [root]
    while queue:
        node = queue.pop(0)
        print(node.val)
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
```

## 常见问题

1. 二叉树的最大深度
2. 判断是否为平衡二叉树
3. 二叉树的最近公共祖先
4. 二叉搜索树的验证

## 总结

二叉树是计算机科学中最重要的数据结构之一。', NULL, 123, 19, 4, 0, 1, NOW()),

(3, 6, 'Git 工作流程最佳实践', 'Git分支管理和团队协作最佳实践', '# Git 工作流程最佳实践

## Git Flow

一种广泛使用的 Git 分支管理策略。

## 分支类型

### 主要分支

- **master/main**: 生产环境代码
- **develop**: 开发环境代码

### 辅助分支

- **feature**: 新功能开发
- **release**: 发布准备
- **hotfix**: 紧急修复

## 基本工作流程

```bash
# 创建功能分支
git checkout -b feature/new-feature develop

# 开发完成后合并
git checkout develop
git merge --no-ff feature/new-feature
git branch -d feature/new-feature
```

## 提交规范

```
<type>(<scope>): <subject>

<body>

<footer>
```

类型：
- feat: 新功能
- fix: 修复
- docs: 文档
- style: 格式
- refactor: 重构
- test: 测试
- chore: 构建

## 常用命令

```bash
# 查看状态
git status

# 暂存更改
git add .

# 提交
git commit -m "feat: add new feature"

# 推送
git push origin feature/new-feature

# 拉取
git pull origin develop

# 查看历史
git log --oneline --graph
```

## 最佳实践

1. 频繁提交，每次提交做一件事
2. 写清晰的提交信息
3. 提交前先拉取最新代码
4. 使用 .gitignore 忽略无关文件

## 总结

良好的 Git 工作流程能大大提高团队协作效率。', NULL, 201, 38, 11, 0, 1, NOW()),

(4, 7, '微服务架构设计与实践', '微服务架构的设计原则和实现方案', '# 微服务架构设计与实践

## 什么是微服务

微服务是一种架构风格，将单一应用程序开发为一组小型服务。

## 核心特性

1. 服务自治
2. 去中心化
3. 独立部署
4. 技术多样性

## 微服务架构组件

### 服务注册与发现

- Eureka
- Consul
- Nacos

### 配置中心

- Spring Cloud Config
- Apollo
- Nacos

### 网关

- Spring Cloud Gateway
- Zuul

### 负载均衡

- Ribbon
- LoadBalancer

### 熔断器

```java
@HystrixCommand(fallbackMethod = "fallback")
public String getData() {
    return restTemplate.getForObject(url, String.class);
}
```

## 服务间通信

### REST API

```java
@FeignClient("user-service")
public interface UserClient {
    @GetMapping("/users/{id}")
    User getUser(@PathVariable Long id);
}
```

### 消息队列

- RabbitMQ
- Kafka

## 分布式事务

- Seata
- TCC
- Saga

## 监控与追踪

- Prometheus
- Grafana
- Zipkin
- SkyWalking

## 最佳实践

1. 服务粒度要合适
2. 做好服务降级
3. 统一日志管理
4. 自动化部署

## 总结

微服务架构能提高系统的可维护性和扩展性。', NULL, 267, 52, 14, 0, 1, NOW());

-- 更新分类文章数
UPDATE `category` SET `article_count` = (SELECT COUNT(*) FROM `article` WHERE `category_id` = `category`.`category_id` AND `status` = 1);

-- ----------------------------
-- 插入文章标签关联
-- ----------------------------
INSERT INTO `article_tag` (`article_id`, `tag_id`) VALUES
(1, 2), (1, 1),
(2, 3), (2, 5),
(3, 4), (3, 7),
(4, 5), (4, 9),
(5, 7), (5, 8),
(6, 1), (6, 3),
(7, 6), (7, 8),
(8, 10), (8, 11),
(9, 6), (9, 10),
(10, 2), (10, 11);

-- 更新标签文章数
UPDATE `tag` SET `article_count` = (SELECT COUNT(*) FROM `article_tag` WHERE `tag_id` = `tag`.`tag_id`);

-- ----------------------------
-- 插入评论数据
-- ----------------------------
INSERT INTO `comment` (`article_id`, `user_id`, `parent_id`, `content`, `status`) VALUES
(1, 2, NULL, '这篇教程写得很清楚，对新手很友好！', 1),
(1, 3, 1, '我也是通过这个教程入门的，确实不错', 1),
(1, 4, NULL, 'Spring Boot真的大大简化了开发流程', 1),
(2, 2, NULL, 'Composition API确实比Options API更灵活', 1),
(2, 5, NULL, 'Vue 3的性能也提升了很多', 1),
(3, 3, NULL, '索引优化这部分讲得很实用', 1),
(3, 4, NULL, '有没有更多关于查询优化的案例？', 1),
(4, 2, NULL, 'Docker部署真的很方便', 1),
(4, 3, 8, '是的，特别是配合CI/CD使用', 1),
(5, 4, NULL, 'Redis在高并发场景下表现很好', 1),
(6, 3, NULL, 'Hooks让React开发体验提升了', 1),
(7, 2, NULL, 'Node.js的异步模型很强大', 1),
(8, 4, NULL, '二叉树是必须掌握的数据结构', 1),
(9, 2, NULL, 'Git Flow我们团队也在用', 1),
(10, 3, NULL, '微服务架构对团队要求也更高', 1);

-- 更新文章评论数
UPDATE `article` SET `comment_count` = (SELECT COUNT(*) FROM `comment` WHERE `article_id` = `article`.`article_id` AND `status` = 1);

-- ----------------------------
-- 插入留言数据
-- ----------------------------
INSERT INTO `message` (`user_id`, `parent_id`, `content`, `status`) VALUES
(2, NULL, '博客做得很棒，内容很有价值！', 1),
(3, 1, '同感，每篇文章都值得学习', 1),
(4, NULL, '希望能多写一些实战案例', 1),
(5, NULL, '期待更多关于微服务的文章', 1),
(2, 4, '确实，实战案例更容易理解', 1),
(3, NULL, '博主更新很勤快，赞！', 1);

-- ----------------------------
-- 插入更多公告
-- ----------------------------
INSERT INTO `announcement` (`title`, `content`, `summary`, `is_top`, `is_emergency`, `status`, `publish_time`) VALUES
('网站改版通知', '为了提供更好的用户体验，本站将于本周末进行系统升级和界面改版。期间可能会有短暂的访问中断，请各位用户知悉。改版后将带来更快的访问速度和更美观的界面。', '网站将于本周末进行改版升级', 1, 0, 1, NOW()),
('新增技术专栏', '本站新增了"面试专栏"和"项目实战"两个新栏目，将定期分享面试经验和实战项目案例，欢迎大家关注！', '新增面试专栏和项目实战栏目', 0, 0, 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
('社区规范更新', '为了营造良好的技术交流氛围，我们更新了社区规范。请各位用户在评论和留言时遵守相关规定，文明交流，共同进步。', '社区规范已更新，请遵守', 0, 0, 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
('系统维护通知', '【紧急通知】由于服务器升级，系统将于今晚23:00-01:00进行维护，期间无法访问。请提前做好准备，给您带来的不便敬请谅解。', '今晚23:00-01:00系统维护', 1, 1, 1, NOW());

-- ----------------------------
-- 插入访问日志
-- ----------------------------
INSERT INTO `visit_log` (`ip`, `page`, `device_type`, `browser`, `os`, `visit_time`) VALUES
('192.168.1.100', '/', 'desktop', 'Chrome', 'Windows 10', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('192.168.1.101', '/article/1', 'mobile', 'Safari', 'iOS', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
('192.168.1.102', '/article/2', 'desktop', 'Firefox', 'Ubuntu', DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('192.168.1.103', '/category', 'desktop', 'Chrome', 'macOS', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
('192.168.1.104', '/article/3', 'tablet', 'Chrome', 'Android', DATE_SUB(NOW(), INTERVAL 5 HOUR)),
('192.168.1.105', '/tag', 'desktop', 'Edge', 'Windows 11', DATE_SUB(NOW(), INTERVAL 6 HOUR)),
('192.168.1.106', '/article/4', 'mobile', 'Chrome', 'Android', DATE_SUB(NOW(), INTERVAL 7 HOUR)),
('192.168.1.107', '/search', 'desktop', 'Chrome', 'Windows 10', DATE_SUB(NOW(), INTERVAL 8 HOUR)),
('192.168.1.108', '/announcement', 'desktop', 'Safari', 'macOS', DATE_SUB(NOW(), INTERVAL 9 HOUR)),
('192.168.1.109', '/message', 'mobile', 'Safari', 'iOS', DATE_SUB(NOW(), INTERVAL 10 HOUR));

-- ----------------------------
-- 插入系统日志
-- ----------------------------
INSERT INTO `log` (`user_id`, `username`, `operation`, `method`, `params`, `ip`, `location`, `status`) VALUES
(1, 'admin', '用户登录', 'POST /auth/login', '{"username":"admin"}', '192.168.1.1', '本地', 1),
(1, 'admin', '创建文章', 'POST /admin/article/create', '{"title":"Spring Boot入门"}', '192.168.1.1', '本地', 1),
(2, 'testuser1', '用户注册', 'POST /auth/register', '{"username":"testuser1"}', '192.168.1.100', '北京', 1),
(2, 'testuser1', '发表评论', 'POST /comment/add', '{"articleId":1}', '192.168.1.100', '北京', 1),
(1, 'admin', '删除评论', 'DELETE /admin/comment/10', '{"id":10}', '192.168.1.1', '本地', 1);

-- ----------------------------
-- 更新系统配置
-- ----------------------------
UPDATE `system_config` SET `config_value` = '技术分享博客' WHERE `config_key` = 'blog_name';
UPDATE `system_config` SET `config_value` = '分享技术知识，记录学习历程' WHERE `config_key` = 'blog_subtitle';
UPDATE `system_config` SET `config_value` = '技术博主' WHERE `config_key` = 'author_name';

-- 打印插入结果
SELECT '============================================' as '';
SELECT '测试数据插入完成！' as '';
SELECT '============================================' as '';
SELECT CONCAT('用户数量: ', COUNT(*)) as '' FROM `user`;
SELECT CONCAT('文章数量: ', COUNT(*)) as '' FROM `article`;
SELECT CONCAT('分类数量: ', COUNT(*)) as '' FROM `category`;
SELECT CONCAT('标签数量: ', COUNT(*)) as '' FROM `tag`;
SELECT CONCAT('评论数量: ', COUNT(*)) as '' FROM `comment`;
SELECT CONCAT('留言数量: ', COUNT(*)) as '' FROM `message`;
SELECT CONCAT('公告数量: ', COUNT(*)) as '' FROM `announcement`;
SELECT '============================================' as '';
SELECT '测试账户信息:' as '';
SELECT '管理员 - 用户名: admin, 密码: admin123' as '';
SELECT '普通用户 - 用户名: testuser1~5, 密码: test123' as '';
SELECT '============================================' as '';


