<template>
    <Modal
        :width="layout !== 'desktop' ? '95vw' : '80vw'"
        :height="layout !== 'desktop' ? '95vh' : '80vh'"
        @close="emits('close')"
    >
        <div class="flex flex-col gap-2">
            <div class="flex">
                <h1 class="ml-4 text-4xl font-semibold">Working Times</h1>
                <Button class="h-8 place-self-end ml-auto">Save Changes</Button>
            </div>
            <div
                class="overflow-auto h-[calc(80vh-11.5rem)] max-lg:h-[calc(95vh-14rem)]"
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
                                    clicked: clickedLine === index
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
                                v-if="clickedLine === index"
                                :index="index"
                                :start="new Date(workingTime.start)"
                                :end="new Date(workingTime.end)"
                                @update:start="updateStart(index, $event)"
                                @update:end="updateEnd(index, $event)"
                            />
                        </template>
                    </tbody>
                </table>
            </div>
            <Rectangle class="w-full mt-2 !rounded-2xl h-20">
                <form @submit.prevent="" class="flex px-4 gap-4">
                    <Text v-model="newWTStart" label="Start" />
                    <Text v-model="newWTEnd" label="End" />
                    <Button type="submit" class="h-8 place-self-end ml-auto">
                        Add new working time
                    </Button>
                </form>
            </Rectangle>
        </div>
    </Modal>
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import { ref, type PropType } from 'vue';
import { formatDate, formatDateToHuman, getHoursDiff, padStartZero } from '@/utils/dates';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import Modal from '../ui/Modal.vue';
import Rectangle from '../ui/cards/Rectangle.vue';
import Text from '../ui/input/Text.vue';
import Button from '../ui/input/Button.vue';
import EditRow from './EditRow.vue';

const props = defineProps({
    date: {
        type: Date,
        required: true
    },
    workingTimes: {
        type: Array as PropType<WorkingTime[]>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'close'): void;
    (e: 'update:workingTimes', workingTimes: WorkingTime[]): void;
}>();

const { layout } = storeToRefs(useScreenStore());

const clickedLine = ref(null as number | null);
const newWTStart = ref('');
const newWTEnd = ref('');

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
        timeout = 500;
        const row = document.querySelector(`.tmp-row`) as HTMLElement;
        row.classList.remove('grow-in');
        row.classList.add('grow-out');
    }
    setTimeout(() => {
        clickedLine.value = clickedLine.value === index ? null : index;
    }, timeout);
}

function updateStart(index: number, date: Date) {
    const workingTimes = [...props.workingTimes];
    workingTimes[index].start = formatDate(date);
    emits('update:workingTimes', workingTimes);
}

function updateEnd(index: number, date: Date) {
    const workingTimes = [...props.workingTimes];
    workingTimes[index].end = formatDate(date);
    emits('update:workingTimes', workingTimes);
}

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
            &:first-child {
                border-radius: 0.25rem 0 0 0.25rem;
                border-right: solid 1px var(--primary);
            }
            &:last-child {
                border-radius: 0 0.25rem 0.25rem 0;
            }
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
