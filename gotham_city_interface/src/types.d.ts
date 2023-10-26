export interface WorkingTime {
    id: number;
    user: number;
    start: Date;
    end: Date;
}

export interface Clock {
    id: number;
    user: number;
    time: Date;
    status: boolean;
}

export interface User {
    id: number;
    username: string;
    email: string;
}
