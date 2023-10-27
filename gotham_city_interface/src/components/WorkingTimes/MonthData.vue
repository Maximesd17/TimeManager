<template>
    <Bar class="h-full w-full" :data="data" :options="options" />
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import { ref, type PropType, watch } from 'vue';
import { useBarChart } from '@/composables/charts/useBarChart';
import {
    getFormattedDaysInInterval,
    formatDateToHuman,
    formatDate,
    getHoursDiff,
    padStartZero
} from '@/utils/dates';

const props = defineProps({
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

let dates = [] as string[];

const labels = ref([] as string[]);
const datasets = ref(
    [] as {
        data: number[];
        backgroundColor: string;
        label?: string[];
        type?: string;
        borderColor?: string;
    }[]
);

function fillChartData() {
    dates = getFormattedDaysInInterval(props.start, props.end, true);
    labels.value = dates.map(d => formatDateToHuman(d, false)) as string[];
    datasets.value = [];

    const data = dates.map(d => {
        const startDate = formatDate(d);
        const workingTime = props.workingTimes.find(
            wt => formatDate(wt.start) === startDate
        );

        return workingTime
            ? getHoursDiff(workingTime.start, workingTime.end)
            : 0;
    }) as number[];

    const dataLabels = data.map(d => {
        if (d === 0) return '';
        const hours = Math.floor(d);
        const minutes = Math.round((d - hours) * 60);

        return `Worked Time: ${padStartZero(hours)}h${padStartZero(minutes)}`;
    });

    datasets.value.push({
        data: data,
        label: dataLabels,
        backgroundColor: '#827679'
    });
}

watch(
    () => [props.workingTimes, props.start, props.end],
    () => {
        fillChartData();
    },
    { immediate: true, deep: true }
);

// @ts-ignore
const { Bar, data, options } = useBarChart(labels, datasets);
</script>

<style lang="scss" scoped>
.chart {
    height: 100%;
}
</style>
