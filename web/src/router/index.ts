import { createRouter, createWebHistory } from 'vue-router';

import Login from '@/views/Login.vue';
import UserDashboard from '@/views/UserDashboard.vue';
import Dashboard from '@/views/MyDashboard.vue';
import Page404 from '@/views/404.vue';

import noauthenticated from '@/middleware/noauthenticated';
import authenticated from '@/middleware/authenticated';
import manager from '@/middleware/manager';

const routes = [
    {
        path: '/',
        component: Login,
        name: 'Login',
        meta: {
            middleware: noauthenticated,
            layout: 'empty',
            title: 'Login - Time manager',
            description: 'Login'
        }
    },
    {
        path: '/dashboard',
        component: Dashboard,
        name: 'MyDashboard',
        meta: {
            middleware: authenticated,
            layout: 'default',
            title: 'Dashboard - Time manager',
            description: 'Dashboard'
        }
    },
    {
        path: '/dashboard/:userID',
        component: UserDashboard,
        name: 'Dashboard',
        meta: {
            middleware: [authenticated, manager],
            layout: 'default',
            title: 'Dashboard - Time manager',
            description: 'Dashboard'
        }
    },
    {
        path: '/404',
        component: Page404,
        name: '404',
        meta: {
            layout: 'empty',
            title: 'Not found - Time manager',
            description: '404'
        }
    },
    {
        path: '/:pathMatch(.*)*',
        redirect: '/404'
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

    document.title = to.meta.title as string || 'Time manager';
    return middleware[0]({
        ...context,
        next: nextFactory(context, middleware, 1)
    });
});

export default router;
