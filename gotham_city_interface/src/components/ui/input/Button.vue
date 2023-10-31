<template>
    <button
        class="button select-none"
        @click="click"
        :type="type"
        :class="{ [variant]: Boolean(variant) }"
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
    padding: 0 1rem;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    border-radius: 1rem;
    cursor: pointer;
    transition: all 0.1s ease-in-out;
    font-weight: 800;
    &:hover {
        transform: translateX(var(--translateX, 0)) translateY(var(--translateY, 0)) scale(1.05, 1.05);
    }
    &:active {
        box-shadow: inset -1px 2px 5px #000;
    }
}

.default {
    background-color: var(--button);
    color: var(--secondary);
}

.defaultBorder {
    background-color: transparent;
    border: 2px solid var(--button);
    color: var(--text);
}

.red {
    background-color: var(--red);
    color: var(--text);
}

.redBorder {
    background-color: transparent;
    border: 2px solid var(--red);
    color: var(--text);
}

.transparent {
    background-color: transparent;
    &:hover {
        transform: scale(1.1);
    }
}
</style>
