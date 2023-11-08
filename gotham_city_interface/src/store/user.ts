import { useApiFetch } from '@/composables/useApiFetch';
import type { APIUser, User } from '@/types';
import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useUserStore = defineStore('useUserStore', () => {
    const user = ref(null as User | null);

    async function refresh() {
        const { data } = await useApiFetch<APIUser>('/users/me');

        user.value = data.value;
    }

    return {
        user,

        refresh
    };
});
