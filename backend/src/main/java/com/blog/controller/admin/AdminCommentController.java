package com.blog.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Comment;
import com.blog.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 评论管理控制器（后台）
 */
@Tag(name = "评论管理（后台）")
@RestController
@RequestMapping("/admin/comment")
public class AdminCommentController {
    
    private final CommentService commentService;
    
    public AdminCommentController(CommentService commentService) {
        this.commentService = commentService;
    }
    
    /**
     * 分页查询所有评论
     */
    @Operation(summary = "分页查询所有评论")
    @GetMapping("/list")
    public Result<Page<Comment>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Comment> page = new Page<>(current, size);
        return Result.success(commentService.page(page));
    }
    
    /**
     * 审核通过评论
     */
    @Operation(summary = "审核通过评论")
    @PutMapping("/approve")
    public Result<?> approve(@RequestBody Map<String, Object> params) {
        try {
            Long commentId = Long.valueOf(params.get("commentId").toString());
            Comment comment = commentService.getById(commentId);
            if (comment != null) {
                comment.setStatus(1);
                commentService.updateById(comment);
                return Result.success("审核成功", null);
            }
            return Result.error("评论不存在");
        } catch (Exception e) {
            return Result.error("审核失败：" + e.getMessage());
        }
    }
    
    /**
     * 屏蔽评论
     */
    @Operation(summary = "屏蔽评论")
    @PutMapping("/block")
    public Result<?> block(@RequestBody Map<String, Object> params) {
        try {
            Long commentId = Long.valueOf(params.get("commentId").toString());
            Comment comment = commentService.getById(commentId);
            if (comment != null) {
                comment.setStatus(2);
                commentService.updateById(comment);
                return Result.success("屏蔽成功", null);
            }
            return Result.error("评论不存在");
        } catch (Exception e) {
            return Result.error("屏蔽失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除评论
     */
    @Operation(summary = "删除评论")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            commentService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
    
    /**
     * 批量删除评论
     */
    @Operation(summary = "批量删除评论")
    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody java.util.List<Long> ids) {
        try {
            commentService.removeByIds(ids);
            return Result.success("批量删除成功", null);
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }
}

