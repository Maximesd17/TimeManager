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

watch(
    () => [props.workingTimes, props.start, props.end],
    () => {
        fillChartData();
    },
    { immediate: true, deep: true }
);

function fillChartData() {
    dates = getFormattedDaysInInterval(props.start, props.end, true);
    labels.value = dates.map(d => formatDateToHuman(d, false)) as string[];
    datasets.value = [];

    const data = dates.map(d => {
        const startDate = formatDate(d);
        const workingTimes = props.workingTimes.filter(
            wt => formatDate(wt.start) === startDate
        );

        let duration = 0;

        for (const workingTime of workingTimes) {
            duration += getHoursDiff(workingTime.start, workingTime.end);
        }

        return duration;
    }) as number[];

    const dataLabels = data.map(d => {
        if (d === 0) return '';
        let hours = Math.floor(d);
        let minutes = Math.round((d - hours) * 60);
        if (minutes === 60) {
            hours++;
            minutes = 0;
        }

        return `Worked Time: ${padStartZero(hours)}h${padStartZero(minutes)}`;
    });

    datasets.value.push({
        data: data,
        label: dataLabels,
        backgroundColor: '#879CA4'
    });
}

// @ts-ignore
const { Bar, data, options } = useBarChart(labels, datasets);
</script>

<style lang="scss" scoped>
.chart {
    height: 100%;
}
</style>
