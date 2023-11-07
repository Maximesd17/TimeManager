<template>
    <Modal
        :width="layout !== 'desktop' ? '95vw' : '80vw'"
        :height="layout !== 'desktop' ? '95vh' : '80vh'"
        @close="emits('close')"
    >
        <div class="flex flex-col gap-2">
            <div class="flex">
                <h1 class="ml-4 text 2xl sm:text-4xl font-bold">
                    Working Times
                </h1>
                <Button
                    class="h-8 place-self-end ml-auto"
                    @click="pushChanges"
                    :disabled="
                        updatedWorkingTimes.length === 0 &&
                        deletedWorkingTimes.length === 0
                    "
                >
                    Save Changes
                </Button>
            </div>
            <div
                class="overflow-auto h-[calc(80vh-10.5rem)] max-lg:h-[calc(95vh-13rem)]"
            >
                <table class="w-full">
                    <thead class="head w-full sticky top-0 bg-secondary">
                        <tr class="row">
                            <th>Day</th>
                            <th>Start</th>
                            <th>End</th>
                            <th>duration</th>
                        </tr>
                    </thead>
                    <tbody class="w-full text-center body">
                        <template
                            v-for="(workingTime, index) in workingTimes"
                            :key="workingTime.id"
                        >
                            <tr
                                class="row rounded-b-[0.25rem]"
                                :class="{
                                    'bg-white': index % 2 === 0,
                                    clicked: clickedLine === index,
                                    deleted: deletedWorkingTimes.some(
                                        wt => wt.id === workingTime.id
                                    )
                                }"
                                @click="toggleClickedLine(index)"
                            >
                                <td>
                                    {{
                                        formatDateToHuman(
                                            workingTime.start,
                                            false
                                        )
                                    }}
                                </td>
                                <td>
                                    {{ formatDateToHuman(workingTime.start) }}
                                </td>
                                <td>
                                    {{ formatDateToHuman(workingTime.end) }}
                                </td>
                                <td>
                                    {{
                                        formatHours(
                                            getHoursDiff(
                                                workingTime.start,
                                                workingTime.end
                                            )
                                        )
                                    }}
                                </td>
                            </tr>
                            <EditRow
                                v-if="
                                    clickedLine === index &&
                                    !deletedWorkingTimes.some(
                                        wt => wt.id === workingTime.id
                                    )
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
            </div>
            <Rectangle class="w-full mt-2 !rounded-2xl h-16">
                <form
                    @submit.prevent="createWorkingTime"
                    class="flex px-4 gap-4"
                >
                    <div>
                        <legend>Date</legend>
                        <DateVue class="h-8" v-model:date="newWTDate" />
                    </div>
                    <div>
                        <legend>Start hour</legend>
                        <TimeVue class="h-8" v-model:time="newWTStart" />
                    </div>
                    <div>
                        <legend>End hour</legend>
                        <TimeVue class="h-8" v-model:time="newWTEnd" />
                    </div>
                    <Button type="submit" class="h-8 place-self-center ml-auto">
                        {{ layout === 'mobile' ? '+' : 'Add new working time' }}
                    </Button>
                </form>
            </Rectangle>
        </div>
    </Modal>
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import { ref, type PropType } from 'vue';
import {
formatDate,
    formatDateTime,
    formatDateToHuman,
    formatTime,
    getHoursDiff,
    newNaiveDateTime,
    padStartZero
} from '@/utils/dates';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import Modal from '../ui/Modal.vue';
import Rectangle from '../ui/cards/Rectangle.vue';
import Button from '../ui/input/Button.vue';
import EditRow from './EditRow.vue';
import DateVue from '../ui/input/Date.vue';
import TimeVue from '../ui/input/Time.vue';
import { useApiFetch } from '@/composables/useApiFetch';

const props = defineProps({
    date: {
        type: Date,
        required: true
    },
    workingTimes: {
        type: Array as PropType<WorkingTime[]>,
        required: true
    },
    userId: {
        type: Number,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'close'): void;
    (e: 'update:workingTimes', workingTimes: WorkingTime[]): void;
}>();

const { layout } = storeToRefs(useScreenStore());

const clickedLine = ref(null as number | null);
const newWTDate = ref(newNaiveDateTime());
const newWTStart = ref(newNaiveDateTime());
const newWTEnd = ref(newNaiveDateTime());
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

async function createWorkingTime() {
    console.log(newWTDate.value, newWTStart.value, newWTEnd.value);
    const { data } = await useApiFetch<WorkingTime>(`/workingtimes/${props.userId}`, {
        method: 'POST',
        data: {
            workingtime: {
                start: `${formatDate(newWTDate.value)} ${formatTime(newWTStart.value)}`,
                end: `${formatDate(newWTDate.value)} ${formatTime(newWTEnd.value)}`
            }
        }
    });
    emits('update:workingTimes', [...props.workingTimes, data.value]);
    newWTDate.value = newNaiveDateTime();
    newWTStart.value = newNaiveDateTime();
    newWTEnd.value = newNaiveDateTime();
}

function deleteWorkingTime(index: number) {
    const dIndex = deletedWorkingTimes.value.findIndex(
        wt => wt.id === props.workingTimes[index].id
    );
    if (dIndex === -1)
        deletedWorkingTimes.value.push(props.workingTimes[index]);
    if (clickedLine.value === index) clickedLine.value += 1;
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
        const newWts = props.workingTimes.map(wt => {
            const uIndex = updatedWorkingTimes.value.findIndex(
                uwt => uwt.id === wt.id
            );
            if (uIndex !== -1) return updatedWorkingTimes.value[uIndex];
            return wt;
        });
        emits('update:workingTimes', newWts);
        updatedWorkingTimes.value = [];
    }
    if (deletedWorkingTimes.value.length > 0) {
        for (const wt of deletedWorkingTimes.value) {
            await useApiFetch(`/workingtimes/${wt.id}`, {
                method: 'DELETE'
            });
        }
        const newWts = props.workingTimes.filter(
            wt => !deletedWorkingTimes.value.some(dwt => dwt.id === wt.id)
        );
        emits('update:workingTimes', newWts);
        deletedWorkingTimes.value = [];
    }
}
</script>

<style lang="scss" scoped>
legend {
    @apply text-xs font-semibold ml-1;
}

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
