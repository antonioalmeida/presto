@extends('layouts.master')

@section('title')
    Search | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5 mb-2">
        <section class="container wrapper mt-5">
            <div class="row">
                <div class="col-md-3 mt-2">
                    <div class="offcanvas-collapse" id="navbarsExampleDefault">
                        <div>
                            <h4 class="pt-4">Type</h4>
                            <div class="dropdown-divider"></div>
                            <div class="typeFilter">
                                <div class="form-check">
                                    <input id="checkAll" class="form-check-input" type="checkbox" id="typeFilterAll">
                                    <label class="form-check-label text-muted btn-link" for="typeFilterAll">
                                        <strong>All Types</strong>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter0">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter0">
                                        Questions
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter1">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter1">
                                        Answers
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter2">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter2">
                                        Topics
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter3">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter3">
                                        Users
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Author</h4>
                            <div class="dropdown-divider"></div>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Find People">
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Time</h4>
                            <div class="dropdown-divider"></div>
                            <div class="typeFilter">
                                <div class="form-check">
                                    <input id="checkAll" class="form-check-input" type="checkbox" id="timeFilterAll">
                                    <label class="form-check-label text-muted btn-link" for="timeFilterAll">
                                        <strong>All Time</strong>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="timeFilter0">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter0">
                                        Past Day
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="timeFilter1">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter1">
                                        Past Week
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="timeFilter2">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter2">
                                        Past Month
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="timeFilter3">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter3">
                                        Past Year
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="d-flex justify-content-between flex-wrap">
                        <h3><small class="text-muted">Results for </small> Maths</h3>
                        <button class="btn btn-link text-mobile" type="button" data-toggle="offcanvas">
                            <i class="far fa-fw fa-filter"></i> Filter
                        </button>
                    </div>
                    <div class="nav nav-tabs mt-3">
                        <a class="nav-item nav-link active" href="#">Newest</a>
                        <a class="nav-item nav-link" href="#">Oldest</a>
                        <a class="nav-item nav-link" href="#">Rating</a>
                    </div>
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
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
