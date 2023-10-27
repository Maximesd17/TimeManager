<template>
    <div class="modal" @click="emits('no')">
        <div class="container" @click.stop :style="{ width, height }">
            <h3 class="text-center text-xl font-bold h-2/3 flex items-center">
                <slot />
            </h3>
            <div class="buttons h-1/3">
                <UiButton @click="emits('yes')" variant="green" class="h-12 w-20">
                    {{ textValidate }}
                </UiButton>
                <UiButton @click="emits('no')" variant="red" class="h-12 w-20">
                    {{ textCancel }}
                </UiButton>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import UiButton from './Button.vue';

const emits = defineEmits(['no', 'yes']);

defineProps({
    text: {
        type: String,
        default: 'Est-tu sur de vouloir faire ca ?'
    },
    textValidate: {
        type: String,
        default: 'Yes'
    },
    textCancel: {
        type: String,
        default: 'No'
    },
    width: {
        type: String,
        default: '20rem'
    },
    height: {
        type: String,
        default: '10rem'
    }
});
</script>

<style lang="scss" scoped>
.modal {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.4);

    .container {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: var(--primary);
        border-radius: 0.5rem;
        overflow-y: auto;
        z-index: 1001;

        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        gap: 1rem;
    }
    .buttons {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        gap: 2rem;
    }
}
</style>
