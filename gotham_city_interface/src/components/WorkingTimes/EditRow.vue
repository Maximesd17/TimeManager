<template>
    <tr
        class="grow-in tmp-row overflow-hidden"
        :class="{ 'bg-white': index % 2 === 0 }"
    >
        <td
            colspan="1"
            class="rounded-bl-[0.25rem] border-r border-r-primary relative overflow-hidden"
        ></td>
        <td colspan="1" class="rounded-bl-[0.25rem] relative overflow-hidden">
            <div class="absolute top-2.5 left-1/2 -translate-x-1/2 flex gap-2">
                <DateInput
                    :selected="start"
                    @update:selected="emits('update:start', $event)"
                />
                <DateInput
                    :selected="start"
                    @update:selected="emits('update:start', $event)"
                />
            </div>
        </td>
        <td colspan="1" class="rounded-bl-[0.25rem] relative overflow-hidden">
            <div class="absolute top-2.5 left-1/2 -translate-x-1/2 flex gap-2">
                <DateInput
                    :selected="end"
                    @update:selected="emits('update:end', $event)"
                />
                <DateInput
                    :selected="end"
                    @update:selected="emits('update:end', $event)"
                />
            </div>
        </td>
        <td colspan="1" class="rounded-br-[0.25rem] relative overflow-hidden">
            <Button
                id="delete"
                class="w-8 rounded-full !p-1 absolute top-2 left-1/2 -translate-x-1/2"
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
import Button from '../ui/input/Button.vue';
import DateInput from '../ui/input/Date.vue';

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

console.log(props.start, props.end);

const emits = defineEmits<{
    (e: 'update:start', date: Date): void;
    (e: 'update:end', date: Date): void;
    (e: 'delete'): void;
}>();
</script>

<style lang="scss" scoped>
.grow-in {
    animation: grow-in 0.3s ease-in-out;
    height: 3rem;
}

@keyframes grow-in {
    0% {
        height: 0;
    }
    100% {
        height: 3rem;
    }
}

.grow-out {
    animation: grow-out 0.3s ease-in-out;
    height: 0rem;
}

@keyframes grow-out {
    0% {
        height: 3rem;
    }
    100% {
        height: 0;
    }
}
</style>
