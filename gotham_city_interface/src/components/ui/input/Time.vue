<template>
    <VDropdown :shown="isOpen">
        <div class="main" @click="openModal">
            <span @click="clickedIndex = 0">{{ displayHours }}</span>
            <span @click="clickedIndex = 1">{{ displayMinutes }}</span>
            <span @click="clickedIndex = 2">{{ displaySeconds }}</span>
        </div>
        <template #popper>
            <div class="border-2 border-primary rounded-md bg-secondary p-3">
                <div class="flex gap-2 font-bold flex-wrap min-w-[10rem]">
                    <Number
                        :modelValue="hours"
                        @update:modelValue="updateHours($event)"
                        :max="23"
                        :min-length="2"
                        ref="hoursInput"
                    />:
                    <Number
                        :modelValue="minutes"
                        @update:modelValue="updateMinutes($event)"
                        :max="59"
                        :min-length="2"
                        ref="minutesInput"
                    />:
                    <Number
                        :modelValue="seconds"
                        @update:modelValue="updateSeconds($event)"
                        :max="59"
                        :min-length="2"
                        ref="secondsInput"
                    />
                </div>
            </div>
        </template>
    </VDropdown>
</template>

<script lang="ts" setup>
import { computed, ref, watch } from 'vue';

import { newNaiveDateTime, padStartZero } from '@/utils/dates';
import Number from '@/components/ui/input/Number.vue';

const props = defineProps({
    time: {
        type: Date,
        required: true
    }
});

const clickedIndex = ref(0);

const isOpen = ref(false);
const hours = ref(props.time.getHours());
const minutes = ref(props.time.getMinutes());
const seconds = ref(props.time.getSeconds());

const displayHours = computed(() => {
    return `${padStartZero(hours.value)}:`;
});
const displayMinutes = computed(() => {
    return `${padStartZero(minutes.value)}:`;
});
const displaySeconds = computed(() => {
    return `${padStartZero(seconds.value)}`
})

const hoursInput = ref();
const minutesInput = ref();
const secondsInput = ref();

watch(
    () => props.time,
    () => {
        hours.value = props.time.getHours();
        minutes.value = props.time.getMinutes();
        seconds.value = props.time.getSeconds();
    }
);

function openModal() {
    isOpen.value = true;
    setTimeout(() => {
        [hoursInput, minutesInput, secondsInput][clickedIndex.value].value?.$el
            .querySelector('input')
            .focus();
    }, 100);
}

function updateHours(nHours: number) {
    const time = newNaiveDateTime(props.time);

    time.setHours(nHours);
    hours.value = time.getHours();
    emits('update:time', time);
}

function updateMinutes(nMinutes: number) {
    const time = newNaiveDateTime(props.time);

    time.setMinutes(nMinutes);
    minutes.value = time.getMinutes();
    emits('update:time', time);
}

function updateSeconds(nSeconds: number) {
    const time = newNaiveDateTime(props.time);

    time.setSeconds(nSeconds);
    seconds.value = time.getSeconds();
    emits('update:time', time);
}

const emits = defineEmits<{
    (e: 'update:time', date: Date): void;
    (e: 'cancel'): void;
}>();
</script>

<style lang="scss" scoped>
.main {
    @apply rounded-full;
    outline: solid 2px var(--primary);
    background-color: white;
    padding: 0 0.5rem;

    &.focus {
        outline: solid 2px var(--button);
    }
}

.time-input {
    @apply gap-2 w-full h-full;
    outline: solid 2px var(--primary);
}
</style>

<style lang="scss">
.v-popper--theme-dropdown {
    .v-popper__inner {
        border: none !important;
    }
    .v-popper__arrow-container {
        display: none !important;
    }
}
</style>
