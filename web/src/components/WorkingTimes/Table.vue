<template>
    <table class="w-full">
        <thead class="head w-full sticky top-0 bg-background">
            <tr class="row">
                <th>Day</th>
                <th>Start</th>
                <th>End</th>
                <th>duration</th>
            </tr>
        </thead>
        <tbody class="w-full text-center body" :class="{}">
            <template
                v-for="(workingTime, index) in sortedRows"
                :key="workingTime.id"
            >
                <tr
                    class="row rounded-b-[0.25rem]"
                    :class="{
                        'bg-background': index % 2 === 0,
                        'bg-secondary': index % 2 !== 0,
                        clicked: clickedLine === index,
                        deleted: deletedWorkingTimes.some(
                            wt => wt.id === workingTime.id
                        )
                    }"
                    @click="toggleClickedLine(index)"
                >
                    <td :colspan="1">
                        <div v-if="workingTime.start">
                            {{ formatDateToHuman(workingTime.start, false) }}
                        </div>
                    </td>
                    <td :colspan="1">
                        <div v-if="workingTime.start">
                            {{ formatDateToHuman(workingTime.start) }}
                        </div>
                    </td>
                    <td :colspan="1">
                        <div v-if="workingTime.start">
                            {{ formatDateToHuman(workingTime.end) }}
                        </div>
                    </td>
                    <td :colspan="1">
                        <div v-if="workingTime.start && workingTime.end">
                            {{
                                formatHours(
                                    getHoursDiff(
                                        workingTime.start,
                                        workingTime.end
                                    )
                                )
                            }}
                        </div>
                    </td>
                </tr>
                <EditRow
                    v-if="
                        clickedLine === index &&
                        !deletedWorkingTimes.some(
                            wt => wt.id === workingTime.id
                        ) &&
                        (roles.includes('admin') ||
                            roles.includes('manager') ||
                            roles.includes('generalManager'))
                    "
                    :index="index"
                    :start="workingTime.start"
                    :end="workingTime.end"
                    @update:start="updateStart(index, $event)"
                    @update:end="updateEnd(index, $event)"
                    @delete="deleteWorkingTime(index)"
                />
            </template>
        </tbody>
    </table>
</template>

<script lang="ts" setup>
import { useApiFetch } from '@/composables/useApiFetch';
import type { WorkingTime } from '@/types';
import {
    formatDateTime,
    formatDateToHuman,
    getHoursDiff,
    padStartZero
} from '@/utils/dates';
import { ref, type PropType, computed } from 'vue';

import EditRow from './EditRow.vue';
import { jwtDecode } from 'jwt-decode';
import useCookies from '@/composables/useCookies';

const props = defineProps({
    workingTimes: {
        type: Array as PropType<WorkingTime[]>,
        required: true
    },

    minimumRows: {
        type: Number,
        default: 0
    }
});

const emits = defineEmits<{
    (e: 'update:workingTimes', workingTimes: WorkingTime[]): void;
}>();

// @ts-ignore
const roles = jwtDecode(useCookies().get('token')!).roles || [];

defineExpose({
    pushChanges,
    hasChanges: computed(() => {
        return !(
            updatedWorkingTimes.value.length > 0 ||
            deletedWorkingTimes.value.length > 0
        );
    })
});

const clickedLine = ref(null as number | null);
const updatedWorkingTimes = ref([] as WorkingTime[]);
const deletedWorkingTimes = ref([] as WorkingTime[]);

function formatHours(time: number) {
    let hours = Math.floor(time);
    let minutes = Math.round((time - hours) * 60);
    if (minutes === 60) {
        hours++;
        minutes = 0;
    }
    return `${padStartZero(hours)}:${padStartZero(minutes)}`;
}

function toggleClickedLine(index: number) {
    let timeout = 0;

    if (clickedLine.value !== null) {
        timeout = 300;
        const row = document.querySelector(`.tmp-row`) as HTMLElement;
        if (!row) return;
        row.classList.remove('grow-in');
        row.classList.add('grow-out');
    }
    setTimeout(() => {
        clickedLine.value = clickedLine.value === index ? null : index;
    }, timeout);
}

function updateStart(index: number, start: Date) {
    const uIndex = updatedWorkingTimes.value.findIndex(
        wt => wt.id === props.workingTimes[index].id
    );
    if (uIndex !== -1) updatedWorkingTimes.value[uIndex].start = start;
    else
        updatedWorkingTimes.value.push({ ...props.workingTimes[index], start });
}

function updateEnd(index: number, end: Date) {
    const uIndex = updatedWorkingTimes.value.findIndex(
        wt => wt.id === props.workingTimes[index].id
    );
    if (uIndex !== -1) updatedWorkingTimes.value[uIndex].end = end;
    else updatedWorkingTimes.value.push({ ...props.workingTimes[index], end });
}

function deleteWorkingTime(index: number) {
    const dIndex = deletedWorkingTimes.value.findIndex(
        wt => wt.id === props.workingTimes[index].id
    );
    if (dIndex === -1)
        deletedWorkingTimes.value.push(props.workingTimes[index]);
    if (
        clickedLine.value === index &&
        props.workingTimes[index + 1] &&
        !deletedWorkingTimes.value.some(
            wt => wt.id === props.workingTimes[index + 1].id
        )
    )
        clickedLine.value += 1;
    else clickedLine.value = null;
}

async function pushChanges() {
    if (updatedWorkingTimes.value.length > 0) {
        for (const wt of updatedWorkingTimes.value) {
            await useApiFetch<WorkingTime>(`/workingtimes/${wt.id}`, {
                method: 'PUT',
                data: {
                    workingtime: {
                        start: formatDateTime(wt.start),
                        end: formatDateTime(wt.end)
                    }
                }
            });
        }
        updatedWorkingTimes.value = [];
    }
    if (deletedWorkingTimes.value.length > 0) {
        for (const wt of deletedWorkingTimes.value) {
            await useApiFetch(`/workingtimes/${wt.id}`, {
                method: 'DELETE'
            });
        }
        emits('update:workingTimes', [
            ...props.workingTimes.filter(
                wt => !deletedWorkingTimes.value.some(dwt => dwt.id === wt.id)
            )
        ]);
        deletedWorkingTimes.value = [];
    }
}

const sortedRows = computed(() => {
    let rows = props.workingTimes;
    if (rows.length < props.minimumRows)
        rows = [
            ...rows,
            ...Array(props.minimumRows - props.workingTimes.length).fill({})
        ];

    return rows;
});
</script>

<style lang="scss" scoped>
.head {
    &::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        height: 1px;
        background-color: var(--primary);
    }

    z-index: 1000;
    .row {
        th {
            &:first-child {
                border-right: solid 1px var(--primary);
            }
        }
    }
}

.body {
    .row {
        td {
            cursor: pointer;
            height: 26px;
            &:first-child {
                border-radius: 0.25rem 0 0 0.25rem;
                border-right: solid 1px var(--primary);
            }
            &:last-child {
                border-radius: 0 0.25rem 0.25rem 0;
            }
        }

        &.deleted {
            color: var(--red) !important;
            opacity: 0.6;
        }
        &.clicked {
            td {
                &:first-child {
                    border-radius: 0.25rem 0 0 0;
                }
                &:last-child {
                    border-radius: 0 0.25rem 0 0;
                }
            }
        }
    }
}
</style>
