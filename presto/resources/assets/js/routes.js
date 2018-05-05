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

    ];

export default new VueRouter({
    routes,
    mode: 'history'
});