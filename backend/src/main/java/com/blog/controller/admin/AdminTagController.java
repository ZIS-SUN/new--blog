package com.blog.controller.admin;

import com.blog.common.Result;
import com.blog.entity.Tag;
import com.blog.service.TagService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签管理控制器（后台）
 */
@io.swagger.v3.oas.annotations.tags.Tag(name = "标签管理（后台）")
@RestController
@RequestMapping("/admin/tag")
public class AdminTagController {
    
    private final TagService tagService;
    
    public AdminTagController(TagService tagService) {
        this.tagService = tagService;
    }
    
    /**
     * 获取所有标签
     */
    @Operation(summary = "获取所有标签")
    @GetMapping("/list")
    public Result<List<Tag>> list() {
        return Result.success(tagService.list());
    }
    
    /**
     * 创建标签
     */
    @Operation(summary = "创建标签")
    @PostMapping("/create")
    public Result<Tag> create(@RequestBody Tag tag) {
        try {
            tagService.save(tag);
            return Result.success("创建成功", tag);
        } catch (Exception e) {
            return Result.error("创建失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新标签
     */
    @Operation(summary = "更新标签")
    @PutMapping("/update")
    public Result<Tag> update(@RequestBody Tag tag) {
        try {
            tagService.updateById(tag);
            return Result.success("更新成功", tag);
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除标签
     */
    @Operation(summary = "删除标签")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            tagService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}

