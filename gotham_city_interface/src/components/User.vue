<template>
    <form @submit.prevent="emits('fetch:user', {username, email})" class="flex gap-2 items-end">
        <InputText v-model="username" label="Username" />
        <InputText v-model="email" label="Email" />
        <Button type="submit" class="h-8" variant="secondary">Search</Button>
    </form>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import InputText from '@/components/ui/input/Text.vue';
import Button from '@/components/ui/input/Button.vue';

const username = ref('');
const email = ref('');

const emits = defineEmits<{
    (e: 'fetch:user', user: {username: string, email: string}): void
}>()

</script>

<style lang="scss" scoped>
</style>