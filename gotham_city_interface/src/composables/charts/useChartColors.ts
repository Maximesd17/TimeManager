
const style = getComputedStyle(document.body);

export const useChartColors = {
	white: '#ffffff',
	text: style.getPropertyValue('--text'),
	primary: style.getPropertyValue('--primary'),
	secondary: style.getPropertyValue('--secondary'),
	background: style.getPropertyValue('--background'),
	accent: style.getPropertyValue('--accent'),
	hidden: '#00000000'
};
