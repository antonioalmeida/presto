<template>
    <div v-infinite-scroll="loadMore" infinite-scroll-disabled="busy" infinite-scroll-distance="0">
        <section class="small-container">
            <div class="container">
                <router-view></router-view>
            </div>
            <div class="container">

                <div class="row">
                    <div class="col-md-8 offset-md-2">

                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a v-on:click="currTab = 'Questions'" class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home"
                                   role="tab" aria-controls="nav-home" aria-selected="true">Questions</a>
                                <a v-on:click="currTab = 'Answers'" class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile"
                                   role="tab" aria-controls="nav-profile" aria-selected="false">Answers</a>
                            </div>
                        </nav>
                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-home" role="tabpanel"
                                 aria-labelledby="nav-home-tab">

                                <div class="list-group">
                                    <template v-for="question in sortedQuestions">
                                        <question-card v-bind:question="question"></question-card>
                                    </template>
                                </div>

                            </div>
                            <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">

                                <div class="list-group">
                                    <template v-for="answer in sortedAnswers">
                                        <answer-card v-bind:answer="answer"></answer-card>
                                    </template>
                                </div>

                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </section>
    </div>
</template>

<script>
    export default {

        props: ['username'],

        name: 'ProfileFeed',

        components: {
            QuestionCard: require('../components/QuestionCard'),
            AnswerCard: require('../components/AnswerCard')
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getQuestions();
            this.getAnswers();
        },

        data() {
            return {
                questions: null,
                answers: null,
                currTab: 'Questions',
                allQuestionsContent: false,
                currQuestionsDataChunk: 1,
                allAnswersContent: false,
                currAnswersDataChunk: 1,
            }
        },

        methods: {
            getQuestions: function () {
                let request = '/api/profile';
                if (this.username)
                    request += '/' + this.username;
                request += '/questions';

                axios.get(request,{
                    params: {
                        chunk: this.currQuestionsDataChunk
                    }
                })
                    .then(({data}) => {
                        if(this.questions == null)
                            this.questions = data.data;
                        else
                            this.joinArray(this.questions,data.data);
                        this.allQuestions = data.last;
                        this.busy = false;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getAnswers: function () {
                let request = '/api/profile';
                if (this.username)
                    request += '/' + this.username;
                request += '/answers';

                axios.get(request,{
                    params: {
                        chunk: this.currAnswersDataChunk
                    }
                })
                    .then(({data}) => {
                        if(this.answers == null)
                            this.answers = data.data;
                        else
                            this.joinArray(this.answers,data.data);
                        this.allAnswers = data.last;
                        this.busy = false;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            loadMore: function(){
                if(this.currTab == 'Questions'){
                    if(this.allQuestions){
                        console.log("No more");
                        return;
                    }
                }

                if(this.currTab == 'Answers'){
                    if(this.allAnswers){
                        console.log("No more");
                        return;
                    }
                }


                console.log("Loading More");
                this.busy = true;
                this.loader = this.$loading.show();


                if(this.currTab == 'Questions'){
                    this.currQuestionsDataChunk++;
                    this.getQuestions();
                }
                else if(this.currTab == 'Answers'){
                    this.currAnswersDataChunk++;
                    this.getAnswers();
                }
            },

            joinArray: function(array,data){
                for(let key in data){
                    if(data[key] != null)
                        array.push(data[key]);
                }
            }

        },

        computed: {
            sortedQuestions: function () {
                if (!this.questions)
                    return null;

                let comparator = (a, b) => {
                    return a.date < b.date
                };

                return this.questions.sort(comparator);
            },

            sortedAnswers: function () {
                if (!this.answers)
                    return null;

                let comparator = (a, b) => {
                    return a.date < b.date
                };

                return this.answers.sort(comparator);
            }

        }
    }
</script>

