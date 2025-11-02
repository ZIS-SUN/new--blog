package com.blog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.blog.entity.Article;
import com.blog.entity.Category;
import com.blog.mapper.ArticleMapper;
import com.blog.mapper.CategoryMapper;
import com.blog.service.CategoryService;
import org.springframework.stereotype.Service;

/**
 * 分类Service实现类
 */
@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {
    
    private final ArticleMapper articleMapper;
    
    public CategoryServiceImpl(ArticleMapper articleMapper) {
        this.articleMapper = articleMapper;
    }
    
    @Override
    public void updateArticleCount(Long categoryId) {
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getCategoryId, categoryId)
                .eq(Article::getStatus, 1);
        Long count = articleMapper.selectCount(wrapper);
        
        Category category = getById(categoryId);
        if (category != null) {
            category.setArticleCount(count.intValue());
            updateById(category);
        }
    }
}


