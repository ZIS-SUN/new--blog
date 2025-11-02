package com.blog.controller;

import com.blog.common.Result;
import com.blog.entity.Tag;
import com.blog.service.TagService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签控制器（访客端）
 */
@io.swagger.v3.oas.annotations.tags.Tag(name = "标签管理（访客端）")
@RestController
@RequestMapping("/tag")
public class TagController {
    
    private final TagService tagService;
    
    public TagController(TagService tagService) {
        this.tagService = tagService;
    }
    
    /**
     * 获取所有标签
     */
    @Operation(summary = "获取所有标签")
    @GetMapping("/list")
    public Result<List<Tag>> list() {
        List<Tag> tags = tagService.list();
        return Result.success(tags);
    }
    
    /**
     * 获取标签详情
     */
    @Operation(summary = "获取标签详情")
    @GetMapping("/{id}")
    public Result<Tag> getById(@PathVariable Long id) {
        Tag tag = tagService.getById(id);
        return Result.success(tag);
    }
}


