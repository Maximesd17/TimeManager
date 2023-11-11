<template>
    <main class="relative h-[calc(100vh-3.5rem)] w-full max-sm:overflow-auto">
        <div
            class="flex gap-4 p-4 h-full max-sm:flex-wrap"
            v-if="currentUser"
        >
            <UserDetailsComponent
                v-if="clock"
                class="w-full sm:w-1/3 relative"
                :user="currentUser"
                :isMe="true"
                v-model:clock="clock"
                @update:user="updateUser"
            />
            <div class="flex flex-col w-full sm:w-2/3 h-full gap-4">
                <div v-if="workingTimes" class="h-full">
                    <WorkingTimeComponent
                        v-model:workingTimes="workingTimes"
                        :userId="currentUser!.id"
                        :start="startDate"
                        :end="endDate"
                        :isMe="true"
                        @prevMonth="setPrevMonth"
                        @nextMonth="setNextMonth"
                    />
                </div>
            </div>
        </div>
    </main>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import { useUserStore } from '@/store/user';
import { storeToRefs } from 'pinia';
import useToast from '@/composables/useToast';

import type {
    APIClock,
    APIUser,
    APIWorkingTime,
    Clock,
    WorkingTime
} from '@/types';
import {
    formatDateTime,
    prevMonth,
    nextMonth,
    getLastDayOfMonth,
    newNaiveDateTime
} from '@/utils/dates';

import WorkingTimeComponent from '@/components/WorkingTimes/WorkingTimes.vue';
import UserDetailsComponent from '@/components/UserDetails.vue';

const userStore = useUserStore();
const { user: currentUser } = storeToRefs(userStore);
if (!currentUser.value) userStore.refresh();

const workingTimes = ref(null as WorkingTime[] | null);
const clock = ref(null as Clock | null);


const startDate = ref(newNaiveDateTime());
startDate.value.setDate(1);
startDate.value.setMonth(startDate.value.getMonth() - 1);
startDate.value.setHours(0, 0, 0, 0);

const endDate = ref(
    new Date(
        startDate.value.getFullYear(),
        startDate.value.getMonth() + 1,
        0,
        23,
        59,
        59,
        999
    )
);

function setPrevMonth() {
    startDate.value = prevMonth(startDate.value);
    endDate.value = getLastDayOfMonth(prevMonth(endDate.value));
    fetchWorkingTime();
}

function setNextMonth() {
    startDate.value = nextMonth(startDate.value);
    endDate.value = getLastDayOfMonth(nextMonth(endDate.value));
    fetchWorkingTime();
}

watch(
    () => [currentUser.value],
    () => {
        fetchWorkingTime();
        fetchClock();
    },
    { deep: true, immediate: true }
);

async function updateUser(updateUser: { username: string; email: string }) {
    if (currentUser.value == null) return;

    const { error } = await useApiFetch<APIUser>(
        `/users/me`,
        {
            method: 'PUT',
            data: {
                user: {
                    username: updateUser.username,
                    email: updateUser.email
                }
            }
        }
    );
    if (error.value) {
        useToast.error(`Error during user update`);
    } else {
        useToast.success(`User updated successfully`);
        userStore.refresh();
    }
}

async function fetchWorkingTime() {
    if (!currentUser.value?.id) return;
    const { data, error } = await useApiFetch<APIWorkingTime[]>(
        `/workingtimes/me`,
        {
            params: {
                start: formatDateTime(startDate.value),
                end: formatDateTime(endDate.value)
            }
        }
    );

    if (error.value) {
        useToast.error(`Error during working time fetching`);
    } else {
        workingTimes.value = data.value
            .map(wt => ({
                ...wt,
                start: newNaiveDateTime(wt.start),
                end: newNaiveDateTime(wt.end)
            }))
            .sort((a, b) => a.id - b.id);
    }
}

async function fetchClock() {
    if (!currentUser.value?.id) return;

    const { data, error } = await useApiFetch<APIClock>(
        `/clocks/me`
    );

    if (error.value) {
        clock.value = {
            id: 0,
            user: currentUser.value!.id,
            status: false,
            time: newNaiveDateTime()
        };
    } else {
        const res = { ...data.value, time: newNaiveDateTime(data.value.time) };
        clock.value = res;
    }
}
</script>

<style lang="scss" scoped></style>
