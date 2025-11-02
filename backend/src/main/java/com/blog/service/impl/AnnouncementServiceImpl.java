package com.blog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.blog.entity.Announcement;
import com.blog.mapper.AnnouncementMapper;
import com.blog.service.AnnouncementService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 公告Service实现类
 */
@Service
public class AnnouncementServiceImpl extends ServiceImpl<AnnouncementMapper, Announcement> implements AnnouncementService {
    
    @Override
    public Page<Announcement> getPublishedAnnouncements(int current, int size) {
        Page<Announcement> page = new Page<>(current, size);
        LambdaQueryWrapper<Announcement> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Announcement::getStatus, 1)
                .orderByDesc(Announcement::getIsTop)
                .orderByDesc(Announcement::getPublishTime);
        return page(page, wrapper);
    }
    
    @Override
    public List<Announcement> getTopAnnouncements() {
        LambdaQueryWrapper<Announcement> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Announcement::getStatus, 1)
                .eq(Announcement::getIsTop, 1)
                .orderByDesc(Announcement::getPublishTime)
                .last("LIMIT 5");
        return list(wrapper);
    }
}


