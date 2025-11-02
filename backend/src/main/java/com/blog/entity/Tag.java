package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 标签实体类
 */
@Data
@TableName("tag")
public class Tag {
    
    /**
     * 标签ID
     */
    @TableId(type = IdType.AUTO)
    private Long tagId;
    
    /**
     * 标签名称
     */
    private String tagName;
    
    /**
     * 文章数量
     */
    private Integer articleCount;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}

