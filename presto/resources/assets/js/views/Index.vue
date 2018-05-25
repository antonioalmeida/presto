<template>
    <main class="mt-5 grey-background" role="main">

            <section v-if="!isLoggedIn" class="jumbotron">
                <div class="container">
                    <div class="row">
                        <div class="col-sm-7 align-self-center my-3 text-shadow">
                            <h1>Be a part of the knowledge community.</h1>
                            <h3>
                                <small>Join <strong>Presto</strong> and help grow the world's knowledge.</small>
                            </h3>
                        </div>
                        <div class="col-sm-5 align-self-center">
                            <div class="card sign-up-card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center flex-column">
                                        <div class="m-2 g-signin2" data-width="254" data-height="40"
                                             data-longtitle="true"></div>

                                        <div class="fb-login-button m-2" data-max-rows="1" data-size="large"
                                             data-button-type="continue_with" data-show-faces="false"
                                             data-auto-logout-link="false" data-use-continue-as="false"></div>
                                    </div>

                                    <div class="d-flex justify-content-center">
                                        <h6 class="text-muted">
                                            <small>OR</small>
                                        </h6>
                                    </div>

                                    <div id="indexSignupForm">
                                        <div class="input-group mb-2">
                                            <div class="input-group-prepend">
                                                <div class="input-group-text"><i class="far fa-user"></i></div>
                                            </div>
                                            <input v-model="username" type="text" class="form-control"
                                                   id="inlineFormInputGroup" placeholder="Your Username">
                                        </div>

                                        <div class="input-group mb-2">
                                            <div class="input-group-prepend">
                                                <div class="input-group-text"><i class="far fa-at"></i></div>
                                            </div>
                                            <input v-model="email" type="text" class="form-control"
                                                   id="inlineFormInputGroup" placeholder="your@email.com"> 
                                        </div>

                                        <div class="input-group mb-2">
                                            <div class="input-group-prepend">
                                                <div class="input-group-text"><i class="far fa-key"></i></div>
                                            </div>
                                            <input v-model="password" type="password" class="form-control"
                                                   id="passwordForm" placeholder="Password">
                                            <input v-model="password_confirmation" type="hidden"
                                                   id="passwordFormConfirmed">
                                        </div>
                                        <div class="form-check mb-2 mx-1">
                                            <input v-model="terms" class="form-check-input" type="checkbox"
                                                   id="defaultCheck1">
                                            <label class="form-check-label" for="defaultCheck1">
                                                <small>I accept Presto's <a href="">Terms and Conditions</a>.</small>
                                            </label>
                                        </div>
                                        <div class="d-flex justify-content-center">
                                            <button @click="onSubmit" class="btn btn-primary">Sign Up</button>
                                        </div>

                                        <!-- @include ('includes.errors') -->

                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>
            </section>

        <!-- content -->
        <section class="container">
            <div class="row mt-5">
                <div class="col-md-2 text-right side-menu text-collapse">
                    <h6>Trending Topics</h6>
                    <ul class="no-bullets">
                    <template v-for="topic in trendingTopics">
                        <li><router-link :to="'/topic/' + topic.name" class="text-muted">{{topic.name}}</router-link></li>
                    </template>
                    </ul>
                </div>
                <div class="col-md-7">
                    <nav>
                        <div class="nav nav-tabs" id="nav-tab" role="tablist">
                            <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home"
                               role="tab" aria-controls="nav-home" aria-selected="true">Top</a>
                            <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile"
                               role="tab" aria-controls="nav-profile" aria-selected="false">New</a>
                                <a v-if="isLoggedIn" class="nav-item nav-link" id="nav-recommended-tab" data-toggle="tab"
                                   href="#nav-recommended" role="tab" aria-controls="nav-recommended"
                                   aria-selected="false">Recommended</a>
                        </div>
                    </nav>
                    <div class="tab-content mb-5" id="nav-tabContent">
                        <div class="tab-pane fade show active" id="nav-home" role="tabpanel"
                             aria-labelledby="nav-home-tab">

                            <div class="list-group">
                                <template v-for="content in topContent">
                                    <answer-card v-if="content.type == 'answer'" v-bind:answer="content.answer"></answer-card>
                                    <question-card v-if="content.type == 'question'" v-bind:question="content.question"></question-card>
                                </template>
                                
                            </div>
                        </div>

                        <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">

                            <div class="list-group">

                                <template v-for="content in newContent">
                                    <answer-card v-if="content.type == 'answer'" v-bind:answer="content.answer"></answer-card>
                                    <question-card v-if="content.type == 'question'" v-bind:question="content.question"></question-card>
                                </template>
                                
                            </div>
                        </div>
                        
                            <div v-if="isLoggedIn" class="tab-pane fade" id="nav-recommended" role="tabpanel"
                                 aria-labelledby="nav-recommended-tab">

                                <div class="list-group">
                                <template v-for="content in recommendedContent">
                                    <answer-card v-if="content.type == 'answer'" v-bind:answer="content.answer"></answer-card>
                                    <question-card v-if="content.type == 'question'" v-bind:question="content.question"></question-card>
                                </template>
                                </div>

                            </div>
                    </div>
                </div>


                <div class="col-md-3 side-menu text-collapse">
                    <div class="card">
                        <div class="card-body">
                            <h6>Who to Follow</h6>
                            <div class="list-group list-group-flush short-padding">
                                    
                                <template v-for="member in topMembers">
                                <div class="list-group-item d-flex justify-content-begin">
                                    <div class="align-self-center">
                                        <img class="user-preview rounded-circle mr-2" width="50px" heigth="50px"
                                             :src="member.profile_picture">
                                    </div>
                                    <div>
                                        <router-link :to="'/profile/' + member.username" class="text-dark">{{member.name}}</router-link>
                                        <br>
                                        <span class="text-muted"><i
                                                    class="fas fa-gem text-primary"></i> {{member.score}} points</span>
                                    </div>
                                    <div class="ml-auto align-self-center">
                                        <a href=""><i class="far fa-fw fa-user-plus"></i></a>
                                    </div>
                                </div>
                               </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </main><!-- /.container -->
