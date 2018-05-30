<template>
    <div class="card-body">
        <h6>
            <small>{{ comments.length > 0 ? comments.length : 'No' }} comments</small>
        </h6>
        <div class="d-flex list-group list-group-flush short-padding">

            <comment-card 
                @report-comment="onReportClick($event)" 
                @delete-comment="onDeleteClick($event)" 
                v-if="comments.length > 0" 
                :comment="comments[0]" 
                :key="comments[0].id">
            </comment-card>
            <template v-if="comments.length > 1">

                <b-collapse id="collapse1" v-model="showingMore">
                    <comment-card 
                        @report-comment="onReportClick($event)" 
                        @delete-comment="onDeleteClick($event)" 
                        v-for="(comment,index) in comments" 
                        v-if="index > 0" 
                        :key="comment.id"
                        :comment="comment">
                    </comment-card>
                </b-collapse>

                <a @click="showingMore = !showingMore" class="btn btn-lg btn-link text-dark" role="button">
                    <span v-if="!showingMore">View More</span>
                    <span v-else>Show Less</span>
                </a>
            </template>
        </div>

        <!-- report comment modal -->
        <b-modal lazy centered
            v-model="showReportModal"
            ref="reportModal"
            title="Report Comment"
            id="reportComment"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Submit"
            cancel-title="Cancel"
            @ok="onReportSubmit"
            >
            <b-form-input
                  type="text"
                  v-model="reportReason"
                  required
                  placeholder="Why are you flagging this comment?">
            </b-form-input>
        </b-modal>

        <!-- delete comment modal -->
        <b-modal lazy centered
            v-model="showDeleteModal"
            title="Delete Comment"
            id="deleteComment"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Confirm"
            cancel-title="Cancel"
            @ok="onDeleteComment"
        >
          <h5><small>Are you sure you wish to delete this comment? You cannot restore it.</small></h5>
        </b-modal>
    </div>
</template>

<script>
    import CommentCard from './CommentCard'
    import {Collapse} from 'bootstrap-vue/es/components'

    export default {

        props: ['comments'],

        components: {
            'CommentCard': CommentCard,
            'Collapse': Collapse
        },

        name: 'CommentsList',

        data() {
            return {
                showingMore: false,

                reportReason: '',
                showReportModal: false,
                commentReportId: -1,

                showDeleteModal:false,
                deleteCommentId: -1,
            }
        },

        methods: {
            onReportClick: function(event) {
                this.showReportModal = true;
                this.commentReportId = event;
            },

            onReportSubmit: function(event) {
                event.preventDefault();
                axios.post('/api/comments/' + this.commentReportId + '/report', {
                    'reason': this.reportReason
                })
                .then(({data}) => {
                    if(data.error != null){
                        this.$alerts.addError(data.error );
                    } else {
                        this.$alerts.addSuccess('Comment successfully reported!');
                    }
                    this.$refs.reportModal.hide();
                })
                 .catch(({response}) => {
                    let messages = [];
                    let errors = response.data.errors;
                    for (let key in errors) {
                        for (let message of errors[key]) {
                            messages.push(message);
                        }
                    }
                    this.$alerts.addArrayError(messages);
                });
            },

            onDeleteComment: function() {
                axios.delete('/api/comments/' + this.deleteCommentId)
                .then(({data}) => {
                        if(data.result) {
                            this.$emit('delete-comment', this.deleteCommentId);
                            this.$alerts.addSuccess('Comment successfully deleted!');
                        }
                    })
                .catch(({response}) => {
                        this.errors = response.data.errors;
                        console.log(this.errors);
                    });
            },

            onDeleteClick: function(event) {
                this.showDeleteModal = true;
                this.deleteCommentId = event;
            }
        }
    }
</script>
