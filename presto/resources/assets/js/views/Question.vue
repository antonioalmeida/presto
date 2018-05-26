<template>

    <main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">

                    <template v-if="!isEditing">
                        <h1>{{ question.title }}</h1>
                        <h4>
                            <small>{{ question.content }}</small>
                        </h4>
                        <h5>
                            <small class="text-muted"><i class="far fa-fw fa-tags"></i>

                                <router-link v-for="(topic, index) in question.topics" :key="topic.id"
                                             :to="'/topic/' + topic.name" class="text-muted">
                                    {{ topic.name }}
                                    <template v-if="index != question.topics.length -1">,</template>
                                </router-link>

                                <span v-if="question.topics.length === 0" class="text-muted">No topics</span>

                            </small>
                        </h5>
                    </template>

                    <div v-else="isEditing" class="edit-profile">
                        <input v-model="titleInput" type="text" class="form-control input-h2">
                        <input v-model="contentInput" type="text" class="form-control input-h5 mt-2">

                        <div class="mt-3">
                          <tags-input element-id="tags"
                          v-model="tagsInput"
                          :typeahead="true"
                          :placeholder="'Add topics...'"
                          ></tags-input>

                            <div class="ml-1 mt-3">
                                <button @click="" class="btn btn-light">Save</button>
                                <button @click="isEditing = false" class="btn btn-danger">Cancel
                                </button>
                            </div>

                        </div>
                    </div>


                    <div class="card my-3">
                        <comments-list :comments="question.comments"></comments-list>
                    </div>

                    <div :id="'questionAcordion'" class="mt-3">

                        <div class="d-flex justify-content-between flex-wrap">

                            <div>

                                <b-btn v-if="!question.solved" href="#" v-b-toggle.accordion1 variant="primary">
                                    <i class="far fa-fw fa-pen"></i> Answer
                                </b-btn>

                                <b-btn v-if="!question.solved" href="#" v-b-toggle.accordion2 variant="outline-primary">
                                    <i class="far fa-fw fa-comment"></i> Comment
                                </b-btn>

                                <button v-on:click="unsolve()" class="btn btn-primary" v-if="question.solved"><i class="far fa-fw fa-unlock-alt"></i> Reopen</button>
                            </div>


                            <div v-show="question.isOwner" class="ml-auto mt-2">
                                <small>
                                    <a href="#" @click="isEditing = true" class="text-muted">Edit</a> |
                                    <a class="text-danger">Delete</a>
                                </small>
                            </div>
                        </div>

                    </div>

                    <div class="mt-3" role="tablist">
                        <b-collapse id="accordion1" accordion="my-accordion" role="tabpanel">

                            <div class="card">

                                <editor
                                        v-model="editorContent"
                                        :init="editorInit"
                                        @onChange="answerShowError = false">
                                </editor>

                                <div class="card-footer">
                                    <span v-if="answerShowError" class="text-danger"><small>You can't submit an empty answer.<br></small></span>

                                    <button @click="onAnswerSubmit" class="mt-1 btn btn-sm btn-primary">Submit</button>

                                    <button v-b-toggle.accordion1 class="mt-1 btn btn-sm btn-link">Cancel</button>
                                </div>
                            </div>

                        </b-collapse>

                        <b-collapse id="accordion2" accordion="my-accordion" role="tabpanel">
                          <CommentBox v-bind:parentType="'question'" v-bind:parent="this.question"></CommentBox>
                        </b-collapse>
                    </div>

                    <h4 class="mt-5"> {{ answers.length }} Answer(s)</h4>

                    <AnswerPartial v-for="answer in answers" v-bind:answerData="answer" v-bind:parent="question" v-on:solve-question="solve(answer.id)"
                                   :key="answer.id"></AnswerPartial>

                </div>
            </div>
        </section>
    </main>
</template>

<script>
    import {Collapse, FormTextarea} from 'bootstrap-vue/es/components'
    import CommentsList from '../components/CommentsList'
    import AnswerPartial from '../components/AnswerPartial'
    import Editor from '@tinymce/tinymce-vue';
    import TagsInput from '../components/TagsInput';
    import CommentBox from '../components/CommentBox';

    export default {

        props: ['id', 'created'],

        name: 'Question',

        created() {
            document.title = "Question | Presto";
        },

        components: {
            'Collapse': Collapse,
            'CommentsList': CommentsList,
            'FormTextarea': FormTextarea,
            'Editor': Editor,
            'AnswerPartial': AnswerPartial,
            'TagsInput': TagsInput,
            'CommentBox': CommentBox
        },

        data() {
            return {
                question: {
                    comments: [],
                    topics: [],
                },
                answers: {},
                editorInit: require('../tiny-mce-config').default,
                editorContent: '',
                isEditing: false,

                //editing data
                titleInput: '',
                contentInput: '',

                //error handling utils
                answerShowError: false
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getData(this.id);
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getData(to.params.id);
            }
        },

        methods: {
            getData: function (id) {
                this.getQuestion(id);
                this.getAnswers(id);
            },

            getQuestion: function (id) {
                axios.get('/api/questions/' + id)
                    .then(({data}) => {
                        this.question = data;

                        this.titleInput = data.title;
                        this.contentInput = data.content;
                        this.tagsInput = data.topics.map(tag => tag.name);
                        /*
                        this.tagsInput =  data.topics.reduce(function(result, item, index, array) {
                           result[item] = item;
                           return result;
                       }, {});
                       */
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getAnswers: function (questionId) {
                let request = '/api/questions/' + questionId + '/answers';

                axios.get(request)
                    .then(({data}) => {
                        this.answers = data;
                        //Guarantee that, if there is a chosen answer, it comes first
                        if(this.question.solved)
                          this.answers.sort((a,b) => {
                            if(a.is_chosen_answer) return -1;
                            if(b.is_chosen_answer) return 1;
                            return a.date - b.date;
                          });

                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onAnswerSubmit: function () {
                if (this.editorContent.length === 0) {
                    this.answerShowError = true;
                    return;
                }

                axios.post('/api/questions/' + this.question.id + '/answers/', {
                    'content': this.editorContent,
                })
                    .then(({data}) => {
                        console.log(data);
                        this.answers.push(data);
                        this.editorContent = '';

                    })
                    .catch(({response}) => {
                        this.errors = response.data.errors;
                        this.showError = true;
                    });

            },

            solve: function(chosenAnswerId) {
                axios.post('/api/questions/' + this.question.id + '/solve', {
                    'answerId': chosenAnswerId
                })
                    .then(({data}) => {
                      window.location.reload();
                    })
                    .catch(({response}) => {
                        this.errors = response.data.errors;
                        console.log(this.errors);
                    });
            },

            unsolve: function() {
              axios.post('/api/questions/' + this.question.id + '/unsolve', {
              })
                  .then(({data}) => {
                    window.location.reload();
                  })
                  .catch(({response}) => {
                      this.errors = response.data.errors;
                      console.log(this.errors);
                  });
            }
        }
    }
</script>
