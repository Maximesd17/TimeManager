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
        <div
            class="flex w-full input"
            :class="{ [variant]: true }"
            :style="{ maxWidth }"
        >
            <input
                class="w-full flex-1 bg-transparent text-xl border-none outline-none"
                :class="{ [textAlign]: true }"
                :type="isVisible ? 'text' : 'password'"
                :value="modelValue"
                :style="{ maxWidth }"
                @focus="isFocus = true"
                @blur="isFocus = false"
                @input="handleInput"
                @keydown.enter.prevent="emits('enter')"
            />
            <div
                class="flex items-center justify-center w-7 h-7 mr-1"
                @click="isVisible = !isVisible"
            >
                <SvgEye
                    v-if="isVisible"
                    class="h-full"
                    src="@/assets/svg/eye.svg"
                    :color="isFocus ? 'var(--accent)' : 'var(--primary)'"
                />
                <SvgEyeSlash
                    v-else
                    class="h-full"
                    src="@/assets/svg/eye-slash.svg"
                    :color="isFocus ? 'var(--accent)' : 'var(--primary)'"
                />
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, type PropType } from 'vue';

import SvgEye from '@/components/svg/Eye.vue';
import SvgEyeSlash from '@/components/svg/EyeSlash.vue';

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
        default: '224px'
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
        text-align: left;
        margin: 0;
        color: var(--label-color) !important;
        margin-left: 0.125rem;
    }
    &.focus {
        .input {
            outline: 0.125rem solid var(--focus-color) !important;
        }
    }
    .input {
        width: 100%;
        border: none;

        &.default {
            outline: 0.125rem solid var(--border-color);
            padding-left: 4px;
            border-radius: 8px;

            &:focus {
                outline: 0.125rem solid var(--focus-color) !important;
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
}
</style>
