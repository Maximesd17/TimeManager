import { defineStore } from 'pinia';
import { ref } from 'vue';
import type { User } from '@/types';

export const useUsersStore = defineStore('useUsersStore', () => {
    const users = ref([] as User[]);

    function fetchUsers() {
    }

    return {
        users,

        fetchUsers
    };
});
