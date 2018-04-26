@php
use Carbon\Carbon;
@endphp

<div class="list-group-item">
    <div class="d-flex flex-column">
        <div class="ml-1">
            <div class="d-flex">
                <div class="align-self-center">
                    <img class="rounded-circle mr-2" width="36px" heigth="36px" src="{{ $comment->member->profile_picture }}">
                </div>
                <div class="d-flex flex-column">
                <span><a href="{{Route('profile', $comment->member->username)}}" class="btn-link"><strong>{{ $comment->member->name }} </strong></a></span>
                    <span class="text-muted">{{Carbon::parse($comment->date)->diffForHumans(Carbon::now(), true)}} ago</span>
                </div>
                @can('update', $comment)
                 <div class="ml-auto ">
                 <small>
                  <a href="#" class="text-muted">Edit</a> |
                  <a href="#" class="text-danger">Delete</a>
                 </small>
                 </div>
                 @endcan
            </div>
        </div>
        <div class="pl-2 mt-1">
            <p>
               {{ $comment->content }}
            </p>
            <div class="d-flex justify-content-between">
                <div>
                    <a class="text-muted" href="">Upvote</a> <span class="text-muted">&bull;</span> <a class="text-muted" href="#">Downvote</a>
                </div>
                <div class="ml-auto">
                    <a href="#" class="text-muted"><small>Report</small></a>
                </div>
            </div>
        </div>
    </div>
</div>