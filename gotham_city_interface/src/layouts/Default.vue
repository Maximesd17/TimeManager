<template>
    <template v-if="layout === 'mobile'">
        Mobile
        <slot />
    </template>
    <template v-else-if="layout === 'tablet'">
        Tablet
        <slot />
    </template>
    <template v-else>
        <header
            class="h-[4.5rem] bg-primary rounded-b-xl grid place-content-center"
        >
            <UserSelector class="h-full" :user="user" @fetch:user="fetchUser" />
        </header>
        <slot />
    </template>
</template>
<script lang="ts" setup>
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

const { layout } = storeToRefs(useScreenStore());
</script>

<style lang="scss" scoped></style>
