package com.blog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.blog.entity.Article;
import com.blog.mapper.ArticleMapper;
import com.blog.service.ArticleService;
import org.springframework.stereotype.Service;

/**
 * 文章Service实现类
 */
@Service
public class ArticleServiceImpl extends ServiceImpl<ArticleMapper, Article> implements ArticleService {
    
    @Override
    public Page<Article> getPublishedArticles(int current, int size) {
        Page<Article> page = new Page<>(current, size);
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getStatus, 1) // 已发布
                .orderByDesc(Article::getIsTop) // 置顶文章在前
                .orderByDesc(Article::getPublishTime); // 按发布时间倒序
        return page(page, wrapper);
    }
    
    @Override
    public Page<Article> getArticlesByCategoryId(Long categoryId, int current, int size) {
        Page<Article> page = new Page<>(current, size);
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getStatus, 1)
                .eq(Article::getCategoryId, categoryId)
                .orderByDesc(Article::getPublishTime);
        return page(page, wrapper);
    }
    
    @Override
    public Page<Article> getArticlesByTagId(Long tagId, int current, int size) {
        // 这里需要关联article_tag表，暂时简化处理
        Page<Article> page = new Page<>(current, size);
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getStatus, 1)
                .orderByDesc(Article::getPublishTime);
        return page(page, wrapper);
    }
    
    @Override
    public Page<Article> searchArticles(String keyword, int current, int size) {
        Page<Article> page = new Page<>(current, size);
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getStatus, 1)
                .and(w -> w.like(Article::getTitle, keyword)
                        .or()
                        .like(Article::getContent, keyword))
                .orderByDesc(Article::getPublishTime);
        return page(page, wrapper);
    }
    
    @Override
    public void incrementViewCount(Long articleId) {
        Article article = getById(articleId);
        if (article != null) {
            article.setViewCount(article.getViewCount() + 1);
            updateById(article);
        }
    }
    
    @Override
    public void incrementLikeCount(Long articleId) {
        Article article = getById(articleId);
        if (article != null) {
            article.setLikeCount(article.getLikeCount() + 1);
            updateById(article);
        }
    }
}


