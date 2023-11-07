import './assets/css/main.css';

import { createApp } from 'vue';
import router from '@/router';

import App from './App.vue';

import axios from 'axios';

import { createPinia } from 'pinia';

import Toast from 'vue-toastification';
import 'vue-toastification/dist/index.css';

import FloatingVue from 'floating-vue';
import 'floating-vue/dist/style.css';

const app = createApp(App);
app.use(router);

const pinia = createPinia();
app.use(pinia);

axios.defaults.baseURL = import.meta.env.BACKEND_URL
    ? import.meta.env.BACKEND_URL + '/api'
    : 'http://localhost:4000/api';

app.use(Toast);

// app.use(VueTippy, {
//     directive: 'tooltip',
//     component: 'tippy',
//     componentSingleton: 'tippy-singleton',
//     defaultProps: {
//         theme: 'dark',
//         placement: 'auto-end',
//         allowHTML: true
//     }
// });

app.use(FloatingVue);

app.mount('#app');