</template>

<script>
    export default {

        name: 'Index',

        created() {
            document.title = "Presto";
        },

        components: {
            QuestionCard: require('../components/QuestionCard'),
            AnswerCard: require('../components/AnswerCard')
        },

        data() {
            return {
                isLoggedIn: true,
                topContent: [],
                newContent: [],
                recommendedContent: [],
                trendingTopics: [],
                topMembers: [],
                username: null,
                email: null,
                password: null,
                password_confirmation: null,
                terms: null,
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getData();
            this.loader.hide();
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getData();
            }
        },

        methods: {
            getData: function () {
                this.getIsLoggedIn();
                this.getNewContent();
                this.getTopContent();
                this.getRecommendedContent();
                this.getTopMembers();
                this.getTrendingTopics();
            },

            getIsLoggedIn: function () {
                axios.get('/api/isLoggedIn')
                    .then(({data}) => {
                        this.isLoggedIn = data.isLoggedIn;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getNewContent: function () {
                axios.get('/api/feed/getNewContent')
                    .then(({data}) => {
                        this.newContent = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getTopContent: function () {
                axios.get('/api/feed/getTopContent')
                    .then(({data}) => {
                        this.topContent = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getRecommendedContent: function () {
                axios.get('/api/feed/getRecommendedContent')
                    .then(({data}) => {
                        this.recommendedContent = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

             getTrendingTopics: function () {
                axios.get('/api/feed/getTrendingTopics')
                    .then(({data}) => {
                        this.trendingTopics = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

             getTopMembers: function () {
                axios.get('/api/feed/getTopMembers')
                    .then(({data}) => {
                        this.topMembers = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            checkForm:function() {
                if(!this.username) {
                    this.$alerts.addError("Username required.");
                    return false;
                }

                if(!this.email) {
                    this.$alerts.addError("Email required.");
                    return false;
                }

                if(!this.password) {
                   this.$alerts.addError("Password required.");
                   return false;
                }

                if(!this.terms) {
                   this.$alerts.addError("Terms required.");
                   return false;
                }
               
                if(!this.$alerts.length)
                 return true;
            },

            onSubmit: function (e) {
               if(!this.checkForm()){
                   return;
               }
                
                axios.post('/signup', {
                    'username': this.username,
                    'email': this.email,
                    'password': this.password,
                    'password_confirmation': this.password,
                    'terms': this.terms,
                })
                    .then(({data}) => {
                        // this.$router.push({path: '/'});
                        window.location.href = '/';
                        this.$alerts.addSuccess('Member successfully registered!');
                    })
                    .catch(({response}) => {
                        this.$alerts.addError(response.data.message);

                        let errors = response.data.errors;
                        for(let key in errors){
                            for(let message of errors[key]){
                                console.log(message);
                                this.$alerts.addError(message);
                            }
                        }
                    });
            }
        }

    }
</script>
