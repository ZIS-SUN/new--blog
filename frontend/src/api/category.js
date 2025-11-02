import request from '@/utils/request'

/**
 * 获取分类列表
 */
export function getCategoryList() {
  return request({
    url: '/category/list',
    method: 'get'
  })
}

/**
 * 获取分类详情
 */
export function getCategoryDetail(id) {
  return request({
    url: `/category/${id}`,
    method: 'get'
  })
}

/**
 * 创建分类（管理端）
 */
export function createCategory(data) {
  return request({
    url: '/admin/category/create',
    method: 'post',
    data
  })
}

/**
 * 更新分类（管理端）
 */
export function updateCategory(data) {
  return request({
    url: '/admin/category/update',
    method: 'put',
    data
  })
}

/**
 * 删除分类（管理端）
 */
export function deleteCategory(id) {
  return request({
    url: `/admin/category/${id}`,
    method: 'delete'
  })
}


