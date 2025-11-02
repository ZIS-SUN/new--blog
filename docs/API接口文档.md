# 个人博客系统 - API 接口文档

## 基础信息

- **Base URL**: `http://localhost:8080/api`
- **认证方式**: JWT Bearer Token
- **Content-Type**: `application/json`

## 认证说明

需要认证的接口，在请求头中添加：
```
Authorization: Bearer <token>
```

---

## 1. 认证模块

### 1.1 用户注册

**接口**: `POST /auth/register`

**请求参数**:
```json
{
  "username": "string",    // 用户名，3-20字符
  "password": "string",    // 密码，最少6字符
  "email": "string",       // 邮箱
  "nickname": "string"     // 昵称（可选）
}
```

**响应**:
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "userId": 1,
    "username": "test",
    "email": "test@example.com",
    "nickname": "测试用户",
    "role": 0,
    "status": 1,
    "createTime": "2025-11-02T10:00:00"
  },
  "timestamp": 1699000000000
}
```

### 1.2 用户登录

**接口**: `POST /auth/login`

**请求参数**:
```json
{
  "username": "string",
  "password": "string"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "userId": 1,
      "username": "admin",
      "nickname": "管理员",
      "role": 1,
      "avatar": null
    }
  },
  "timestamp": 1699000000000
}
```

---

## 2. 文章模块（访客端）

### 2.1 获取文章列表

**接口**: `GET /article/list`

**请求参数**:
- `current`: 当前页码，默认 1
- `size`: 每页数量，默认 10

**响应**:
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "records": [
      {
        "articleId": 1,
        "title": "文章标题",
        "summary": "文章摘要",
        "coverImage": "封面图URL",
        "viewCount": 100,
        "likeCount": 10,
        "commentCount": 5,
        "isTop": 0,
        "status": 1,
        "publishTime": "2025-11-02T10:00:00"
      }
    ],
    "total": 100,
    "size": 10,
    "current": 1
  }
}
```

### 2.2 获取文章详情

**接口**: `GET /article/{id}`

**响应**: 返回完整的文章信息，包括 Markdown 内容

### 2.3 根据分类查询文章

**接口**: `GET /article/category/{categoryId}`

**请求参数**: 同文章列表

### 2.4 搜索文章

**接口**: `GET /article/search`

**请求参数**:
- `keyword`: 搜索关键词
- `current`: 当前页码
- `size`: 每页数量

### 2.5 文章点赞

**接口**: `POST /article/{id}/like`

**认证**: 不需要

---

## 3. 分类模块

### 3.1 获取所有分类

**接口**: `GET /category/list`

**响应**:
```json
{
  "code": 200,
  "data": [
    {
      "categoryId": 1,
      "categoryName": "技术分享",
      "description": "技术相关的文章",
      "articleCount": 10,
      "createTime": "2025-11-01T10:00:00"
    }
  ]
}
```

### 3.2 获取分类详情

**接口**: `GET /category/{id}`

---

## 4. 标签模块

### 4.1 获取所有标签

**接口**: `GET /tag/list`

**响应**: 同分类列表

---

## 5. 公告模块

### 5.1 获取公告列表

**接口**: `GET /announcement/list`

**请求参数**: 支持分页

### 5.2 获取置顶公告

**接口**: `GET /announcement/top`

**响应**: 返回最多5条置顶公告

### 5.3 获取公告详情

**接口**: `GET /announcement/{id}`

---

## 6. 评论模块

### 6.1 获取文章评论

**接口**: `GET /comment/article/{articleId}`

**请求参数**: 支持分页

**响应**:
```json
{
  "code": 200,
  "data": {
    "records": [
      {
        "commentId": 1,
        "articleId": 1,
        "userId": 2,
        "parentId": null,
        "content": "评论内容",
        "status": 1,
        "createTime": "2025-11-02T10:00:00"
      }
    ]
  }
}
```

### 6.2 发表评论

**接口**: `POST /comment/add`

**认证**: 需要

