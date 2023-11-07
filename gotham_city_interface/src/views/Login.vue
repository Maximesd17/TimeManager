<template>
    <div
        class="flex flex-col items-center gap-4 h-full"
    >
        <div class="mt-auto justify-end flex items-end flex-1">
            <img
                src="@/assets/img/gotham_city.png"
                alt="gotham_city_icon"
                class="w-[60vw] min-w-[25rem]"
            />
        </div>
        <form
            @submit.prevent="login"
            class="flex flex-col gap-2 items-center"
        >
            <h1 class="text-4xl font-bold text-center">
                Gotham City Time Manager
            </h1>
            <InputText v-model="username" label="Username" maxWidth="20rem" class="w-[20rem]" />
            <InputText v-model="password" label="Password" maxWidth="20rem" class="w-[20rem]" />
            <Button type="submit" class="h-8 w-[15rem]">login</Button>
        </form>
        <div class="flex-1"></div>
    </div>
</template>

<script lang="ts" setup>
import Button from '@/components/ui/input/Button.vue';
import InputText from '@/components/ui/input/Text.vue';
import useCookies from '@/composables/useCookies';
import { ref } from 'vue';

const username = ref('');
const password = ref('');

function login() {
    useCookies().setCookie('token', 'token', 1);
    document.location.reload();
}
</script>

<style lang="scss" scoped></style>
