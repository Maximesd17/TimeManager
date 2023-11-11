<template>
    <div>
        <Pie class="h-full w-full" :data="data" :options="options" />
    </div>
</template>

<script lang="ts" setup>
import type { Clock } from '@/types';
import { ref, type PropType, watch } from 'vue';
import { usePieChart } from '@/composables/charts/usePieChart';
import { getHoursDiff, newNaiveDateTime, padStartZero } from '@/utils/dates';

const props = defineProps({
    clock: {
        type: Object as PropType<Clock>,
        required: true
    }
});

const date = newNaiveDateTime();

const labels = ref(['Worked Time', 'Remaining Working Time'] as string[]);
const datasets = ref(
    [] as {
        data: number[];
        label?: string[];
        backgroundColor?: string[];
        type?: string;
        borderColor?: string;
    }[]
);

function fillChartData() {
    const style = getComputedStyle(document.body);
    const timeWorked = props.clock.time
        ? getHoursDiff(props.clock.time, date)
        : 0;
    const timeRemaining = timeWorked <= 8 ? 8 - timeWorked : 0;
    datasets.value = [];

    let hoursWorked = Math.floor(timeWorked);
    let minutesWorked = Math.round((timeWorked - hoursWorked) * 60);
    if (minutesWorked === 60) {
        hoursWorked++;
        minutesWorked = 0;
    }

    let hoursRemaining = Math.floor(timeRemaining);
    let minutesRemaining = Math.round((timeRemaining - hoursRemaining) * 60);
    if (minutesRemaining === 60) {
        hoursRemaining++;
        minutesRemaining = 0;
    }

    datasets.value.push({
        data: [timeWorked, timeRemaining],
        label: [
            ` Worked Time: ${padStartZero(hoursWorked)}h${padStartZero(
                minutesWorked
            )}`,
            ` Remaining Time: ${padStartZero(hoursRemaining)}h${padStartZero(
                minutesRemaining
            )}`
        ],
        backgroundColor: [
            style.getPropertyValue('--primary'),
            style.getPropertyValue('--accent')
        ],
        borderColor: style.getPropertyValue('--secondary')
    });
}

watch(
    () => props.clock,
    () => {
        fillChartData();
    },
    { immediate: true, deep: true }
);

// @ts-ignore
const { Pie, data, options } = usePieChart(labels, datasets);
</script>

<style lang="scss" scoped></style>
