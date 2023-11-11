<template>
    <header
        class="h-[4.5rem] bg-primary rounded-b-xl grid place-content-center"
    >
        <!-- <UserSelector class="h-full" :user="user" @fetch:user="fetchUser" /> -->
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
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import UserSelector from '@/components/User.vue';

const { layout } = storeToRefs(useScreenStore());
</script>

<style lang="scss" scoped></style>
