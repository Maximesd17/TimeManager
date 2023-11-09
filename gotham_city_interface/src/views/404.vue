<template>
    <div
        id="error-page-404"
        class="flex h-full w-full flex-col items-center justify-evenly gap-5 text-center"
    >
        <div class="text-primary">
            <h2 class="text-9xl">404</h2>
            <span class="text-5xl">La page n'existe pas</span>
        </div>

        <a href="/dashboard">
            <ButtonVue>Retourner à la page d'accueil</ButtonVue>
        </a>
    </div>
</template>
<script lang="ts" setup>
import ButtonVue from '@/components/ui/input/Button.vue';
</script>
