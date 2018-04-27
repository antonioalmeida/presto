@extends('layouts.master')

@section('title')
    Presto
@endsection

@section('content')

    <body class="grey-background">
    <main class="mt-5" role="main">
        @guest
        <section class="jumbotron">
            <div class="container">
                <div class="row">
                    <div class="col-sm-7 align-self-center my-3 text-shadow">
                        <h1>Be a part of the knowledge community.</h1>
                        <h3><small>Join <strong>Presto</strong> and help grow the world's knowledge.</small></32>
                    </div>
                    <div class="col-sm-5 align-self-center">
                        <div class="card sign-up-card">
                            <div class="card-body">
                                <div class="d-flex align-items-center flex-column">
                                     <div class="m-2 g-signin2" data-width="254" data-height="40" data-longtitle="true"></div>
            
                                    <div class="fb-login-button m-2" data-max-rows="1" data-size="large" data-button-type="continue_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false"></div>
                                </div>

                                <div class="d-flex justify-content-center">
                                    <h6 class="text-muted"><small>OR</small></h6>
                                </div>

                                <form id="indexSignupForm" method="POST" action="{{Route('signup')}}">
                                    {{ csrf_field() }}
                                    <div class="input-group mb-2">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text"><i class="far fa-user"></i></div>
                                        </div>
                                        <input name="username" type="text" class="form-control" id="inlineFormInputGroup" placeholder="Your Username">
                                    </div>

                                    <div class="input-group mb-2">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text"><i class="far fa-at"></i></div>
                                        </div>
                                        <input name="email" type="text" class="form-control" id="inlineFormInputGroup" placeholder="your@email.com">
                                    </div>

                                    <div class="input-group mb-2">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text"><i class="far fa-key"></i></div>
                                        </div>
                                        <input name="password" type="password" class="form-control" id="passwordForm" placeholder="Password">
                                        <input name="password_confirmation" type="hidden" id="passwordFormConfirmed">
                                    </div>
                                    <div class="form-check mb-2 mx-1">
                                        <input name="terms" class="form-check-input" type="checkbox" id="defaultCheck1" required>
                                        <label class="form-check-label" for="defaultCheck1">
                                            <small>I accept Presto's <a href="">Terms and Conditions</a>.</small>
                                        </label>
                                    </div>
                                    <div class="d-flex justify-content-center">
                                        <button type="submit" class="btn btn-primary">Sign Up</button>
                                    </div>

                                    @include ('includes.errors')

                                </form>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </section>
        @endguest
        <!-- content -->
            <!-- content -->
            <section class="container">
                <div class="row mt-5">
                    <div class="col-md-2 text-right side-menu text-collapse">
                        <h6>Trending Topics</h6>
                        <ul class="no-bullets">
                            <li><a href="" class="text-muted">Science</a></li>
                            <li><a href="" class="text-muted">Education</a></li>
                            <li><a href="" class="text-muted">Sports</a></li>
                            <li><a href="" class="text-muted">Design</a></li>
                            <li><a href="" class="text-muted">Entertainment</a></li>
                            <li><a href="" class="text-muted">Bodybuilding</a></li>
                        </ul>
                    </div>
                    <div class="col-md-7">
                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">Top</a>
                                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false">New</a>
                                @auth
                                <a class="nav-item nav-link" id="nav-recommended-tab" data-toggle="tab" href="#nav-recommended" role="tab" aria-controls="nav-recommended" aria-selected="false">Recommended</a>
                                @endauth
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

                                <div class="list-group">

                                    <div onclick="location.assign('answer.html');" class="list-group-item list-group-item-action flex-column align-items-start">
                                        <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                            <h4 class="mb-1">How is Maths taught?</h4>
                                            <small class="pb-1"><a href="profile.html" class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a> <span class="text-muted">asked</span></small>
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
                            @auth
                            <div class="tab-pane fade" id="nav-recommended" role="tabpanel" aria-labelledby="nav-recommended-tab">
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
                            @endauth
                        </div>
                    </div>


                    <div class="col-md-3 side-menu text-collapse">
                        <div class="card">
                            <div class="card-body">
                                <h6>Who to Follow</h6>
                                <div class="list-group list-group-flush short-padding">
                                    <div class="list-group-item d-flex justify-content-begin">
                                        <div class="align-self-center">
                                            <img class="user-preview rounded-circle mr-2" width="50px" heigth="50px" src="assets/img/portrait-man2.jpeg">
                                        </div>
                                        <div>
                                            <a href="" class="text-dark">João Damas</a>
                                            <br>
                                            <span class="text-muted"><i class="fas fa-gem text-primary"></i> 1.2k points</span>
                                        </div>
                                        <div class="ml-auto align-self-center">
                                            <a href=""><i class="far fa-fw fa-user-plus"></i></a>
                                        </div>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-begin">
                                        <div class="align-self-center">
                                            <img class="user-preview rounded-circle mr-2" width="50px" heigth="50px" src="assets/img/portrait-man2.jpeg">
                                        </div>
                                        <div>
                                            <a href="" class="text-dark">João Damas</a>
                                            <br>
                                            <span class="text-muted"><i class="fas fa-gem text-primary"></i> 1.2k points</span>
                                        </div>
                                        <div class="ml-auto align-self-center">
                                            <a href=""><i class="far fa-fw fa-user-plus"></i></a>
                                        </div>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-begin">
                                        <div class="align-self-center">
                                            <img class="user-preview rounded-circle mr-2" width="50px" heigth="50px" src="assets/img/portrait-man2.jpeg">
                                        </div>
                                        <div>
                                            <a href="" class="text-dark">João Damas</a>
                                            <br>
                                            <span class="text-muted"><i class="fas fa-gem text-primary"></i> 1.2k points</span>
                                        </div>
                                        <div class="ml-auto align-self-center">
                                            <a href=""><i class="far fa-fw fa-user-plus"></i></a>
                                        </div>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-begin">
                                        <div class="align-self-center">
                                            <img class="user-preview rounded-circle mr-2" width="50px" heigth="50px" src="assets/img/portrait-man2.jpeg">
                                        </div>
                                        <div>
                                            <a href="" class="text-dark">João Damas</a>
                                            <br>
                                            <span class="text-muted"><i class="fas fa-gem text-primary"></i> 1.2k points</span>
                                        </div>
                                        <div class="ml-auto align-self-center">
                                            <a href=""><i class="far fa-fw fa-user-plus"></i></a>
                                        </div>
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