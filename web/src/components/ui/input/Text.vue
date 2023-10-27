<template>
    <div
        class="text"
        :style="{
            '--border-color': borderColor
        }"
    >
        <label v-if="label" style="{ maxWidth }" class="label">{{
            label
        }}</label>
        <input
            class="input"
            type="text"
            :value="modelValue"
            :style="{ maxWidth }"
            @input="handleInput"
            @keydown.enter.prevent="emits('enter')"
        />
    </div>
</template>

<script setup lang="ts">
const emits = defineEmits(['update:modelValue', 'enter']);

defineProps({
    modelValue: {
        type: String,
        required: true
    },
    maxWidth: {
        type: String,
        default: '14rem'
    },
    label: {
        type: String,
        default: ''
    },
    borderColor: {
        type: String,
        default: 'var(--primary)'
    }
});

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
        margin-left: 4px;
    }
    .input {
        width: 100%;
        border: none;
        background-color: white;
        outline: 2px solid var(--border-color);
        padding: 2px 2px 2px 4px;
        border-radius: 0.5rem;
        font-size: large;
        font-weight: 600;
        color: var(--primary);
    }
}
</style>