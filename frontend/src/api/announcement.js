import request from '@/utils/request'

/**
 * 获取公告列表
 */
export function getAnnouncementList(params) {
  return request({
    url: '/announcement/list',
    method: 'get',
    params
  })
}

/**
 * 获取置顶公告
 */
export function getTopAnnouncements() {
  return request({
    url: '/announcement/top',
    method: 'get'
  })
}

/**
 * 获取公告详情
 */
export function getAnnouncementDetail(id) {
  return request({
    url: `/announcement/${id}`,
    method: 'get'
  })
}


