<template>
    <form
        @submit.prevent="emits('fetch:user', { username, email })"
        class="flex gap-4 items-end w-full justify-center"
    >
        <InputText
            v-model="username"
            label="Username"
            labelColor="var(--secondary)"
            class="w-[16rem]"
            max-width="16rem"
        />
        <InputText
            v-model="email"
            label="Email"
            labelColor="var(--secondary)"
            class="w-[16rem]"
            max-width="16rem"
        />
        <Button type="submit" class="h-8">Search</Button>
    </form>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import InputText from '@/components/ui/input/Text.vue';
import Button from '@/components/ui/input/Button.vue';

const username = ref('');
const email = ref('');

const emits = defineEmits<{
    (e: 'fetch:user', user: { username: string; email: string }): void;
}>();

setTimeout(() => {
    username.value = 'hollitizz';
    email.value = 'valentin.caure@epitech.eu';
    emits('fetch:user', { username: username.value, email: email.value });
}, 500);
</script>

<style lang="scss" scoped></style>
