<template>
    <div class="z-[50] absolute left-0 top-0" ref="menu">
        <div class="burger-toggle overflow-hidden" @click="isOpen = !isOpen">
            <SvgDrag class="svg" :rotate="isOpen" />
        </div>
        <div v-show="isOpen" class="tools flex flex-col gap-2 items-center">
            <div
                class="account cursor-pointer"
                @click="router.push('dashboard')"
            >
                <SvgAccount class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">{{ user?.username }}</p>
                    <p class="text-center">{{ user?.email }}</p>
                </div>
            </div>

            <div class="h-[1px] w-4/5 bg-accent mb-4 flex-center"></div>

            <div
                class="item cursor-pointer"
                :class="
                    route.path == '/dashboard'
                        ? 'opacity-100 bg-secondary'
                        : 'opacity-50 hover:opacity-100'
                "
                @click="router.push('dashboard')"
            >
                <SvgDashboard class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">Overview</p>
                </div>
            </div>

            <div
                class="item cursor-pointer"
                :class="
                    route.path.startsWith('/dashboard/')
                        ? 'opacity-100 bg-secondary'
                        : 'opacity-50 hover:opacity-100'
                "
                @click="router.push('dashboard')"
            >
                <SvgAdmin class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">User Overview</p>
                </div>
            </div>

            <div
                class="item cursor-pointer opacity-50 hover:opacity-100"
                @click="disconnect"
            >
                <SvgDisconnect class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">Sign out</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { useUserStore } from '@/store/user';
import { storeToRefs } from 'pinia';
import router from '@/router';
import { useRoute } from 'vue-router';
import useDetectOutsideClick from '@/composables/useClickOutside';

import SvgDrag from '@/components/svg/Drag.vue';
import SvgAccount from '@/components/svg/Account.vue';
import SvgDashboard from '@/components/svg/Dashboard.vue';
import SvgDisconnect from '@/components/svg/Disconnect.vue';
import SvgAdmin from '@/components/svg/Admin.vue';
import useCookies from '@/composables/useCookies';

const userStore = useUserStore();
const { user } = storeToRefs(userStore);
if (!user) userStore.refresh();

const route = useRoute();

const menu = ref();

const isOpen = ref(true);
watch(
    () => isOpen.value,
    () => {
        console.log(isOpen.value);
    }
);

const disconnect = () => {
    useCookies().revoke('token');
    document.location.reload();
};

useDetectOutsideClick(menu, () => {
    isOpen.value = false;
});
</script>

<style lang="scss" scoped>
.burger-toggle {
    position: absolute;
    top: 0.75rem;
    left: 1rem;
    width: 2rem;
    height: 2rem;
    cursor: pointer;
    z-index: 100;
    outline: 1px solid var(--accent);
    border-radius: 0.25rem;

    &:hover {
        scale: (1.05);
    }
}

.tools {
    @apply h-[100vh] w-[20rem] bg-background rounded-r-xl placeholder-opacity-100 pt-16 px-4;
    border: solid 1px var(--accent);
}

.account {
    @apply flex h-12 items-center w-full hover:bg-[rgba(0,0,0,0.05)] rounded-md p-4;
}
.item {
    @apply flex h-12 items-center w-full rounded-full p-4;
}
</style>

<style lang="scss"></style>
