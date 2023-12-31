import { Pie } from 'vue-chartjs';
import {
    Chart,
    type ChartOptions,
    type ChartData,
    Title,
    Tooltip,
    Legend,
    CategoryScale,
    LinearScale,
    ArcElement
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import { useChartColors } from './useChartColors';
import { computed, type Ref } from 'vue';

Chart.register(
    Title,
    Tooltip,
    Legend,
    CategoryScale,
    LinearScale,
    ArcElement,
    ChartDataLabels
);

export function usePieChartGenerateDefaultOptions(): ChartOptions<'pie'> {
    const colors = useChartColors();
    return {
        plugins: {
            legend: {
                display: true,
                position: 'bottom',
                align: 'center',
                labels: { color: colors['text'] }
            },
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
                }
            },
            datalabels: {
                display: false
            }
        },
        maintainAspectRatio: false,
        locale: 'fr-FR'
    };
}

export function usePieChart(
    labels: Ref<ChartData<'pie'>['labels']>,
    datasets: Ref<ChartData<'pie'>['datasets']>,
    generateOptions: boolean = true
) {
    const options = generateOptions
        ? computed(usePieChartGenerateDefaultOptions)
        : ({} as Ref<ChartOptions<'pie'>>);

    const data = computed<ChartData<'pie'>>(() => ({
        labels: labels.value,
        datasets: datasets.value.map(dataset => ({
            borderRadius: 5,
            ...dataset
        }))
    }));

    return {
        Pie,
        data,
        options
    };
}
