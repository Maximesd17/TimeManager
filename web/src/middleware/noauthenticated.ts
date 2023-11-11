import useCookies from '@/composables/useCookies';
import { type RouteLocationNormalized } from 'vue-router';

export default function authenticated({
    to,
    next
}: {
    to: RouteLocationNormalized;
    next: Function;
}) {
    const token = useCookies().getCookie('token');

    if (token) {
        const [_, uri] = to.fullPath.split('?uri=');

        return next({ path: `${uri || '/dashboard'}` });
    }

    next();
}
