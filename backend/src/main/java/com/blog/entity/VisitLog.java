package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 访问统计实体类
 */
@Data
@TableName("visit_log")
public class VisitLog {
    
    /**
     * 访问ID
     */
    @TableId(type = IdType.AUTO)
    private Long visitId;
    
    /**
     * IP地址
     */
    private String ip;
    
    /**
     * 访问页面
     */
    private String page;
    
    /**
     * 设备类型
     */
    private String deviceType;
    
    /**
     * 浏览器
     */
    private String browser;
    
    /**
     * 操作系统
     */
    private String os;
    
    /**
     * 访问时间
     */
    private LocalDateTime visitTime;
}

