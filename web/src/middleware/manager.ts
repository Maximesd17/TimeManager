import useCookies from '@/composables/useCookies';
import { type RouteLocationNormalized } from 'vue-router';

export default async function manager({
    to,
    next
}: {
    to: RouteLocationNormalized;
    next: Function;
}) {
    // if (!user.value) await userStore.refresh();

    // if (!user.value?.roles.includes('manager')) {

    //     return next({ path: `/404` });
    // }

    next();
}
