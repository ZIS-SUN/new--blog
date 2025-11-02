package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 文章实体类
 */
@Data
@TableName("article")
public class Article {
    
    /**
     * 文章ID
     */
    @TableId(type = IdType.AUTO)
    private Long articleId;
    
    /**
     * 作者ID
     */
    private Long userId;
    
    /**
     * 分类ID
     */
    private Long categoryId;
    
    /**
     * 文章标题
     */
    private String title;
    
    /**
     * 文章摘要
     */
    private String summary;
    
    /**
     * 文章内容(Markdown)
     */
    private String content;
    
    /**
     * 封面图片URL
     */
    private String coverImage;
    
    /**
     * 阅读数
     */
    private Integer viewCount;
    
    /**
     * 点赞数
     */
    private Integer likeCount;
    
    /**
     * 评论数
     */
    private Integer commentCount;
    
    /**
     * 是否置顶: 0-否, 1-是
     */
    private Integer isTop;
    
    /**
     * 状态: 0-草稿, 1-已发布
     */
    private Integer status;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
    
    /**
     * 发布时间
     */
    private LocalDateTime publishTime;
}

