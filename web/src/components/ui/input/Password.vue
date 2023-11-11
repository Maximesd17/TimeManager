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
        <div class="flex w-full input" :class="{[variant]: true}">
            <input
                class="bg-white w-full"
                :class="{ [textAlign]: true,  }"
                :type="isVisible ? 'text' : 'password'"
                :value="modelValue"
                :style="{ maxWidth }"
                @focus="isFocus = true"
                @blur="isFocus = false"
                @input="handleInput"
                @keydown.enter.prevent="emits('enter')"
            />
            <div
                class="flex items-center justify-center h-8 mr-1"
                @click="isVisible = !isVisible"
            >
                <img v-if="isVisible" class="h-full" src="@/assets/svg/eye.svg" />
                <img v-else class="h-full" src="@/assets/svg/eye-slash.svg" />
            </div>
        </div>
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
        default: 'var(--primary)'
    },
    borderColor: {
        type: String,
        default: 'var(--primary)'
    },
    focusColor: {
        type: String,
        default: 'var(--button)'
    },

    variant: {
        type: String as PropType<'default' | 'userEdit'>,
        default: 'default'
    }
});

const isFocus = ref(false);
const isVisible = ref(false);

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
        font-size: small;
        font-weight: 500;
        text-align: left;
        margin: 0;
        color: var(--label-color) !important;
        margin-left: 2px;
    }

    .input {
        width: 100%;
        border: none;
        font-size: large;
        font-weight: 600;
        background-color: white;

        &.default {
            outline: 2px solid var(--border-color);
            padding-left: 0.25rem;
            border-radius: 0.5rem;
            font-size: large;
            font-weight: 600;
            color: var(--primary);

            &:focus {
                outline: 2px solid var(--focus-color) !important;
            }
        }

        &.userEdit {
            font-size: large;
            font-weight: 500;
            color: var(--primary);
            background-color: var(--secondary);

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
