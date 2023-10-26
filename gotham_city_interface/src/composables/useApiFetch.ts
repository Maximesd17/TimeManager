import axios from 'axios';
import type { AxiosRequestConfig } from 'axios';
import type { Ref } from 'vue';
import { ref } from 'vue';

type AsyncData<T> = {
    data: Ref<T>;
    error: Ref<string | boolean>;
};

export async function useApiFetch<T>(
    request: string,
    opts: AxiosRequestConfig
): Promise<AsyncData<T>> {
    const data = ref(undefined as T);
    const error = ref(false as string | boolean);

    if (opts.method && opts.method !== 'GET' && opts.method !== 'get') {
        opts.headers = {...opts.headers}
    }
    const res = await axios({
        ...opts,
        url: request,
        validateStatus: () => true,
        headers: {
            ...opts.headers,
            'Content-Type': 'application/json',
        },
        data: opts.data ? JSON.stringify(opts.data) : undefined,
    });
    data.value = res.data.data ?? undefined;
    error.value =
        !data.value ? `${res.status} (${res.statusText})` : false;

    return Promise.resolve({ data, error } as AsyncData<T>);
}
