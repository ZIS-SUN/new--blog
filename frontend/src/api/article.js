import request from '@/utils/request'

/**
 * 获取文章列表
 */
export function getArticleList(params) {
  return request({
    url: '/article/list',
    method: 'get',
    params
  })
}

/**
 * 获取文章详情
 */
export function getArticleDetail(id) {
  return request({
    url: `/article/${id}`,
    method: 'get'
  })
}

/**
 * 根据分类获取文章
 */
export function getArticlesByCategory(categoryId, params) {
  return request({
    url: `/article/category/${categoryId}`,
    method: 'get',
    params
  })
}

/**
 * 根据标签获取文章
 */
export function getArticlesByTag(tagId, params) {
  return request({
    url: `/article/tag/${tagId}`,
    method: 'get',
    params
  })
}

/**
 * 搜索文章
 */
export function searchArticles(params) {
  return request({
    url: '/article/search',
    method: 'get',
    params
  })
}

/**
 * 文章点赞
 */
export function likeArticle(id) {
  return request({
    url: `/article/${id}/like`,
    method: 'post'
  })
}


