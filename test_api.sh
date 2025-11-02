#!/bin/bash

# 个人博客系统 API 自动化测试脚本
# 使用方法: chmod +x test_api.sh && ./test_api.sh

BASE_URL="http://localhost:8080/api"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0

echo "========================================="
echo "  个人博客系统 API 自动化测试"
echo "========================================="
echo ""

# 测试函数
test_api() {
    local name=$1
    local method=$2
    local url=$3
    local data=$4
    local headers=$5
    
    echo -n "测试: $name ... "
    
    if [ -z "$data" ]; then
        if [ -z "$headers" ]; then
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url")
        else
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" -H "$headers")
        fi
    else
        if [ -z "$headers" ]; then
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" \
                -H "Content-Type: application/json" \
                -d "$data")
        else
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" \
                -H "Content-Type: application/json" \
                -H "$headers" \
                -d "$data")
        fi
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    if [ "$http_code" == "200" ]; then
        echo -e "${GREEN}✓ 通过${NC} (HTTP $http_code)"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗ 失败${NC} (HTTP $http_code)"
        echo "  响应: $body"
        ((FAIL_COUNT++))
        return 1
    fi
}

echo "===== 1. 认证模块测试 ====="
echo ""

# 测试注册（可能失败，因为用户名已存在）
echo -n "测试: 用户注册 ... "
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/auth/register" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "autotest_'$(date +%s)'",
        "password": "123456",
        "email": "autotest_'$(date +%s)'@test.com",
        "nickname": "自动测试用户"
    }')
http_code=$(echo "$response" | tail -n1)
if [ "$http_code" == "200" ]; then
    echo -e "${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ 跳过${NC} (可能用户已存在)"
fi

# 测试登录
echo -n "测试: 管理员登录 ... "
LOGIN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin123"}')

http_code=$(echo "$LOGIN_RESPONSE" | tail -n1)
body=$(echo "$LOGIN_RESPONSE" | head -n-1)

if [ "$http_code" == "200" ]; then
    TOKEN=$(echo "$body" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo -e "${GREEN}✓ 通过${NC}"
    echo "  Token: ${TOKEN:0:30}..."
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    echo "  无法获取Token，后续需要认证的测试将跳过"
    ((FAIL_COUNT++))
    TOKEN=""
fi

echo ""
echo "===== 2. 文章模块测试（访客端） ====="
echo ""

test_api "获取文章列表" "GET" "/article/list?current=1&size=5"
test_api "获取文章详情" "GET" "/article/1"
test_api "根据分类查询文章" "GET" "/article/category/1?current=1&size=5"
test_api "搜索文章" "GET" "/article/search?keyword=Spring&current=1&size=5"
test_api "文章点赞" "POST" "/article/1/like"

echo ""
echo "===== 3. 分类和标签测试 ====="
echo ""

test_api "获取分类列表" "GET" "/category/list"
test_api "获取分类详情" "GET" "/category/1"
test_api "获取标签列表" "GET" "/tag/list"
test_api "获取标签详情" "GET" "/tag/1"

echo ""
echo "===== 4. 公告模块测试 ====="
echo ""

test_api "获取公告列表" "GET" "/announcement/list?current=1&size=5"
test_api "获取置顶公告" "GET" "/announcement/top"
test_api "获取公告详情" "GET" "/announcement/1"

echo ""
echo "===== 5. 评论和留言测试 ====="
echo ""

test_api "获取文章评论" "GET" "/comment/article/1?current=1&size=10"
test_api "获取留言列表" "GET" "/message/list?current=1&size=10"

if [ -n "$TOKEN" ]; then
    echo ""
    echo "===== 6. 管理端测试（需要Token） ====="
    echo ""
    
    test_api "仪表盘统计" "GET" "/admin/dashboard/statistics" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有文章（管理端）" "GET" "/admin/article/list?current=1&size=5" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有分类（管理端）" "GET" "/admin/category/list" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有标签（管理端）" "GET" "/tag/list" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有公告（管理端）" "GET" "/admin/announcement/list?current=1&size=5" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有评论（管理端）" "GET" "/admin/comment/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    test_api "获取所有留言（管理端）" "GET" "/admin/message/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    test_api "获取用户列表" "GET" "/admin/user/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    
    echo ""
    echo "===== 7. 创建操作测试 ====="
    echo ""
    
    # 测试创建文章
    test_api "创建文章" "POST" "/admin/article/create" \
        '{
            "userId": 1,
            "categoryId": 1,
            "title": "自动化测试文章 - '$(date +%Y%m%d%H%M%S)'",
            "summary": "这是通过自动化测试创建的文章",
            "content": "# 自动化测试\\n\\n这是测试内容。",
            "status": 0,
            "isTop": 0
        }' \
        "Authorization: Bearer $TOKEN"
    
    # 测试创建公告
    test_api "创建公告" "POST" "/admin/announcement/create" \
        '{
            "title": "自动化测试公告 - '$(date +%Y%m%d%H%M%S)'",
            "summary": "测试公告摘要",
            "content": "这是通过自动化测试创建的公告",
            "isTop": 0,
            "isEmergency": 0,
            "status": 0
        }' \
        "Authorization: Bearer $TOKEN"
else
    echo -e "${YELLOW}跳过管理端测试（未获取到Token）${NC}"
fi

echo ""
echo "========================================="
echo "  测试完成！"
echo "========================================="
echo ""
echo -e "通过: ${GREEN}$PASS_COUNT${NC}"
echo -e "失败: ${RED}$FAIL_COUNT${NC}"
echo -e "总计: $((PASS_COUNT + FAIL_COUNT))"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ 所有测试通过！${NC}"
    exit 0
else
    echo -e "${RED}✗ 有 $FAIL_COUNT 个测试失败${NC}"
    exit 1
fi


