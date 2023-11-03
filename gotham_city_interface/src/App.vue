<template>
    <RouterView />
</template>

<script lang="ts" setup>
import { onMounted, onUnmounted } from 'vue';
import { useScreenStore } from '@/store/screen';

const screenStore = useScreenStore();

onMounted(() => {
    screenStore.update();
    window.addEventListener('resize', screenStore.update);
});

onUnmounted(() => {
    window.removeEventListener('resize', screenStore.update);
});
</script>

<style lang="scss" scoped></style>
