<template>
    <div class="mt-4">
        <hr>
        <div class="d-flex flex-wrap">
            <div class="align-self-center">
                <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                    <img class="rounded-circle ml-1 mr-2" width="50px" heigth="50px"
                         :src="answer.author.profile_picture">
                </router-link>
            </div>
            <div class="ml-1">
                <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                    <h5>{{ answer.author.name }}</h5>
                </router-link>
                <h6>
                    <router-link :to="'/questions/' + answer.question.id + '/answers/' + answer.id" class="text-dark btn-link">
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
                <button v-on:click="$emit('solve-question')" class="btn btn-primary" v-if="!parent.solved"><i class="far fa-fw fa-lock-alt"></i> Choose as correct answer</button>

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
            <p v-if="answer.is_chosen_answer">
              I AM THE CHOSEN ONE
            </p>
            <p v-html="answer.content">
            </p>

            <div v-if="!answer.author.isSelf" class="d-flex">
                <div>
                    <a @click.stop.prevent="rateAnswer(1)" class="btn" :class="{'text-primary text-strong' : answer.isUpvoted}"><i class="far fa-fw fa-arrow-up"></i>
                        <template v-if="answer.isUpvoted">Upvoted</template>
                        <template v-else>Upvote</template>
                        <span :class="[answer.isUpvoted ? 'badge-primary' : 'badge-light']" class="badge">{{ answer.upvotes }}</span> <span class="sr-only">upvote number</span>
                    </a>
                    <a @click.stop.prevent="rateAnswer(-1)" class="btn"  :class="{'text-danger text-strong' : answer.isDownvoted}"><i class="far fa-fw fa-arrow-down"></i>
                        <template v-if="answer.isDownvoted">Downvoted</template>
                        <template v-else>Downvote</template>
                        <span :class="[answer.isDownvoted ? 'badge-danger' : 'badge-light']" class="badge">{{ answer.downvotes }} </span> <span class="sr-only">downvote number</span></a>
                </div>
            </div>

        </div>

        <div class="card my-3">
            <comments-list :comments="answer.comments"></comments-list>

            <CommentBox v-if="!parent.solved" v-bind:parentType="'answer'" v-bind:parent="this.answer"></CommentBox>
        </div>
    </div>
</template>

<script>
    import CommentsList from '../components/CommentsList'
    import FollowButton from '../components/FollowButton'
    import CommentBox from './CommentBox'

    export default {

        props: ['answerData', 'parent'],

        name: 'AnswerPartial',

        components: {
            'CommentsList': CommentsList,
            'FollowButton': FollowButton,
            'CommentBox': CommentBox
        },


        data() {
            return {
                answer: this.answerData
            }
        },

        methods: {
            rateAnswer: function (vote) {
                axios.post('/api/questions/' + this.answer.question.id + '/answers/' + this.answer.id + '/rate', {
                    'rate': vote,
                })
                    .then(({data}) => {
                        this.answer.isUpvoted = data.isUpvoted;
                        this.answer.isDownvoted = data.isDownvoted;
                        this.answer.upvotes = data.upvotes;
                        this.answer.downvotes = data.downvotes;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }

        }

    }
</script>
