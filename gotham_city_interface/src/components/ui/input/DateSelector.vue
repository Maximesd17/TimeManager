<template>
    <div class="date-selector flex flex-col" ref="dateSelector">
        <div class="flex items-center text-lg font-bold mx-auto">
            <div class="flex items-center ml-auto text-lg font-bold">
                <ArrowLeft
                    class="h-4 w-4 mr-1 cursor-pointer"
                    @click="setPrevMonth"
                    :color="'var(--accent)'"
                />
                <h5 class="text-center">
                    {{ monthNames[date.getMonth()] }}
                    {{ date.getFullYear() }}
                </h5>
                <ArrowRight
                    class="h-4 w-4 ml-1 cursor-pointer"
                    @click="setNextMonth"
                    :color="'var(--accent)'"
                />
            </div>
        </div>
        <div
            class="w-full h-full grid grid-cols-7 justify-items-center place-content-around"
        >
            <template v-for="day in dayNames" :key="day">
                <p class="font-bold">{{ day.slice(0, 3) }}</p>
            </template>

            <template v-for="date in datesArray" :key="date.toString()">
                <p
                    class="date  p-1.5"
                    :class="{ 'font-bold': date.isCurrentMonth }"
                    @click="updateDate(date.date)"
                >
                    {{ date.date.getDate() }}
                </p>
            </template>
        </div>
    </div>
</template>

<script lang="ts" setup>
import useClickOutside from '@/composables/useClickOutside';
import { ref, type PropType } from 'vue';

import {
    dayNames,
    getFormattedDaysInInterval,
    monthNames,
    prevMonth,
    nextMonth,
    newNaiveDateTime
} from '@/utils/dates';

import ArrowLeft from '@/components/svg/arrow/Left.vue';
import ArrowRight from '@/components/svg/arrow/Right.vue';

const props = defineProps({
    month: {
        type: Date as PropType<Date | null>,
        default: null
    },
    date: {
        type: Date as PropType<Date>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'cancel'): void;
    (e: 'update:date', date: Date): void;
}>();

const dateForMonth = ref(newNaiveDateTime(props.month ?? props.date));
dateForMonth.value.setDate(1);
dateForMonth.value.setHours(0, 0, 0, 0);

const dateSelector = ref();
const datesArray = ref([] as { date: Date; isCurrentMonth: boolean }[]);

function setPrevMonth() {
    dateForMonth.value = prevMonth(dateForMonth.value);
    generateDateArray();
}

function setNextMonth() {
    dateForMonth.value = nextMonth(dateForMonth.value);
    generateDateArray();
}

function generateDateArray() {
    const firstDayOfMonth = new Date(dateForMonth.value);
    firstDayOfMonth.setHours(0, 0, 0, 0);
    firstDayOfMonth.setMonth(dateForMonth.value.getMonth());
    firstDayOfMonth.setDate(1);

    const lastDayOfMonth = new Date(firstDayOfMonth);
    lastDayOfMonth.setMonth(dateForMonth.value.getMonth() + 1);
    lastDayOfMonth.setDate(0);

    const firstDayOfCalendar = new Date(firstDayOfMonth);
    firstDayOfCalendar.setDate(
        firstDayOfMonth.getDate() -
            (firstDayOfMonth.getDay() ? firstDayOfMonth.getDay() - 1 : 6)
    );

    const lastDayOfCalendar = new Date(lastDayOfMonth);
    lastDayOfCalendar.setDate(
        lastDayOfMonth.getDate() +
            (lastDayOfMonth.getDay() ? 7 - lastDayOfMonth.getDay() : 0)
    );

    const dates = getFormattedDaysInInterval(
        firstDayOfCalendar,
        lastDayOfCalendar,
        true
    );
    datesArray.value = dates.map(d => {
        const nDate = new Date(d);
        return {
            date: nDate,
            isCurrentMonth: nDate.getMonth() === dateForMonth.value.getMonth()
        };
    });
}

function updateDate(date: Date) {
    const d = new Date(date);

    emits('update:date', d);
}

function cancel() {
    emits('cancel');
}

generateDateArray();

useClickOutside(dateSelector, cancel, ['.dateSelectorButton']);
</script>

<style lang="scss" scoped>
.date-selector {
    width: 16rem;
    height: 16rem;
    z-index: 13;
    padding: 0.5rem 0.75rem;
    background-color: var(--secondary);
    border: 2px solid var(--primary);
    border-radius: 0.375rem;

    .date {
        @apply cursor-pointer w-full h-full text-center;

        &:hover {
            @apply rounded-full bg-white;

            outline: var(--primary) 1px solid;
        }
    }
}
</style>
