<template>
    <Confirm
        v-if="tmpUserCreation"
        width="40vw"
        height="30vh"
        @yes="createUser"
        @no="tmpUserCreation = null"
    >
        This user doesn't exist, do you want to create it ?
    </Confirm>
    <header
        class="h-[4.5rem] -mt-2 bg-primary flex items-center justify-center rounded-b-xl"
    >
        <UserSelector @fetch:user="fetchUser" />
    </header>
    {{ user }}
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import useToast from '@/composables/useToast';

import type { Clock, User, WorkingTime } from '@/types';

import UserSelector from '@/components/User.vue';
import Confirm from '@/components/ui/input/Confirm.vue';

const user = ref(null as User | null);
const workingTime = ref(null as WorkingTime[] | null);
const clock = ref(null as Clock | null);

const tmpUserCreation = ref(null as { username: string; email: string } | null);

async function createUser() {
    if (!tmpUserCreation.value) return;
    const { data, error } = await useApiFetch<User>('/users', {
        method: 'POST',
        data: {
            user: {
                username: tmpUserCreation.value.username,
                email: tmpUserCreation.value.email
            }
        }
    });
    tmpUserCreation.value = null;
    if (error.value) {
        useToast.error(`Error during user creation`);
    } else {
        user.value = data.value;
    }
}

async function fetchUser(fUser: { username: string; email: string }) {
    const { data, error } = await useApiFetch<User>('/users', {
        params: {
            username: fUser.username,
            email: fUser.email
        }
    });

    if (error.value) {
        tmpUserCreation.value = fUser;
    } else {
        user.value = data.value;
    }
}
</script>

<style lang="scss" scoped></style>
