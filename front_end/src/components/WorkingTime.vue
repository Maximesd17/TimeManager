<script lang="ts">
    import axios from 'axios';
    import {API_WORKINGTIMES_ROUTE} from "../router/index";


    function createWorkingTime() {
        axios.post(API_WORKINGTIMES_ROUTE).then(function (response) {
            console.log(response);
        })
    }

    function updateWorkingTime() {
        axios.put(API_WORKINGTIMES_ROUTE).then(function (response) {
            console.log(response);
        })
    }

    function deleteWorkingTime() {
        axios.delete(API_WORKINGTIMES_ROUTE).then(function (response) {
            console.log(response);
        })
    }
</script>