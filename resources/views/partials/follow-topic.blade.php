@auth
@if(Auth::user()->isFollowingTopic($topic))
    <form method="POST" action="{{Route('api.unFollowTopic', $topic)}}">
        {{ method_field('DELETE') }}
        {{ csrf_field() }}

        <button type="submit" class="btn btn-sm btn-light"><i class="far fa-user"></i> <span class="text-collapse">Following</span></button>
    </form>
@else
    <form method="POST" action="{{Route('api.followTopic', $topic)}}">
        {{ csrf_field() }}
        <button type="submit" class="btn btn-sm btn-outline-light"><i class="far fa-fw fa-user-plus"></i> <span class="text-collapse">Follow</span></button>
    </form>
@endif
@endauth