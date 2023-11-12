<template>
    <div class="modal" @click="emits('no')">
        <div class="container" @click.stop :style="{ width, height }">
            <h5 class="text-center font-bold h-1/2 flex items-end">
                <slot />
            </h5>
            <div class="buttons h-1/2 mt-auto items-end pb-8">
                <UiButton
                    @click="emits('yes')"
                    :variant="variant === 'default' ? 'default' : 'danger'"
                    class="h-12 w-20"
                >
                    {{ textValidate }}
                </UiButton>
                <UiButton
                    @click="emits('no')"
                    :variant="
                        variant === 'default' ? 'defaultBorder' : 'dangerBorder'
                    "
                    class="h-12 w-20"
                >
                    {{ textCancel }}
                </UiButton>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { onMounted, onBeforeUnmount, type PropType } from 'vue';
import UiButton from './Button.vue';

const emits = defineEmits(['no', 'yes']);

defineProps({
    text: {
        type: String,
        default: 'Are you sure to want this ?'
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
    },

    variant: {
        type: String as PropType<'default' | 'danger'>,
        default: 'default'
    }
});

onMounted(() => {
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
            emits('no');
        }
    });
});

onBeforeUnmount(() => {
    document.removeEventListener('keydown', e => {
        if (e.key === 'Escape') {
            emits('no');
        }
    });
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
        background-color: var(--background);
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
        gap: 1rem;
    }
}
</style>
