@auth
@if(Auth::user()->id != $follower->id)
@if(Auth::user()->isFollowing($follower))
    <form method="POST" action="{{Route('api.unFollow', $follower)}}">
        {{ method_field('DELETE') }}
        {{ csrf_field() }}
        <button type="submit" class="btn btn-sm btn-primary"><i class="far fa-user"></i> <span class="text-collapse">Following</span></button>
    </form>
@else
    <form method="POST" action="{{Route('api.follow', $follower)}}">
        {{ csrf_field() }}
        <button type="submit" class="btn btn-sm btn-outline-primary"><i class="far fa-fw fa-user-plus"></i> <span class="text-collapse">Follow</span></button>
    </form>
@endif
@endif
@endauth