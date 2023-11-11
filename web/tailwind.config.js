/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './src/components/**/*.{js,vue,ts}',
        './src/views/**/*.{js,vue,ts}',
        './src/layouts/**/*.{js,vue,ts}',
        './src/App.vue'
    ],
    theme: {
        extend: {
            colors: {
                primary: 'var(--primary)',
                secondary: 'var(--secondary)',
                button: 'var(--button)',
                green: 'var(--green)',
                red: 'var(--red)'
            }
        }
    },
    plugins: [
        function ({ addUtilities }) {
            addUtilities({
                '.text-ellipsis': {
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                    whiteSpace: 'nowrap'
                },

                '.absolute-center': {
                    position: 'absolute',
                    top: '50%',
                    left: '50%',
                    transform: 'translate(-50%, -50%)'
                },

                '.fixed-center': {
                    position: 'fixed',
                    top: '50%',
                    left: '50%',
                    transform: 'translate(-50%, -50%)'
                },

                '.grid-center': {
                    display: 'grid',
                    placeItems: 'center'
                },

                '.flex-center': {
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center'
                }
            });
        }
    ]
};
