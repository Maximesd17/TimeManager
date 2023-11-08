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

    <main class="relative h-[calc(100vh-4.5rem)] w-full max-sm:overflow-auto">
        <div class="flex gap-4 p-4 h-full max-sm:flex-wrap" v-if="user">
            <UserDetailsComponent
                v-if="clock"
                class="w-full sm:w-1/3 relative"
                :user="user"
                v-model:clock="clock"
                @update:user="updateUser"
                @delete:user="deleteUser"
            />
            <div class="flex flex-col w-full sm:w-2/3 h-full gap-4">
                <div v-if="workingTimes" class="h-full">
                    <WorkingTimeComponent
                        v-model:workingTimes="workingTimes"
                        :userId="user.id"
                        :start="startDate"
                        :end="endDate"
                        @prevMonth="setPrevMonth"
                        @nextMonth="setNextMonth"
                    />
                </div>
            </div>
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

import type {
APIClock,
    APIUser,
    APIWorkingTime,
    Clock,
    User,
    WorkingTime
} from '@/types';
import {
    formatDateTime,
    prevMonth,
    nextMonth,
    getLastDayOfMonth,
    newNaiveDateTime
} from '@/utils/dates';

import UserSelector from '@/components/User.vue';
import Confirm from '@/components/ui/input/Confirm.vue';
import WorkingTimeComponent from '@/components/workingTimes/WorkingTimes.vue';
import UserDetailsComponent from '@/components/UserDetails.vue';

const user = ref(null as User | null);
const workingTimes = ref(null as WorkingTime[] | null);
const clock = ref(null as Clock | null);

const tmpUserCreation = ref(null as { username: string; email: string } | null);

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

async function createUser() {
    if (!tmpUserCreation.value) return;
    const { data, error } = await useApiFetch<APIUser>('/users', {
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
    const { data, error } = await useApiFetch<APIUser>('/users', {
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

async function updateUser(updateUser: { username: string; email: string }) {
    if (user.value == null) return;

    const { data, error } = await useApiFetch<APIUser>(
        `/users/${user.value.id}`,
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
        user.value = data.value;
    }
}

async function deleteUser() {
    if (user.value == null) return;
    const { error } = await useApiFetch<APIUser>(`/users/${user.value.id}`, {
        method: 'DELETE'
    });
    if (error.value) {
        useToast.error(`Error during user delete`);
    } else {
        useToast.success(`User deleted successfully`);
        user.value = null;
    }
}

async function fetchWorkingTime() {
    if (!user.value?.id) return;

    const { data, error } = await useApiFetch<APIWorkingTime[]>(
        `/workingtimes/${user.value?.id}`,
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
    if (!user.value?.id) return;
    const { data, error } = await useApiFetch<APIClock>(
        `/clocks/${user.value?.id}`
    );

    if (error.value) {
        clock.value = {
            id: 0,
            user: user.value.id,
            status: false,
            time: newNaiveDateTime()
        };
    } else {
        const res = {...data.value, time: newNaiveDateTime(data.value.time)};
        clock.value = res;
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
