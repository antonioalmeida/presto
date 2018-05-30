<template>

    <main class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                  <h3 v-if="question.solved"><span class="badge badge-primary"><i class="far fa-fw fa-check"></i>Solved</span></h3>
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

                    <div v-else class="edit-content">
                        <input v-model="titleInput" type="text" class="form-control input-h2">
                        <input v-model="contentInput" type="text" class="form-control input-h5 mt-2">

                        <div class="mt-3">
                            <tags-input element-id="tags"
                                        v-model="tagsInput"
                                        :typeahead="true"
                                        :placeholder="'Add topics...'"
                            ></tags-input>

                            <div class="ml-1 mt-3">
                                <button @click="onEditSubmit" class="btn btn-outline-primary">Save</button>
                                <button @click="isEditing = false" class="btn btn-outline-danger">Cancel
                                </button>
                            </div>

                        </div>
                    </div>

                    <div :id="'questionAcordion'" class="mt-2">

                        <div class="mt-2 d-flex justify-content-between flex-wrap">

                            <rate-content
                                class="mt-2"
                                v-if="!question.isOwner"
                                :content="question"
                                :endpoint="rateEndpoint"
                            ></rate-content>

                            <div>
                                <b-btn v-if="!question.solved" v-b-toggle.accordion1 variant="link">
                                    <i class="far fa-fw fa-pen"></i> Answer
                                </b-btn>

                                <b-btn class="ml-auto" id="questionComment" v-if="!question.solved" v-b-toggle.accordion2 variant="link">
                                    <i class="far fa-fw fa-comment"></i> Comment
                                </b-btn>

                                <b-dropdown class="ml-auto" variant="link" id="ddown1" size="lg" no-caret right>
                                    <template slot="button-content">
                                        <span id="questionOptions"><i class="fas fa-fw fa-ellipsis-h-alt"></i>    </span>
                                        <b-tooltip target="questionOptions" title="More options"></b-tooltip>
                                    </template>

                                    <template v-if="question.isOwner">
                                        <b-dropdown-item v-if="!question.solved" @click="isEditing = true">Edit</b-dropdown-item>
                                        <b-dropdown-item v-b-modal.deleteQuestionModal>Delete</b-dropdown-item>
                                        <b-dropdown-item @click="unsolve()" v-if="question.solved">Reopen</b-dropdown-item>
                                        <b-dropdown-divider></b-dropdown-divider>
                                    </template>
                                    <b-dropdown-item v-b-modal.questionReport>Report</b-dropdown-item>
                                </b-dropdown>
                            </div>
                        </div>

                    </div>

                    <b-collapse id="accordion2" accordion="my-accordion" role="tabpanel">
                        <div class="card my-2">
                            <CommentBox v-bind:parentType="'question'" v-bind:parent="this.question"></CommentBox>
                        </div>
                    </b-collapse>

                    <div class="mt-3">
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
                    </div>

                    <div class="card my-3">
                        <comments-list :comments="question.comments"></comments-list>
                    </div>

                    <h4 class="mt-5"> {{ answers.length }} Answer(s)</h4>

                    <AnswerPartial v-for="answer in answers" v-bind:answerData="answer" v-bind:parent="question"
                                   v-on:solve-question="solve(answer.id)"
                                   :key="answer.id">
                    </AnswerPartial>

                </div>
            </div>
        </section>

        <!-- delete question modal -->
        <b-modal lazy centered
            title="Delete Question"
            id="deleteQuestionModal"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Confirm"
            cancel-title="Cancel"
            @ok="onDelete"
        >
            <h5><small>Are you sure you wish to delete this question? You cannot restore it.</small></h5>
        </b-modal>

        <!-- Report Question -->
        <report-content
            modalName="questionReport"
            type="Question"
            :endpoint="'/api/questions/' + question.id + '/report'"
        ></report-content>
    </main>
</template>

<script>
    import {Collapse, FormTextarea} from 'bootstrap-vue/es/components'
    import CommentsList from '../components/CommentsList'
    import AnswerPartial from '../components/AnswerPartial'
    import Editor from '@tinymce/tinymce-vue';
    import TagsInput from '../components/TagsInput';
    import CommentBox from '../components/CommentBox';
    import RateContent from '../components/RateContent';
    import ReportContent from '../components/ReportContent';
    import bDropdown from 'bootstrap-vue/es/components/dropdown/dropdown';
    import bTooltip from 'bootstrap-vue/es/components/tooltip/tooltip';

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
            'CommentBox': CommentBox,
            'RateContent': RateContent,
            'ReportContent': ReportContent,
            'bDropdown': bDropdown,
            'bTooltip': bTooltip,
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
                tagsInput:[],

                //error handling utils
                answerShowError: false,
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
                        document.title = this.question.title + " | Presto";
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
                        if (this.question.solved)
                            this.answers.sort((a, b) => {
                                if (a.is_chosen_answer) return -1;
                                if (b.is_chosen_answer) return 1;
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

            onEditSubmit: function() {
               axios.post('/api/questions/' + this.question.id, {
                'title': this.titleInput,
                'content': this.contentInput,
                'topics': this.tagsInput,
            })
               .then(({data}) => {
                this.question.title = data.title;
                this.question.content = data.content;
                this.question.topics = data.topics;
                this.isEditing = false;
                this.$alerts.addSuccess('Question successfully edited!');
            })
               .catch(({response}) => {
                let errors = response.data.errors;
                let messages = [];
                for (let key in errors) {
                    for (let message of errors[key]) {
                        messages.push(message);
                    }
                }
                this.$alerts.addArrayError(messages);
                });
            },

            onDelete: function() {
                axios.delete('/api/questions/' + this.question.id)
                .then(({data}) => {
                        if(data.result) {
                            this.$router.push({path: '/'});
                            this.$alerts.addSuccess('Question successfully deleted!');
                        }
                    })
                .catch(({response}) => {
                        this.errors = response.data.errors;
                        console.log(this.errors);
                    });
            },

            solve: function (chosenAnswerId) {
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

            unsolve: function () {
                axios.post('/api/questions/' + this.question.id + '/unsolve', {})
                    .then(({data}) => {
                        window.location.reload();
                    })
                    .catch(({response}) => {
                        this.errors = response.data.errors;
                        console.log(this.errors);
                    });
            }
        },

        computed: {
            rateEndpoint: function() {
                return '/api/questions/' + this.question.id + '/rate/';
            }
        }
    }
</script>
