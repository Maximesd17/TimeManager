<template>
    <div class="h-fit sm:h-full relative">
        <Confirm
            v-if="isDeletingUser"
            width="40vw"
            height="30vh"
            @yes="handleDelete"
            @no="isDeletingUser = false"
            variant="danger"
        >
            Are you sure you want to delete this user ?
        </Confirm>
        <ClockComponent v-if="clock" @click="postClock" :clock="clock" />
        <Card
            class="w-full text-center flex flex-col justify-center items-center gap-6 collapse-open min-h-[13rem]"
            :class="
                (isPieOpen || isPieOpening) && !isPieClosing
                    ? 'h-auto sm:h-2/5'
                    : 'h-full'
            "
        >
            <form @submit.prevent="emits('update:user', { username, email })">
                <div>
                    <h3>Username:</h3>
                    <InputText
                        v-if="isEditMode"
                        v-model="username"
                        class="w-[16rem] !h-6"
                        text-align="center"
                        variant="userEdit"
                        max-width="16rem"
                    />
                    <p v-else>{{ username }}</p>
                </div>
                <div>
                    <h3>Email:</h3>
                    <InputText
                        v-if="isEditMode"
                        v-model="email"
                        class="w-[16rem] !h-6"
                        text-align="center"
                        variant="userEdit"
                        max-width="16rem"
                    />
                    <p v-else>{{ email }}</p>
                </div>
                <UiButton
                    v-show="isEditMode"
                    type="submit"
                    class="absolute translate-y-2 -translate-x-1/2"
                    :style="{
                        '--translateY': '0.5rem',
                        '--translateX': '-50%'
                    }"
                    :class="{
                        appear: isEditMode,
                        disappear: isEditModeClosing
                    }"
                >
                    Update
                </UiButton>
            </form>
            <UiButton
                v-if="
                    isEditMode &&
                    !isMe &&
                    (roles.includes('manager') ||
                        roles.includes('general_manager') ||
                        roles.includes('administrator'))
                "
                class="absolute right-2 top-2 h-8 w-8 !p-1"
                :class="{
                    'slide-in': isEditMode,
                    'slide-out': isEditModeClosing
                }"
                :style="{
                    '--translateX': `${isEditMode ? '-2.5rem' : '0'}`
                }"
                variant="danger"
                @click="isDeletingUser = true"
            >
                <SvgDelete class="w-full h-full" color="white" />
            </UiButton>
            <UiButton
                class="absolute right-2 top-2 h-8 w-8 !p-1.5"
                @click="toggleEditMode"
            >
                <SvgEdit class="w-full h-full" />
            </UiButton>
        </Card>
        <Card
            v-if="isPieOpen || isPieOpening || isPieClosing"
            class="w-full text-center flex flex-col justify-end items-center gap-6 collapse-open mt-4 relative"
            :class="`${
                (isPieOpen || isPieOpening) && !isPieClosing
                    ? 'h-[20rem] sm:h-[calc(60%-1rem)]'
                    : 'h-0'
            }`"
        >
            <h2 class="absolute top-2">Current Day Data</h2>
            <CurrentDayData
                v-if="isPieOpen || !(isPieClosing && layout === 'mobile')"
                :key="clock.status.toString() + chartReload.toString()"
                class="h-full pt-[2.5rem] mt-auto"
                :clock="clock"
            />
        </Card>
    </div>
</template>

<script lang="ts" setup>
import type { Clock, User } from '@/types';
import { ref, type PropType, watch, onMounted } from 'vue';
import { useApiFetch } from '@/composables/useApiFetch';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import InputText from '@/components/ui/input/Text.vue';
import ClockComponent from '@/components/Clock.vue';
import Card from '@/components/ui/cards/Rectangle.vue';
import CurrentDayData from './CurrentDayData.vue';
import UiButton from '@/components/ui/input/Button.vue';
import Confirm from './ui/input/Confirm.vue';
import SvgEdit from '@/components/svg/Edit.vue';
import SvgDelete from '@/components/svg/Delete.vue';
import { useEventBus } from '@/composables/useEventBus';
import useCookies from '@/composables/useCookies';
import { jwtDecode } from 'jwt-decode';

const props = defineProps({
    user: {
        type: Object as PropType<User>,
        required: true
    },
    isMe: {
        type: Boolean,
        default: false
    },
    clock: {
        type: Object as PropType<Clock>,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'delete:user'): void;
    (e: 'update:user', user: { username: string; email: string }): void;
    (e: 'update:clock', clock: Clock): void;
}>();

const screenStore = useScreenStore();
const { layout } = storeToRefs(screenStore);

// @ts-ignore
const roles = jwtDecode(useCookies().get('token')!).roles || [];

const isPieOpen = ref(props.clock?.status ?? false);
const isPieOpening = ref(false);
const isPieClosing = ref(false);

const isEditMode = ref(false);
const isEditModeClosing = ref(false);

const email = ref(props.user.email);
const username = ref(props.user.username);

const isDeletingUser = ref(false);

const chartReload = ref(false);

function toggleEditMode() {
    isEditModeClosing.value = true;
    setTimeout(
        () => {
            isEditModeClosing.value = false;
            isEditMode.value = !isEditMode.value;
        },
        isEditMode.value ? 200 : 0
    );
}

async function postClock() {
    const { data } = await useApiFetch<Clock>(
        `/clocks/${props.isMe ? 'me' : props.user.id}`,
        {
            method: 'POST'
        }
    );

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

watch(
    () => props.user,
    () => {
        email.value = props.user.email;
        username.value = props.user.username;
    },
    {
        deep: true
    }
);

function handleDelete() {
    emits('delete:user');
    isDeletingUser.value = false;
}

function togglePie() {
    if (!props.clock?.status) {
        isPieClosing.value = true;
        isPieOpen.value = false;
        setTimeout(() => {
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

onMounted(() => {
    useEventBus.on('refresh_charts', () => {
        chartReload.value = !chartReload.value;
    });
});
</script>

<style lang="scss" scoped>
h3 {
    @apply font-bold text-lg;
}

h2 {
    @apply font-bold text-xl;
}

img {
    margin: auto;
    display: block;
}

.margin {
    margin-left: 10px;
}

.slide-in {
    animation: slide-open 0.2s ease-in-out;
    transform: translateX(-2.5rem);
}

.slide-out {
    animation: slide-close 0.2s;
    transform: translateX(0);
}

.collapse-open {
    transition: height 400ms ease-in-out;
}

@keyframes slide-open {
    0% {
        transform: translateX(0);
    }
    100% {
        transform: translateX(-2.5rem);
    }
}

@keyframes slide-close {
    0% {
        transform: translateX(-2.5rem);
    }
    100% {
        transform: translateX(0);
    }
}

.appear {
    animation: appear 0.2s;
}

.disappear {
    animation: disappear 0.2s;
}

@keyframes appear {
    0% {
        opacity: 0;
    }
    100% {
        opacity: 1;
    }
}

@keyframes disappear {
    0% {
        opacity: 1;
    }
    100% {
        opacity: 0;
    }
}
</style>
