package com.blog.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.blog.entity.VisitLog;
import org.apache.ibatis.annotations.Mapper;

/**
 * 访问统计Mapper
 */
@Mapper
public interface VisitLogMapper extends BaseMapper<VisitLog> {
}

