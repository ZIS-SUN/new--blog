# 个人博客系统 - API 完整测试指南

## 测试准备

### 1. 导入测试数据

```bash
# 首先导入基础表结构
mysql -u root -p < database/blog_schema.sql

# 然后导入测试数据
mysql -u root -p < database/test_data.sql
```

### 2. 启动后端服务

```bash
cd backend
mvn spring-boot:run
```

服务地址: `http://localhost:8080/api`

### 3. 测试工具

推荐使用以下工具之一：
- **Postman** (推荐)
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **cURL** 命令行
- **IDEA HTTP Client**

### 4. 测试账户

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | admin123 | 完全权限 |
| 普通用户 | testuser1 | test123 | 普通权限 |
| 普通用户 | testuser2 | test123 | 普通权限 |
| 普通用户 | testuser3 | test123 | 普通权限 |

---

## 一、认证模块测试

### 1.1 用户注册 ✅

**接口**: `POST /auth/register`

**请求示例**:
```json
{
  "username": "newuser",
  "password": "123456",
  "email": "newuser@test.com",
  "nickname": "新用户"
}
```

**预期结果**: 
- 状态码: 200
- 返回新创建的用户信息
- 密码已加密

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser999",
    "password": "123456",
    "email": "testuser999@test.com",
    "nickname": "测试用户999"
  }'
```

**验证点**:
- [x] 用户名重复时报错
- [x] 邮箱重复时报错
- [x] 必填字段验证
- [x] 密码加密存储

---

### 1.2 用户登录 ✅

**接口**: `POST /auth/login`

**请求示例**:
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**预期结果**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "userId": 1,
      "username": "admin",
      "nickname": "系统管理员",
      "role": 1
    }
  }
}
```

**测试用例**:
```bash
# 管理员登录
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'

# 普通用户登录
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser1",
    "password": "test123"
  }'
```

**验证点**:
- [x] 正确的用户名密码可登录
- [x] 错误的密码登录失败
- [x] 不存在的用户登录失败
- [x] 返回有效的 JWT Token
- [x] 禁用用户无法登录

**保存Token**: 后续需要认证的接口都需要使用此Token

---

### 1.3 退出登录 ✅

**接口**: `POST /auth/logout`

**请求示例**:
```bash
curl -X POST http://localhost:8080/api/auth/logout
```

**预期结果**: 
- 状态码: 200
- 返回成功消息

---

## 二、文章模块测试（访客端）

### 2.1 获取文章列表 ✅

**接口**: `GET /article/list?current=1&size=10`

**测试用例**:
```bash
curl "http://localhost:8080/api/article/list?current=1&size=10"
```

**预期结果**:
```json
{
  "code": 200,
  "data": {
    "records": [
      {
        "articleId": 1,
        "title": "Spring Boot 入门教程",
        "summary": "本文介绍...",
        "viewCount": 156,
        "likeCount": 23,
        "commentCount": 8,
        "isTop": 1,
        "publishTime": "2025-11-02T10:00:00"
      }
    ],
    "total": 10,
    "current": 1,
    "size": 10
  }
}
```

**验证点**:
- [x] 返回已发布的文章
- [x] 置顶文章排在前面
- [x] 分页功能正常
- [x] 按发布时间倒序

---

### 2.2 获取文章详情 ✅

**接口**: `GET /article/{id}`

**测试用例**:
```bash
curl http://localhost:8080/api/article/1
```

**预期结果**:
- 返回完整的文章信息
- 包含 Markdown 内容
- 阅读数自动+1

**验证点**:
- [x] 返回完整内容
- [x] 阅读数增加
- [x] 不存在的文章返回404

---

### 2.3 根据分类查询文章 ✅

**接口**: `GET /article/category/{categoryId}?current=1&size=10`

**测试用例**:
```bash
# 查询"技术分享"分类的文章（分类ID=1）
curl "http://localhost:8080/api/article/category/1?current=1&size=10"
```

**验证点**:
- [x] 返回指定分类的文章
- [x] 分页功能正常

