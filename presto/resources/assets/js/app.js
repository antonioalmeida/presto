import './bootstrap';
import router from './routes';
import AddQuestionModal from './components/AddQuestionModal';

Vue.use(require('vue-moment'));

new Vue({
    el: '#app',
    router,
    components: {
    	'AddQuestionModal': AddQuestionModal
    } 
});