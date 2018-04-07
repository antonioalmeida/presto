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

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>


                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
                                        </div>
                                        <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                    </div>

                                </div>


                            </div>
                            <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
                                <!-- answers go here -->
                                <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                    <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                        <h4 class="mb-3">Where has Math been invented?</h4>
                                        <div class="d-flex">
                                            <div>
                                                <img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                            </div>
                                            <h6><a href="profile.html" class="btn-link">António Almeida</a><br>
                                                <small class="text-muted">answered 23h ago</small></h6>
                                        </div>
                                    </div>
                                    <p class="mb-1">The history of mathematics can be seen as an ever-increasing series of abstractions. The first abstraction, which is shared by many animals, was probably that of numbers... <span class="btn-link text-primary">(read more)</span></p>
                                    <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                </div>

                                <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                    <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                        <h4 class="mb-3">Where has Math been invented?</h4>
                                        <div class="d-flex">
                                            <div>
                                                <img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                            </div>
                                            <h6><a href="profile.html" class="btn-link">António Almeida</a><br>
                                                <small class="text-muted">answered 23h ago</small></h6>
                                        </div>
                                    </div>
                                    <div class="row answer-preview">
                                        <div class="answer-text-preview col-sm mb-1">
                                            <p class="mb-1">The history of mathematics can be seen as an ever-increasing series of abstractions. The first abstraction, which is shared by many animals, was probably the realization that a collection of two apples and a collection of two oranges (for example) have something in common, namely quantity of their members. <span class="btn-link text-primary">(read more)</span></p>
                                        </div>
                                        <div class="answer-image-preview col-sm-4">
                                            <img class="rounded" src="https://upload.wikimedia.org/wikipedia/commons/1/1a/Kapitolinischer_Pythagoras_adjusted.jpg">
                                        </div>
                                    </div>
                                    <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                </div>

                                <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                    <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                        <h4 class="mb-3">Where has Math been invented?</h4>
                                        <div class="d-flex">
                                            <div>
                                                <img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                            </div>
                                            <h6><a href="profile.html" class="btn-link">António Almeida</a><br>
                                                <small class="text-muted">answered 23h ago</small></h6>
                                        </div>
                                    </div>
                                    <div class="row answer-preview">
                                        <div class="answer-text-preview col-sm mb-1">
                                            <p class="mb-1">The history of mathematics can be seen as an ever-increasing series of abstractions. The first abstraction, which is shared by many animals, was probably the realization that a collection of two apples and a collection of two oranges (for example) have something in common, namely quantity of their members. <span class="btn-link text-primary">(read more)</span></p>
                                        </div>
                                        <div class="answer-image-preview col-sm-4">
                                            <img class="rounded" src="https://upload.wikimedia.org/wikipedia/commons/a/af/Abacus_6.png">
                                        </div>
                                    </div>
                                    <small class="text-muted"><i class="far fa-tags"></i> <a href="topic.html" class="btn-link">Science</a>, <a href="topic.html" class="btn-link">Education</a></small>
                                </div>

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
