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
        path: '/profile',
        component: require('./views/Profile')
    }


    ];

export default new VueRouter({
    routes
});