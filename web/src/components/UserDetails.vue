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
            <div v-if='!isEditMode'>
                <div>
                    <h3>Username:</h3>
                    <p>{{ user.username }}</p>
                </div>
                <div>
                    <h3>Email:</h3>
                    <p>{{ user.email }}</p>
                </div>
                <UiButton @click="switchEditMode">Edit</UiButton>
            </div>
            <form v-else @submit.prevent="emits('update:user', {id: user.id, username: user.username, email: user.email })">
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
                <UiButton type='submit' @click='switchEditMode' variant="default" class="h-12 w-20 margin">
                    <img src='../assets/svg/edit.svg' />
                </UiButton>
            </form>
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
            <CurrentDayData
                v-if="isPieOpen"
                :key="clock.status.toString()"
                class="h-full pt-[10%]"
                :clock="clock"
            />
        </Card>
    </div>
</template>

<script lang="ts" setup>
import type { Clock, User } from '@/types';
import { ref, type PropType, watch } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import InputText from '@/components/ui/input/Text.vue';
import ClockComponent from '@/components/Clock.vue';
import Card from '@/components/ui/cards/Rectangle.vue';
import CurrentDayData from './CurrentDayData.vue';
import UiButton from '@/components/ui/input/Button.vue';
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
    (e: 'delete:user', user: { id: number;}): void;
    (e: 'update:user', user: { id: number; username: string; email: string }): void;
    (e: 'update:clock', clock: Clock): void;
}>();

const isPieOpen = ref(props.clock?.status ?? false);
const isPieOpening = ref(false);
const isPieClosing = ref(false);
const isEditMode = ref(false);

function switchEditMode() {
    isEditMode.value = !isEditMode.value;
}

async function postClock() {
    const { data } = await useApiFetch<Clock>(`/clocks/${props.user.id}`, {
        method: 'POST'
    });

    emits('update:clock', data.value);
}

watch(
    () => props.clock,
    () => {
        setTimeout(() => togglePie(), 50);
    },
    {
        deep: true
    }
);

function togglePie() {
    if (!props.clock.status) {
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

img{
    margin: auto;
    display: block;
}

.margin{
    margin-left: 10px;
}


.transition {
    transition: height 400ms ease-in-out;
}
</style>
