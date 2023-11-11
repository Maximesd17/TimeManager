<template>
    <component :is="layout">
        <RouterView />
    </component>
</template>

<script lang="ts" setup>
import { computed, onMounted, onUnmounted } from 'vue';
import { useScreenStore } from '@/store/screen';
import { useRoute } from 'vue-router';

import Default from './layouts/Default.vue';
import Empty from './layouts/Empty.vue';

const screenStore = useScreenStore();
const route = useRoute();

const layout = computed(() => {
    console.log(route.meta.layout)
    switch (route.meta.layout) {
        case 'default':
            return Default;
        case 'empty':
            return Empty;
        default:
            return Empty;
    }
})

onMounted(() => {
    screenStore.update();
    window.addEventListener('resize', screenStore.update);
});

onUnmounted(() => {
    window.removeEventListener('resize', screenStore.update);
});
</script>

<style lang="scss" scoped></style>
