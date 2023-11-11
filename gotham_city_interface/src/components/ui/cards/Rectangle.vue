<template>
    <div class="card">
        <slot />
    </div>
</template>
<style lang="scss" scoped>
.card {
    background-color: var(--background);
    border-radius: 0.5rem;
    padding: 0.5rem;

    background-color: var(--card-bg);
}
</style>
