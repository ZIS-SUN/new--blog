package com.blog.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Announcement;
import com.blog.service.AnnouncementService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

/**
 * 公告管理控制器（后台）
 */
@Tag(name = "公告管理（后台）")
@RestController
@RequestMapping("/admin/announcement")
public class AdminAnnouncementController {
    
    private final AnnouncementService announcementService;
    
    public AdminAnnouncementController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }
    
    /**
     * 分页查询所有公告
     */
    @Operation(summary = "分页查询所有公告")
    @GetMapping("/list")
    public Result<Page<Announcement>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Announcement> page = new Page<>(current, size);
        return Result.success(announcementService.page(page));
    }
    
    /**
     * 创建公告
     */
    @Operation(summary = "创建公告")
    @PostMapping("/create")
    public Result<Announcement> create(@RequestBody Announcement announcement) {
        try {
            announcementService.save(announcement);
            return Result.success("创建成功", announcement);
        } catch (Exception e) {
            return Result.error("创建失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新公告
     */
    @Operation(summary = "更新公告")
    @PutMapping("/update")
    public Result<Announcement> update(@RequestBody Announcement announcement) {
        try {
            announcementService.updateById(announcement);
            return Result.success("更新成功", announcement);
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除公告
     */
    @Operation(summary = "删除公告")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            announcementService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}


