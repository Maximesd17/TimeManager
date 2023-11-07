<template>
    <label
        class="font-h4 flex items-center justify-between gap-x-2 rounded-3xl min-w-min"
        :class="`${isDisabled ? '' : 'bg-white'} ${
            isFocus ? 'focus' : ''
        }`"
        @keydown.down.prevent="decrement"
        @keydown.up.prevent="increment"
        for="input"
    >

        <input
            type="number"
            class="flex-grow rounded-3xl py-1.5 w-[inherit] text-center"
            :class="`${isDisabled ? '' : 'bg-white'}`"
            v-model="inputNumber"
            :min="min"
            :max="max"
            :step="step"
            @change="onChange"
            @focus="isFocus = true"
            @blur="isFocus = false"
            :disabled="isDisabled || !canEdit"
        />
    </label>
</template>

<script lang="ts" setup>
import { padStartZero } from '@/utils/dates';
import { ref, watch } from 'vue';

const props = defineProps({
    modelValue: {
        type: Number,
        required: true
    },

    min: {
        type: Number,
        default: 0
    },
    max: {
        type: Number,
        default: 100
    },
    step: {
        type: Number,
        default: 1
    },
    minLength: {
        type: Number,
        default: 1
    },

    canEdit: {
        type: Boolean,
        default: true
    },
    isDisabled: {
        type: Boolean,
        default: false
    }
});

const emits = defineEmits<{
    (e: 'update:modelValue', value: number): void;
}>();

const inputNumber = ref(padStartZero(props.modelValue, props.minLength));
const isFocus = ref(false);

watch(
    () => props.modelValue,
    () => {
        inputNumber.value = padStartZero(props.modelValue, props.minLength);
    }
);

function onChange() {
    if (parseInt(inputNumber.value) > props.max) {
        inputNumber.value = padStartZero(props.max);
    }
    if (parseInt(inputNumber.value) < props.min) {
        inputNumber.value = padStartZero(props.min);
    }
    emits('update:modelValue', parseInt(inputNumber.value));
}

function increment() {
    inputNumber.value = padStartZero(parseInt(inputNumber.value) + props.step);
    if (parseInt(inputNumber.value) > props.max) {
        inputNumber.value = padStartZero(props.max);
    }
    onChange();
}

function decrement() {
    inputNumber.value = padStartZero(parseInt(inputNumber.value) - props.step);
    if (parseInt(inputNumber.value) < props.min) {
        inputNumber.value = padStartZero(props.min);
    }
    onChange();
}
</script>

<style lang="scss" scoped>
label {
    outline: solid 2px var(--primary);

    &.focus {
        outline: solid 2px var(--button);
    }

    input {
        @apply rounded-full;

        -webkit-appearance: none !important;
        -moz-appearance: textfield !important;
        appearance: textfield !important;

        outline: none;
        background-color: white;
        padding: 0 0.5rem;

        &.focus {
            outline: solid 2px var(--button);
        }
        &::-webkit-outer-spin-button,
        &::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
    }
}
</style>
