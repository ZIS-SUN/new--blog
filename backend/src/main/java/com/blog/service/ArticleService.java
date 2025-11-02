package com.blog.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.Article;

/**
 * 文章Service
 */
public interface ArticleService extends IService<Article> {
    
    /**
     * 分页查询已发布文章
     */
    Page<Article> getPublishedArticles(int current, int size);
    
    /**
     * 根据分类ID查询文章
     */
    Page<Article> getArticlesByCategoryId(Long categoryId, int current, int size);
    
    /**
     * 根据标签ID查询文章
     */
    Page<Article> getArticlesByTagId(Long tagId, int current, int size);
    
    /**
     * 搜索文章
     */
    Page<Article> searchArticles(String keyword, int current, int size);
    
    /**
     * 增加阅读数
     */
    void incrementViewCount(Long articleId);
    
    /**
     * 增加点赞数
     */
    void incrementLikeCount(Long articleId);
}


