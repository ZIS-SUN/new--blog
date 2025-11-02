package com.blog.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.User;

/**
 * 用户Service
 */
public interface UserService extends IService<User> {
    
    /**
     * 用户注册
     */
    User register(String username, String password, String email, String nickname);
    
    /**
     * 用户登录
     */
    String login(String username, String password);
    
    /**
     * 根据用户名查询
     */
    User getByUsername(String username);
    
    /**
     * 根据邮箱查询
     */
    User getByEmail(String email);
}

