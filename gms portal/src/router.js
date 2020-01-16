import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'progs',
      component: () => import('./views/progs.vue')
    },
    {
      path: '/news',
      name: 'news',
      component: () => import('./views/news.vue')
    },
    {
      path: '/ComplMount',
      name: 'ComplMount',
      component: () => import('./views/ComplMount.vue')
    },
    {
      path: '/AdminPanel',
      name: 'AdminPanel',
      component: () => import('./views/AdminPanel.vue')
    },

  ]
})
