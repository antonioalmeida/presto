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




/**
  * Import tributejs for mentions
  */
  import Tribute from "tributejs";
  window.Tribute = Tribute;

/**
  * Import Mentions class
  */
import Mentions from './laravel-mentions';
window.Mentions = Mentions;
