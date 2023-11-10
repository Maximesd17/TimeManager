import axios from 'axios';
import type { AxiosRequestConfig } from 'axios';
import type { Ref } from 'vue';
import { ref } from 'vue';
import useCookies from './useCookies';
import useToast from './useToast';

type AsyncData<T> = {
    data: Ref<T>;
    error: Ref<{ status: number; message: string } | false>;
};

export async function useApiFetch<T>(
    request: string,
    opts: AxiosRequestConfig = {}
): Promise<AsyncData<T>> {
    const data = ref(undefined as T);
    const error = ref(false as { status: number; message: string } | boolean);
    const token = useCookies().getCookie('token');

    if (token) {
        opts.headers = {
            ...opts.headers,
            Authorization: `Bearer ${token}`
        };
    }
    const res = await axios({
        ...opts,
        url: request,
        validateStatus: () => true,
        headers: {
            ...opts.headers,
            'content-type': 'application/json'
        },
        data: opts.data ? JSON.stringify(opts.data) : undefined
    });

    data.value = res.data.data ?? undefined;
    if (
        res.status.toString().startsWith('4') ||
        res.status.toString().startsWith('5')
    ) {
        error.value = { status: res.status, message: res.statusText };
        if (res.status === 401) {
            useCookies().revoke('token');
            useToast.error('You session has expired. Please log in again.');
            document.location.reload();
        }
    } else {
        error.value = false;
    }

    return Promise.resolve({ data, error } as AsyncData<T>);
}
