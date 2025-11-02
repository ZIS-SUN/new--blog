package com.blog.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.Article;
import com.blog.service.ArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

/**
 * 文章控制器（访客端）
 */
@Tag(name = "文章管理（访客端）")
@RestController
@RequestMapping("/article")
public class ArticleController {
    
    private final ArticleService articleService;
    
    public ArticleController(ArticleService articleService) {
        this.articleService = articleService;
    }
    
    /**
     * 分页查询文章列表
     */
    @Operation(summary = "分页查询文章列表")
    @GetMapping("/list")
    public Result<Page<Article>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Article> page = articleService.getPublishedArticles(current, size);
        return Result.success(page);
    }
    
    /**
     * 获取文章详情
     */
    @Operation(summary = "获取文章详情")
    @GetMapping("/{id}")
    public Result<Article> getById(@PathVariable Long id) {
        Article article = articleService.getById(id);
        if (article != null && article.getStatus() == 1) {
            // 增加阅读数
            articleService.incrementViewCount(id);
            return Result.success(article);
        }
        return Result.error("文章不存在");
    }
    
    /**
     * 根据分类查询文章
     */
    @Operation(summary = "根据分类查询文章")
    @GetMapping("/category/{categoryId}")
    public Result<Page<Article>> getByCategory(
            @PathVariable Long categoryId,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Article> page = articleService.getArticlesByCategoryId(categoryId, current, size);
        return Result.success(page);
    }
    
    /**
     * 根据标签查询文章
     */
    @Operation(summary = "根据标签查询文章")
    @GetMapping("/tag/{tagId}")
    public Result<Page<Article>> getByTag(
            @PathVariable Long tagId,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Article> page = articleService.getArticlesByTagId(tagId, current, size);
        return Result.success(page);
    }
    
    /**
     * 搜索文章
     */
    @Operation(summary = "搜索文章")
    @GetMapping("/search")
    public Result<Page<Article>> search(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Article> page = articleService.searchArticles(keyword, current, size);
        return Result.success(page);
    }
    
    /**
     * 文章点赞
     */
    @Operation(summary = "文章点赞")
    @PostMapping("/{id}/like")
    public Result<?> like(@PathVariable Long id) {
        articleService.incrementLikeCount(id);
        return Result.success("点赞成功", null);
    }
}


