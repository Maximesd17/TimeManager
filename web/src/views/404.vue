<template>
    <div
        id="error-page-404"
        class="flex h-full w-full bg-background flex-col items-center justify-evenly gap-5 text-center"
    >
        <div class="text-text">
            <h1 class="text-9xl text-accent">404</h1>
            <h1>La page n'existe pas</h1>
        </div>

        <a href="/dashboard">
            <ButtonVue>Retourner à la page d'accueil</ButtonVue>
        </a>
    </div>
</template>
<script lang="ts" setup>
import ButtonVue from '@/components/ui/input/Button.vue';
</script>
