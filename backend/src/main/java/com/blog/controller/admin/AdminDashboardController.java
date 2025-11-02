package com.blog.controller.admin;

import com.blog.common.Result;
import com.blog.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 仪表盘控制器（后台）
 */
@Tag(name = "仪表盘（后台）")
@RestController
@RequestMapping("/admin/dashboard")
public class AdminDashboardController {
    
    private final ArticleService articleService;
    private final UserService userService;
    private final CommentService commentService;
    private final MessageService messageService;
    private final AnnouncementService announcementService;
    
    public AdminDashboardController(
            ArticleService articleService,
            UserService userService,
            CommentService commentService,
            MessageService messageService,
            AnnouncementService announcementService) {
        this.articleService = articleService;
        this.userService = userService;
        this.commentService = commentService;
        this.messageService = messageService;
        this.announcementService = announcementService;
    }
    
    /**
     * 获取统计数据
     */
    @Operation(summary = "获取统计数据")
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        Map<String, Object> data = new HashMap<>();
        
        // 统计数量
        data.put("articleCount", articleService.count());
        data.put("userCount", userService.count());
        data.put("commentCount", commentService.count());
        data.put("messageCount", messageService.count());
        data.put("announcementCount", announcementService.count());
        
        return Result.success(data);
    }
}


