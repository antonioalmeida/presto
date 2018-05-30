<template>

    <div class="list-group-item">
        <div class="d-flex flex-column">
            <div class="ml-1">
                <div class="d-flex">
                    <div class="align-self-center">
                        <img class="rounded-circle mr-2" width="36" height="36"
                             :alt="comment.author.name + '\'s profile picture'"
                             :src="comment.author.profile_picture">
                    </div>
                    <div class="d-flex flex-column">

                        <span><router-link :to="'/profile/' + comment.author.username" class="btn-link"><strong>{{ comment.author.name }} </strong></router-link></span>
                        <span class="text-muted">{{ comment.date | moment("from") }}</span>
                    </div>
                </div>
            </div>
            <div class="pl-2 mt-1">
                <p class="mt-1">
                    {{ comment.content }}
                </p>
                <div v-if="!comment.author.isSelf" class="d-flex justify-content-between">
                    <div>
                        <a href="" :class="[comment.isUpvoted ? 'text-primary text-strong' : 'text-muted']" @click.stop.prevent="rateComment(1)">
                            <template v-if="comment.isUpvoted">Upvoted</template>
                            <template v-else>Upvote</template>
                        </a> 
                        <span :class="[comment.isUpvoted ? 'badge-primary' : 'badge-light']" class="badge">{{ comment.upvotes }}</span>
                        <span class="sr-only">upvote number</span>

                        <!-- divider -->
                        <span class="text-muted">&bull;</span>

                        <a href="" :class="[comment.isDownvoted ? 'text-danger text-strong' : 'text-muted']" @click.stop.prevent="rateComment(-1)">
                            <template v-if="comment.isDownvoted">Downvoted</template>
                            <template v-else>Downvote</template>
                        </a>
                        <span :class="[comment.isDownvoted ? 'badge-danger' : 'badge-light']" class="badge">{{ comment.downvotes }}</span>
                        <span class="sr-only">downvote number</span>
                    </div>
                    <div class="ml-auto">
                        <b-btn @click="$emit('report-comment', comment.id)" variant="link" class="text-muted">
                            Report
                        </b-btn>
                    </div>
                </div>
                <div v-else class="d-flex justify-content-between">
                    <div :id="'upvoteNumber' + comment.id">
                        <a class="text-muted">
                            Upvotes
                        </a> 
                        <span :class="[comment.upvotes > 0 ? 'badge-primary' : 'badge-light']" class="badge">{{ comment.upvotes }}</span>
                        <span class="sr-only">upvote number</span>
                       

                        <!-- divider -->
                        <span class="text-muted">&bull;</span>

                        <a class="text-muted">
                            Downvotes
                        </a> 
                        <span :class="[comment.downvotes > 0 ? 'badge-primary' : 'badge-light']" class="badge">{{ comment.downvotes }}</span>
                        <span class="sr-only">downvote number</span> 
                    </div>
                    <b-tooltip :target="'upvoteNumber' + comment.id" title="You can't rate your own comments"></b-tooltip>
                    <b-btn @click="$emit('delete-comment', comment.id)" variant="link" class="text-muted">
                        Delete
                    </b-btn> 
                </div>
            </div>
        </div>
    </div>
</template>

<script>

    export default {

        props: ['comment'],

        name: 'CommentCard',

        data() {
            return {}
        },

        methods: {
            displayDate: function (date) {
                return moment.fromNow(true);
            },

            rateComment: function (vote) {
                axios.post('/api/comments/' + this.comment.id + '/rate', {
                    'rate': vote,
                })
                .then(({data}) => {
                    this.comment.upvotes = data.upvotes;
                    this.comment.downvotes = data.downvotes;
                    this.comment.isUpvoted = data.isUpvoted;
                    this.comment.isDownvoted = data.isDownvoted;
                })
                .catch((error) => {
                    console.log(error);
                });
            }
        }
    }
</script>
