package com.blog.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Message;
import com.blog.service.MessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 留言控制器（访客端）
 */
@Tag(name = "留言管理（访客端）")
@RestController
@RequestMapping("/message")
public class MessageController {
    
    private final MessageService messageService;
    
    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }
    
    /**
     * 获取留言列表
     */
    @Operation(summary = "获取留言列表")
    @GetMapping("/list")
    public Result<Page<Message>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "20") int size) {
        Page<Message> page = messageService.getMessages(current, size);
        return Result.success(page);
    }
    
    /**
     * 发表留言（需要登录）
     */
    @Operation(summary = "发表留言")
    @PostMapping("/add")
    public Result<Message> addMessage(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        try {
            Long userId = (Long) request.getAttribute("userId");
            String content = params.get("content").toString();
            Long parentId = params.get("parentId") != null ? 
                    Long.valueOf(params.get("parentId").toString()) : null;
            
            Message message = messageService.addMessage(userId, parentId, content);
            return Result.success("留言成功", message);
        } catch (Exception e) {
            return Result.error("留言失败：" + e.getMessage());
        }
    }
}


