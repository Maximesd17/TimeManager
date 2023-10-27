<template>
    <Bar class="h-[20rem]" :data="data" :options="options" />
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import { ref, type PropType, watch } from 'vue';

import { useBarChart } from '@/composables/charts/useBarChart';
import { getFormattedDaysInInterval, formatDateToHuman } from '@/utils/dates';

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
        type?: string;
        borderColor?: string;
    }[]
);

function fillChartData() {
    dates = getFormattedDaysInInterval(props.start, props.end, true)
    labels.value = dates.map(d => formatDateToHuman(d, false)) as string[];
    datasets.value = [];

    datasets.value.push({
        data: [0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5],
        backgroundColor: '#ffffff'
    });

    datasets.value.push({
        data: [1, 2, 3, 4, 5, 6, 7, 8],
        backgroundColor: '#bada55'
    });
}

watch(
    () => [props.workingTimes, props.start, props.end],
    () => {
        fillChartData();
    }, { immediate: true, deep: true}
);

// @ts-ignore
const { Bar, data, options } = useBarChart(labels, datasets);
</script>

<style lang="scss" scoped></style>
