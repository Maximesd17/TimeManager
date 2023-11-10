<template>
    <div class="h-full flex flex-col gap-4">
        <Modal
            v-if="interval"
            v-model:interval="interval"
            :user-id="userId"
            @close="interval = null"
        />
        <Card class="w-full h-full trans relative">
            <DateRange
                v-if="dateSelectorIsOpen"
                class="absolute translate-x-4 translate-y-4"
                @update:interval="interval = $event"
                @cancel="dateSelectorIsOpen = false"
                :start="null"
                :end="null"
                :month="start"
            />
            <Button
                class="absolute inset-2 h-8 w-8 !p-1.5 z-10 dateSelectorButton"
                @click="dateSelectorIsOpen = !dateSelectorIsOpen"
            >
                <SvgEdit class="h-full w-full" />
            </Button>
            <div class="h-full w-full relative flex flex-col justify-between">
                <div class="flex items-center flex-wrap">
                    <h3 class="text-center mb-4 ml-[50%] -translate-x-1/2">
                        Month Data
                    </h3>
                    <div class="flex items-center ml-auto text-lg font-bold">
                        <ArrowLeft
                            class="h-5 w-5 mr-1 cursor-pointer"
                            @click="emits('prevMonth')"
                            :color="'var(--accent)'"
                        />
                        <h5 class="text-center">
                            {{ monthNames[start.getMonth()] }}
                            {{ start.getFullYear() }}
                        </h5>
                        <ArrowRight
                            class="h-5 w-5 ml-1 cursor-pointer"
                            @click="emits('nextMonth')"
                            :color="'var(--accent)'"
                        />
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
import Modal from './Modal.vue';
import DateRange from '../ui/input/DateRange.vue';
import ArrowLeft from '@/components/svg/arrow/Left.vue';
import ArrowRight from '@/components/svg/arrow/Right.vue';
import SvgEdit from '@/components/svg/Edit.vue';

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

const interval = ref(null as { start: Date; end: Date } | null);

const dateSelectorIsOpen = ref(false);

watch(
    () => interval.value,
    () => {
        dateSelectorIsOpen.value = false;
    }
);
</script>

<style lang="scss" scoped>
.trans {
    transition: height 0.2s ease-in-out;
}
</style>
