<template>
    <div class="h-full flex flex-col gap-4">
        <Modal
            v-if="selectedDate"
            :date="selectedDate"
            :workingTimes="workingTimes"
            @update:workingTimes="emits('update:workingTimes', $event)"
            @close="selectedDate = null"
        />
        <Card class="w-full h-full trans relative">
            <DateSelector
                v-if="dateSelectorIsOpen"
                class="absolute translate-x-4 translate-y-4"
                @cancel="dateSelectorIsOpen = false"
                v-model:selected="selectedDate"
                :date="start"
            />
            <Button
                class="absolute inset-2 h-8 w-8 !p-1.5 z-10 dateSelectorButton"
                @click="dateSelectorIsOpen = !dateSelectorIsOpen"
            >
                <img class="w-full h-full" src="@/assets/svg/edit.svg" />
            </Button>
            <div class="h-[calc(100%-2rem)] w-full relative">
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
                <MonthData
                    :workingTimes="workingTimes"
                    :start="start"
                    :end="end"
                />
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

defineProps({
    workingTimes: {
        type: Object as PropType<WorkingTime[]>,
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

const selectedDate = ref(new Date() as Date | null);

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
