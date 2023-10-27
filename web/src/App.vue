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
        class="h-[4.5rem] bg-primary rounded-b-xl grid place-content-center"
    >
        <UserSelector class="h-full" @fetch:user="fetchUser" />
    </header>

    <main class="relative h-[calc(100vh-4.5rem)] w-full">
        <div class="flex gap-4 p-4 h-full" v-if="user">
            <Card class="h-full relative w-1/3">
                <ClockComponent v-if="clock" :clock="clock" />
                <UserDetailsComponent :user="user" />
            </Card>
            <Card class="h-1/2 w-2/3 relative">
                <div v-if="workingTimes">
                    <WorkingTimeComponent :workingTimes="workingTimes" :start="startDate" :end="endDate"/>
                </div>
            </Card>
        </div>
        <div
            v-else
            class="flex justify-center items-center h-[calc(100vh-4.5rem)]"
        >
            <div class="flex flex-col items-center">
                <div class="text-2xl font-bold">No user selected</div>
                <div class="text-xl">Please select a user</div>
            </div>
        </div>
    </main>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import useToast from '@/composables/useToast';

import type { Clock, User, WorkingTime } from '@/types';
import { formatDateTime } from '@/utils/dates';

import UserSelector from '@/components/User.vue';
import Confirm from '@/components/ui/input/Confirm.vue';
import Card from '@/components/ui/cards/Rectangle.vue';
import ClockComponent from '@/components/Clock.vue';
import WorkingTimeComponent from '@/components/WorkingTimes.vue';
import UserDetailsComponent from '@/components/UserDetails.vue';

const user = ref(null as User | null);
const workingTimes = ref(null as WorkingTime[] | null);
const clock = ref(null as Clock | null);

const tmpUserCreation = ref(null as { username: string; email: string } | null);

const startDate = new Date();
startDate.setDate(1);
startDate.setMonth(startDate.getMonth() - 1);
startDate.setHours(0, 0, 0, 0);

const endDate = new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0);
endDate.setHours(23, 59, 59, 999);


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

    const { data, error } = await useApiFetch<WorkingTime[]>(
        `/workingtimes/${user.value?.id}`,
        {
            params: {
                start: formatDateTime(startDate),
                end: formatDateTime(endDate)
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
        clock.value = {
            id: 0,
            user: user.value.id,
            status: false,
            time: new Date(),
        };
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
