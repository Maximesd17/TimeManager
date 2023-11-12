<template>
    <Modal
        :height="layout !== 'desktop' ? '32rem' : '30rem'"
        :width="layout !== 'desktop' ? '90%' : '40rem'"
        @close="emits('close')"
    >
        <h3>Create a new employee</h3>
        <form
            @submit.prevent="createUser"
            class="flex flex-col items-center justify-center h-full gap-2"
        >
            <Text
                v-model="newUserUsername"
                label="Username"
                class="w-[20rem]"
                max-width="20rem"
            />
            <Text
                v-model="newUserMail"
                label="Mail"
                class="w-[20rem]"
                max-width="20rem"
            />
            <Password
                v-model="newUserPassword"
                label="Password"
                class="w-[20rem]"
                max-width="20rem"
            />

            <div
                v-if="
                    roles.includes('general_manager') ||
                    roles.includes('administrator')
                "
                class="flex flex-col"
            >
                <label for="role" class="ml-0.5">Role</label>
                <select
                    v-model="newUserRoles"
                    id="role"
                    class="w-[20rem] max-w-[20rem] text-xl"
                >
                    <option :value="null">Employee</option>
                    <option :value="['manager']">Manager</option>
                    <option
                        v-if="roles.includes('administrator')"
                        :value="['general_manager']"
                    >
                        General Manager
                    </option>
                </select>
            </div>
            <Text
                v-if="
                    roles.includes('general_manager') ||
                    roles.includes('administrator')
                "
                v-model="newUserTeam"
                label="Team"
                class="w-[20rem]"
                max-width="20rem"
            />
            <Button type="submit" class="mt-2">Create</Button>
        </form>
    </Modal>
</template>

<script lang="ts" setup>
import { useScreenStore } from '@/store/screen';
import { useUserStore } from '@/store/user';
import { storeToRefs } from 'pinia';
import useCookies from '@/composables/useCookies';
import { jwtDecode } from 'jwt-decode';
import { ref, type PropType } from 'vue';
import type { User } from '@/types';
import { useApiFetch } from '@/composables/useApiFetch';

import Modal from './ui/Modal.vue';
import Text from './ui/input/Text.vue';
import Password from './ui/input/Password.vue';
import Button from './ui/input/Button.vue';
import useToast from '@/composables/useToast';

const props = defineProps({
    users: {
        type: Array as PropType<User[]>,
        required: true
    }
});

const screenStore = useScreenStore();
const { layout } = storeToRefs(screenStore);

const userStore = useUserStore();
const { user } = storeToRefs(userStore);
if (!user.value) userStore.refresh();

const token = useCookies().get('token');
// @ts-ignore
const roles = jwtDecode(token)?.roles || [];

const emits = defineEmits<{
    (e: 'close'): void;
    (e: 'update:users', users: User[]): void;
}>();

const newUserUsername = ref('');
const newUserMail = ref('');
const newUserPassword = ref('');
const newUserRoles = ref(null as string[] | null);
const newUserTeam = ref('' as string);

async function createUser() {
    if (!newUserUsername.value.length)
        return useToast.error('Username is required');
    if (!newUserMail.value.length) return useToast.error('Mail is required');
    if (!newUserPassword.value.length)
        return useToast.error('Password is required');

    if (!checkPassword(newUserPassword.value))
        return useToast.error(
            'Password must contain at least 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character'
        );
    if (!checkMail(newUserMail.value)) return useToast.error('Invalid mail');

    let teams = [newUserTeam.value];
    let nRoles = newUserRoles.value;
    if (
        !(roles.includes('general_manager') || roles.includes('administrator'))
    ) {
        nRoles = [];
        teams = user.value?.teams ?? [];
    } else {
        if (!newUserRoles.value) nRoles = [];
        if (!newUserTeam.value) teams = [];
    }

    const { data } = await useApiFetch<User>('/users', {
        method: 'POST',
        data: {
            user: {
                username: newUserUsername.value,
                email: newUserMail.value,
                password: newUserPassword.value,
                roles: nRoles,
                teams
            }
        }
    });

    if (data.value) {
        emits('update:users', [
            ...props.users,
            data.value
        ]);
        useToast.success('User created successfully');
        newUserUsername.value = '';
        newUserMail.value = '';
        newUserPassword.value = '';
        newUserRoles.value = null;
        newUserTeam.value = '';
    } else {
        useToast.error('An error occurred');
    }
}

function checkMail(mail: string): boolean {
    const regex = /^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/;
    return regex.test(mail);
}

function checkPassword(password: string): boolean {
    const regex =
        /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]).{8,}$/;
    return regex.test(password);
}
</script>

<style lang="scss" scoped>
select {
    background-color: var(--background);
    padding-left: 0.25rem;
    padding-top: 3px;
    padding-bottom: 3px;
    outline: solid 2px var(--primary);
    border-radius: 0.5rem;
}
</style>