**请求参数**:
```json
{
  "articleId": 1,
  "content": "评论内容",
  "parentId": null  // 回复评论时填写父评论ID
}
```

---

## 7. 留言模块

### 7.1 获取留言列表

**接口**: `GET /message/list`

### 7.2 发表留言

**接口**: `POST /message/add`

**认证**: 需要

**请求参数**:
```json
{
  "content": "留言内容",
  "parentId": null
}
```

---

## 8. 管理端 - 文章管理

### 8.1 获取所有文章

**接口**: `GET /admin/article/list`

**认证**: 需要（管理员）

**请求参数**: 支持分页

### 8.2 创建文章

**接口**: `POST /admin/article/create`

**认证**: 需要（管理员）

**请求参数**:
```json
{
  "title": "文章标题",
  "summary": "文章摘要",
  "content": "Markdown内容",
  "categoryId": 1,
  "coverImage": "封面图URL",
  "status": 1,      // 0-草稿, 1-已发布
  "isTop": 0,       // 0-否, 1-置顶
  "userId": 1
}
```

### 8.3 更新文章

**接口**: `PUT /admin/article/update`

**请求参数**: 同创建，需包含 `articleId`

### 8.4 删除文章

**接口**: `DELETE /admin/article/{id}`

### 8.5 批量删除文章

**接口**: `DELETE /admin/article/batch`

**请求参数**:
```json
[1, 2, 3, 4, 5]  // 文章ID数组
```

---

## 9. 管理端 - 分类管理

### 9.1 创建分类

**接口**: `POST /admin/category/create`

**请求参数**:
```json
{
  "categoryName": "分类名称",
  "description": "分类描述"
}
```

### 9.2 更新分类

**接口**: `PUT /admin/category/update`

### 9.3 删除分类

**接口**: `DELETE /admin/category/{id}`

---

## 10. 管理端 - 标签管理

接口与分类管理类似，路径为 `/admin/tag/*`

---

## 11. 管理端 - 公告管理

### 11.1 创建公告

**接口**: `POST /admin/announcement/create`

**请求参数**:
```json
{
  "title": "公告标题",
  "summary": "公告摘要",
  "content": "公告内容",
  "isTop": 1,       // 是否置顶
  "isEmergency": 0, // 是否紧急
  "status": 1       // 0-隐藏, 1-发布
}
```

### 11.2 更新/删除公告

同文章管理

---

## 12. 管理端 - 用户管理

### 12.1 获取用户列表

**接口**: `GET /admin/user/list`

### 12.2 更新用户状态

**接口**: `PUT /admin/user/status`

**请求参数**:
```json
{
  "userId": 1,
  "status": 0  // 0-禁用, 1-启用
}
```

### 12.3 删除用户

**接口**: `DELETE /admin/user/{id}`

---

## 13. 管理端 - 仪表盘

### 13.1 获取统计数据

**接口**: `GET /admin/dashboard/statistics`

**响应**:
```json
{
  "code": 200,
  "data": {
    "articleCount": 100,
    "userCount": 50,
    "commentCount": 200,
    "messageCount": 30,
    "announcementCount": 5
  }
}
```

---

## 状态码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权，需要登录 |
| 403 | 无权限访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

## 错误响应格式

```json
{
  "code": 500,
  "message": "错误信息描述",
  "data": null,
  "timestamp": 1699000000000
}
```

---

## 在线 API 文档

启动后端服务后，访问 Swagger UI:

**URL**: http://localhost:8080/api/swagger-ui.html

Swagger 提供交互式 API 文档，可以直接在线测试接口。

---

## 注意事项

1. 所有时间格式为 ISO 8601: `yyyy-MM-ddTHH:mm:ss`
2. 分页参数 `current` 从 1 开始
3. 管理端接口需要管理员权限（`role = 1`）
4. JWT Token 默认有效期为 24 小时
5. 文件大小限制为 2MB

---

**更多详细信息请参考 Swagger 文档或源代码注释**


