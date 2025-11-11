# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a full-stack personal blog system built with Spring Boot 3.1.5 backend and Vue 3 frontend, featuring a Harmony Design System UI. The system includes both guest-facing features (article browsing, comments, announcements) and an admin dashboard for content management.

**Tech Stack:**
- Backend: Spring Boot 3.1.5 + MyBatis Plus + MySQL 8.0 + JWT authentication
- Frontend: Vue 3.3 + Vite 5.0 + Element Plus + Pinia
- Design: Harmony Design System (HarmonyOS-inspired UI)

## Development Commands

### Backend (Spring Boot)

```bash
cd backend

# Build and install dependencies
mvn clean install

# Run development server
mvn spring-boot:run

# Build production JAR
mvn clean package
# Output: target/personal-blog-1.0.0.jar

# Run tests
mvn test
```

Backend runs on `http://localhost:8080` with context path `/api`

### Frontend (Vue 3)

```bash
cd frontend

# Install dependencies
npm install

# Run development server (with hot reload)
npm run dev
# Runs on http://localhost:3000

# Build for production
npm run build
# Output: dist/

# Preview production build
npm run preview
```

### Database Setup

```bash
# Initialize database schema
mysql -u root -p < database/blog_schema.sql

# Import test data (recommended)
mysql -u root -p < database/test_data.sql
```

Test data includes: 6 users, 10 articles, 8 categories, 18 tags, 15 comments, 6 messages, 5 announcements.

**Default credentials:**
- Admin: `admin` / `admin123`
- Test users: `testuser1-5` / `test123`

### Testing

```bash
# Automated API tests (requires backend running)
chmod +x test_api.sh
./test_api.sh

# Comprehensive tests with service detection
chmod +x comprehensive_test.sh
./comprehensive_test.sh
```

## Architecture

### Backend Architecture

The backend follows a standard Spring Boot layered architecture:

```
Controller → Service → Mapper → Database
    ↓         ↓         ↓
  (HTTP)  (Business) (MyBatis Plus)
```

**Package structure:**
- `entity/` - JPA entities with MyBatis Plus annotations
- `mapper/` - MyBatis Plus data access interfaces
- `service/` + `service/impl/` - Business logic layer
- `controller/` - Guest-facing REST APIs
- `controller/admin/` - Admin-only REST APIs (JWT protected)
- `config/` - Configuration classes (WebConfig, JwtConfig)
- `interceptor/` - JWT authentication interceptor
- `util/` - Utilities (JwtUtil, MD5Util)
- `common/` - Common classes (Result response wrapper)
- `exception/` - Global exception handler

**Authentication Flow:**
1. JWT interceptor (`JwtInterceptor`) intercepts requests matching:
   - `/admin/**` - All admin endpoints
   - `/comment/add` - Comment creation
   - `/message/add` - Message creation
2. Excludes: `/auth/login`, `/auth/register`, Swagger docs
3. Token format: `Authorization: Bearer <token>`
4. Token expiration: 24 hours (configurable in `application.yml`)

**Key configuration:** `backend/src/main/resources/application.yml`
- Database connection (MySQL)
- JWT secret and expiration
- File upload path (absolute path, needs update for deployment)
- MyBatis Plus settings
- Swagger API docs enabled at `/api/swagger-ui.html`

### Frontend Architecture

Vue 3 with Composition API and three distinct layout sections:

```
Router → Layout → View → API Module → Axios → Backend
           ↓
    (GuestLayout / AdminLayout / AuthLayout)
```

**Directory structure:**
- `views/guest/` - Public-facing pages (Home, ArticleDetail, Category, Tag, Archive, Search, Announcement, About, Message)
- `views/admin/` - Admin dashboard pages (Dashboard, Article, Category, Tag, Announcement, Comment, AdminMessage, User)
- `views/auth/` - Authentication pages (Login, Register)
- `layouts/` - Layout wrappers (GuestLayout, AdminLayout, AuthLayout)
- `api/` - API modules per resource (article.js, auth.js, admin.js, etc.)
- `utils/request.js` - Axios instance with JWT interceptor
- `router/index.js` - Vue Router configuration with route guards
- `styles/harmony.scss` - Harmony Design System theme variables