---

### 2.4 根据标签查询文章 ✅

**接口**: `GET /article/tag/{tagId}?current=1&size=10`

**测试用例**:
```bash
# 查询"Java"标签的文章（标签ID=1）
curl "http://localhost:8080/api/article/tag/1?current=1&size=10"
```

---

### 2.5 搜索文章 ✅

**接口**: `GET /article/search?keyword=关键词&current=1&size=10`

**测试用例**:
```bash
# 搜索包含"Spring"的文章
curl "http://localhost:8080/api/article/search?keyword=Spring&current=1&size=10"
```

**验证点**:
- [x] 标题包含关键词的文章
- [x] 内容包含关键词的文章
- [x] 空关键词处理

---

### 2.6 文章点赞 ✅

**接口**: `POST /article/{id}/like`

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/article/1/like
```

**预期结果**:
- 点赞数+1
- 无需登录

---

## 三、分类模块测试

### 3.1 获取分类列表 ✅

**接口**: `GET /category/list`

**测试用例**:
```bash
curl http://localhost:8080/api/category/list
```

**预期结果**:
```json
{
  "code": 200,
  "data": [
    {
      "categoryId": 1,
      "categoryName": "技术分享",
      "description": "技术相关的文章",
      "articleCount": 3
    }
  ]
}
```

**验证点**:
- [x] 返回所有分类
- [x] 文章数量统计正确

---

### 3.2 获取分类详情 ✅

**接口**: `GET /category/{id}`

**测试用例**:
```bash
curl http://localhost:8080/api/category/1
```

---

## 四、标签模块测试

### 4.1 获取标签列表 ✅

**接口**: `GET /tag/list`

**测试用例**:
```bash
curl http://localhost:8080/api/tag/list
```

**验证点**:
- [x] 返回所有标签
- [x] 包含文章数量

---

## 五、公告模块测试

### 5.1 获取公告列表 ✅

**接口**: `GET /announcement/list?current=1&size=10`

**测试用例**:
```bash
curl "http://localhost:8080/api/announcement/list?current=1&size=10"
```

**验证点**:
- [x] 返回已发布的公告
- [x] 置顶公告在前
- [x] 紧急公告标识

---

### 5.2 获取置顶公告 ✅

**接口**: `GET /announcement/top`

**测试用例**:
```bash
curl http://localhost:8080/api/announcement/top
```

**预期结果**:
- 返回最多5条置顶公告
- 按发布时间倒序

---

### 5.3 获取公告详情 ✅

**接口**: `GET /announcement/{id}`

**测试用例**:
```bash
curl http://localhost:8080/api/announcement/1
```

---

## 六、评论模块测试

### 6.1 获取文章评论 ✅

**接口**: `GET /comment/article/{articleId}?current=1&size=20`

**测试用例**:
```bash
curl "http://localhost:8080/api/comment/article/1?current=1&size=20"
```

**验证点**:
- [x] 返回已审核的评论
- [x] 支持嵌套回复
- [x] 按时间倒序

---

### 6.2 发表评论 ✅ (需认证)

**接口**: `POST /comment/add`

**请求头**: 
```
Authorization: Bearer {token}
```

**请求示例**:
```json
{
  "articleId": 1,
  "content": "这篇文章写得真不错！",
  "parentId": null
}
```

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/comment/add \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "articleId": 1,
    "content": "这篇文章写得真不错！",
    "parentId": null
  }'
```

**验证点**:
- [x] 需要登录
- [x] 评论成功后文章评论数+1
- [x] 支持回复评论（设置parentId）

---

## 七、留言模块测试

### 7.1 获取留言列表 ✅

**接口**: `GET /message/list?current=1&size=20`

**测试用例**:
```bash
curl "http://localhost:8080/api/message/list?current=1&size=20"
```

---

### 7.2 发表留言 ✅ (需认证)

**接口**: `POST /message/add`

**请求示例**:
```json
{
  "content": "网站做得很棒！",
  "parentId": null
}
```

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/message/add \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "content": "网站做得很棒！",
    "parentId": null
  }'
