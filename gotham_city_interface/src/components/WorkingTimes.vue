<template>
    {{ workingTimes }}
</template>

<script lang="ts" setup>
import type { WorkingTime } from '@/types';
import type { PropType } from 'vue';


const props = defineProps({
    workingTimes: {
        type: Object as PropType<WorkingTime[]>,
        required: true
    }
});
</script>

<style lang="scss" scoped>
</style>