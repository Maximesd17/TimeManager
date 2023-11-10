import { newNaiveDateTime } from '@/utils/dates'
import { ref } from 'vue'

interface Cookies {
    [key: string]: string
}

export default function useCookies() {
    const cookies = ref<Cookies>({})

    function setCookie(name: string, value: string, days: number) {
        const date = newNaiveDateTime()
        date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000)
        const expires = '; expires=' + date.toUTCString()
        document.cookie = name + '=' + value + expires + '; path=/'
        cookies.value[name] = value
    }

    function getCookie(name: string) {
        const nameEQ = name + '='
        const ca = document.cookie.split(';')
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i]
            while (c.charAt(0) === ' ') c = c.substring(1, c.length)
            if (c.indexOf(nameEQ) === 0) {
                const value = c.substring(nameEQ.length, c.length)
                cookies.value[name] = value
                return value
            }
        }
        return null
    }

    function revokeCookie(name: string) {
        setCookie(name, '', -1)
    }

    return {
        cookies,
        setCookie,
        getCookie,
        revoke: revokeCookie
    }
}
