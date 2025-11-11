package com.blog.config;

import com.blog.interceptor.JwtInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web配置类
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    private final JwtInterceptor jwtInterceptor;
    
    public WebConfig(JwtInterceptor jwtInterceptor) {
        this.jwtInterceptor = jwtInterceptor;
    }
    
    /**
     * 配置跨域
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
    
    /**
     * 配置拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/admin/**")  // 拦截管理端接口
                .addPathPatterns("/comment/add")  // 拦截评论接口
                .addPathPatterns("/message/add")  // 拦截留言接口
                .excludePathPatterns(
                        "/auth/login",         // 登录接口
                        "/auth/register",      // 注册接口
                        "/swagger-ui/**",      // Swagger文档
                        "/v3/api-docs/**"      // API文档
                );
    }
    
    /**
     * 配置静态资源
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 文件上传路径映射
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:/Users/zishen/Desktop/123/毕业设计/blog/uploads/");
    }
}

