import './bootstrap';
import router from './routes';
import AddQuestionModal from './components/AddQuestionModal';
import SearchBar from './components/SearchBar';

import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.min.css';

Vue.use(Loading);

Vue.use(require('vue-moment'));
Vue.router = router;

new Vue({
    el: '#app',
    router,
    components: {
        'AddQuestionModal': AddQuestionModal,
        'SearchBar': SearchBar
    }
});


