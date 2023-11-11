<template>
    <button
        class="button select-none font-bold"
        @click="click"
        :type="type"
        :class="{ [variant]: Boolean(variant), disabled }"
    >
        <slot />
    </button>
</template>
<script setup lang="ts">
import type { PropType } from 'vue';

const emits = defineEmits(['click']);

defineProps({
    variant: {
        type: String,
        default: 'default'
    },
    type: {
        type: String as PropType<'button' | 'submit'>,
        default: 'button'
    },
    disabled: {
        type: Boolean,
        default: false
    }
});

function click() {
    emits('click');
}
</script>
<style lang="scss" scoped>
.button {
    border: none;
    outline: none;

    padding: 0.5rem 1rem;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    border-radius: 1rem;
    cursor: pointer;
    transition: all 0.1s ease-in-out;

    &:not(.disabled) {
        &:hover {
            transform: translateX(var(--translateX, 0))
                translateY(var(--translateY, 0)) scale(1.05, 1.05);
        }
        &:active {
            box-shadow: inset -1px 2px 5px #000;
        }
    }

    &.disabled {
        cursor: not-allowed;
        position: relative;
        &::after {
            @apply absolute inset-0 h-full w-full rounded-full;
            content: '';

            background: rgba(0 0 0 / 0.5);
        }
    }
}

.default {
    background-color: var(--secondary);
    color: var(--text);
}

.defaultBorder {
    background-color: transparent;
    border: 2px solid var(--secondary);
    color: var(--text);
}

.danger {
    background-color: var(--danger);
    color: var(--text);
}

.dangerBorder {
    background-color: transparent;
    border: 2px solid var(--danger);
    color: var(--text);
}

.transparent {
    background-color: transparent;
    &:hover {
        transform: scale(1.1);
    }
}
</style>
