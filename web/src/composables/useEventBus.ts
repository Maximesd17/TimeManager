import { onBeforeUnmount } from 'vue';
import { app } from '@/main';

export const useEventBus = {
    on(event: string, callback: (...args: any[]) => void, autoUnmount = true) {
        app.config.globalProperties.$eventBus.on(event, callback);

        if (!autoUnmount) return;

        onBeforeUnmount(() =>
            app.config.globalProperties.$eventBus.off(event, callback)
        );
    },

    off(event: string, callback?: (...args: any[]) => void) {
        app.config.globalProperties.$eventBus.off(event, callback);
    },

    emit(event: string, ...args: any[]) {
        app.config.globalProperties.$eventBus.emit(event, args);
    }
};
