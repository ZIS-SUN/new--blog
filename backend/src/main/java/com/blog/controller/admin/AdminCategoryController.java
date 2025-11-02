package com.blog.controller.admin;

import com.blog.common.Result;
import com.blog.entity.Category;
import com.blog.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 分类管理控制器（后台）
 */
@Tag(name = "分类管理（后台）")
@RestController
@RequestMapping("/admin/category")
public class AdminCategoryController {
    
    private final CategoryService categoryService;
    
    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }
    
    /**
     * 获取所有分类
     */
    @Operation(summary = "获取所有分类")
    @GetMapping("/list")
    public Result<List<Category>> list() {
        return Result.success(categoryService.list());
    }
    
    /**
     * 创建分类
     */
    @Operation(summary = "创建分类")
    @PostMapping("/create")
    public Result<Category> create(@RequestBody Category category) {
        try {
            categoryService.save(category);
            return Result.success("创建成功", category);
        } catch (Exception e) {
            return Result.error("创建失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新分类
     */
    @Operation(summary = "更新分类")
    @PutMapping("/update")
    public Result<Category> update(@RequestBody Category category) {
        try {
            categoryService.updateById(category);
            return Result.success("更新成功", category);
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除分类
     */
    @Operation(summary = "删除分类")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            categoryService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}


