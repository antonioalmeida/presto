import Vue from 'vue';
import VueRouter from 'vue-router';
import axios from 'axios';

window.Vue = Vue;
Vue.use(VueRouter);

window.axios = axios;
window.axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

window.axios.interceptors.response.use(
    response => response,
    (error) => {

        if (error.response.status === 401) {
            window.location.href = "/login";
        } else if (error.response.status === 404 || error.response.status === 500) {
            window.location.href = "/404";
        }

        return Promise.reject(error);

    });
