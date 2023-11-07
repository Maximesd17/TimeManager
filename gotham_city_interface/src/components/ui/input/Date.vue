<template>
    <VDropdown class="date-input">
        <div class="main">
            {{ formatDateToHuman(selected, false) }}
        </div>
        <template #popper>
            <DateSelector
                :date="selected"
                :selected="selected"
                @update:selected="emits('update:selected', $event)"
            />
        </template>
    </VDropdown>
</template>

<script lang="ts" setup>
import DateSelector from '@/components/ui/input/DateSelector.vue';
import { formatDateToHuman } from '@/utils/dates';
import { watch } from 'vue';

const props = defineProps({
    selected: {
        type: Date,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'update:selected', date: Date): void;
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
