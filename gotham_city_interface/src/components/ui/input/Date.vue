<template>
    <VDropdown class="date-input" :shown="isOpen">
        <div class="main" @click="isOpen = true">
            {{ formatDateToHuman(date, false) }}
        </div>
        <template #popper>
            <DateSelector
                :date="date"
                @update:date="
                    emits('update:date', $event);
                    isOpen = false;
                "
                @cancel="isOpen = false"
            />
        </template>
    </VDropdown>
</template>

<script lang="ts" setup>
import DateSelector from '@/components/ui/input/DateSelector.vue';
import { formatDateToHuman } from '@/utils/dates';
import { ref } from 'vue';

defineProps({
    date: {
        type: Date,
        required: true
    }
});

const isOpen = ref(false);

const emits = defineEmits<{
    (e: 'update:date', date: Date): void;
    (e: 'cancel'): void;
}>();
</script>

<style lang="scss" scoped>
.main {
    @apply rounded-full;
    outline: solid 2px var(--primary);
    background-color: white;
    padding: 0 0.5rem;

    &.focus {
        outline: solid 2px var(--button);
    }
}
</style>

<style lang="scss">
.v-popper--theme-dropdown {
    .v-popper__inner {
        border: none !important;
    }
    .v-popper__arrow-container {
        display: none !important;
    }
}
</style>
