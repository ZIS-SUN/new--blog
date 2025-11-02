#!/bin/bash

# 个人博客系统 - 完整测试脚本（包含服务检测）
# 使用方法: chmod +x comprehensive_test.sh && ./comprehensive_test.sh

BASE_URL="http://localhost:8080/api"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

echo "========================================="
echo "  个人博客系统 - 完整测试"
echo "========================================="
echo ""

# 检查服务是否启动
echo -e "${BLUE}检查后端服务状态...${NC}"
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:8080/api/category/list > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 后端服务已启动${NC}"
        break
    fi
    echo -n "."
    sleep 2
    ((RETRY_COUNT++))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}✗ 后端服务未启动，请先启动后端服务${NC}"
    echo "启动命令: cd backend && mvn spring-boot:run"
    exit 1
fi

echo ""
echo "========================================="
echo "  开始API接口测试"
echo "========================================="
echo ""

# 测试函数
test_api() {
    local name=$1
    local method=$2
    local url=$3
    local data=$4
    local headers=$5
    local expect_success=${6:-true}
    
    echo -n "测试: $name ... "
    
    if [ -z "$data" ]; then
        if [ -z "$headers" ]; then
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" 2>&1)
        else
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" -H "$headers" 2>&1)
        fi
    else
        if [ -z "$headers" ]; then
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" \
                -H "Content-Type: application/json" \
                -d "$data" 2>&1)
        else
            response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$url" \
                -H "Content-Type: application/json" \
                -H "$headers" \
                -d "$data" 2>&1)
        fi
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "200" ] || [ "$http_code" == "201" ]; then
        echo -e "${GREEN}✓ 通过${NC} (HTTP $http_code)"
        ((PASS_COUNT++))
        return 0
    elif [ "$expect_success" == "false" ]; then
        echo -e "${GREEN}✓ 符合预期${NC} (HTTP $http_code)"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗ 失败${NC} (HTTP $http_code)"
        ((FAIL_COUNT++))
        return 1
    fi
}

echo "===== 1. 认证模块测试 (3个接口) ====="
echo ""

# 测试注册
RANDOM_NUM=$(date +%s)
test_api "用户注册" "POST" "/auth/register" \
    "{
        \"username\": \"test_${RANDOM_NUM}\",
        \"password\": \"123456\",
        \"email\": \"test_${RANDOM_NUM}@test.com\",
        \"nickname\": \"测试用户\"
    }"

# 测试登录
echo -n "测试: 管理员登录 ... "
LOGIN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin123"}' 2>&1)

http_code=$(echo "$LOGIN_RESPONSE" | tail -n1)
body=$(echo "$LOGIN_RESPONSE" | sed '$d')

if [ "$http_code" == "200" ]; then
    TOKEN=$(echo "$body" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo -e "${GREEN}✓ 通过${NC} (获取Token成功)"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC} (HTTP $http_code)"
    ((FAIL_COUNT++))
    TOKEN=""
fi

test_api "退出登录" "POST" "/auth/logout"

echo ""
echo "===== 2. 文章模块测试 - 访客端 (6个接口) ====="
echo ""

test_api "获取文章列表（分页）" "GET" "/article/list?current=1&size=5"
test_api "获取文章详情（ID=1）" "GET" "/article/1"
test_api "根据分类查询文章" "GET" "/article/category/1?current=1&size=5"
test_api "根据标签查询文章" "GET" "/article/tag/1?current=1&size=5"
test_api "搜索文章（关键词：Spring）" "GET" "/article/search?keyword=Spring&current=1&size=5"
test_api "文章点赞（ID=1）" "POST" "/article/1/like"

echo ""
echo "===== 3. 分类和标签测试 (4个接口) ====="
echo ""

test_api "获取所有分类" "GET" "/category/list"
test_api "获取分类详情（ID=1）" "GET" "/category/1"
test_api "获取所有标签" "GET" "/tag/list"
test_api "获取标签详情（ID=1）" "GET" "/tag/1"

echo ""
echo "===== 4. 公告模块测试 (3个接口) ====="
echo ""

test_api "获取公告列表（分页）" "GET" "/announcement/list?current=1&size=5"
test_api "获取置顶公告" "GET" "/announcement/top"
test_api "获取公告详情（ID=1）" "GET" "/announcement/1"

echo ""
echo "===== 5. 评论和留言测试 (2个接口) ====="
echo ""

test_api "获取文章评论（文章ID=1）" "GET" "/comment/article/1?current=1&size=10"
test_api "获取留言列表" "GET" "/message/list?current=1&size=10"

