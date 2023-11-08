<template>
    <div class="date-selector flex flex-col" ref="dateSelector">
        <div class="flex items-center text-lg font-bold mx-auto">
            <div
                class="w-4 h-4 mr-1 flex items-center cursor-pointer"
                @click="setPrevMonth"
            >
                <img src="@/assets/svg/arrowLeft.svg" class="w-full h-full" />
            </div>
            <h3 class="w-40 text-center">
                {{ monthNames[date.getMonth()] }}
                {{ date.getFullYear() }}
            </h3>
            <div
                class="w-4 h-4 ml-1 rotate-180 flex items-center cursor-pointer"
                @click="setNextMonth"
            >
                <img src="@/assets/svg/arrowLeft.svg" class="w-full h-full" />
            </div>
        </div>
        <div
            class="w-full h-full grid grid-cols-7 justify-items-center place-content-around"
        >
            <template v-for="day in dayNames" :key="day">
                <p class="font-bold">{{ day.slice(0, 3) }}</p>
            </template>

            <template v-for="date in datesArray" :key="date.toString()">
                <div
                    class="date"
                    :class="{
                        inRange: inRange(date.date),
                        'rounded-l-full': isLeftRounded(date.date),
                        'rounded-r-full': isRightRounded(date.date)
                    }"
                >
                    <p
                        class="w-full h-full p-0.5 select-none"
                        :class="{
                            'font-bold': date.isCurrentMonth,
                            selected: isDate(date.date)
                        }"
                        @click="updateDate(date.date)"
                        @mouseenter="hoveredDate = date.date"
                    >
                        {{ date.date.getDate() }}
                    </p>
                </div>
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

const props = defineProps({
    start: {
        type: Date as PropType<Date | null>,
        required: true
    },
    end: {
        type: Date as PropType<Date | null>,
        required: true
    },
    month: {
        type: Date as PropType<Date | null>,
        default: null
    }
});

const emits = defineEmits<{
    (e: 'cancel'): void;
    (e: 'update:interval', interval: { start: Date; end: Date }): void;
}>();

const hoveredDate = ref<Date | null>(null);

const date = ref(newNaiveDateTime(props.month ?? undefined));
date.value.setDate(1);
date.value.setHours(0, 0, 0, 0);

const start = ref(props.start ? newNaiveDateTime(props.start) : null);
const end = ref(props.end ? newNaiveDateTime(props.end) : null);

const dateSelector = ref();
const datesArray = ref([] as { date: Date; isCurrentMonth: boolean }[]);

function inRange(target: Date) {
    if (start.value && !end.value && hoveredDate.value) {
        return (
            (target.getTime() >= start.value.getTime() &&
                hoveredDate.value.getTime() > start.value.getTime() &&
                target.getTime() <= hoveredDate.value.getTime()) ||
            (target.getTime() <= start.value.getTime() &&
                hoveredDate.value.getTime() < start.value.getTime() &&
                target.getTime() >= hoveredDate.value.getTime())
        );
    }
    if (!start.value && end.value && hoveredDate.value) {
        return (
            target.getTime() <= end.value.getTime() &&
            hoveredDate.value.getTime() < end.value.getTime() &&
            target.getTime() >= hoveredDate.value.getTime()
        );
    }
    if (start.value && end.value) {
        return (
            target.getTime() >= start.value.getTime() &&
            target.getTime() <= end.value.getTime()
        );
    }
    return false;
}

function isDate(target: Date) {
    if (start.value && end.value)
        return (
            start.value?.toDateString() === target.toDateString() ||
            end.value?.toDateString() === target.toDateString()
        );
    return (
        start.value?.toDateString() === target.toDateString() ||
        hoveredDate.value?.toDateString() === target.toDateString() ||
        end.value?.toDateString() === target.toDateString()
    );
}

function isLeftRounded(target: Date) {
    if (target.getDay() === 1) return true;
    if (
        start.value &&
        hoveredDate.value &&
        start.value.getTime() > hoveredDate.value.getTime() &&
        !end.value
    ) {
        return hoveredDate.value?.toDateString() === target.toDateString();
    }
    return start.value?.toDateString() === target.toDateString();
}

function isRightRounded(target: Date) {
    if (target.getDay() === 0) return true;
    if (
        start.value &&
        hoveredDate.value &&
        start.value.getTime() > hoveredDate.value.getTime() &&
        !end.value
    )
        return start.value.toDateString() === target.toDateString();
    return (
        end.value?.toDateString() === target.toDateString() ||
        (hoveredDate.value?.toDateString() === target.toDateString() &&
            !end.value)
    );
}

function setPrevMonth() {
    date.value = prevMonth(date.value);
    generateDateArray();
}

function setNextMonth() {
    date.value = nextMonth(date.value);
    generateDateArray();
}

function generateDateArray() {
    const firstDayOfMonth = new Date(date.value);
    firstDayOfMonth.setHours(0, 0, 0, 0);
    firstDayOfMonth.setMonth(date.value.getMonth());
    firstDayOfMonth.setDate(1);

    const lastDayOfMonth = new Date(firstDayOfMonth);
    lastDayOfMonth.setMonth(date.value.getMonth() + 1);
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
            isCurrentMonth: nDate.getMonth() === date.value.getMonth()
        };
    });
}

function updateDate(date: Date) {
    if (!start.value) {
        updateStart(date);
    } else if (!end.value) {
        if (start.value.getTime() > date.getTime()) {
            updateEnd(start.value);
            updateStart(date);
        } else updateEnd(date);
    } else {
        if (date.toDateString() === start.value.toDateString()) {
            updateStart(end.value);
            end.value = null;
        } else if (date.toDateString() === end.value.toDateString()) {
            end.value = null;
        } else {
            updateStart(date);
            end.value = null;
        }
        return;
    }
    if (end.value && start.value) {
        emits('update:interval', { start: start.value, end: end.value });
    }
}

function updateStart(date: Date) {
    const d = newNaiveDateTime(date);

    if (end.value && d > end.value) {
        end.value = d;
        end.value.setHours(23, 59, 59, 999);
    }
    start.value = d;
    start.value.setHours(0, 0, 0, 0);
}

function updateEnd(date: Date) {
    const d = newNaiveDateTime(date);

    if (start.value && d < start.value) {
        start.value = d;
        start.value.setHours(0, 0, 0, 0);
    }
    end.value = d;
    end.value.setHours(23, 59, 59, 999);
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

        .selected {
            @apply rounded-full bg-white;
            color: var(--primary);
            outline: var(--primary) 1px solid;
            outline-offset: -1px;
            &:first-child {
                @apply rounded-l-full;
            }
        }

        &.inRange {
            background-color: var(--primary);
            color: var(--secondary);
        }
    }
}
</style>
