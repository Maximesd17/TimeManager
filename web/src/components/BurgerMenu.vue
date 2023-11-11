<template>
    <div class="z-[50] absolute left-0 top-0" ref="menu">
        <div class="burger-toggle overflow-hidden" @click="isOpen = !isOpen">
            <SvgDrag class="svg" :rotate="isOpen" />
        </div>
        <div v-show="isOpen" class="tools flex flex-col gap-2 items-center">
            <div
                class="account cursor-pointer"
                @click="router.push('/dashboard')"
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
                @click="router.push('/dashboard')"
            >
                <SvgDashboard class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">Overview</p>
                </div>
            </div>

            <div
                class="flex flex-col w-full"
                v-if="
                    roles.includes('manager') ||
                    roles.includes('general_manager') ||
                    roles.includes('admin')
                "
            >
                <div
                    class="item cursor-pointer"
                    :class="`${
                        route.path.startsWith('/dashboard/')
                            ? 'opacity-100 bg-secondary'
                            : 'opacity-50 hover:opacity-100'
                    } ${isUserListOpen ? '!opacity-100' : ''}`"
                    @click="isUserListOpen = !isUserListOpen"
                >
                    <SvgAdmin class="w-8 h-8" />
                    <div class="flex-center flex-col w-full">
                        <p class="text-center">User Overview</p>
                    </div>
                    <SvgArrowDown :class="{ 'rotate-180': isUserListOpen }" />
                </div>
                <div v-if="isUserListOpen" class="user-list">
                    <div class="bg-background sticky top-0">
                        <Text
                            class="rounded-md mt-1 ml-12 mr-4 h-8 flex-center"
                            placeholder="Search for an employee"
                            v-model="search"
                        />
                    </div>
                    <template v-for="user in filteredUsers" :key="user.email">
                        <p
                            class="ml-12 rounded-md mr-4 hover:bg-hover h-8 flex-center"
                            @click="router.push(`/dashboard/${user.id}`)"
                        >
                            {{ user.email }}
                        </p>
                    </template>
                </div>
            </div>

            <div
                class="item cursor-pointer opacity-50 hover:opacity-100"
                @click="togglePreferredTheme"
            >
                <SvgColorTheme class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">Preferred theme: {{ currTheme }}</p>
                </div>
            </div>

            <!-- TODO: Add file link -->
            <a
                v-if="layout !== 'desktop'"
                class="item cursor-pointer opacity-50 hover:opacity-100"
                href="https://www.01net.com/telecharger/redirect/358169/"
                download="time_manager.apk"
            >
                <SvgPhone class="w-8 h-8" />
                <div class="flex-center flex-col w-full">
                    <p class="text-center">Download mobile app</p>
                </div>
            </a>

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
import { computed, onMounted, ref } from 'vue';
import { useUserStore } from '@/store/user';
import { useScreenStore } from '@/store/screen';
import { storeToRefs } from 'pinia';
import { useRoute } from 'vue-router';
import { useEventBus } from '@/composables/useEventBus';
import { jwtDecode } from 'jwt-decode';
import { useApiFetch } from '@/composables/useApiFetch';
import type { APIUser, User } from '@/types';
import router from '@/router';
import useDetectOutsideClick from '@/composables/useClickOutside';
import useCookies from '@/composables/useCookies';

import Text from './ui/input/Text.vue';
import SvgDrag from '@/components/svg/Drag.vue';
import SvgAccount from '@/components/svg/Account.vue';
import SvgDashboard from '@/components/svg/Dashboard.vue';
import SvgDisconnect from '@/components/svg/Disconnect.vue';
import SvgAdmin from '@/components/svg/Admin.vue';
import SvgColorTheme from '@/components/svg/ColorTheme.vue';
import SvgArrowDown from '@/components/svg/arrow/Bottom.vue';
import SvgPhone from '@/components/svg/Phone.vue';

const screenStore = useScreenStore();
const { layout } = storeToRefs(screenStore);

const userStore = useUserStore();
const { user } = storeToRefs(userStore);
if (!user.value) userStore.refresh();

const route = useRoute();

const menu = ref();

const isOpen = ref(false);
const currTheme = ref(useCookies().get('theme') || 'automatic');

const token = useCookies().get('token');
let roles = ref([] as string[]);
// @ts-ignore
if (token) roles.value = jwtDecode(token)?.roles || [];

const search = ref('');
const filteredUsers = computed(() => {
    return users.value.filter(user => {
        return user.email.toLowerCase().includes(search.value.toLowerCase());
    });
});

const isUserListOpen = ref(false);

const users = ref([] as User[]);

function togglePreferredTheme() {
    let theme = useCookies().get('theme');
    switch (theme) {
        case 'automatic':
            useCookies().set('theme', 'light', 300);
            theme = 'light';
            break;
        case 'light':
            useCookies().set('theme', 'dark', 300);
            theme = 'dark';
            break;
        case 'dark':
            useCookies().set('theme', 'automatic', 300);
            theme = 'automatic';
            break;
        default:
            useCookies().set('theme', 'automatic', 300);
            theme = 'automatic';
            break;
    }
    document.documentElement.classList.remove('light', 'dark', 'automatic');
    document.documentElement.classList.add(theme);
    currTheme.value = theme;
    useEventBus.emit('refresh_charts');
}

async function fetchUsers() {
    if (
        !(
            roles.value.includes('manager') ||
            roles.value.includes('general_manager') ||
            roles.value.includes('admin')
        )
    )
        return [];
    const { data } = await useApiFetch<APIUser[]>('/users/teams');

    return data.value || [];
}

function disconnect() {
    useCookies().revoke('token');
    document.location.reload();
}

onMounted(async () => {
    users.value = await fetchUsers();
});

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
    @apply flex h-12 items-center w-full hover:bg-hover rounded-md p-4;
}
.item {
    @apply flex h-12 items-center w-full rounded-full p-4;
}

.user-list {
    @apply flex flex-col gap-2 max-h-[15rem] overflow-auto;
}
</style>

<style lang="scss"></style>
