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
        path: '/login',
        component: require('./views/Login')
    },

    {
        path: '/signup',
        component: require('./views/Register')
    },


    {
        path: '/profile/:username',
        component: require('./views/Profile'),
        props: true,

        children: [
            {
                path: '',
                component: require('./views/ProfileFeed'),
                props: true,
            },

            {
                path: 'followers',
                component: require('./views/Followers'),
                props: true,
            },

            {
                path: 'following',
                component: require('./views/Following'),
                props: true,
            }
        ]
    },

    {
        path: '/edit-profile',
        component: require('./views/EditProfile'),
        props: true,
    },

    {
        path: '/questions/:q_id/answers/:a_id',
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

    {
        path: '/notifications',
        component: require('./views/Notifications')
    },

    {
        path: '/404',
        component: require('./views/404')
    },

];


export default new VueRouter({
    routes,
    mode: 'history',

    scrollBehavior(to, from, savedPosition) {
        return {x: 0, y: 0};
    }
});

