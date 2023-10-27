<script lang="ts">
    import axios from "axios";
    import { API_USERS_ROUTE } from "@/router/";

    // const route: string = API_USERS_ROUTE;

    interface User {
        id: number,
        username: string,
        email: string
    }

    function createUser(): boolean {
        axios.post(API_USERS_ROUTE).then(function (response) {
            console.log(response);
        });
        return false;
    }

    function updateUser(): boolean {
        const _id: number = -1; //REMOVE
        axios.put(API_USERS_ROUTE + "/" + _id).then(function (response) {
            console.log(response);
        });
        return false;
    }

    function getUserById(id: number): User | null {
        let user: User | null = null;
        axios.get(API_USERS_ROUTE + `/${id}`).then(function (response) {
            console.log(response);
        })
        return user;
    }

    function getUser(username: string, email: string) {
        let user: User | null = null;
        axios.get(API_USERS_ROUTE + `?username=${username}&email=${email}`).then(function (response) {
            user = response.data.data;
            return user;
        }).catch(function (error) {
            if (error.response.status == 404) {
                console.log("No user found");
                return null;
            }
            throw new Error(error);
        }).finally(() => {
            return user;
        });
    }

    function deleteUser(): boolean {
        axios.delete(API_USERS_ROUTE).then(function (response) {
            console.log(response);
        });
        return false;
    }

    function getAllUsers(): User[] {
        const list_users: User[] = [];
        axios.get(API_USERS_ROUTE).then(function (response) {
            const data: any[] = response.data.data;
            console.log(data);
            for (let i: number = 0; i < data.length; i += 1) {
                console.log(data[i]);
                list_users.push(data[i]);
            }
            console.log(list_users);
        });
        return list_users;
    }

    export { createUser, updateUser, getUser, deleteUser, getAllUsers };
    export type { User };
</script>