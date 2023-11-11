import useCookies from '@/composables/useCookies';
import { jwtDecode } from 'jwt-decode';
import { type RouteLocationNormalized } from 'vue-router';

export default async function manager({
    to,
    next
}: {
    to: RouteLocationNormalized;
    next: Function;
}) {
    const token = useCookies().get('token') as string;
    //@ts-ignore
    const roles = jwtDecode(token).roles || [];

    if (
        roles.includes('admin') ||
        roles.includes('generalManager') ||
        roles.includes('manager')
    ) {
        return next({ path: `/404` });
    }

    next();
}
