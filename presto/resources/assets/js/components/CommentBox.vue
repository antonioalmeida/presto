<template>
  <div class="card-footer">
      <b-form-textarea
              v-model="commentText"
              placeholder="Leave a comment..."
              :rows="2"
              :max-rows="6"
              :state="showError ? !showError : null" @input="showError = false; showSuccess = false;">
      </b-form-textarea>

      <span v-if="showError" class="text-danger"><small>You can't submit an empty comment.</small></span>
      <span v-if="showSuccess" class="text-primary"><small>Comment successfully added.</small></span>


      <div class="mt-2">
          <button @click="onCommentSubmit" class="btn btn-sm btn-primary">Submit</button>
          <button v-if="this.parentType=='question'" v-b-toggle.accordion2 class="btn btn-sm btn-link">Cancel</button>
      </div>
  </div>
</template>

<script>
    export default {

        props: ['parentType', 'parent'],

        name: 'CommentBox',

        components: {},

        data() {
            return {
                //parentType: this.parentType,
                //parent: this.parent,
                commentText: '',
                showError: false,
                showSuccess: false,
            }
        },

        methods: {
            onCommentSubmit: function () {
                if (this.commentText == '') {
                    this.showError = true;
                    return;
                }
                else
                    this.showError = false;

                axios.post('/api/comments/' + this.parentType + '/' + this.parent.id, {
                    'content': this.commentText,
                })
                    .then(({data}) => {
                        this.parent.comments.unshift(data);
                        this.commentText = '';
                        this.showSuccess = true;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }
        }

    }
</script>
