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

    <div v-if="clock && workingTimes" class="flex">
        <ClockComponent :clock="clock" />
        <WorkingTimeComponent :workingTimes="workingTimes" />
    </div>

    <div v-else class="flex justify-center items-center h-[calc(100vh-4.5rem)]">
        <div class="flex flex-col items-center">
            <div class="text-2xl font-bold">No user selected</div>
            <div class="text-xl">Please select a user</div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import useToast from '@/composables/useToast';

import type { Clock, User, WorkingTime } from '@/types';
import { formatDateTime } from '@/utils/dates';

import UserSelector from '@/components/User.vue';
import Confirm from '@/components/ui/input/Confirm.vue';
import ClockComponent from '@/components/Clock.vue';
import WorkingTimeComponent from '@/components/WorkingTimes.vue';

const user = ref(null as User | null);
const workingTimes = ref(null as WorkingTime[] | null);
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

async function fetchWorkingTime() {
    if (!user.value?.id) return;
    const startTime = new Date();
    startTime.setHours(0, 0, 0, 0);
    const endTime = new Date();
    endTime.setHours(23, 59, 59, 999);

    const { data, error } = await useApiFetch<WorkingTime[]>(
        `/workingtimes/${user.value?.id}`,
        {
            params: {
                start: formatDateTime(startTime),
                end: formatDateTime(endTime)
            }
        }
    );

    if (error.value) {
        useToast.error(`Error during working time fetching`);
    } else {
        workingTimes.value = data.value;
    }
}

async function fetchClock() {
    if (!user.value?.id) return;
    const { data, error } = await useApiFetch<Clock>(
        `/clocks/${user.value?.id}`
    );

    if (error.value) {
        useToast.error(`Error during clock fetching`);
    } else {
        clock.value = data.value;
    }
}

watch(
    () => user.value,
    () => {
        fetchWorkingTime();
        fetchClock();
    },
    { immediate: true, deep: true }
);
</script>

<style lang="scss" scoped></style>
