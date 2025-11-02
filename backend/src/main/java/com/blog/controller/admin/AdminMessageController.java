package com.blog.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Message;
import com.blog.service.MessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 留言管理控制器（后台）
 */
@Tag(name = "留言管理（后台）")
@RestController
@RequestMapping("/admin/message")
public class AdminMessageController {
    
    private final MessageService messageService;
    
    public AdminMessageController(MessageService messageService) {
        this.messageService = messageService;
    }
    
    /**
     * 分页查询所有留言
     */
    @Operation(summary = "分页查询所有留言")
    @GetMapping("/list")
    public Result<Page<Message>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Message> page = new Page<>(current, size);
        return Result.success(messageService.page(page));
    }
    
    /**
     * 审核通过留言
     */
    @Operation(summary = "审核通过留言")
    @PutMapping("/approve")
    public Result<?> approve(@RequestBody Map<String, Object> params) {
        try {
            Long messageId = Long.valueOf(params.get("messageId").toString());
            Message message = messageService.getById(messageId);
            if (message != null) {
                message.setStatus(1);
                messageService.updateById(message);
                return Result.success("审核成功", null);
            }
            return Result.error("留言不存在");
        } catch (Exception e) {
            return Result.error("审核失败：" + e.getMessage());
        }
    }
    
    /**
     * 屏蔽留言
     */
    @Operation(summary = "屏蔽留言")
    @PutMapping("/block")
    public Result<?> block(@RequestBody Map<String, Object> params) {
        try {
            Long messageId = Long.valueOf(params.get("messageId").toString());
            Message message = messageService.getById(messageId);
            if (message != null) {
                message.setStatus(2);
                messageService.updateById(message);
                return Result.success("屏蔽成功", null);
            }
            return Result.error("留言不存在");
        } catch (Exception e) {
            return Result.error("屏蔽失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除留言
     */
    @Operation(summary = "删除留言")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            messageService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
    
    /**
     * 批量删除留言
     */
    @Operation(summary = "批量删除留言")
    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody java.util.List<Long> ids) {
        try {
            messageService.removeByIds(ids);
            return Result.success("批量删除成功", null);
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }
}

