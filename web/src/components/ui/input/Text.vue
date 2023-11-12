<template>
    <div
        class="text"
        :style="{
            '--border-color': borderColor,
            '--label-color': labelColor,
            '--focus-color': focusColor
        }"
        :class="{
            [`${variant}-text`]: true,
            focus: isFocus
        }"
    >
        <label v-if="label.length" style="{ maxWidth }" class="label">
            {{ label }}
        </label>
        <input
            class="input text-xl h-[28px] py-auto"
            :class="{ [textAlign]: true, [variant]: true }"
            type="text"
            :value="modelValue"
            :style="{ maxWidth }"
            :placeholder="placeholder"
            @focus="isFocus = true"
            @blur="isFocus = false"
            @input="handleInput"
            @keydown.enter.prevent="emits('enter')"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, type PropType } from 'vue';

const emits = defineEmits(['update:modelValue', 'enter']);

defineProps({
    modelValue: {
        type: String,
        required: true
    },
    label: {
        type: String,
        default: ''
    },
    placeholder: {
        type: String,
        default: ''
    },

    maxWidth: {
        type: String,
        default: '14rem'
    },
    textAlign: {
        type: String as PropType<'left' | 'center' | 'right'>,
        default: 'left'
    },
    labelColor: {
        type: String,
        default: 'var(--text)'
    },
    borderColor: {
        type: String,
        default: 'var(--primary)'
    },
    focusColor: {
        type: String,
        default: 'var(--accent)'
    },

    variant: {
        type: String as PropType<'default' | 'userEdit'>,
        default: 'default'
    }
});

const isFocus = ref(false);

function handleInput(event: Event) {
    const target = event?.target as HTMLInputElement;
    emits('update:modelValue', target?.value);
}
</script>

<style lang="scss" scoped>
.text {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    justify-content: center;

    .label {
        width: 100%;
        text-align: left;
        margin: 0;
        color: var(--label-color) !important;
        margin-left: 2px;
    }

    .input {
        width: 100%;
        border: none;
        background-color: transparent;

        &.default {
            outline: 2px solid var(--border-color);
            padding-left: 0.25rem;
            border-radius: 0.5rem;

            &:focus {
                outline: 2px solid var(--focus-color) !important;
            }
        }

        &.userEdit {
            background-color: transparent;

            &:focus {
                outline: none;
            }
        }

        &.left {
            text-align: left;
        }

        &.center {
            text-align: center;
        }

        &.right {
            text-align: right;
        }
    }
    &.userEdit-text {
        position: relative;

        &::after {
            content: '';
            position: absolute;
            top: 60%;
            left: 50%;
            transform: translateX(-50%);
            width: 3rem;
            height: 2px;
            background-color: var(--primary);
            margin-top: 0.5rem;
            transition: width 0.2s ease-in-out;
        }

        &.focus {
            &::after {
                content: '';
                position: absolute;
                top: 60%;
                left: 50%;
                transform: translateX(-50%);
                width: 6rem;
                height: 2px;
                background-color: var(--primary);
                margin-top: 0.5rem;
            }
        }
    }
}
</style>
