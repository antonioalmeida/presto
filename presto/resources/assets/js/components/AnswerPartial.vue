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
    <p>
        {{ answer.content }}
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

</div>
</div>
</div>
</template>

<script>
import CommentsList from '../components/CommentsList'

export default {

    props: ['answer'],

    name: 'AnswerPartial',

    components: {
        'CommentsList': CommentsList
    },

    data () {
        return {

        }
    }
}
</script>
