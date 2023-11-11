import { Bar } from 'vue-chartjs';
import type { ChartOptions, ChartData } from 'chart.js';
import {
    Chart,
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement
} from 'chart.js';

import { useChartColors } from './useChartColors';
import { computed, type Ref } from 'vue';

import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

Chart.register(
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement
);

export function useBarChartGenerateOptions(): ChartOptions<'bar'> {
    const { layout } = storeToRefs(useScreenStore());
    return {
        scales: {
            x: {
                ticks: {
                    font: { family: "'Montserrat', sans-serif" },
                    color: useChartColors['primary']
                },
                grid: {
                    color: ({ tick }) => {
                        if (!tick || tick.value !== 0)
                            return useChartColors['hidden'];
                        return useChartColors['primary'];
                    }
                }
            },
            y: {
                beginAtZero: true,
                border: { display: false },
                ticks: {
                    font: { family: "'Montserrat', sans-serif" },
                    color: useChartColors['primary']
                },
                grid: {
                    color: ({ tick }) => {
                        if (tick.value !== 0) return useChartColors['primary'];
                        return useChartColors['primary'];
                    }
                }
            }
        },
        plugins: {
            legend: { display: false },
            title: { display: false },
            tooltip: {
                backgroundColor: useChartColors['light'],
                titleColor: useChartColors['primary'],
                bodyColor: useChartColors['primary'],
                borderWidth: 1,
                borderColor: useChartColors['button'],
                callbacks: {
                    label: context => {
                        // @ts-ignore
                        return context.dataset.label[context.dataIndex];
                    }
                },
                mode: 'index'
            },
            // @ts-ignore
            datalabels: {
                display: false
            }
        },
        maintainAspectRatio: false,
        locale: 'fr-FR'
    };
}

export function useBarChart(
    labels: Ref<ChartData<'bar'>['labels']>,
    datasets: Ref<ChartData<'bar'>['datasets']>,
    generateOptions: boolean = true
) {
    const options = generateOptions
        ? computed(useBarChartGenerateOptions)
        : ({} as Ref<ChartOptions<'bar'>>);
    const colors = labels.value?.map((_, i) =>
        i % 2 ? useChartColors['button'] : useChartColors['primary']
    );

    const data = computed<ChartData<'bar'>>(() => ({
        labels: labels.value,
        datasets: datasets.value.map(dataset => ({
            borderRadius: 10,
            backgroundColor: colors,
            ...dataset
        }))
    }));

    return {
        Bar,
        data,
        options
    };
}
