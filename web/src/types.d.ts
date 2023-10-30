export interface WorkingTime {
    id: number;
    user: number;
    start: string;
    end: string;
}

export interface Clock {
    id: number;
    user: number;
    time: string;
    status: boolean;
}

export interface User {
    id: number;
    username: string;
    email: string;
}
