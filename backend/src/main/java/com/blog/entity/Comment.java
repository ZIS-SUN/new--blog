package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 评论实体类
 */
@Data
@TableName("comment")
public class Comment {
    
    /**
     * 评论ID
     */
    @TableId(type = IdType.AUTO)
    private Long commentId;
    
    /**
     * 文章ID
     */
    private Long articleId;
    
    /**
     * 评论用户ID
     */
    private Long userId;
    
    /**
     * 父评论ID(用于回复)
     */
    private Long parentId;
    
    /**
     * 评论内容
     */
    private String content;
    
    /**
     * 状态: 0-待审核, 1-已通过, 2-已屏蔽
     */
    private Integer status;
    
    /**
     * 评论时间
     */
    private LocalDateTime createTime;
}

