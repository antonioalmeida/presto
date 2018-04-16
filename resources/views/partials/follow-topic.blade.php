@auth
@if(Auth::user()->isFollowingTopic($topic))
    <form method="POST" action="{{Route('api.unFollowTopic', $topic)}}">
        {{ method_field('DELETE') }}
        {{ csrf_field() }}

        <button type="submit" class="btn btn btn-outline-light btn-unfollow"> <span class="before"><i class="far fa-user"></i> Following</span> <span class="after"><i class="far fa-user-times"></i> Unfollow</span></button>
    </form>
@else
    <form method="POST" action="{{Route('api.followTopic', $topic)}}">
        {{ csrf_field() }}
        <button type="submit" class="btn btn btn-outline-light"><i class="far fa-fw fa-user-plus"></i> <span>Follow</span></button>
    </form>
@endif
@endauth