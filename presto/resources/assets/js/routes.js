import VueRouter from 'vue-router';

let routes = [

    {
        path: '/',
        component: require('./views/Index')
    },

    {
        path: '/about',
        component: require('./views/About')
    },

    {
        path: '/profile/:username?',
        component: require('./views/Profile'),
        props: true,
    }


    ];

export default new VueRouter({
    routes
});