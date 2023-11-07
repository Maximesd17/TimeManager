<template>
    <template v-if="layout === 'mobile'">
        Mobile
        <slot />
    </template>
    <template v-else>
        Default
        <slot />
    </template>
</template>
<script lang="ts" setup>
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

const { layout } = storeToRefs(useScreenStore());
</script>

<style lang="scss" scoped></style>
