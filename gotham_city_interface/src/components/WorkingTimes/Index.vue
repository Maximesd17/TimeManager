<template>
    <div class="h-full flex flex-col gap-4">
        <Card class="w-full h-full transition relative">
            <div class="h-[calc(100%-2rem)] w-full">
                <div class="flex justify-center items-center w-full">
                    <h2 class="h-4 text-center mb-4">Past Month Data</h2>
                    <div
                        class="flex items-center absolute right-4 text-lg font-bold"
                    >
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
import { type PropType } from 'vue';
import { monthNames } from '@/utils/dates';

import Card from '@/components/ui/cards/Rectangle.vue';
import MonthData from '@/components/WorkingTimes/MonthData.vue';

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
    (e: 'prevMonth'): void;
    (e: 'nextMonth'): void;
}>();
</script>

<style lang="scss" scoped>
h2 {
    @apply font-bold text-xl;
}

.transition {
    transition: height 0.2s ease-in-out;
}
</style>
