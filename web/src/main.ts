import './assets/css/main.css';

import { createApp } from 'vue';
import { createPinia } from 'pinia';

import Toast from 'vue-toastification';
import 'vue-toastification/dist/index.css';
import App from './App.vue';
import axios from 'axios';

import VueTippy from 'vue-tippy';
import 'tippy.js/dist/tippy.css';
import 'tippy.js/dist/svg-arrow.css';

const app = createApp(App);
const pinia = createPinia();

axios.defaults.baseURL = import.meta.env.BACKEND_URL
    ? import.meta.env.BACKEND_URL + '/api'
    : 'http://localhost:4000/api';

app.use(Toast);
app.use(pinia);
app.use(VueTippy, {
    directive: 'tooltip',
    component: 'tippy',
    componentSingleton: 'tippy-singleton',
    defaultProps: {
        theme: 'dark',
        placement: 'auto-end',
        allowHTML: true
    }
});
app.mount('#app');
