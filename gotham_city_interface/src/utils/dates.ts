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