```

---

## 八、管理端测试 (需管理员权限)

### 8.1 仪表盘统计 ✅

**接口**: `GET /admin/dashboard/statistics`

**请求头**: 
```
Authorization: Bearer {admin_token}
```

**测试用例**:
```bash
# 先用admin登录获取token
TOKEN=$(curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  | jq -r '.data.token')

# 使用token访问统计接口
curl http://localhost:8080/api/admin/dashboard/statistics \
  -H "Authorization: Bearer $TOKEN"
```

**预期结果**:
```json
{
  "code": 200,
  "data": {
    "articleCount": 10,
    "userCount": 6,
    "commentCount": 15,
    "messageCount": 6,
    "announcementCount": 5
  }
}
```

---

### 8.2 文章管理

#### 8.2.1 获取所有文章 ✅

**接口**: `GET /admin/article/list?current=1&size=10`

**测试用例**:
```bash
curl "http://localhost:8080/api/admin/article/list?current=1&size=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

**验证点**:
- [x] 返回所有文章（包括草稿）
- [x] 需要管理员权限

---

#### 8.2.2 创建文章 ✅

**接口**: `POST /admin/article/create`

**请求示例**:
```json
{
  "userId": 1,
  "categoryId": 1,
  "title": "测试文章标题",
  "summary": "这是文章摘要",
  "content": "# 这是文章内容\n\n这是一篇测试文章。",
  "coverImage": null,
  "status": 1,
  "isTop": 0
}
```

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/admin/article/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "userId": 1,
    "categoryId": 1,
    "title": "API测试文章",
    "summary": "这是通过API创建的测试文章",
    "content": "# API测试\n\n这是通过API创建的文章内容。",
    "status": 1,
    "isTop": 0
  }'
```

**验证点**:
- [x] 需要管理员权限
- [x] 自动设置发布时间
- [x] 返回新创建的文章

---

#### 8.2.3 更新文章 ✅

**接口**: `PUT /admin/article/update`

**请求示例**: 同创建，需包含 `articleId`

```bash
curl -X PUT http://localhost:8080/api/admin/article/update \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "articleId": 1,
    "title": "更新后的标题",
    "summary": "更新后的摘要",
    "content": "更新后的内容",
    "status": 1
  }'
```

---

#### 8.2.4 删除文章 ✅

**接口**: `DELETE /admin/article/{id}`

**测试用例**:
```bash
curl -X DELETE http://localhost:8080/api/admin/article/999 \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

#### 8.2.5 批量删除文章 ✅

**接口**: `DELETE /admin/article/batch`

**请求示例**:
```json
[1, 2, 3, 4, 5]
```

**测试用例**:
```bash
curl -X DELETE http://localhost:8080/api/admin/article/batch \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '[11, 12, 13]'
```

---

### 8.3 分类管理

#### 8.3.1 创建分类 ✅

**接口**: `POST /admin/category/create`

**请求示例**:
```json
{
  "categoryName": "新分类",
  "description": "分类描述"
}
```

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/admin/category/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "categoryName": "测试分类",
    "description": "这是一个测试分类"
  }'
```

---

#### 8.3.2 更新分类 ✅

**接口**: `PUT /admin/category/update`

```bash
curl -X PUT http://localhost:8080/api/admin/category/update \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "categoryId": 1,
    "categoryName": "更新后的分类名",
    "description": "更新后的描述"
  }'
```

---

#### 8.3.3 删除分类 ✅

**接口**: `DELETE /admin/category/{id}`

```bash
curl -X DELETE http://localhost:8080/api/admin/category/99 \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

### 8.4 标签管理

测试方法与分类管理类似，接口路径为 `/admin/tag/*`

---

### 8.5 公告管理

#### 8.5.1 创建公告 ✅

**接口**: `POST /admin/announcement/create`

