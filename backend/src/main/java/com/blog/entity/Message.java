package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 留言实体类
 */
@Data
@TableName("message")
public class Message {
    
    /**
     * 留言ID
     */
    @TableId(type = IdType.AUTO)
    private Long messageId;
    
    /**
     * 留言用户ID
     */
    private Long userId;
    
    /**
     * 父留言ID(用于回复)
     */
    private Long parentId;
    
    /**
     * 留言内容
     */
    private String content;
    
    /**
     * 状态: 0-待审核, 1-已通过, 2-已屏蔽
     */
    private Integer status;
    
    /**
     * 留言时间
     */
    private LocalDateTime createTime;
}

