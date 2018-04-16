<div onclick="location.assign('/questions/{{$question->id}}');" class="list-group-item list-group-item-action flex-column align-items-start">
    <div class="d-flex w-100 justify-content-between flex-md-nowrap flex-wrap-reverse">
        <h4 class="mb-1 max-w-70">{{ $question->title }}</h4>
        <div class="pb-1">
            <small><a href="{{Route('profile', $question->member->username)}}" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="{{$question->member->profile_picture}}">{{$question->member->name}}</a> <span class="text-muted">asked</span></small>
        </div>
    </div>

    <small class="text-muted"><i class="far fa-tags"></i>
        @foreach($question->topics as $topic)
        <a href="{{Route('topic', $topic->name)}}" class="btn-link">{{$topic->name}}</a>{{$loop->last ? '' : ','}}

        @endforeach
    </small>
</div> 