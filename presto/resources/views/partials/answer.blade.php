@php
use Carbon\Carbon;
@endphp

<div class="mt-5">
<div class="d-flex flex-wrap">
    <div class="align-self-center">
        <a href="{{Route('profile', $answer->member->username)}}" class="text-dark btn-link">
            <img class="rounded-circle ml-1 mr-2" width="50px" heigth="50px" src="{{ $answer->member->profile_picture }}">
    </div>
    <div class="ml-1">
            <h5>{{$answer->member->name}}</h5>
        </a>
            <h6><small class="text-muted">answered {{Carbon::parse($answer->date)->diffForHumans(Carbon::now(), true)}} ago</small></h6>
    </div>
    <div class="ml-3">
        @include('partials.follow', ['followTarget' => $answer->member])
    </div>
    @can('update', $answer)
    <div class="ml-auto ">
                <small>
                  <a href="#" class="text-muted">Edit</a> |
                  <a href="#" class="text-danger">Delete</a>
                </small>
    </div>
    @endcan
    </div>
<hr>
<div>
    <p>
        {{ $answer->content }}
    </p>

    <div class="d-flex">
        <div>
            <!-- <a href="" class="btn"><i class="far fa-fw fa-arrow-up"></i> Upvote <span class="badge badge-primary">19</span> <span class="sr-only">upvote number</span></a> -->
            @include('partials.upvote', ['answer'=> $answer])
            <a href="" class="btn"><i class="far fa-fw fa-arrow-down"></i> Downvote <span class="badge badge-primary">9</span> <span class="sr-only">downvote number</span></a>
            <a href="" class="btn">
                <i class="far fa-fw fa-comment"></i> Comment
            </a>
        </div>
    </div>

</div>

<div class="card my-3">
    <div class="card-body">
        <h6><small>{{$answer->comments->count()}} Comments</small></h6>
        <div class="d-flex list-group list-group-flush short-padding">

            @foreach ($answer->comments as $comment)
                @if ($loop->first && !$loop->last)
                    @include('partials.comment', ['comment' => $comment])
                    <div class="collapse" id="commentCollapse{{ $answer->id}}">
                @elseif($loop->last && !$loop->first)
                    @include('partials.comment', ['comment' => $comment])
                    </div>
                @else
                    @include('partials.comment', ['comment' => $comment])
                @endif

            @endforeach

            <a class="btn btn-lg btn-link text-dark" data-toggle="collapse" href="#commentCollapse{{ $answer->id}}" role="button" aria-expanded="false" aria-controls="commentCollapse{{ $answer->id}}">
                View More
            </a>

        </div>
    </div>
</div>