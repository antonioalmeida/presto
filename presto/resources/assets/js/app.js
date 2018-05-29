import './bootstrap';
import router from './routes';
import AddQuestionModal from './components/AddQuestionModal';
import SearchBar from './components/SearchBar';
import Alerts from './components/Alerts';
import infiniteScroll from 'vue-infinite-scroll';

import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.min.css';

window.FontAwesomeConfig = { autoReplaceSvg: 'nest' };

Vue.use(Loading);

Vue.use(require('vue-moment'));
Vue.router = router;
Vue.alerts = Alerts;

if (document.getElementById('app') != null) {
    new Vue({
        el: '#app',
        router,
        components: {
            'AddQuestionModal': AddQuestionModal,
            'SearchBar': SearchBar,
            'Alerts': Alerts
        }
    });


}