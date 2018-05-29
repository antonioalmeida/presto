<template>

    <main class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    
                    <router-link :to="'/questions/' + answer.question.id" class="text-dark list-group-item-action">
                        <h1>{{answer.question.title}}</h1>
                    </router-link>
                    <h5>
                        <small class="text-muted">
                            <i class="far fa-fw fa-tags"></i>
                            <router-link v-for="(topic, index) in answer.question.topics" :key="topic.id"
                                         :to="'/topic/' + topic.name" class="text-muted">
                                {{ topic.name }}
                                <template v-if="index != answer.question.topics.length -1">,
                                </template>
                            </router-link>

                            <span v-if="answer.question.topics.length === 0" class="text-muted">No topics</span>
                        </small>
                    </h5>

                    <div class="mt-4">

                        <AnswerPartial :answerData="answer" :key="answer.id" :parent="answer.question" v-on:solve-question="solve()"></AnswerPartial>

                    </div>
                </div>
            </div>
        </section>


    </main>

</template>

<script>
    import {Collapse, FormTextarea} from 'bootstrap-vue/es/components'
    import CommentsList from '../components/CommentsList'
    import AnswerPartial from '../components/AnswerPartial'

    export default {

        props: ['q_id', 'a_id'],

        name: 'Answer',

        created() {
            document.title = "Answer | Presto";
        },

        components: {
            'Collapse': Collapse,
            'FormTextarea': FormTextarea,
            'CommentsList': CommentsList,
            'AnswerPartial': AnswerPartial
        },

        data() {
            return {
                answer: {
                    question: {
                        topics: [],
                    },

                    author: [],
                    comments: [],

                },
                commentText: '',
                showError: false,
                showSuccess: false,
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getData(this.q_id, this.a_id);
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getData(to.params.q_id, to.params.a_id);
            }
        },

        methods: {
            getData: function (q_id, a_id) {
                this.getAnswer(q_id, a_id);
            },

            getAnswer: function (q_id, a_id) {
                let request = '/api/questions/' + q_id + '/answers/' + a_id;

                axios.get(request)
                    .then(({
                               data
                           }) => {
                        this.answer = data;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onCommentSubmit: function () {
                if (this.commentText == '') {
                    this.showError = true;
                    return;
                } else
                    this.showError = false;

                axios.post('/api/comments/answer', {
                    'answer_id': this.answer.id,
                    'content': this.commentText,
                })
                    .then(({
                               data
                           }) => {
                        this.answer.comments.push(data);
                        this.commentText = '';
                        this.showSuccess = true;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            solve: function() {
                axios.post('/api/questions/' + this.answer.question.id + '/solve', {
                    'answerId': this.answer.id
                })
                    .then(({data}) => {
                      window.location.reload();
                    })
                    .catch(({response}) => {
                        this.errors = response.data.errors;
                        console.log(this.errors);
                    });
            },
        }
    }
</script>