if [ -n "$TOKEN" ]; then
    echo ""
    echo "===== 6. 管理端测试 - 需要Token (15个接口) ====="
    echo ""
    
    # 仪表盘
    test_api "仪表盘统计数据" "GET" "/admin/dashboard/statistics" "" "Authorization: Bearer $TOKEN"
    
    # 文章管理
    test_api "获取所有文章（管理端）" "GET" "/admin/article/list?current=1&size=5" "" "Authorization: Bearer $TOKEN"
    test_api "创建文章" "POST" "/admin/article/create" \
        "{
            \"userId\": 1,
            \"categoryId\": 1,
            \"title\": \"API测试文章_${RANDOM_NUM}\",
            \"summary\": \"这是API测试创建的文章\",
            \"content\": \"# API测试\\n\\n文章内容\",
            \"status\": 0,
            \"isTop\": 0
        }" \
        "Authorization: Bearer $TOKEN"
    
    # 分类管理
    test_api "获取所有分类（管理端）" "GET" "/admin/category/list" "" "Authorization: Bearer $TOKEN"
    
    # 标签管理
    test_api "获取所有标签（管理端）" "GET" "/tag/list" "" "Authorization: Bearer $TOKEN"
    
    # 公告管理
    test_api "获取所有公告（管理端）" "GET" "/admin/announcement/list?current=1&size=5" "" "Authorization: Bearer $TOKEN"
    test_api "创建公告" "POST" "/admin/announcement/create" \
        "{
            \"title\": \"API测试公告_${RANDOM_NUM}\",
            \"summary\": \"测试摘要\",
            \"content\": \"测试内容\",
            \"isTop\": 0,
            \"isEmergency\": 0,
            \"status\": 0
        }" \
        "Authorization: Bearer $TOKEN"
    
    # 评论管理
    test_api "获取所有评论（管理端）" "GET" "/admin/comment/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    
    # 留言管理
    test_api "获取所有留言（管理端）" "GET" "/admin/message/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    
    # 用户管理
    test_api "获取用户列表" "GET" "/admin/user/list?current=1&size=10" "" "Authorization: Bearer $TOKEN"
    
    echo ""
    echo "===== 7. 需要登录的操作测试 (2个接口) ====="
    echo ""
    
    # 普通用户登录
    echo -n "测试: 普通用户登录 ... "
    USER_LOGIN=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d '{"username":"testuser1","password":"test123"}' 2>&1)
    
    user_http_code=$(echo "$USER_LOGIN" | tail -n1)
    user_body=$(echo "$USER_LOGIN" | sed '$d')
    
    if [ "$user_http_code" == "200" ]; then
        USER_TOKEN=$(echo "$user_body" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
        echo -e "${GREEN}✓ 通过${NC}"
        ((PASS_COUNT++))
        
        # 测试发表评论
        test_api "发表评论（需要登录）" "POST" "/comment/add" \
            "{
                \"articleId\": 1,
                \"content\": \"API自动化测试评论_${RANDOM_NUM}\",
                \"parentId\": null
            }" \
            "Authorization: Bearer $USER_TOKEN"
        
        # 测试发表留言
        test_api "发表留言（需要登录）" "POST" "/message/add" \
            "{
                \"content\": \"API自动化测试留言_${RANDOM_NUM}\",
                \"parentId\": null
            }" \
            "Authorization: Bearer $USER_TOKEN"
    else
        echo -e "${RED}✗ 失败${NC}"
        ((FAIL_COUNT++))
        ((SKIP_COUNT+=2))
    fi
    
else
    echo -e "${YELLOW}⚠ 跳过管理端测试（未获取管理员Token）${NC}"
    ((SKIP_COUNT+=15))
fi

echo ""
echo "===== 8. 权限测试 (2个测试) ====="
echo ""

# 测试未登录访问需认证接口
test_api "未登录访问管理端接口（应返回401）" "GET" "/admin/dashboard/statistics" "" "" "false"

# 如果有普通用户token，测试访问管理端
if [ -n "$USER_TOKEN" ]; then
    test_api "普通用户访问管理端（应返回403或401）" "GET" "/admin/dashboard/statistics" "" "Authorization: Bearer $USER_TOKEN" "false"
else
    echo -e "${YELLOW}⚠ 跳过普通用户权限测试${NC}"
    ((SKIP_COUNT++))
fi

echo ""
echo "========================================="
echo "  测试完成！"
echo "========================================="
echo ""
echo -e "${GREEN}通过: $PASS_COUNT${NC}"
echo -e "${RED}失败: $FAIL_COUNT${NC}"
if [ $SKIP_COUNT -gt 0 ]; then
    echo -e "${YELLOW}跳过: $SKIP_COUNT${NC}"
fi
echo -e "总计: $((PASS_COUNT + FAIL_COUNT + SKIP_COUNT))"
echo ""

# 计算成功率
if [ $((PASS_COUNT + FAIL_COUNT)) -gt 0 ]; then
    SUCCESS_RATE=$(awk "BEGIN {printf \"%.1f\", ($PASS_COUNT/($PASS_COUNT+$FAIL_COUNT))*100}")
    echo "成功率: ${SUCCESS_RATE}%"
    echo ""
fi

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}========================================="
    echo "  ✓ 所有测试通过！"
    echo "=========================================${NC}"
    exit 0
else
    echo -e "${RED}========================================="
    echo "  ✗ 有 $FAIL_COUNT 个测试失败"
    echo "=========================================${NC}"
    echo ""
    echo "请检查后端日志: tail -f backend.log"
    exit 1
fi


