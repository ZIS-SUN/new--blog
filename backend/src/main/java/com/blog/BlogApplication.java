package com.blog;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 个人博客系统启动类
 * 
 * @author Blog System
 * @version 1.0.0
 */
@SpringBootApplication
@MapperScan("com.blog.mapper")
public class BlogApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(BlogApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("个人博客系统启动成功！");
        System.out.println("接口文档地址: http://localhost:8080/api/swagger-ui.html");
        System.out.println("========================================\n");
    }
}

