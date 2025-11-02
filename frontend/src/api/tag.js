import request from '@/utils/request'

/**
 * 获取标签列表
 */
export function getTagList() {
  return request({
    url: '/tag/list',
    method: 'get'
  })
}

/**
 * 获取标签详情
 */
export function getTagDetail(id) {
  return request({
    url: `/tag/${id}`,
    method: 'get'
  })
}

/**
 * 创建标签（管理端）
 */
export function createTag(data) {
  return request({
    url: '/admin/tag/create',
    method: 'post',
    data
  })
}

/**
 * 更新标签（管理端）
 */
export function updateTag(data) {
  return request({
    url: '/admin/tag/update',
    method: 'put',
    data
  })
}

/**
 * 删除标签（管理端）
 */
export function deleteTag(id) {
  return request({
    url: `/admin/tag/${id}`,
    method: 'delete'
  })
}


