<template>
    <div
        class="rounded-full w-12 h-12 m-4 relative shadow-lg"
        :class="{
            'bg-green': clock.status,
            'bg-red': !clock.status
        }"
        v-tooltip="
            clock.status
                ? `In since ${formatDateTime(props.clock.time)}`
                : 'Out'
        "
    ></div>
</template>

<script lang="ts" setup>
import type { Clock } from '@/types';
import { formatDateTime } from '@/utils/dates';
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
