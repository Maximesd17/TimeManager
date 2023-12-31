<template>
    <div class="modal" @click="close">
        <div
            class="modal-content bg-primary p-1 pl-3"
            :style="{ width, height }"
            @click.stop
        >
            <div
                class="bg-background h-full w-full rounded-l-lg rounded-r-2xl p-4 overflow-auto flex flex-col"
            >
                <UiButton
                    v-if="layout !== 'desktop'"
                    @click="close"
                    class="button-close"
                    variant="transparent"
                >
                    <SvgClose />
                </UiButton>
                <slot />
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { onMounted, onUnmounted } from 'vue';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import UiButton from './input/Button.vue';
import SvgClose from '@/components/svg/Close.vue';

const { layout } = storeToRefs(useScreenStore());

defineProps({
    width: {
        type: String,
        default: '30rem'
    },
    height: {
        type: String,
        default: '25rem'
    }
});

const emits = defineEmits(['close']);

function close() {
    emits('close');
}

onMounted(() => {
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && document.activeElement?.tagName !== 'INPUT') {
            close();
        }
    });
});

onUnmounted(() => {
    document.removeEventListener('keydown', e => {
        if (e.key === 'Escape' && document.activeElement?.tagName !== 'INPUT') {
            close();
        }
    });
});
</script>

<style lang="scss" scoped>
.modal {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 101;
    width: 100%;
    height: 100%;

    .modal-content {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        border-radius: 1rem;
    }

    .button-close {
        position: sticky;
        top: 0;
        right: 0;
        margin-left: auto;

        padding: 0;
    }
}
</style>
