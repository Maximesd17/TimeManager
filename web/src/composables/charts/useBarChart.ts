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
    const colors = useChartColors();
    return {
        scales: {
            x: {
                ticks: {
                    font: { family: "'Montserrat', sans-serif" },
                    color: colors['text']
                },
                grid: {
                    color: ({ tick }) => {
                        if (!tick || tick.value !== 0)
                            return colors['hidden'];
                        return colors['secondary'];
                    }
                }
            },
            y: {
                beginAtZero: true,
                border: { display: false },
                ticks: {
                    font: { family: "'Montserrat', sans-serif" },
                    color: colors['text']
                },
                grid: {
                    color: ({ tick }) => {
                        if (tick.value !== 0) return colors['secondary'];
                        return colors['secondary'];
                    }
                }
            }
        },
        plugins: {
            legend: { display: false },
            title: { display: false },
            tooltip: {
                backgroundColor: colors['background'],
                titleColor: colors['text'],
                bodyColor: colors['text'],
                borderWidth: 1,
                borderColor: colors['primary'],
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
    const chartColors = useChartColors();
    const options = generateOptions
        ? computed(useBarChartGenerateOptions)
        : ({} as Ref<ChartOptions<'bar'>>);
    const colors = labels.value?.map((_, i) =>
        i % 2 ? chartColors['primary'] : chartColors['primary']
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
