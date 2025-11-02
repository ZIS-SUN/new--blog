package com.blog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.blog.entity.Message;
import com.blog.mapper.MessageMapper;
import com.blog.service.MessageService;
import org.springframework.stereotype.Service;

/**
 * 留言Service实现类
 */
@Service
public class MessageServiceImpl extends ServiceImpl<MessageMapper, Message> implements MessageService {
    
    @Override
    public Page<Message> getMessages(int current, int size) {
        Page<Message> page = new Page<>(current, size);
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Message::getStatus, 1) // 已通过审核
                .orderByDesc(Message::getCreateTime);
        return page(page, wrapper);
    }
    
    @Override
    public Message addMessage(Long userId, Long parentId, String content) {
        Message message = new Message();
        message.setUserId(userId);
        message.setParentId(parentId);
        message.setContent(content);
        message.setStatus(1); // 默认通过审核
        save(message);
        return message;
    }
}


