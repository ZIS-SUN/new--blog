package com.blog.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.blog.entity.Category;

/**
 * 分类Service
 */
public interface CategoryService extends IService<Category> {
    
    /**
     * 更新分类文章数量
     */
    void updateArticleCount(Long categoryId);
}


