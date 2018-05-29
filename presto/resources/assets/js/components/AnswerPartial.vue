<template>
    <div class="mt-4">
        <hr>
        <div v-bind:class="{'card': answer.is_chosen_answer, 'card-body': answer.is_chosen_answer, 'border-primary': answer.is_chosen_answer}">
            <h5 v-if="answer.is_chosen_answer"><span class="badge badge-primary">Chosen answer</span></h5>
            <div class="d-flex flex-wrap">
                <div class="align-self-center">
                    <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                        <img class="rounded-circle ml-1 mr-2" width="50" height="50"
                             :alt="answer.author.name + '\'s profile picture'"
                             :src="answer.author.profile_picture">
                    </router-link>
                </div>
                <div class="ml-1">
                    <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                        <h5>{{ answer.author.name }}</h5>
                    </router-link>
                    <h6>
                        <router-link :to="'/questions/' + answer.question.id + '/answers/' + answer.id"
                                     class="text-dark btn-link">
                            <small class="text-muted">answered {{ answer.date | moment("from") }}</small>
                        </router-link>
                    </h6>
                </div>
                <div class="ml-3">
                    <follow-button v-if="!answer.author.isSelf"
                                   v-model="answer.author.isFollowing"
                                   :classesDefault="'btn btn-sm btn-primary'"
                                   :classesActive="'btn btn-sm btn-outline-primary'"
                                   :path="'/api/member/' + answer.author.username + '/toggle-follow'"
                    >
                    </follow-button>
                    <button v-on:click="$emit('solve-question')" class="btn btn-primary" v-if="!parent.solved"><i
                            class="far fa-fw fa-lock-alt"></i> Choose as correct answer
                    </button>

                </div>

            </div>
            <hr>
            <div>
                <p v-if="!isEditing" v-html="answer.content"></p>
                <div v-else class="card">
                    <editor
                        v-model="editorContent"
                        :init="editorInit"
                        @onChange="answerShowError = false">
                    </editor>

                    <div class="card-footer">
                        <span v-if="answerShowError" class="text-danger"><small>You can't submit an empty answer.<br></small></span>

                        <button @click="onAnswerSubmit" class="mt-1 btn btn-sm btn-primary">Submit</button>

                        <button @click="isEditing = false" class="mt-1 btn btn-sm btn-link">Cancel</button>
                    </div>
                </div>

                <div class="mt-2 d-flex justify-content-between flex-wrap">

                    <div v-if="!answer.author.isSelf" class="d-flex">
                        <rate-content 
                        :content="answer"
                        :endpoint="rateEndpoint"
                        ></rate-content>
                    </div>

                    <b-dropdown class="ml-auto" variant="link" id="ddown1" size="lg" no-caret right>
                        <template slot="button-content">
                            <span id="questionOptions"><i class="fas fa-fw fa-ellipsis-h-alt"></i>    </span>
                            <b-tooltip target="questionOptions" title="More options"></b-tooltip>
                        </template>
                    
                        <template v-if="answer.author.isSelf">
                            <b-dropdown-item @click="isEditing = true">Edit</b-dropdown-item>
                            <b-dropdown-item v-b-modal.deleteQuestionModal>Delete</b-dropdown-item>
                            <b-dropdown-item>Reopen</b-dropdown-item>
                            <b-dropdown-divider></b-dropdown-divider>
                        </template>
                        <b-dropdown-item>Report</b-dropdown-item>
                    </b-dropdown>
                </div>

            </div>

            <div class="card my-3">
                <comments-list :comments="answer.comments"></comments-list>

                <CommentBox v-if="!parent.solved" v-bind:parentType="'answer'" v-bind:parent="this.answer"></CommentBox>
            </div>
        </div>
    </div>
</template>

<script>
    import CommentsList from './CommentsList'
    import FollowButton from './FollowButton'
    import CommentBox from './CommentBox'
    import RateContent from './RateContent'
    import Editor from '@tinymce/tinymce-vue';

    export default {

        props: ['answerData', 'parent'],

        name: 'AnswerPartial',

        components: {
            'CommentsList': CommentsList,
            'FollowButton': FollowButton,
            'CommentBox': CommentBox,
            'RateContent': RateContent,
            'Editor': Editor,
        },

        data() {
            return {
                answer: this.answerData,

                isEditing: false,
                answerShowError: false,
                editorContent: this.answerData.content,
                editorInit: require('../tiny-mce-config').default,
            }
        },

        methods: {
            onAnswerSubmit: function () {
                if (this.editorContent.length === 0) {
                    this.answerShowError = true;
                    return;
                }

                axios.post('/api/questions/' + this.answer.question.id + '/answers/' + this.answer.id, {
                    'content': this.editorContent,
                })
                .then(({data}) => {
                    this.$alerts.addSuccess('Answer successfully edited!');
                    this.answer = data;
                    this.editorContent = data.content;
                    this.isEditing = false;
                })
                .catch(({response}) => {
                    this.errors = response.data.errors;
                    this.showError = true;
                });
            },
        },

        computed: {
            rateEndpoint: function() {
                return '/api/questions/' + this.answer.question.id + '/answers/' + this.answer.id + '/rate';
            }
        }

    }
</script>
