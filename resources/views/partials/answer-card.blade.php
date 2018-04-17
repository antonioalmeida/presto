@php
use Carbon\Carbon;
@endphp

<div onclick="location.assign('/questions/{{$answer->question->id}}/answers/{{$answer->id}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                            <h4 class="mb-3">{{$answer->question->title}}</h4>
                                            <div class="d-flex">
                                                <div>
                                                    <img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$answer->member->profile_picture}}">
                                                </div>
                                                <h6><a href="{{Route('profile', $answer->member->username)}}" class="btn-link">{{$answer->member->name}}</a><br>
                                                    <small class="text-muted">answered {{Carbon::parse($answer->date)->diffForHumans(Carbon::now(), true)}} ago</small></h6>
                                            </div>
                                        </div>
                                        <p class="mb-1">{{substr($answer->content, 0, 169)}}{{(strlen($answer->content)>169 ? '...' : '')}}<span href="/questions/{{$answer->question->id}}/answers/{{$answer->id}}" class="btn-link text-primary">(read more)</span></p>
                                        <small class="text-muted"><i class="far fa-tags"></i>
                                            @forelse ($answer->question->topics as $topic)
                                            <a class="text-muted" href="{{Route('topic', $topic->name)}}">{{ $topic->name }}</a>{{$loop->last ? '' : ','}}
                                            @empty
                                            <span class="text-muted">No topics</span>
                                            @endforelse
                                        </small>
                                    </div>