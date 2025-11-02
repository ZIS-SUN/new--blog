package com.blog.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.Comment;

/**
 * 评论Service
 */
public interface CommentService extends IService<Comment> {
    
    /**
     * 根据文章ID获取评论（分页）
     */
    Page<Comment> getCommentsByArticleId(Long articleId, int current, int size);
    
    /**
     * 发表评论
     */
    Comment addComment(Long articleId, Long userId, Long parentId, String content);
}


