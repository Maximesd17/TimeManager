/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./src/components/**/*.{js,vue,ts}', './src/App.vue'],
    theme: {
        extend: {
            colors: {
                'primary': 'var(--primary)',
                'secondary': 'var(--secondary)',
                'green': 'var(--green)',
                'red': 'var(--red)',
            }
        }
    },
    plugins: []
};
