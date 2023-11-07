export interface APIWorkingTime {
    id: number;
    user: number;
    start: string;
    end: string;
}

export interface APIClock {
    id: number;
    user: number;
    time: string;
    status: boolean;
}

export interface APIUser {
    id: number;
    username: string;
    email: string;
}

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

