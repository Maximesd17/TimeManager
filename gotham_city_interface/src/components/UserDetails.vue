<template>
    <div class="w-full h-full text-center flex flex-col justify-center items-center gap-6">
        <form @submit.prevent="emits('update:user', {id: user.id, username: user.username, email: user.email })">
            <InputText
                v-model="user.username"
                label="Username"
                class="w-[16rem]"
                max-width="16rem"
            />
            <InputText
                v-model="user.email"
                label="Email"
                class="w-[16rem]"
                max-width="16rem"
            />
            <br>
            <UiButton @click="emits('delete:user',{id:user.id})" variant="red" class="h-12 w-20">
                    <img src='../assets/svg/delete.svg'/>
            </UiButton>
            <UiButton type='submit' variant="primary" class="h-12 w-20 margin">
                <img src='../assets/svg/edit.svg' />
            </UiButton>
        </form>
    </div>
</template>

<script lang="ts" setup>
import type { User } from '@/types';
import type { PropType } from 'vue';
import UiButton from './ui/input/Button.vue';
import InputText from './ui/input/Text.vue';

const props = defineProps({
    user: {
        type: Object as PropType<User>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'delete:user', user: { id: number;}): void;
    (e: 'update:user', user: { id: number; username: string; email: string }): void;
}>();
</script>

<style lang="scss" scoped>
h3 {
    @apply font-bold text-lg;
}

img{
    margin: auto;
    display: block;
}

.margin{
    margin-left: 10px;
}
</style>
