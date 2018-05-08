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
        path: '/profile/:username',
        component: require('./views/Profile'),
        props: true,
    },

    {
        path: '/answers/:a_id',
        component: require('./views/Answer'),
        props: true,
    },

    {
        path: '/questions/:id',
        component: require('./views/Question'),
        props: true,
    },

    {
        path: '/topic/:name',
        component: require('./views/Topic'),
        props: true,
    },

    {
        path: '/search/:query',
        component: require('./views/Search'),
        props: true,
    },

    {
        path: '/admin',
        component: require('./views/Admin'),
    },

    ];

export default new VueRouter({
    routes,
    mode: 'history'
});