**请求示例**:
```json
{
  "title": "测试公告",
  "summary": "公告摘要",
  "content": "这是公告内容",
  "isTop": 1,
  "isEmergency": 0,
  "status": 1
}
```

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/admin/announcement/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "title": "API测试公告",
    "summary": "这是测试公告摘要",
    "content": "这是通过API创建的测试公告",
    "isTop": 1,
    "isEmergency": 0,
    "status": 1
  }'
```

---

### 8.6 评论管理

#### 8.6.1 获取所有评论 ✅

**接口**: `GET /admin/comment/list?current=1&size=10`

```bash
curl "http://localhost:8080/api/admin/comment/list?current=1&size=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

#### 8.6.2 审核评论 ✅

**接口**: `PUT /admin/comment/approve`

**请求示例**:
```json
{
  "commentId": 1
}
```

```bash
curl -X PUT http://localhost:8080/api/admin/comment/approve \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"commentId": 1}'
```

---

#### 8.6.3 删除评论 ✅

**接口**: `DELETE /admin/comment/{id}`

```bash
curl -X DELETE http://localhost:8080/api/admin/comment/99 \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

### 8.7 留言管理

测试方法与评论管理类似，接口路径为 `/admin/message/*`

---

### 8.8 用户管理

#### 8.8.1 获取用户列表 ✅

**接口**: `GET /admin/user/list?current=1&size=10`

```bash
curl "http://localhost:8080/api/admin/user/list?current=1&size=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

#### 8.8.2 更新用户状态 ✅

**接口**: `PUT /admin/user/status`

**请求示例**:
```json
{
  "userId": 2,
  "status": 0
}
```

```bash
# 禁用用户
curl -X PUT http://localhost:8080/api/admin/user/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"userId": 2, "status": 0}'

# 启用用户
curl -X PUT http://localhost:8080/api/admin/user/status \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"userId": 2, "status": 1}'
```

---

#### 8.8.3 删除用户 ✅

**接口**: `DELETE /admin/user/{id}`

```bash
curl -X DELETE http://localhost:8080/api/admin/user/99 \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

---

## 九、文件上传测试

### 9.1 上传图片 ✅

**接口**: `POST /upload/image`

**测试用例**:
```bash
curl -X POST http://localhost:8080/api/upload/image \
  -F "file=@/path/to/image.jpg"
```

**预期结果**:
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "url": "/uploads/uuid.jpg",
    "filename": "uuid.jpg"
  }
}
```

**验证点**:
- [x] 只能上传图片格式
- [x] 文件大小限制2MB
- [x] 生成唯一文件名
- [x] 返回可访问的URL

---

### 9.2 上传文件 ✅

**接口**: `POST /upload/file`

```bash
curl -X POST http://localhost:8080/api/upload/file \
  -F "file=@/path/to/document.pdf"
```

**验证点**:
- [x] 支持多种文件格式
- [x] 文件大小限制10MB

---

## 十、完整测试脚本

### 10.1 自动化测试脚本 (Bash)

保存为 `test_all_apis.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080/api"

echo "========================================="
echo "开始测试所有API接口"
echo "========================================="

# 1. 测试用户注册
echo "1. 测试用户注册..."
curl -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "apitest",
    "password": "123456",
    "email": "apitest@test.com",
    "nickname": "API测试用户"
  }' | jq .

# 2. 测试用户登录
echo "2. 测试管理员登录..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}')

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.token')
echo "获取到Token: $TOKEN"

# 3. 测试获取文章列表
echo "3. 测试获取文章列表..."
curl -s "$BASE_URL/article/list?current=1&size=5" | jq .

# 4. 测试获取文章详情
echo "4. 测试获取文章详情..."
curl -s "$BASE_URL/article/1" | jq .

# 5. 测试搜索文章
echo "5. 测试搜索文章..."
curl -s "$BASE_URL/article/search?keyword=Spring" | jq .

# 6. 测试获取分类列表
echo "6. 测试获取分类列表..."
curl -s "$BASE_URL/category/list" | jq .

# 7. 测试获取标签列表
echo "7. 测试获取标签列表..."
curl -s "$BASE_URL/tag/list" | jq .

# 8. 测试获取公告列表
echo "8. 测试获取公告列表..."
curl -s "$BASE_URL/announcement/list" | jq .

# 9. 测试获取置顶公告
echo "9. 测试获取置顶公告..."
curl -s "$BASE_URL/announcement/top" | jq .

# 10. 测试仪表盘统计（需要管理员权限）
echo "10. 测试仪表盘统计..."
curl -s "$BASE_URL/admin/dashboard/statistics" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 11. 测试获取所有文章（管理端）
echo "11. 测试管理端获取文章列表..."
curl -s "$BASE_URL/admin/article/list?current=1&size=5" \
  -H "Authorization: Bearer $TOKEN" | jq .

echo "========================================="
echo "测试完成！"
echo "========================================="
```

### 10.2 使用Postman Collection

导入以下JSON到Postman:

保存为 `Blog_API_Tests.postman_collection.json`

---

## 十一、测试检查清单

### 功能测试 ✅

- [ ] 用户注册功能正常
- [ ] 用户登录返回有效Token
- [ ] 文章列表分页正常
- [ ] 文章详情展示完整
- [ ] 文章搜索功能正常
- [ ] 分类、标签列表正常
- [ ] 公告展示功能正常
- [ ] 评论发表功能正常
- [ ] 留言发表功能正常
- [ ] 管理端CRUD操作正常
- [ ] 文件上传功能正常

### 权限测试 ✅

- [ ] 未登录访问需认证接口返回401
- [ ] 普通用户访问管理端接口返回403
- [ ] Token过期后返回401
- [ ] 管理员可以访问所有接口

### 异常测试 ✅

- [ ] 不存在的资源返回404
- [ ] 参数错误返回400
- [ ] 文件大小超限返回错误
- [ ] 重复数据返回错误提示

### 性能测试 ✅

- [ ] 接口响应时间 < 500ms
- [ ] 分页查询效率正常
- [ ] 搜索功能响应快速

---

## 十二、常见问题排查

### 问题1: Token无效

**症状**: 返回401 Unauthorized

**解决**:
1. 检查Token是否正确复制
2. Token前面要加 "Bearer "
3. 检查Token是否过期（默认24小时）

### 问题2: 接口404

**症状**: Not Found

**解决**:
1. 检查后端是否启动
2. 检查URL路径是否正确
3. 检查端口是否为8080

### 问题3: 数据库连接失败

**症状**: 500 Internal Server Error

**解决**:
1. 检查MySQL是否启动
2. 检查数据库配置
3. 检查数据库是否已创建

---

## 十三、测试报告模板

测试完成后，填写以下表格：

| 模块 | 接口数 | 通过数 | 失败数 | 通过率 | 备注 |
|------|--------|--------|--------|--------|------|
| 认证模块 | 3 | | | | |
| 文章模块 | 6 | | | | |
| 分类模块 | 2 | | | | |
| 标签模块 | 2 | | | | |
| 公告模块 | 3 | | | | |
| 评论模块 | 2 | | | | |
| 留言模块 | 2 | | | | |
| 管理端-文章 | 5 | | | | |
| 管理端-分类 | 4 | | | | |
| 管理端-标签 | 4 | | | | |
| 管理端-公告 | 4 | | | | |
| 管理端-评论 | 3 | | | | |
| 管理端-留言 | 3 | | | | |
| 管理端-用户 | 3 | | | | |
| 管理端-统计 | 1 | | | | |
| 文件上传 | 2 | | | | |
| **总计** | **50** | | | | |

---

## 附录：快速参考

### 常用cURL命令

```bash
# GET请求
curl http://localhost:8080/api/article/list

# POST请求（JSON）
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 带Token的请求
curl http://localhost:8080/api/admin/dashboard/statistics \
  -H "Authorization: Bearer YOUR_TOKEN"

# 文件上传
curl -X POST http://localhost:8080/api/upload/image \
  -F "file=@image.jpg"

# DELETE请求
curl -X DELETE http://localhost:8080/api/admin/article/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

**测试愉快！如有问题请查看日志或联系开发团队。**


