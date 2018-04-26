<form method="POST" action="{{Route('api.upvoteAnswer', ['question' => $answer->question, 'answer' => $answer])}}">
        {{ csrf_field() }}
       <button type="submit" class="btn"><i class="far fa-fw fa-arrow-up"></i> Upvote <span class="badge badge-primary">{{$answer->answerRatings->count()}}</span> <span class="sr-only">upvote number</span></button>
</form>