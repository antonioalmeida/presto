<template>
    <main class="mt-5 grey-background">

        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" :src="topic.picture"/>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow">
                            <h1>{{ topic.name }}</h1>

                            <!-- bio -->
                            <div class="bio mt-3">
                                <div class="d-flex justify-content-sm-start justify-content-around">
                                    <h5 class="p-2">{{ topic.nrFollowers }}
                                        <small>followers</small>
                                    </h5>
                                </div>
                                <p class="lead lead-adapt">
                                    {{ topic.description }}
                                </p>

                                <follow-button
                                        v-model="topic.isFollowing"
                                        :classesDefault="'btn btn-outline-light'"
                                        :classesActive="'btn btn-danger'"
                                        :path="'/api/topic/' + topic.name + '/toggle-follow'"
                                        :data="followData" @update:data="value => topic.nrFollowers = value.no_follow"
                                >
                                </follow-button>

                                <router-link v-if="this.member.is_moderator" :to="'/topic/'+topic.name+'/edit'" class="btn btn-outline-light">
                                    Edit Topic
                                </router-link>

                            </div>

                        </div>

                        <div class="col-md-3 mt-3">
                            <div class="card card-body">
                                <h5 class="text-dark">Stats</h5>
                                <div class="dropdown-divider"></div>
                                <div class="d-flex flex-column justify-content-around flex-wrap">
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-question"></i>
                                        </div>
                                        <h6>{{ topic.nrQuestions }}
                                            <small class="text-muted">questions</small>
                                        </h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-book"></i>
                                        </div>
                                        <h6>{{ topic.nrAnswers }}
                                            <small class="text-muted">answers</small>
                                        </h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- content -->
        <section class="container wrapper mt-4 mb-2">
            <div class="row">

                <div class="col-md-2 text-right text-collapse side-menu">
                    <h6 class="">Related Topics</h6>
                    <ul class="no-bullets">

                        <router-link v-for="topic in topic.related" :key="topic.id" :to="'/topic/' + topic.name"
                                     class="text-muted">
                            <li>{{ topic.name }}</li>
                        </router-link>

                    </ul>
                </div>

                <div class="col-md-8">

                    <nav>
                        <div class="nav nav-tabs" id="nav-tab" role="tablist">
                            <a class="nav-item nav-link active" id="nav-newest-tab" data-toggle="tab" href="#nav-newest"
                               role="tab" aria-controls="nav-newest" aria-selected="true">Newest</a>
                            <a class="nav-item nav-link" id="nav-oldest-tab" data-toggle="tab" href="#nav-oldest"
                               role="tab" aria-controls="nav-oldest" aria-selected="false">Oldest</a>
                            <a class="nav-item nav-link" id="nav-rating-tab" data-toggle="tab" href="#nav-rating"
                               role="tab" aria-controls="nav-rating" aria-selected="false">Rating</a>
                        </div>
                    </nav>

                    <div class="tab-content mb-5" id="nav-tabContent">
                        <div class="tab-pane fade show active" id="nav-newest" role="tabpanel"
                             aria-labelledby="nav-newest-tab">
                            <div class="list-group">

                                <question-card :key="question.id" v-for="question in this.sortedNewest"
                                               :question="question"></question-card>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="nav-oldest" role="tabpanel" aria-labelledby="nav-oldest-tab">
                            <div class="list-group">

                                <question-card :key="question.id" v-for="question in this.sortedOldest"
                                               :question="question"></question-card>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="nav-rating" role="tabpanel" aria-labelledby="nav-rating-tab">
                            <div class="list-group">

                                <question-card :key="question.id" v-for="question in this.sortedRating"
                                               :question="question"></question-card>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

    </main>
</template>

<script>
    import QuestionCard from '../components/QuestionCard'
    import FollowButton from '../components/FollowButton'

    export default {

        props: ['name'],

        name: 'Topic',

        created() {
            document.title = this.name + " | Presto";
        },

        components: {
            'QuestionCard': QuestionCard,
            'FollowButton': FollowButton
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getTopic(this.name);
            this.getMember();
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getTopic(to.params.name);
            }
        },

        data() {
            return {
                topic: {},
                member: {},
                followData: null,
            }
        },

        methods: {
            getTopic: function (id) {
                axios.get('/api/topic/' + this.name)
                    .then(({data}) => {
                        this.topic = data;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getMember: function () {
              axios.get('/api/profile/')
                  .then(({data}) => {
                      this.member = data;
                  })
                  .catch((error) => {
                      this.member.is_moderator = false; //In case not logged in
                  });
            }
        },

        computed: {
            sortedNewest: function () {
                if (!this.topic.questions)
                    return [];

                return this.topic.questions.slice().sort((a, b) => {
                    return a.date < b.date;
                })
            },

            sortedOldest: function () {
                if (!this.topic.questions)
                    return [];

                return this.topic.questions.slice().sort((a, b) => {
                    return a.date > b.date;
                })
            },

            sortedRating: function () {
                if (!this.topic.questions)
                    return [];

                return this.topic.questions.slice().sort((a, b) => {
                    return a.rating < b.rating;
                })
            }
        }
    }
</script>
