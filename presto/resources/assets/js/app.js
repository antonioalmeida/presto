import './bootstrap';
import router from './routes';

Vue.use(require('vue-moment'));

new Vue({
    el: '#app',

    router
});