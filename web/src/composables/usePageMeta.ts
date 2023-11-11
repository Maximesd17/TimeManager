interface PageMetaOptions {
    title?: string;
    description?: string;
    layout?: 'default' | 'empty';
}

import Default from '@/layouts/Default.vue';
import Empty from '@/layouts/Empty.vue';

let options: PageMetaOptions = {};

export function definePageMeta(opts: PageMetaOptions) {
    opts.title = opts.title ?? 'Time Manager';
    opts.description = opts.description ?? 'Time Manager App';
    opts.layout = opts.layout ?? 'default';
    options = opts;

    usePageMeta();
}

export function usePageMeta() {
    const opts = {...options};
    options = {};

    document.title = opts.title ?? 'Time Manager';
    document
        .querySelector('meta[name="description"]')
        ?.setAttribute('content', opts.description ?? 'Time Manager App');

    switch (opts.layout) {
        case 'empty':
            return Empty;
        default:
            return Default;
    }
}
