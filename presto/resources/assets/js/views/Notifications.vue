<template>

 <body class="grey-background">

    <main role="main" class="mt-5">
        <div class="container">
            <div class="row">


                <div class="col-md-2 offset-1 text-collapse">
                    <div class="mt-4">
                        <h4 class="pt-4">Notifications</h4>
                        <div class="dropdown-divider"></div>
                        <ul class="no-bullets pl-0">
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Questions</a> <div><span class="badge badge-danger "></span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Answers</a> <div><span class="badge badge-danger "></span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Comments</a> <div><span class="badge badge-danger "></span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">People</a> <div><span class="badge badge-danger "></span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Upvotes</a> <div><span class="badge badge-danger "></span></div></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9 mt-4">
                    <div class="list-group mt-4">
                        <h4 class="text-mobile">Notifications</h4>

                                <template v-for="notification in notifications">
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

    data () {
        return {
            notifications: {}
        }
    },

    mounted() {
        this.loader = this.$loading.show();
        this.getData();
    },

    watch: {
        '$route' (to, from) {
            this.loader = this.$loading.show();
            this.getData();
        }
    },

    methods: {
        getData: function() {
            this.getNotifications();
        },

        getNotifications: function()  {
            axios.get('/api/notifications')
            .then(({data}) => {
                this.notifications = data;
                this.loader.hide();
            })
            .catch((error) => {
                console.log(error);
            });    
        }
    }
}
</script>