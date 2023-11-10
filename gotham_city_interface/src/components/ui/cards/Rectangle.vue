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

    @media (prefers-color-scheme: light) {
        background-color: rgba($color: #000000, $alpha: 0.03);
    }

    @media (prefers-color-scheme: dark) {
        background-color: rgba($color: #ffffff, $alpha: 0.03);
    }
}
</style>
