<template>
    <div class="w-1/3 h-full relative flex flex-col gap-4">
        <ClockComponent v-if="clock" @click="postClock" :clock="clock" />
        <Card
            class="w-full h-2/5 text-center flex flex-col justify-center items-center gap-6 transition"
            :class="clock && clock.status ? 'h-2/5' : 'h-full'"
        >
            <div>
                <h3>Username:</h3>
                <p>{{ user.username }}</p>
            </div>
            <div>
                <h3>Email:</h3>
                <p>{{ user.email }}</p>
            </div>
        </Card>
        <Card
            v-if="clock && clock.status"
            class="w-full h-3/5 text-center flex flex-col justify-center items-center gap-6"
        >
            <h2 class="h-4">Current Day Data</h2>
            <CurrentDayData class="h-[90%]" :clock="clock" />
        </Card>
    </div>
</template>

<script lang="ts" setup>
import type { Clock, User } from '@/types';
import type { PropType } from 'vue';
import ClockComponent from '@/components/Clock.vue';
import Card from '@/components/ui/cards/Rectangle.vue';
import CurrentDayData from './CurrentDayData.vue';
import { useApiFetch } from '@/composables/useApiFetch';

const props = defineProps({
    user: {
        type: Object as PropType<User>,
        required: true
    },
    clock: {
        type: Object as PropType<Clock | null>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'update:clock', clock: Clock): void;
}>();

async function postClock() {
    const { data } = await useApiFetch<Clock>(`/clocks/${props.user.id}`, {
        method: 'POST',
    });

    console.log(data.value);
    emits('update:clock', data.value);
}
</script>

<style lang="scss" scoped>
h3 {
    @apply font-bold text-lg;
}

h2 {
    @apply font-bold text-xl;
}
.transition {
    transition: height 0.2s ease-in-out;
}
</style>
