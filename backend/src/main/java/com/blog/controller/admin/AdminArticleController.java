package com.blog.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Article;
import com.blog.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

/**
 * 文章管理控制器（后台）
 */
@Tag(name = "文章管理（后台）")
@RestController
@RequestMapping("/admin/article")
public class AdminArticleController {
    
    private final ArticleService articleService;
    
    public AdminArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }
    
    /**
     * 分页查询所有文章
     */
    @Operation(summary = "分页查询所有文章")
    @GetMapping("/list")
    public Result<Page<Article>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Article> page = new Page<>(current, size);
        return Result.success(articleService.page(page));
    }
    
    /**
     * 创建文章
     */
    @Operation(summary = "创建文章")
    @PostMapping("/create")
    public Result<Article> create(@RequestBody Article article) {
        try {
            if (article.getStatus() == 1) {
                article.setPublishTime(LocalDateTime.now());
            }
            articleService.save(article);
            return Result.success("创建成功", article);
        } catch (Exception e) {
            return Result.error("创建失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新文章
     */
    @Operation(summary = "更新文章")
    @PutMapping("/update")
    public Result<Article> update(@RequestBody Article article) {
        try {
            if (article.getStatus() == 1 && article.getPublishTime() == null) {
                article.setPublishTime(LocalDateTime.now());
            }
            articleService.updateById(article);
            return Result.success("更新成功", article);
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除文章
     */
    @Operation(summary = "删除文章")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            articleService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
    
    /**
     * 批量删除文章
     */
    @Operation(summary = "批量删除文章")
    @DeleteMapping("/batch")
    public Result<?> batchDelete(@RequestBody java.util.List<Long> ids) {
        try {
            articleService.removeByIds(ids);
            return Result.success("批量删除成功", null);
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }
}


