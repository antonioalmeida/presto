<template>
    <div class="mt-5">
        <div class="d-flex flex-wrap">
            <div class="align-self-center">
                <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                    <img class="rounded-circle ml-1 mr-2" width="50px" heigth="50px" :src="answer.author.profile_picture">
                </router-link>
            </div>
            <div class="ml-1">
                <router-link :to="'/profile/' + answer.author.username" class="text-dark btn-link">
                    <h5>{{ answer.author.name }}</h5>
                </router-link>
                <h6><small class="text-muted">answered {{ answer.date | moment("from") }}</small></h6>
            </div>
            <div class="ml-3">
                Follow
                <!--@include('partials.follow', ['followTarget' => answer.member])-->
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

    <div class="d-flex">
        <div>
            <a href="" class="btn"><i class="far fa-fw fa-arrow-up"></i> Upvote 
                <span class="badge badge-primary">{{ answer.upvotes }}</span> <span class="sr-only">upvote number</span>
            </a>
            <a href="" class="btn"><i class="far fa-fw fa-arrow-down"></i> Downvote <span class="badge badge-primary">{{ answer.downvotes }} </span> <span class="sr-only">downvote number</span></a>
            <a href="" class="btn">
                <i class="far fa-fw fa-comment"></i> Comment
            </a>
        </div>
    </div>

</div>

<div class="card my-3">
    <comments-list :comments="answer.comments"></comments-list>

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
<!--
<button v-b-toggle.accordion2 class="btn btn-sm btn-link">Clear</button>
-->
</div>
</div>

</div>
</div>
</template>

<script>
import CommentsList from '../components/CommentsList'

export default {

    props: ['answerData'],

    name: 'AnswerPartial',

    components: {
        'CommentsList': CommentsList
    },


    data () {
        return {
            answer: this.answerData,
            commentText: '',
            showError: false,

        }
    },

    methods: {
        onCommentSubmit: function() {
            if(this.commentText == '') {
                this.showError = true;
                return;
            }
            else 
                this.showError = false;

            axios.post('/api/comments/answer', {
                'answer_id': this.answer.id,
                'content': this.commentText,
            })
            .then(({data}) => {
                this.answer.comments.push(data);
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