**Routing:**
- Guest routes: `/`, `/article/:id`, `/category`, `/tag`, `/archive`, `/search`, `/announcement`, `/about`, `/message`
- Auth routes: `/login`, `/register`
- Admin routes: `/admin/*` (requires authentication)

**State Management:**
- Pinia stores (if present in `stores/`)
- JWT token stored in localStorage as `token`

**API Proxy:** Vite dev server proxies `/api` to `http://localhost:8080` (see `vite.config.js`)

## Key Files

### Critical Configuration Files
- `backend/src/main/resources/application.yml` - Backend config (DB, JWT, file paths)
- `backend/pom.xml` - Maven dependencies
- `frontend/package.json` - NPM dependencies
- `frontend/vite.config.js` - Vite config and API proxy
- `database/blog_schema.sql` - Database schema
- `database/test_data.sql` - Test data

### Entry Points
- `backend/src/main/java/com/blog/BlogApplication.java` - Spring Boot main class
- `frontend/src/main.js` - Vue app entry point
- `frontend/index.html` - HTML entry point

### Core Backend Files
- `config/WebConfig.java` - CORS, interceptors, static resources
- `interceptor/JwtInterceptor.java` - JWT authentication
- `util/JwtUtil.java` - JWT token generation/validation
- `common/Result.java` - Standard API response wrapper
- `exception/GlobalExceptionHandler.java` - Exception handling

### Core Frontend Files
- `router/index.js` - Route definitions and guards
- `utils/request.js` - Axios setup with JWT headers
- `styles/harmony.scss` - Harmony Design theme (primary color: #007DFF)

## Important Implementation Details

### File Upload Path
The file upload path in `application.yml` is **hardcoded to an absolute path**:
```yaml
file:
  upload-path: /Users/zishen/Desktop/123/毕业设计/blog/uploads/
```

Also hardcoded in `WebConfig.java:59`. When deploying or working in a different environment, these paths must be updated.

### CORS Configuration
CORS is enabled for all origins in `WebConfig.java`. For production, restrict `allowedOriginPatterns` to specific domains.

### Database Connection
Default connection assumes MySQL on localhost:3306 with database name `personal_blog`. Update credentials in `application.yml` before running.

### API Documentation
Swagger/OpenAPI docs auto-generated at:
- Swagger UI: `http://localhost:8080/api/swagger-ui.html`
- OpenAPI JSON: `http://localhost:8080/api/v3/api-docs`

### Harmony Design System
The UI follows HarmonyOS design principles:
- Primary color: `#007DFF` (sky blue)
- Secondary: `#E6F0FF` (soft blue-white)
- Border radius: 12px
- Font: HarmonyOS Sans (if available)
- Smooth transitions and subtle animations

## Common Development Tasks

### Adding a New Entity/Feature

1. **Backend:**
   ```
   1. Create SQL table in database/
   2. Create Entity class in entity/
   3. Create Mapper interface in mapper/
   4. Create Service interface in service/
   5. Implement ServiceImpl in service/impl/
   6. Create Controller in controller/ (or controller/admin/)
   ```

2. **Frontend:**
   ```
   1. Create API module in api/
   2. Create Vue component in views/guest/ or views/admin/
   3. Add route in router/index.js
   4. Update layout navigation if needed
   ```

### Testing API Endpoints
1. Start backend: `cd backend && mvn spring-boot:run`
2. Visit Swagger UI: `http://localhost:8080/api/swagger-ui.html`
3. Or run automated tests: `./test_api.sh`

### Debugging
- **Backend logs:** Check console output (logging level: debug for `com.blog`)
- **Frontend:** Browser DevTools, Vue DevTools extension
- **API issues:** Use Swagger UI or curl with test_api.sh as reference

### Modifying Authentication
JWT configuration in `application.yml`:
```yaml
jwt:
  secret: personal-blog-secret-key-2025-harmony-design
  expiration: 86400000  # 24 hours in milliseconds
```

Protected paths configured in `WebConfig.java:40-49` addInterceptors method.

## Project Context

This is a graduation project (毕业设计) demonstrating:
- Full-stack development skills
- Modern Spring Boot and Vue 3 practices
- RESTful API design
- JWT authentication
- MyBatis Plus ORM
- Component-based UI architecture
- Harmony Design System implementation

The codebase is well-documented with comprehensive Chinese documentation in `docs/` directory including deployment guides, API documentation, and test reports.
