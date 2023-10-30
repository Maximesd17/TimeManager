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
	ArcElement,
} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import { useChartColors } from './useChartColors';
import { computed, type Ref } from 'vue';

Chart.register(Title, Tooltip, Legend, CategoryScale, LinearScale, ArcElement, ChartDataLabels);

export function usePieChartGenerateDefaultOptions(): ChartOptions<'pie'> {
	return {
		plugins: {
			legend: { display: true, position: 'bottom', align: 'center', labels: { color: useChartColors['primary'] } },
			title: { display: false },
			tooltip: {
				backgroundColor: useChartColors['light'],
				titleColor: useChartColors['primary'],
				bodyColor: useChartColors['primary'],
				borderWidth: 1,
				borderColor: useChartColors['primary'],
                callbacks: {
                    label: (context) => {
                        // @ts-ignore
                        return context.dataset.label[context.dataIndex];
                    }
                }
			},
            // @ts-ignore
			datalabels: {
				display: false
			},

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
	const options = generateOptions ? computed(usePieChartGenerateDefaultOptions) : ({} as Ref<ChartOptions<'pie'>>);

	const data = computed<ChartData<'pie'>>(() => ({
		labels: labels.value,
		datasets: datasets.value.map(dataset => ({
			backgroundColor: ['#1f2145', '#63647d', '#e0886a', '#2e2b28', '#cda06b', '#000000'],
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
