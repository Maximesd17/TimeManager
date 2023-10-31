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
import { ref, watch, type PropType } from 'vue';

import InputText from '@/components/ui/input/Text.vue';
import Button from '@/components/ui/input/Button.vue';
import type { User } from '@/types';

const props = defineProps({
    user: {
        type: Object as PropType<User | null>,
        required: true
    }
});

const username = ref(props.user?.username ?? '');
const email = ref(props.user?.email ?? '');

const emits = defineEmits<{
    (e: 'fetch:user', user: { username: string; email: string }): void;
}>();

watch(
    () => props.user,
    user => {
        if (!user) return;
        username.value = user.username;
        email.value = user.email;
    },
    { deep: true }
);

setTimeout(() => {
    username.value = 'hollitizz';
    email.value = 'valentin.caure@epitech.eu';
    emits('fetch:user', { username: username.value, email: email.value });
}, 500);
</script>

<style lang="scss" scoped></style>
