# 个人博客系统

> 基于 Spring Boot + Vue 3 + 鸿蒙设计语言的个人博客系统

## 项目简介

这是一个功能完整的个人博客系统，采用前后端分离架构，支持文章发布、评论互动、公告管理、数据统计等功能。界面采用鸿蒙设计语言（Harmony Design System），提供现代化、流畅的用户体验。

## 技术栈

### 后端技术
- **框架**: Spring Boot 3.1.5
- **数据库**: MySQL 8.0
- **ORM**: MyBatis Plus 3.5.4
- **认证**: JWT + MD5
- **工具**: Hutool、FastJSON2
- **文档**: Swagger/OpenAPI 3.0

### 前端技术
- **框架**: Vue 3.3
- **路由**: Vue Router 4.2
- **状态管理**: Pinia 2.1
- **UI 组件**: Element Plus 2.4
- **HTTP 客户端**: Axios 1.6
- **Markdown 渲染**: markdown-it
- **代码高亮**: highlight.js
- **图表**: ECharts 5.4
- **构建工具**: Vite 5.0

## 功能特性

### 访客端功能（12个模块）
1. **首页** - 文章列表展示、公告轮播、热门分类/标签
2. **文章详情** - Markdown渲染、评论互动、点赞功能
3. **分类浏览** - 分类卡片展示
4. **标签浏览** - 标签云展示
5. **归档** - 时间轴归档视图
6. **搜索** - 文章全文搜索
7. **公告中心** - 公告列表与详情
8. **评论互动** - 嵌套评论、楼层展示
9. **关于我** - 个人信息展示
10. **留言板** - 访客留言功能
11. **登录注册** - 用户认证
12. **退出登录** - 登出功能

### 管理端功能（8个模块）
1. **仪表盘** - 数据统计、图表展示
2. **文章管理** - 增删改查、草稿/发布、置顶
3. **分类管理** - 分类维护
4. **标签管理** - 标签维护
5. **公告管理** - 公告发布、置顶/紧急标识
6. **评论管理** - 审核、删除
7. **留言管理** - 审核、删除
8. **用户管理** - 用户状态管理

## 项目结构

```
blog/
├── backend/                    # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/blog/
│   │   │   │   ├── config/    # 配置类
│   │   │   │   ├── controller/# 控制器
│   │   │   │   ├── entity/    # 实体类
│   │   │   │   ├── mapper/    # 数据访问层
│   │   │   │   ├── service/   # 业务逻辑层
│   │   │   │   ├── util/      # 工具类
│   │   │   │   ├── common/    # 通用类
│   │   │   │   └── interceptor/# 拦截器
│   │   │   └── resources/
│   │   │       └── application.yml
│   │   └── pom.xml
│   └── ...
├── frontend/                   # 前端项目
│   ├── src/
│   │   ├── api/               # API接口
│   │   ├── assets/            # 静态资源
│   │   ├── components/        # 组件
│   │   ├── layouts/           # 布局
│   │   ├── router/            # 路由
│   │   ├── styles/            # 样式
│   │   ├── utils/             # 工具
│   │   ├── views/             # 页面
│   │   │   ├── admin/        # 管理端页面
│   │   │   ├── auth/         # 认证页面
│   │   │   └── guest/        # 访客端页面
│   │   ├── App.vue
│   │   └── main.js
│   ├── package.json
│   └── vite.config.js
├── database/                   # 数据库脚本
│   └── blog_schema.sql
├── docs/                       # 文档
└── README.md
```

## 快速开始

### 环境要求
- JDK 17+
- Node.js 16+
- MySQL 8.0+
- Maven 3.6+

### 后端部署

1. **创建数据库并导入测试数据**
```bash
# 导入数据库结构
mysql -u root -p < database/blog_schema.sql

# 导入测试数据（可选，但强烈推荐）
mysql -u root -p < database/test_data.sql
```

> 测试数据包含：6个用户、10篇文章、8个分类、18个标签、15条评论、6条留言、5条公告
> 详见：[测试数据说明](README_测试数据说明.md)

2. **修改配置**
编辑 `backend/src/main/resources/application.yml`，修改数据库连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/personal_blog
    username: root
    password: your_password
```

3. **启动后端**
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动

### 前端部署

1. **安装依赖**
```bash
cd frontend
npm install
```

2. **启动开发服务器**
```bash
npm run dev
```

前端服务将在 `http://localhost:3000` 启动

3. **构建生产版本**
```bash
npm run build
```

## 默认账户

- **管理员账户**
  - 用户名: `admin`
  - 密码: `admin123`

- **测试用户账户**（导入测试数据后可用）
  - 用户名: `testuser1` ~ `testuser5`
  - 密码: `test123`

## API 文档

启动后端服务后，访问 Swagger 文档：
- URL: http://localhost:8080/api/swagger-ui.html

## API 测试

### 自动化测试脚本

```bash
# 赋予执行权限
chmod +x test_api.sh

# 运行测试（确保后端服务已启动）
./test_api.sh
```

测试脚本会自动测试所有主要API接口，并显示测试结果。

### 手动测试

参考详细的测试文档：
- [API测试指南](docs/API测试指南.md) - 包含所有接口的测试用例
- [测试数据说明](README_测试数据说明.md) - 测试数据详情

## 鸿蒙设计规范

### 主色调
- 主色: `#007DFF` (天青蓝)
- 次色: `#E6F0FF` (柔和蓝白)

### 设计特点
- **圆角**: 统一 12px 圆角
- **字体**: HarmonyOS Sans
- **动效**: 渐变与弹性过渡
- **风格**: 清爽、流动、亲和、轻动效

## 数据库设计

系统包含以下核心数据表：
1. `user` - 用户表
2. `article` - 文章表
3. `category` - 分类表
4. `tag` - 标签表
5. `article_tag` - 文章标签关联表
6. `comment` - 评论表
7. `message` - 留言表
8. `announcement` - 公告表
9. `log` - 系统日志表
10. `visit_log` - 访问统计表
11. `system_config` - 系统配置表

详细设计请参考 `database/blog_schema.sql`

## 部署建议

### 生产环境部署

1. **后端部署**
   - 打包: `mvn clean package`
   - 运行: `java -jar target/personal-blog-1.0.0.jar`
   - 配置: 建议使用外部配置文件

2. **前端部署**
   - 构建: `npm run build`
   - 将 `dist` 目录部署到 Nginx

3. **Nginx 配置示例**
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # 前端静态文件
    location / {
        root /path/to/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端 API 代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 开发进度

- [x] 数据库设计
- [x] 后端 API 开发
- [x] JWT 认证实现
- [x] 前端框架搭建
- [x] 鸿蒙主题配置
- [x] 访客端页面开发
- [x] 管理端页面开发
- [x] 接口文档生成
- [x] 部署文档编写

## 贡献指南

欢迎提交 Issue 和 Pull Request

## 许可证

MIT License

## 联系方式

- 作者: Blog System
- 邮箱: author@blog.com

---

**注意**: 这是一个毕业设计项目，仅供学习和参考使用。
