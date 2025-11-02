package com.blog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.blog.entity.Comment;
import com.blog.mapper.CommentMapper;
import com.blog.service.CommentService;
import org.springframework.stereotype.Service;

/**
 * 评论Service实现类
 */
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {
    
    @Override
    public Page<Comment> getCommentsByArticleId(Long articleId, int current, int size) {
        Page<Comment> page = new Page<>(current, size);
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getArticleId, articleId)
                .eq(Comment::getStatus, 1) // 已通过审核
                .orderByDesc(Comment::getCreateTime);
        return page(page, wrapper);
    }
    
    @Override
    public Comment addComment(Long articleId, Long userId, Long parentId, String content) {
        Comment comment = new Comment();
        comment.setArticleId(articleId);
        comment.setUserId(userId);
        comment.setParentId(parentId);
        comment.setContent(content);
        comment.setStatus(1); // 默认通过审核，可根据需求修改
        save(comment);
        return comment;
    }
}


