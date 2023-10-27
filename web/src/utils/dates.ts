export function padStartZero(number: number | string, length: number = 2) {
    if (typeof number === 'string') return number.padStart(length, '0');
    return number.toString().padStart(length, '0');
}

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
    withTime: boolean = true
): string {
    if (typeof date === 'string') date = new Date(date);
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
