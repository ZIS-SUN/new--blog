package com.blog.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.blog.entity.Log;
import org.apache.ibatis.annotations.Mapper;

/**
 * 日志Mapper
 */
@Mapper
public interface LogMapper extends BaseMapper<Log> {
}

