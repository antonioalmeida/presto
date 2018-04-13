
<div class="d-flex flex-wrap">
    <div class="align-self-center">
        <img class="rounded-circle ml-1 mr-2" width="50px" heigth="50px" src="{{ $answer->member->profile_picture }}">
    </div>
    <div class="ml-1">
        <h5>{{ $answer->member->name }}</h5>
        <h6><small class="text-muted">answered 23h ago</small></h6>
    </div>
    <div class="ml-3">
        <a href="" class="btn btn-sm btn-outline-primary"><i class="far fa-fw fa-user-plus"></i><span class="text-collapse"> Follow</span></a>
    </div>
</div>

<hr>
<div>
    <p>
        {{ $answer->content }}
    </p>

    <div class="d-flex">
        <div>
            <a href="" class="btn"><i class="far fa-fw fa-arrow-up"></i> Upvote <span class="badge badge-primary">19</span> <span class="sr-only">upvote number</span></a>
            <a href="" class="btn"><i class="far fa-fw fa-arrow-down"></i> Downvote <span class="badge badge-primary">9</span> <span class="sr-only">downvote number</span></a>
            <a href="" class="btn">
                <i class="far fa-fw fa-comment"></i> Comment
            </a>
        </div>
    </div>

</div>

<div class="card my-3">
    <div class="card-body">
        <h6><small>3 Comments</small></h6>
        <div class="d-flex list-group list-group-flush short-padding">

                @foreach ($answer->comments as $comment)
                    @include('partials.comment', ['comment' => $comment])
                @endforeach

            <div class="collapse" id="collapseExample">

                <!-- add extra comments -->
                @foreach ($answer->comments as $comment)
                    @include('partials.comment', ['comment' => $comment])
                @endforeach

            </div>

            <a class="btn btn-lg btn-link text-dark" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
                View More
            </a>

        </div>
    </div>
</div>