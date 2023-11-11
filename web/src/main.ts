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

import useCookies from '@/composables/useCookies';

import bus from './plugins/bus';

export const app = createApp(App);
app.use(router);

const pinia = createPinia();
app.use(pinia);

let preferredTheme = useCookies().get('theme');
if (!preferredTheme) {
    preferredTheme = 'automatic';
    useCookies().set('theme', preferredTheme, 3000);
}
switch (preferredTheme) {
    case 'light':
        document.documentElement.classList.add('light');
        break;
    case 'dark':
        document.documentElement.classList.add('dark');
        break;
    default:
        document.documentElement.classList.add('automatic');
        break;
}



axios.defaults.baseURL = import.meta.env.BACKEND_URL
    ? import.meta.env.BACKEND_URL + '/api'
    : 'http://localhost:4000/api';

app.use(Toast);

app.use(bus.install(app));

app.use(FloatingVue);

app.mount('#app');
