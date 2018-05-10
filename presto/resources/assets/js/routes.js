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

    ];

    
export default new VueRouter({
    routes,
    mode: 'history',

    scrollBehavior (to, from, savedPosition) {
        return { x: 0, y: 0 };
    }
});