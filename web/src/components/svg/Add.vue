<template>
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M16 4V16M16 28V16M16 16H4M16 16H28" :stroke="color" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
</template>
<script setup lang="ts">
const { color } = defineProps({ color: { type: String, default: 'var(--accent)' } });
</script>
