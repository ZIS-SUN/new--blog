package com.blog.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Announcement;
import com.blog.service.AnnouncementService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 公告控制器（访客端）
 */
@Tag(name = "公告管理（访客端）")
@RestController
@RequestMapping("/announcement")
public class AnnouncementController {
    
    private final AnnouncementService announcementService;
    
    public AnnouncementController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }
    
    /**
     * 分页查询公告列表
     */
    @Operation(summary = "分页查询公告列表")
    @GetMapping("/list")
    public Result<Page<Announcement>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Announcement> page = announcementService.getPublishedAnnouncements(current, size);
        return Result.success(page);
    }
    
    /**
     * 获取置顶公告
     */
    @Operation(summary = "获取置顶公告")
    @GetMapping("/top")
    public Result<List<Announcement>> getTopAnnouncements() {
        List<Announcement> announcements = announcementService.getTopAnnouncements();
        return Result.success(announcements);
    }
    
    /**
     * 获取公告详情
     */
    @Operation(summary = "获取公告详情")
    @GetMapping("/{id}")
    public Result<Announcement> getById(@PathVariable Long id) {
        Announcement announcement = announcementService.getById(id);
        if (announcement != null && announcement.getStatus() == 1) {
            return Result.success(announcement);
        }
        return Result.error("公告不存在");
    }
}


