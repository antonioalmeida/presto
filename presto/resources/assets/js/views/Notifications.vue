<template>

    <body class="grey-background">

    <main role="main" class="mt-5">
        <div class="container">
            <div class="row">


                <div class="col-md-2 offset-1 text-collapse">
                    <div class="mt-4">
                        <h4 class="pt-4">Notifications</h4>
                        <div class="dropdown-divider"></div>
                        <!-- <ul class="no-bullets pl-0">
                             <li class="d-flex justify-content-between"><a href="" class="text-muted">Questions</a> <div><span class="badge badge-danger ">{{notifications.Questions}}</span></div></li>
                             <li class="d-flex justify-content-between"><a href="" class="text-muted">Answers</a> <div><span class="badge badge-danger ">{{notifications.Answers}}</span></div></li>
                             <li class="d-flex justify-content-between"><a href="" class="text-muted">Comments</a> <div><span class="badge badge-danger ">{{notifications.Comments}}</span></div></li>
                             <li class="d-flex justify-content-between"><a href="" class="text-muted">People</a> <div><span class="badge badge-danger ">{{notifications.Follows}}</span></div></li>
                             <li class="d-flex justify-content-between"><a href="" class="text-muted">Upvotes</a> <div><span class="badge badge-danger ">{{notifications.Rating}}</span></div></li>
                         </ul> -->
                        <b-form-radio-group class="text-muted" v-model="type" :options="typeOptions" stacked
                                            name="typeRadio"></b-form-radio-group>
                    </div>
                </div>
                <div class="col-md-9 mt-4">
                    <div class="list-group mt-4">
                        <h4 class="text-mobile">Notifications</h4>

                        <template v-for="notification in filteredResults">
                            <notifications-card v-bind:notification="notification"></notifications-card>
                        </template>


                    </div>
                </div>


            </div>
        </div>
        </div>
        </div>
    </main><!-- /.container -->
    <!-- /.container -->
    </body>
</template>

<script>
    export default {

        components: {
            NotificationsCard: require('../components/NotificationsCard')
        },

        data() {
            return {
                notifications: {},
                results: null,
                type: 'All',
                typeOptions: {},
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getData();
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getData();
            }
        },

        methods: {
            getData: function () {
                this.getNotificationsStats();
                this.getNotifications();
            },

            getNotificationsStats: function () {
                axios.get('/api/notificationsStats')
                    .then(({data}) => {
                        this.notifications = data;
                        this.typeOptions = [
                            {text: 'All Notifications', value: 'All'},
                            {text: 'Questions ' + this.notifications.Questions, value: 'Question'},
                            {text: 'Answers ' + this.notifications.Answers, value: 'Answer'},
                            {text: 'Comments ' + this.notifications.Comments, value: 'Comment'},
                            {text: 'People ' + this.notifications.Follows, value: 'Follow'},
                            {text: 'Rating ' + this.notifications.Rating, value: 'Rating'}
                        ];
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getNotifications: function () {
                axios.get('/api/notifications')
                    .then(({data}) => {
                        this.results = data;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }
        },

        computed: {
            filteredResults: function () {
                if (!this.results)
                    return null;

                return this.results.filter((entry) => entry.data['type'] == this.type || this.type == 'All');
            }
        }
    }
</script>