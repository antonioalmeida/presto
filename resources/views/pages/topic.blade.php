@extends('layouts.master')

@section('title')
    Topic | Presto
@endsection

@section('content')
    @php
    $answers = $topic->getAnswersStats();
    @endphp

    <body class="grey-background">
    <main class="mt-5" role="main">

        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" src="{{$topic->picture}}"/>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow">
                            <h1>{{$topic->name}}</h1>

                            <!-- bio -->
                            <div class="bio mt-3">
                                <div class="d-flex justify-content-sm-start justify-content-around">
                                    <h5 class="p-2">{{$topic->getNumFollowers()}} <small>followers</small></h5>
                                </div>
                                <p class="lead lead-adapt">
                                    {{$topic->description}}
                                </p>
                                <a href="" class="btn btn-outline-light"><i class="far fa-user-plus fa-fw"></i> Follow</a>

                            </div>

                        </div>

                        <div class="col-md-3 mt-3">
                            <div class="card card-body">
                                <h5 class="text-dark">Stats</h5>
                                <div class="dropdown-divider"></div>
                                <div class="d-flex flex-column justify-content-around flex-wrap">
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-eye"></i>
                                        </div>
                                        <h6>{{$answers['views']}} <small class="text-muted">answer views</small></h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-question"></i>
                                        </div>
                                        <h6>{{$topic->questions->count()}} <small class="text-muted">questions</small></h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-book"></i>
                                        </div>
                                        <h6>{{$answers['number']}} <small class="text-muted">answers</small></h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- content -->
        <section class="container wrapper mt-4 mb-2">
            <div class="row">

                <div class="col-md-2 text-right text-collapse side-menu">
                    <h6 class="">Related Topics</h6>
                    <ul class="no-bullets">
                        <li><a href="" class="text-muted">French History</a></li>
                        <li><a href="" class="text-muted">Prehistory</a></li>
                        <li><a href="" class="text-muted">Science</a></li>
                        <li><a href="" class="text-muted">Napoleon</a></li>
                    </ul>
                </div>

                <div class="col-md-8">
                    <div class="nav nav-tabs">
                        <a class="nav-item nav-link active" href="#">Newest</a>
                        <a class="nav-item nav-link" href="#">Oldest</a>
                        <a class="nav-item nav-link" href="#">Rating</a>
                    </div>

                    <div class="list-group">
                        @foreach($topic->questions as $question)
                            <div onclick="location.assign('/questions/{{$question->id}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                    <h4 class="mb-1">{{substr($question->title,0,38)}}{{(strlen($question->title)>39? '...' : '')}}</h4>
                                    <small class="pb-1"><a href="{{Route('profile', $question->member->username)}}" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="{{$question->member->profile_picture}}">{{$question->member->name}}</a> <span class="text-muted">asked</span></small>
                                </div>

                                <small class="text-muted"><i class="far fa-tags"></i>
                                    @foreach($question->topics as $topic)
                                        <a href="{{Route('topic', $topic->name)}}" class="btn-link">{{$topic->name}}</a>{{$loop->last ? '' : ','}}

                                    @endforeach
                                </small>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </section>


    </main><!-- /.container -->
    <!-- /.container -->
    </body>

@endsection
