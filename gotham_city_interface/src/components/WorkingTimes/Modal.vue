<template>
    <Modal
        :width="layout !== 'desktop' ? '95vw' : '80vw'"
        :height="layout !== 'desktop' ? '95vh' : '80vh'"
        @close="emits('close')"
    >
        <div class="flex flex-col gap-2 h-full w-full relative">
            <div class="flex">
                <h1 class="ml-4 text 2xl sm:text-4xl font-bold">
                    Working Times
                </h1>
                <VDropdown class="place-self-end" :shown="isOpen">
                    <Button
                        class="ml-4 h-8 w-8 !p-1.5 z-10 dateSelectorButton"
                        @click="isOpen = !isOpen"
                    >
                        <SvgEdit class="h-full w-full" />
                    </Button>
                    <template #popper>
                        <DateRange
                            @update:interval="emits('update:interval', $event)"
                            @cancel="isOpen = false"
                            :start="interval.start"
                            :end="interval.end"
                            :month="interval.start"
                        />
                    </template>
                </VDropdown>
                <Button
                    class="h-8 place-self-end ml-auto"
                    @click="pushChanges"
                    :disabled="wTTable?.hasChanges"
                >
                    Save Changes
                </Button>
            </div>
            <div
                class="overflow-auto h-[calc(80vh-10.5rem)] max-lg:h-[calc(95vh-13rem)] relative"
            >
                <TableVue
                    ref="wTTable"
                    v-model:working-times="workingTimes"
                    :minimum-rows="15"
                />
                <div
                    v-if="!workingTimes.length && !isLoading"
                    class="absolute w-full h-full top-0"
                >
                    <div
                        class="bg-white bg-opacity-80 shadow-lg shadow-white w-full h-full"
                    ></div>
                    <div class="absolute-center">
                        {{
                            interval.start.toDateString() ===
                            interval.end.toDateString()
                                ? `No working times on ${formatDateToHuman(
                                      interval.start,
                                      false
                                  )}`
                                : `No working times on period
                        ${formatDateToHuman(interval.start, false)}
                        -> ${formatDateToHuman(interval.end, false)}`
                        }}
                    </div>
                </div>
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
import type { APIWorkingTime, WorkingTime } from '@/types';
import { ref, type PropType, watch } from 'vue';
import {
    formatDate,
    formatDateTime,
    formatDateToHuman,
    formatTime,
    newNaiveDateTime
} from '@/utils/dates';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';
import { useApiFetch } from '@/composables/useApiFetch';

import DateRange from '@/components/ui/input/DateRange.vue';
import Modal from '../ui/Modal.vue';
import Rectangle from '../ui/cards/Rectangle.vue';
import Button from '../ui/input/Button.vue';
import DateVue from '../ui/input/Date.vue';
import TimeVue from '../ui/input/Time.vue';
import TableVue from './Table.vue';
import SvgEdit from '@/components/svg/Edit.vue';

const props = defineProps({
    interval: {
        type: Object as PropType<{ start: Date; end: Date }>,
        required: true
    },
    userId: {
        type: Number,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'close'): void;
    (e: 'update:interval', interval: { start: Date; end: Date }): void;
}>();

const { layout } = storeToRefs(useScreenStore());

const newWTDate = ref(newNaiveDateTime(props.interval.start));
const newWTStart = ref(newNaiveDateTime());
const newWTEnd = ref(newNaiveDateTime());
const workingTimes = ref([] as WorkingTime[]);
const isLoading = ref(true);

const wTTable = ref(null as typeof TableVue | null);

const isOpen = ref(false);

async function fetchWorkingTimes() {
    const { data, error } = await useApiFetch<APIWorkingTime[]>(
        `/workingtimes/${props.userId}`,
        {
            params: {
                start: `${formatDateTime(props.interval.start)}`,
                end: `${formatDateTime(props.interval.end)}`
            }
        }
    );
    if (error.value) {
        isLoading.value = false;
        return;
    } else {
        workingTimes.value = data.value
            .map(wt => ({
                ...wt,
                start: newNaiveDateTime(wt.start),
                end: newNaiveDateTime(wt.end)
            }))
            .sort((a, b) => a.id - b.id);
        isLoading.value = false;
    }
}

watch(
    () => props.interval,
    () => fetchWorkingTimes(),
    { deep: true, immediate: true }
);

async function createWorkingTime() {
    const { data } = await useApiFetch<WorkingTime>(
        `/workingtimes/${props.userId}`,
        {
            method: 'POST',
            data: {
                workingtime: {
                    start: `${formatDate(newWTDate.value)} ${formatTime(
                        newWTStart.value
                    )}`,
                    end: `${formatDate(newWTDate.value)} ${formatTime(
                        newWTEnd.value
                    )}`
                }
            }
        }
    );

    if (
        newWTDate.value.getTime() >= props.interval.start.getTime() &&
        newWTDate.value.getTime() <= props.interval.end.getTime()
    ) {
        workingTimes.value.push({
            ...data.value,
            start: newNaiveDateTime(data.value.start),
            end: newNaiveDateTime(data.value.end)
        });
    }
}

function pushChanges() {
    wTTable.value?.pushChanges();
}
</script>

<style lang="scss" scoped>
legend {
    @apply text-xs font-semibold ml-1;
}
</style>
