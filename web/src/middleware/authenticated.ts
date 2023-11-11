import { type RouteLocationNormalized } from 'vue-router';
import useCookies from '@/composables/useCookies';

export default function authenticated({
    to,
    next
}: {
    to: RouteLocationNormalized;
    next: Function;
}) {
    const token = useCookies().get('token');

    if (!token) {
        const [path, uri] = to.fullPath.split('?uri=');

        return next({ path: `/?uri=${uri || path}` });
    }

    next();
}
