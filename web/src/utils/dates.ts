export function padStartZero(number: number | string, length: number = 2) {
    if (typeof number === 'string') return number.padStart(length, '0');
    return number.toString().padStart(length, '0');
}

export const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
];

export function formatDateTime(date: Date | string): string {
    if (typeof date === 'string') date = new Date(date);

    const year = padStartZero(date.getFullYear());
    const month = padStartZero(date.getMonth() + 1);
    const day = padStartZero(date.getDate());

    const hours = padStartZero(date.getHours());
    const minutes = padStartZero(date.getMinutes());
    const seconds = padStartZero(date.getSeconds());

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

export function formatDate(date: Date | string): string {
    if (typeof date === 'string') date = new Date(date);
    const year = padStartZero(date.getFullYear());
    const month = padStartZero(date.getMonth() + 1);
    const day = padStartZero(date.getDate());

    return `${year}-${month}-${day}`;
}

export function formatDateToHuman(
    date: Date | string,
    withTime: boolean = true,
    fromUtc: boolean = true
): string {
    if (typeof date === 'string') date = new Date(date);
    const timeZoneOffset = date.getTimezoneOffset() / 60;
    if (fromUtc) date.setHours(date.getHours() - timeZoneOffset);

    const year = padStartZero(date.getFullYear());
    const month = padStartZero(date.getMonth() + 1);
    const day = padStartZero(date.getDate());

    const hours = padStartZero(date.getHours());
    const minutes = padStartZero(date.getMinutes());
    const seconds = padStartZero(date.getSeconds());

    return withTime
        ? `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`
        : `${day}/${month}/${year}`;
}

export function getFormattedDaysInInterval(
    start: string | Date | number,
    end: string | Date | number,
    includeEnd = false
) {
    if (!start || !end) return [];

    const startDate = new Date(start);
    const endDate = new Date(end);

    startDate.setHours(12, 0, 0, 0);
    endDate.setHours(12, 0, 0, 0);

    if (includeEnd) endDate.setDate(endDate.getDate() + 1);

    const days = [];
    for (
        let date = startDate;
        date < endDate;
        date.setDate(date.getDate() + 1)
    ) {
        days.push(formatDate(date));
    }

    return days;
}

export function getHoursDiff(
    startDate: string | Date,
    endDate: string | Date
): number {
    if (!startDate || !endDate) return 0;
    if (typeof startDate === 'string') startDate = new Date(startDate);
    if (typeof endDate === 'string') endDate = new Date(endDate);

    const diff = endDate.getTime() - startDate.getTime();
    return diff / (1000 * 60 * 60);
}
