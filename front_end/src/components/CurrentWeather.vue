<template>
    <div>
        <h2>Current Weather</h2>
        <div id="weather_data">
            <div v-for="weather in getWeather()" v-bind:key="weather.town">
                <div id="{{ weather.town }}"></div>
                <p>Local datetime: {{ weather.date }}</p>
                <p>{{ weather.town }}: {{ weather.temp }}°C</p>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
    interface Weather {
        town: string,
        temp: number,
        date: string
    }
    const weather_data: Weather[] = [
        {town: "Paris", temp: 11.7, date: "2023-10-25 10:41:12"},
        {town: "Toronto", temp: 3, date: "2023-10-25 4:41:12"},
        {town: "Tokyo", temp: 15.3, date: "2023-10-25 16:41:12"},
    ];

    function getWeather(): Weather[] {
        return weather_data;
    }
</script>

<style lang="css" scoped>
</style>