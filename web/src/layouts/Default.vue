<template>
    <header class="h-[3.5rem] w-full relative flex justify-center items-center">
        <BurgerMenu />
        <h3>Time manager</h3>
    </header>
    <template v-if="layout === 'mobile'">
        <slot />
    </template>
    <template v-else-if="layout === 'tablet'">
        <slot />
    </template>
    <template v-else>
        <slot />
    </template>
</template>
<script lang="ts" setup>
import BurgerMenu from '@/components/BurgerMenu.vue';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

const { layout } = storeToRefs(useScreenStore());
</script>

<style lang="scss" scoped>
header {
    &::after {
        content: '';
        position: absolute;
        width: 100%;
        bottom: 0;
        left: 0;
        right: 0;
        height: 1px;
        background-color: var(--secondary);
    }
}
</style>
