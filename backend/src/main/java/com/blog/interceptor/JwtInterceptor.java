package com.blog.interceptor;

import com.alibaba.fastjson2.JSON;
import com.blog.common.Result;
import com.blog.config.JwtConfig;
import com.blog.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT拦截器
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    private final JwtUtil jwtUtil;
    private final JwtConfig jwtConfig;
    
    public JwtInterceptor(JwtUtil jwtUtil, JwtConfig jwtConfig) {
        this.jwtUtil = jwtUtil;
        this.jwtConfig = jwtConfig;
    }
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 跨域预检请求直接放行
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }
        
        // 获取Token
        String token = request.getHeader(jwtConfig.getHeader());
        
        if (token == null || token.isEmpty()) {
            responseUnauthorized(response, "未提供认证信息");
            return false;
        }
        
        // 移除Bearer前缀
        if (token.startsWith(jwtConfig.getPrefix())) {
            token = token.substring(jwtConfig.getPrefix().length()).trim();
        }
        
        // 验证Token
        if (!jwtUtil.validateToken(token)) {
            responseUnauthorized(response, "认证信息无效或已过期");
            return false;
        }
        
        // 将用户信息存入请求属性
        Long userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);
        Integer role = jwtUtil.getRoleFromToken(token);
        
        request.setAttribute("userId", userId);
        request.setAttribute("username", username);
        request.setAttribute("role", role);
        
        return true;
    }
    
    /**
     * 返回未授权响应
     */
    private void responseUnauthorized(HttpServletResponse response, String message) throws Exception {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(JSON.toJSONString(Result.error(401, message)));
    }
}

