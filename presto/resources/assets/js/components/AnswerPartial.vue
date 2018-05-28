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
                <!--
                @can('update', $answer)
                <div class="ml-auto ">
                    <small>
                      <a href="#" class="text-muted">Edit</a> |
                      <a href="#" class="text-danger">Delete</a>
                  </small>
              </div>
              @endcan
          -->

            </div>
            <hr>
            <div>
                <p v-html="answer.content">
                </p>

                <div v-if="!answer.author.isSelf" class="d-flex">
                    <rate-content 
                    :content="answer"
                    :endpoint="rateEndpoint"
                    ></rate-content>
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

    export default {

        props: ['answerData', 'parent'],

        name: 'AnswerPartial',

        components: {
            'CommentsList': CommentsList,
            'FollowButton': FollowButton,
            'CommentBox': CommentBox,
            'RateContent': RateContent
        },


        data() {
            return {
                answer: this.answerData,
            }
        },

        computed: {
            rateEndpoint: function() {
                return '/api/questions/' + this.answer.question.id + '/answers/' + this.answer.id + '/rate';
            }
        }

    }
</script>
