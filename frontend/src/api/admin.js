import request from '@/utils/request'

/**
 * 获取仪表盘统计数据
 */
export function getDashboardStatistics() {
  return request({
    url: '/admin/dashboard/statistics',
    method: 'get'
  })
}

/**
 * 获取文章列表
 */
export function getAdminArticleList(params) {
  return request({
    url: '/admin/article/list',
    method: 'get',
    params
  })
}

/**
 * 创建文章
 */
export function createArticle(data) {
  return request({
    url: '/admin/article/create',
    method: 'post',
    data
  })
}

/**
 * 更新文章
 */
export function updateArticle(data) {
  return request({
    url: '/admin/article/update',
    method: 'put',
    data
  })
}

/**
 * 删除文章
 */
export function deleteArticle(id) {
  return request({
    url: `/admin/article/${id}`,
    method: 'delete'
  })
}

/**
 * 批量删除文章
 */
export function batchDeleteArticles(ids) {
  return request({
    url: '/admin/article/batch',
    method: 'delete',
    data: ids
  })
}

/**
 * 获取公告列表
 */
export function getAdminAnnouncementList(params) {
  return request({
    url: '/admin/announcement/list',
    method: 'get',
    params
  })
}

/**
 * 创建公告
 */
export function createAnnouncement(data) {
  return request({
    url: '/admin/announcement/create',
    method: 'post',
    data
  })
}

/**
 * 更新公告
 */
export function updateAnnouncement(data) {
  return request({
    url: '/admin/announcement/update',
    method: 'put',
    data
  })
}

/**
 * 删除公告
 */
export function deleteAnnouncement(id) {
  return request({
    url: `/admin/announcement/${id}`,
    method: 'delete'
  })
}

/**
 * 获取评论列表
 */
export function getAdminCommentList(params) {
  return request({
    url: '/admin/comment/list',
    method: 'get',
    params
  })
}

/**
 * 审核评论
 */
export function approveComment(commentId) {
  return request({
    url: '/admin/comment/approve',
    method: 'put',
    data: { commentId }
  })
}

/**
 * 删除评论
 */
export function deleteComment(id) {
  return request({
    url: `/admin/comment/${id}`,
    method: 'delete'
  })
}

/**
 * 获取留言列表
 */
export function getAdminMessageList(params) {
  return request({
    url: '/admin/message/list',
    method: 'get',
    params
  })
}

/**
 * 审核留言
 */
export function approveMessage(messageId) {
  return request({
    url: '/admin/message/approve',
    method: 'put',
    data: { messageId }
  })
}

/**
 * 删除留言
 */
export function deleteMessage(id) {
  return request({
    url: `/admin/message/${id}`,
    method: 'delete'
  })
}

/**
 * 获取用户列表
 */
export function getUserList(params) {
  return request({
    url: '/admin/user/list',
    method: 'get',
    params
  })
}

/**
 * 更新用户状态
 */
export function updateUserStatus(data) {
  return request({
    url: '/admin/user/status',
    method: 'put',
    data
  })
}

/**
 * 删除用户
 */
export function deleteUser(id) {
  return request({
    url: `/admin/user/${id}`,
    method: 'delete'
  })
}


