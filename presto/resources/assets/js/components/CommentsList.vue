<template>
    <div class="card-body">
        <h6>
            <small>{{ comments.length > 0 ? comments.length : 'No' }} Comments</small>
        </h6>
        <div class="d-flex list-group list-group-flush short-padding">

            <comment-card @report-comment="handleReportClick($event)" v-if="comments.length > 0" :comment="comments[0]" :key="comments[0].id"></comment-card>
            <template v-if="comments.length > 1">

                <b-collapse id="collapse1" v-model="showingMore">
                    <comment-card @report-comment="handleReportClick($event)" v-for="(comment,index) in comments" v-if="index > 0" :key="comment.id"
                                  :comment="comment"></comment-card>
                </b-collapse>

                <a @click="showingMore = !showingMore" class="btn btn-lg btn-link text-dark" role="button">
                    <span v-if="!showingMore">View More</span>
                    <span v-else>Show Less</span>
                </a>
            </template>
        </div>
                <!-- Edit email modal -->
        <b-modal lazy centered
            v-model="showReportModal"
            ref="reportModal"
            title="Report Comment"
            id="reportComment"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Submit"
            cancel-title="Cancel"
            @ok="handleReportSubmit"
            >
            <b-form-input
                              type="text"
                              v-model="reportReason"
                              required
                              placeholder="Why are you flagging this comment?">
            </b-form-input>
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
            }
        },

        methods: {
            handleReportClick: function(event) {
                this.showReportModal = true;
                this.commentReportId = event;
            },

            handleReportSubmit: function(event) {
                event.preventDefault();
                axios.post('/api/comments/' + this.commentReportId + '/report', {
                    'reason': this.reportReason
                })
                .then(({data}) => {
                    this.$alerts.addSuccess('Comment successfully reported!');
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
        }
    }
</script>
