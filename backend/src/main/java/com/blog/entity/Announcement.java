package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 公告实体类
 */
@Data
@TableName("announcement")
public class Announcement {
    
    /**
     * 公告ID
     */
    @TableId(type = IdType.AUTO)
    private Long announcementId;
    
    /**
     * 公告标题
     */
    private String title;
    
    /**
     * 公告内容
     */
    private String content;
    
    /**
     * 公告摘要
     */
    private String summary;
    
    /**
     * 是否置顶: 0-否, 1-是
     */
    private Integer isTop;
    
    /**
     * 是否紧急: 0-否, 1-是
     */
    private Integer isEmergency;
    
    /**
     * 状态: 0-隐藏, 1-发布
     */
    private Integer status;
    
    /**
     * 发布时间
     */
    private LocalDateTime publishTime;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}

