package com.blog.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 系统日志实体类
 */
@Data
@TableName("log")
public class Log {
    
    /**
     * 日志ID
     */
    @TableId(type = IdType.AUTO)
    private Long logId;
    
    /**
     * 操作用户ID
     */
    private Long userId;
    
    /**
     * 操作用户名
     */
    private String username;
    
    /**
     * 操作类型
     */
    private String operation;
    
    /**
     * 请求方法
     */
    private String method;
    
    /**
     * 请求参数
     */
    private String params;
    
    /**
     * IP地址
     */
    private String ip;
    
    /**
     * IP归属地
     */
    private String location;
    
    /**
     * 状态: 0-失败, 1-成功
     */
    private Integer status;
    
    /**
     * 错误信息
     */
    private String errorMsg;
    
    /**
     * 操作时间
     */
    private LocalDateTime createTime;
}

