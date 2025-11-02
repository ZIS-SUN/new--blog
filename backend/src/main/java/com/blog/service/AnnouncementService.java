package com.blog.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.Announcement;

import java.util.List;

/**
 * 公告Service
 */
public interface AnnouncementService extends IService<Announcement> {
    
    /**
     * 获取已发布的公告列表（分页）
     */
    Page<Announcement> getPublishedAnnouncements(int current, int size);
    
    /**
     * 获取置顶公告
     */
    List<Announcement> getTopAnnouncements();
}


