@extends('layouts.master')

@section('title')
    Profile | Presto
@endsection

@section('content')

    <body class="grey-background">

    <main class="mt-5" role="main">

    @include('pages.profile.profile')


    <!-- content -->
        <section class="small-container">
            <div class="container">

                <div class="row">
                    <div class="col-md-8 offset-md-2">

                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">Questions</a>
                                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false">Answers</a>
                            </div>
                        </nav>
                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
                                <!-- Questions go here -->

                                <div class="list-group">
                                    @foreach($member->questions as $question)
                                        <div onclick="location.assign('/question/{{$question->id}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                            <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                                <h4 class="mb-1">{{$question->title}}</h4>
                                                <small class="pb-1"><a href="{{Route('profile', $question->member->username)}}" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="{{$question->member->profile_picture}}">{{$question->member->name}}</a> <span class="text-muted">asked</span></small>
                                            </div>

                                            <small class="text-muted"><i class="far fa-tags"></i>
                                                @foreach($question->topics as $topic)
                                                    <a href="{{Route('topic', $topic->name)}}" class="btn-link">{{$topic->name}}</a>,
                                                @endforeach
                                            </small>
                                        </div>
                                    @endforeach
                                </div>


                            </div>
                            <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
                                <!-- answers go here -->
                                @foreach($member->answers as $answer)
                                    <div onclick="location.assign('/answer/{{$answer->id}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                            <h4 class="mb-3">{{$answer->question->title}}</h4>
                                            <div class="d-flex">
                                                <div>
                                                    <img class="rounded-circle pr-1" width="36px" heigth="36px" src="{{$answer->member->profile_picture}}">
                                                </div>
                                                <h6><a href="profile.html" class="btn-link">{{$answer->member->name}}</a><br>
                                                    <small class="text-muted">answered 23h ago</small></h6>
                                            </div>
                                        </div>
                                        <p class="mb-1">{{substr($answer->content, 0, 169)}}... <span class="btn-link text-primary">(read more)</span></p>
                                        <small class="text-muted"><i class="far fa-tags"></i>
                                            @foreach($answer->question->topics as $topic)
                                                <a href="{{Route('topic', $topic->name)}}" class="btn-link">{{$topic->name}}</a>,
                                            @endforeach
                                        </small>
                                    </div>
                                @endforeach
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </section>


    </main><!-- /.container -->

    <!-- /.container -->
    </body>

@endsection
