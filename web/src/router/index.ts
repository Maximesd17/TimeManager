import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'

const API_HOST: string = "http://localhost:4000"
const API_DEFAULT_ROUTE: string = API_HOST + "/api";
const API_USERS_ROUTE: string = API_DEFAULT_ROUTE + "/users";
const API_WORKINGTIMES_ROUTE: string = API_DEFAULT_ROUTE + "/workingtimes";
const API_CLOCKS_ROUTE: string = API_DEFAULT_ROUTE + "/clocks";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/bootstrap',
      name: 'bootstrap',
      component: () => import('../views/WeatherView.vue')
    }
  ]
})

export default router
export {API_USERS_ROUTE, API_WORKINGTIMES_ROUTE, API_CLOCKS_ROUTE}
