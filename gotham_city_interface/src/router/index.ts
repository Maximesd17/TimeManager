import { createRouter, createWebHistory } from 'vue-router';

import Login from '@/views/Login.vue';
import Dashboard from '@/views/Dashboard.vue';

import noauthenticated from '@/middleware/noauthenticated';
import authenticated from '@/middleware/authenticated';

const routes = [
    {
        path: '/',
        component: Login,
        name: 'Login',
        meta: {
            middleware: noauthenticated,
            layout: 'empty',
            title: 'Login',
            description: 'Login'
        }
    },
    {
        path: '/dashboard',
        component: Dashboard,
        name: 'Dashboard',
        meta: {
            middleware: authenticated,
            layout: 'default',
            title: 'Dashboard',
            description: 'Dashboard'
        }
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

function nextFactory(context: any, middleware: Function[], index: number): typeof nextFactory {
    const nextMiddleware = middleware[index];

    if (!nextMiddleware) {
        return context.next;
    }

    const subsequentMiddleware = nextFactory(context, middleware, index + 1);
    return nextMiddleware({ ...context, next: subsequentMiddleware });
}

router.beforeEach((to, from, next) => {
    if (!to.meta.middleware) {
        return next();
    }

    const middleware = Array.isArray(to.meta.middleware)
        ? to.meta.middleware
        : [to.meta.middleware];
    const context = {
        to,
        from,
        next,
        router
    };

    return middleware[0]({
        ...context,
        next: nextFactory(context, middleware, 1)
    });
});

export default router;
