<template>
    <div class="w-full h-full text-center flex flex-col justify-center items-center gap-6">
        <div>
            <h3>Username:</h3>
            <p>{{ user.username }}</p>
        </div>
        <div>
            <h3>Email:</h3>
            <p>{{ user.email }}</p>
        </div>
    </div>
</template>

<script lang="ts" setup>
import type { User } from '@/types';
import type { PropType } from 'vue';

const props = defineProps({
    user: {
        type: Object as PropType<User>,
        required: true
    }
});
</script>

<style lang="scss" scoped>
h3 {
    @apply font-bold text-lg;
}
</style>
