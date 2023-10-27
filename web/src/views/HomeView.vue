<template>
    <main>
        <h2>Search user by its username or email:</h2>
        <form id="form" onsubmit="">
            <div>
                <label for="inp_username">Username: </label>
                <input type="text" id="inp_username" name="username" v-model="inp_username" list="usernames_list">
            </div>
            <div>
                <label for="inp_email">Email: </label>
                <input type="text" id="inp_email" name="email" v-model="inp_email" list="emails_list">
            </div>
            <div>
                <input type="submit" value="Search" @click="searchUser()">
            </div>
            <div>
                <input type="button" value="Refresh Users" @click="getAllUsers()">
            </div>
        </form>
    </main>
</template>

<script lang="ts" setup>
    import type { User } from "@/components/UserManager.vue"
    import { getUser, getAllUsers } from "@/components/UserManager.vue";
    import { onMounted } from "vue";
    
    let inp_username: string = "";
    let inp_email: string = "";
    
    function searchUser(){
        const form = document.getElementById("form");
        
        if (form == null) {
            return null
        }
        form.onsubmit = function (event) {
            event.preventDefault();
        };
        const found_user: User | null = getUser(inp_username, inp_email);
        console.log(`found user: ${found_user}`);
    }

    // function getUsers() {
    //     users_list = getAllUsers();
    // }

    // onMounted(() => {
    //     getUsers();
    // })
</script>

<style lang="scss" scoped>
</style>