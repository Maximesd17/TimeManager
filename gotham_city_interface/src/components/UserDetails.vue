<template>
    <div class="w-1/3 h-full relative gap-4">
        <ClockComponent v-if="clock" @click="postClock" :clock="clock" />
        <Card
            class="w-full text-center flex flex-col justify-center items-center gap-6 transition"
            :class="
                (isPieOpen || isPieOpening) && !isPieClosing
                    ? 'h-2/5'
                    : 'h-full'
            "
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
            v-show="isPieOpen || isPieOpening || isPieClosing"
            class="w-full text-center flex flex-col justify-end items-center gap-6 transition mt-4 relative"
            :class="`${
                (isPieOpen || isPieOpening) && !isPieClosing
                    ? 'h-[calc(60%-1rem)]'
                    : 'h-0'
            }`"
        >
            <h2 class="absolute top-2">Current Day Data</h2>
            <CurrentDayData class="h-full pt-[10%]" :clock="clock" />
        </Card>
    </div>
</template>

<script lang="ts" setup>
import type { Clock, User } from '@/types';
import { ref, type PropType } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';

import ClockComponent from '@/components/Clock.vue';
import Card from '@/components/ui/cards/Rectangle.vue';
import CurrentDayData from './CurrentDayData.vue';

const props = defineProps({
    user: {
        type: Object as PropType<User>,
        required: true
    },
    clock: {
        type: Object as PropType<Clock>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'update:clock', clock: Clock): void;
}>();

const isPieOpen = ref(props.clock?.status ?? false);
const isPieOpening = ref(false);
const isPieClosing = ref(false);

async function postClock() {
    const { data } = await useApiFetch<Clock>(`/clocks/${props.user.id}`, {
        method: 'POST'
    });
    togglePie();
    emits('update:clock', data.value);
}


function togglePie() {
    if (isPieOpen.value) {
        isPieClosing.value = true;
        setTimeout(() => {
            isPieOpen.value = false;
            isPieClosing.value = false;
        }, 400);
    } else {
        isPieOpening.value = true;
        setTimeout(() => {
            isPieOpen.value = true;
            isPieOpening.value = false;
        }, 400);
    }
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
    transition: height 400ms ease-in-out;
}
</style>
