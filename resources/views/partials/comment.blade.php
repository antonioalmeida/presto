<div class="list-group-item">
    <div class="d-flex flex-column">
        <div class="ml-1">
            <div class="d-flex">
                <div class="align-self-center">
                    <img class="rounded-circle mr-2" width="36px" heigth="36px" src="{{ $comment->member->profile_picture }}">
                </div>
                <div class="d-flex flex-column">
                    <span><strong>{{ $comment->member->name }} </strong></span>
                    <span class="text-muted">5h ago</span>
                </div>
            </div>
        </div>
        <div class="pl-2 mt-1">
            <p>
               {{ $comment->content }}
            </p>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.  Phasellus eu orci quis erat rhoncus feugiat eget congue leo.</p>
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