package com.blog.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Comment;
import com.blog.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 评论控制器（访客端）
 */
@Tag(name = "评论管理（访客端）")
@RestController
@RequestMapping("/comment")
public class CommentController {
    
    private final CommentService commentService;
    
    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }
    
    /**
     * 获取文章评论列表
     */
    @Operation(summary = "获取文章评论列表")
    @GetMapping("/article/{articleId}")
    public Result<Page<Comment>> getByArticle(
            @PathVariable Long articleId,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "20") int size) {
        Page<Comment> page = commentService.getCommentsByArticleId(articleId, current, size);
        return Result.success(page);
    }
    
    /**
     * 发表评论（需要登录）
     */
    @Operation(summary = "发表评论")
    @PostMapping("/add")
    public Result<Comment> addComment(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        try {
            Long userId = (Long) request.getAttribute("userId");
            Long articleId = Long.valueOf(params.get("articleId").toString());
            String content = params.get("content").toString();
            Long parentId = params.get("parentId") != null ? 
                    Long.valueOf(params.get("parentId").toString()) : null;
            
            Comment comment = commentService.addComment(articleId, userId, parentId, content);
            return Result.success("评论成功", comment);
        } catch (Exception e) {
            return Result.error("评论失败：" + e.getMessage());
        }
    }
}


