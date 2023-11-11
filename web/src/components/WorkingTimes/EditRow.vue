<template>
    <tr
        class="grow-in tmp-row overflow-hidden"
        :class="{ 'bg-white': index % 2 === 0 }"
        :style="`--height: ${layout === 'mobile' ? '5' : '3'}rem`"
    >
        <td
            colspan="1"
            class="rounded-bl-[0.25rem] border-r border-r-primary relative overflow-hidden"
        ></td>
        <td colspan="1" class="rounded-bl-[0.25rem] relative overflow-hidden">
            <div
                class="absolute top-2.5 justify-center left-1/2 -translate-x-1/2 flex gap-2 max-sm:flex-wrap"
            >
                <DateInput
                    :date="start"
                    @update:date="emits('update:start', $event)"
                />
                <TimeInput
                    :time="start"
                    @update:time="emits('update:start', $event)"
                />
            </div>
        </td>
        <td colspan="1" class="rounded-bl-[0.25rem] relative overflow-hidden">
            <div
                class="absolute top-2.5 justify-center left-1/2 -translate-x-1/2 flex gap-2 max-sm:flex-wrap"
            >
                <DateInput
                    :date="end"
                    @update:date="emits('update:end', $event)"
                />
                <TimeInput
                    :time="end"
                    @update:time="emits('update:end', $event)"
                />
            </div>
        </td>
        <td colspan="1" class="rounded-br-[0.25rem] relative overflow-hidden">
            <Button
                id="delete"
                class="w-8 rounded-full !p-1 absolute left-1/2 -translate-x-1/2 top-[1.375rem] sm:top-2"
                :style="{ '--translateX': '-50%' }"
                variant="red"
                @click="emits('delete')"
            >
                <img src="@/assets/svg/delete.svg" />
            </Button>
        </td>
    </tr>
</template>

<script lang="ts" setup>
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';

import Button from '../ui/input/Button.vue';
import DateInput from '../ui/input/Date.vue';
import TimeInput from '../ui/input/Time.vue';

const { layout } = storeToRefs(useScreenStore());

const props = defineProps({
    index: {
        type: Number,
        required: true
    },
    start: {
        type: Date,
        required: true
    },
    end: {
        type: Date,
        required: true
    }
});

const emits = defineEmits<{
    (e: 'update:start', date: Date): void;
    (e: 'update:end', date: Date): void;
    (e: 'delete'): void;
}>();
</script>

<style lang="scss" scoped>
.grow-in {
    animation: grow-in 0.3s ease-in-out;
    height: var(--height);
}

@keyframes grow-in {
    0% {
        height: 0;
    }
    100% {
        height: var(--height);
    }
}

.grow-out {
    animation: grow-out 0.3s ease-in-out;
    height: 0rem;
}

@keyframes grow-out {
    0% {
        height: var(--height);
    }
    100% {
        height: 0;
    }
}
</style>
