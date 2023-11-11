<template>
    <div
        class="absolute rounded-full w-8 h-8 inset-2 shadow-lg cursor-pointer"
        :class="{
            'bg-success': clock.status,
            'bg-danger': !clock.status
        }"
        v-tooltip="
            clock.status
                ? `In since ${formatDateToHuman(props.clock.time)}`
                : 'Out'
        "
    ></div>
</template>

<script lang="ts" setup>
import type { Clock } from '@/types';
import { formatDateToHuman } from '@/utils/dates';
import type { PropType } from 'vue';

const props = defineProps({
    clock: {
        type: Object as PropType<Clock>,
        required: true
    }
});
</script>

<style lang="scss" scoped>
</style>
