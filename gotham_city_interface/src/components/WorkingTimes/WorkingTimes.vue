<template>
    <div class="h-full flex flex-col gap-4">
        <Modal
            v-if="selectedDate"
            :date="selectedDate"
            :workingTimes="workingTimes"
            :user-id="userId"
            @update:workingTimes="emits('update:workingTimes', $event)"
            @close="selectedDate = null"
        />
        <Card class="w-full h-full trans relative">
            <DateRange
                v-if="dateSelectorIsOpen"
                class="absolute translate-x-4 translate-y-4"
                @cancel="dateSelectorIsOpen = false"
                :start="null"
                :end="null"
                :month="start"
            />
            <Button
                class="absolute inset-2 h-8 w-8 !p-1.5 z-10 dateSelectorButton"
                @click="dateSelectorIsOpen = !dateSelectorIsOpen"
            >
                <img class="w-full h-full" src="@/assets/svg/edit.svg" />
            </Button>
            <div class="h-full w-full relative flex flex-col justify-between">
                <div class="flex items-center flex-wrap">
                    <h2 class="h-4 text-center mb-4 ml-[50%] -translate-x-1/2">
                        Past Month Data
                    </h2>
                    <div class="flex items-center ml-auto text-lg font-bold">
                        <div
                            class="w-4 h-4 mr-1 flex items-center cursor-pointer"
                            @click="emits('prevMonth')"
                        >
                            <img
                                src="@/assets/svg/arrowLeft.svg"
                                class="w-full h-full"
                            />
                        </div>
                        <h3 class="w-40 text-center">
                            {{ monthNames[start.getMonth()] }}
                            {{ start.getFullYear() }}
                        </h3>
                        <div
                            class="w-4 h-4 ml-1 rotate-180 flex items-center cursor-pointer"
                            @click="emits('nextMonth')"
                        >
                            <img
                                src="@/assets/svg/arrowLeft.svg"
                                class="w-full h-full"
                            />
                        </div>
                    </div>
                </div>
                <div class="h-[calc(100%-4rem)] mt-auto">
                    <MonthData
                        :workingTimes="workingTimes"
                        :start="start"
                        :end="end"
                    />
                </div>
            </div>
        </Card>
    </div>
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import { ref, type PropType, watch } from 'vue';
import { monthNames } from '@/utils/dates';

import Card from '@/components/ui/cards/Rectangle.vue';
import MonthData from '@/components/workingTimes/MonthData.vue';
import Button from '@/components/ui/input/Button.vue';
import DateSelector from '@/components/ui/input/DateSelector.vue';
import Modal from './Modal.vue';
import DateRange from '../ui/input/DateRange.vue';

defineProps({
    workingTimes: {
        type: Object as PropType<WorkingTime[]>,
        required: true
    },
    userId: {
        type: Number,
        required: true
    },
    start: {
        type: Date,
        required: true
    },
    end: {
        type: Date,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'update:workingTimes', workingTimes: WorkingTime[]): void;
    (e: 'prevMonth'): void;
    (e: 'nextMonth'): void;
}>();

const selectedDate = ref(null as Date | null);

const dateSelectorIsOpen = ref(false);

watch(
    () => selectedDate.value,
    () => {
        dateSelectorIsOpen.value = false;
    }
);
</script>

<style lang="scss" scoped>
h2 {
    @apply font-bold text-xl;
}

.trans {
    transition: height 0.2s ease-in-out;
}
</style>
