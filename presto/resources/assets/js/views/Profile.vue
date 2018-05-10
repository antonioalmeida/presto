<template>

    <body class="grey-background">

        <main class="mt-5" role="main">

            <section>
                <div class="jumbotron profile-jumbotron">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-2 text-center">
                                <img class="profile-pic img-fluid rounded-circle m-2" :src="user.profile_picture"/>
                            </div>

                            <div class="col-md-6 text-shadow mobile-center">
                                <h2 class="h2-adapt">{{ user.name }}</h2>
                                <h4 class="h4-adapt">&#64;{{ user.username}}</h4>

                                <!-- bio -->
                                
                                <div class="bio mt-3">
                                    <div class="d-flex justify-content-sm-start justify-content-around">
                                        <router-link :to="'followers'">
                                            <h5 class="p-2 h5-adapt"> {{ this.user.nrFollowers }} <small>followers</small>
                                            </h5>
                                        </router-link>

                                         <router-link :to="'following'">
                                            <h5 class="p-2 h5-adapt"> {{ this.user.nrFollowing }} <small>following</small>
                                            </h5>
                                        </router-link>

                                    </div>

                                        <p class="lead lead-adapt">
                                            {{user.bio}}
                                        </p>

                                        <router-link v-if="user.isOwner" :to="'/edit-profile'" class="btn btn-outline-light">Edit Profile</router-link>
                                    </div>
                                </div>

                                <div class="col-md-3 mt-3">
                                    <div class="card card-body">
                                        <h5 class="text-dark">Stats</h5>
                                        <div class="dropdown-divider"></div>
                                        <div class="d-flex flex-column justify-content-around flex-wrap">
                                            <div class="d-flex p-1">
                                                <div class="mx-2">
                                                    <a href="#"><i class="fa fa-gem"></i></a>
                                                </div>
                                                <h6>{{user.score}} <small class="text-muted">points</small></h6>
                                            </div>
                                            <div class="d-flex p-1">
                                                <div class="mx-2">
                                                    <i class="far fa-fw fa-eye"></i>
                                                </div>
                                                <h6>{{ user.answers_views }} <small class="text-muted">answer views</small></h6>
                                            </div>
                                            <div class="d-flex p-1">
                                                <div class="mx-2">
                                                    <i class="far fa-fw fa-question"></i>
                                                </div>
                                                <h6>{{ user.nr_questions }} <small class="text-muted">questions</small></h6>
                                            </div>
                                            <div class="d-flex p-1">
                                                <div class="mx-2">
                                                    <i class="far fa-fw fa-book"></i>
                                                </div>
                                                <h6>{{user.nr_answers}} <small class="text-muted">answers</small></h6>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </section>


            <section class="small-container">
                <div class="container">
                    <router-view></router-view>
                </div>
                <div class="container">

                    <div class="row">
                        <div class="col-md-8 offset-md-2">

                            <nav>
                                <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                    <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">Questions</a>
                                    <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false">Answers</a>
                                </div>
                            </nav>
                            <div class="tab-content mb-5" id="nav-tabContent">
                                <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
                                    <!-- Questions go here -->

                                <!--
                                @foreach(user.questions->sortByDesc('date') as $question)
                                @include('partials.question-card', ['question', $question]) 
                                @endforeach
                            -->

                            <div class="list-group">
                                <template v-for="question in questions">
                                    <question-card v-bind:question="question"></question-card> 
                                </template>
                            </div>


                    </div>
                    <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
                            <!-- answers go here 
                            @foreach(user.answers->sortByDesc('date') as $answer)
                            @include('partials.answer-card',['answer', $answer]) 
                            @endforeach -->
            
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </section>
</main><!-- /.container -->

<!-- /.container -->
</body>

</template>

<script>
export default {

    props: ['username'],

    created () {
   		document.title = "Profile | Presto";
  	},

    components: {
        QuestionCard: require('../components/QuestionCard')
    },

    data () {
        return {
            user: {},
            questions: {}
        }
    },

    mounted() {
        this.loader = this.$loading.show();
        this.getData(this.username);
    },

    watch: {
        '$route' (to, from) {
            this.loader = this.$loading.show();
            this.getData(to.params.username);
        }
    },

    methods: {
        getData: function(username) {
            this.getUser(username);
            this.getQuestions(username);
        },

        getUser: function(username)  {
            axios.get('/api/profile/' + ( username || '' ))
            .then(({data}) => {
                this.user = data;
            })
            .catch((error) => {
                console.log(error);
            });    
        },

        getQuestions: function(username) {
            let request = '/api/profile';
            if(username)
                request += '/' + username;
            request += '/questions';

            axios.get(request)
            .then(({data}) => {
                this.questions = data;
                this.loader.hide();
            })
            .catch((error) => {
                console.log(error);
            }); 
        }
    }

}
</script>

