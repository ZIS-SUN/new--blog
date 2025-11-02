package com.blog.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.Message;

/**
 * 留言Service
 */
public interface MessageService extends IService<Message> {
    
    /**
     * 获取留言列表（分页）
     */
    Page<Message> getMessages(int current, int size);
    
    /**
     * 发表留言
     */
    Message addMessage(Long userId, Long parentId, String content);
}


