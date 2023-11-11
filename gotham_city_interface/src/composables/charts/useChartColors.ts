export const useChartColors = () => {
    const style = getComputedStyle(document.body);

    return {
        white: '#ffffff',
        text: style.getPropertyValue('--text'),
        primary: style.getPropertyValue('--primary'),
        secondary: style.getPropertyValue('--secondary'),
        background: style.getPropertyValue('--background'),
        accent: style.getPropertyValue('--accent'),
        hidden: '#00000000'
    };
};
