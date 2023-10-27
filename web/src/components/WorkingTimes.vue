<script lang="ts">
    import axios from 'axios';
    import { API_WORKINGTIMES_ROUTE } from '@/router';
    function getWorkingTimes() {
        axios.get(API_WORKINGTIMES_ROUTE).then(function (response) {
            console.log(response);
        })
    }
</script>