import moment, { type Moment } from 'moment';

export function padStartZero(number: number | string, length: number = 2) {
    if (typeof number === 'string') return number.padStart(length, '0');
    return number.toString().padStart(length, '0');
}

export const dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
];

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

export function newNaiveDateTime(date?: Date | string): Date {
    if (!date) date = new Date();
    if (typeof date === 'string') date = new Date(date);
    return new Date(date.getTime());
}

export function formatDateTime(date: Date | string | Moment): string {
    if (typeof date === 'string') date = new Date(date);
    if (date instanceof Date) date = moment(date);
    return date.format('YYYY-MM-DD HH:mm:ss');
}

export function formatDate(date: Date | string | Moment): string {
    if (typeof date === 'string') date = new Date(date);
    if (date instanceof Date) date = moment(date);
    return date.format('YYYY-MM-DD');
}

export function formatTime(date: Date | string | Moment): string {
    if (typeof date === 'string') date = new Date(date);
    if (date instanceof Date) date = moment(date);
    return date.format('HH:mm:ss');
}

export function formatDateToHuman(
    date: Date | string | Moment,
    withTime: boolean = true
): string {
    if (!date) date = newNaiveDateTime();
    if (typeof date === 'string') date = new Date(date);
    if (date instanceof Date) date = moment(date);
    if (withTime) return date.format('DD/MM/YYYY HH:mm:ss');
    return date.format('DD/MM/YYYY');
}

export function formatTimeToHuman(date: Date | string | Moment): string {
    if (typeof date === 'string') date = new Date(date);
    if (date instanceof Date) date = moment(date);
    return date.format('HH:mm:ss');
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
    if (typeof startDate === 'string') startDate = newNaiveDateTime(startDate);
    if (typeof endDate === 'string') endDate = newNaiveDateTime(endDate);

    const diff = endDate.getTime() - startDate.getTime();
    return diff / (1000 * 60 * 60);
}

export function prevMonth(startDate: Date | string) {
    if (typeof startDate === 'string') startDate = newNaiveDateTime(startDate);
    const year = startDate.getFullYear();
    const month = startDate.getMonth();
    return new Date(year, month - 1, 1);
}

export function nextMonth(startDate: Date | string) {
    if (typeof startDate === 'string') startDate = newNaiveDateTime(startDate);
    const year = startDate.getFullYear();
    const month = startDate.getMonth();
    return new Date(year, month + 1, 1);
}

export function getLastDayOfMonth(date: Date) {
    const year = date.getFullYear();
    const month = date.getMonth();
    return new Date(year, month + 1, 0, 23, 59, 59, 999);
}
