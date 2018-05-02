 <div class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="notifications-card d-flex w-100 justify-content-between flex-wrap">
                                <div>
                                    <!-- <a href="" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a>
                                    <span class="text-muted">answered your question to </span>
                                    <a href="">"When did the French Revolution begin?"</a>. -->
                                    @switch($notification->data['type'])
                                        @case("Follow")
                                            <a href="profile/{{$notification->data['data']['follower_username']}}" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$notification->data['data']['follower_picture']}}">{{$notification->data['data']['follower_name']}}</a>
                                    <span class="text-muted"> started following you.</span>
                                            @break

                                        @case("Question")
                                        <a href="questions/{{$notification->data['data']['question_id']}}" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$notification->data['data']['following_picture']}}">{{$notification->data['data']['following_name']}}</a>
                                    <span class="text-muted"> posted a question.</span>
                                            @break
                                        @case("Answer")
                                        <a href="questions/{{$notification->data['data']['question_id']}}/answers/{{$notification->data['data']['answer_id']}}" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$notification->data['data']['following_picture']}}">{{$notification->data['data']['following_name']}}</a>
                                    <span class="text-muted">  answered your question: </span> {{$notification->data['data']['question_title']}}
                                            @break
            
                                        @case("Comment")
                                        <a href="questions/{{$notification->data['data']['question_id']}}@if($notification->data['data']['type']=='Answer')/answers/{{$notification->data['data']['answer_id']}}@endif" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$notification->data['data']['follower_picture']}}">{{$notification->data['data']['follower_name']}}</a>
                                    <span class="text-muted"> left a comment on your @if($notification->data['data']['type']=="Answer") answer to the @endif question: </span>
                                    $notification->data['data']['question_title']}}
                                            @break

                                        @case("Rate")
                                            Second case...
                                            @break
            
                                        @default
                                            Default case...
                                    @endswitch
</div>