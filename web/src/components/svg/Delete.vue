<template>
    <svg
        width="32"
        height="32"
        viewBox="0 0 32 32"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
    >
        <path
            d="M13.5 16.25V22.5M18.5 16.25V22.5M6 10H26M8.5 13.75V23.75C8.5 25.8211 10.1789 27.5 12.25 27.5H19.75C21.8211 27.5 23.5 25.8211 23.5 23.75V13.75M12.25 7.5C12.25 6.11929 13.3693 5 14.75 5H17.25C18.6307 5 19.75 6.11929 19.75 7.5V10H12.25V7.5Z"
            :stroke="color"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
        />
    </svg>
</template>
<script setup lang="ts">
const { color } = defineProps({
    color: { type: String, default: 'var(--accent)' }
});
</script>
