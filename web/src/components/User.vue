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
        <Button @click="disconnect" class="h-8">disconnect</Button>
    </form>
</template>

<script lang="ts" setup>
import { ref, watch, type PropType } from 'vue';

import InputText from '@/components/ui/input/Text.vue';
import Button from '@/components/ui/input/Button.vue';
import type { User } from '@/types';
import useCookies from '@/composables/useCookies';

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

function disconnect() {
    useCookies().revoke('token');
    document.location.reload();
}

watch(
    () => props.user,
    user => {
        if (!user) return;
        username.value = user.username;
        email.value = user.email;
    },
    { deep: true }
);

</script>

<style lang="scss" scoped></style>
