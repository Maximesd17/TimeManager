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
    opts: AxiosRequestConfig = {}
): Promise<AsyncData<T>> {
    const data = ref(undefined as T);
    const error = ref(false as string | boolean);

    // if (opts.method && opts.method !== 'GET' && opts.method !== 'get') {
    //     console.log('Adding CORS header');
    //     opts.headers = { ...opts.headers, 'Access-Control-Allow-Origin': '*' };
    // }
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
    error.value = !data.value && res.status !== 204 ? `${res.status} (${res.statusText})` : false;

    return Promise.resolve({ data, error } as AsyncData<T>);
}
