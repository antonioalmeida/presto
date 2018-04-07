@extends('layouts.master')

@section('title')
    Topic | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main class="mt-5" role="main">

        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" src="assets/img/history.jpg"/>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow">
                            <h1>History</h1>

                            <!-- bio -->
                            <div class="bio mt-3">
                                <div class="d-flex justify-content-sm-start justify-content-around">
                                    <h5 class="p-2">632k <small>followers</small></h5>
                                </div>
                                <p class="lead lead-adapt">
                                    The study of the past as it is described in written documents.
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
                                        <h6>1.2M <small class="text-muted">answer views</small></h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-question"></i>
                                        </div>
                                        <h6>456 <small class="text-muted">questions</small></h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-book"></i>
                                        </div>
                                        <h6>845 <small class="text-muted">answers</small></h6>
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
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                <h4 class="mb-1">When did the French revolution begin?</h4>
                                <small class="pb-1"><span class="btn-link"><img class="user-preview rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</span> <span class="text-muted">asked</span></small>
                            </div>
                            <small class="text-muted"><i class="far fa-tags"></i> <span class="btn-link text-muted">History</span>, <span class="btn-link">Education</span></small>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between flex-wrap-reverse">
                                <h4 class="mb-1">In what year was Brazil discovered?</h4>
                                <small><span class="btn-link"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</span> <span class="text-muted">asked</span></small>
                            </div>
                            <small class="text-muted"><i class="far fa-tags"></i> <span class="btn-link text-muted">History</span>, <span class="btn-link">Education</span></small>
                        </a>
                        <a href="" class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="d-flex w-100 justify-content-between flex-column mb-1">
                                <h4 class="mb-3">Who fought in the Hundred Years' War?</h4>
                                <div class="d-flex">
                                    <div>
                                        <img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                    </div>
                                    <h6><span class="btn-link">António Almeida</span><br>
                                        <small class="text-muted">answered 23h ago</small></h6>
                                </div>
                            </div>
                            <div class="row answer-preview">
                                <div class="answer-text-preview col-sm mb-1">
                                    <p class="mb-1">The Hundred Years' War was a series of conflicts waged from 1337 to 1453 by the House of Plantagenet, rulers of the Kingdom of England, against the House of Valois, rulers of the Kingdom of France, over the succession to the French throne. Each side drew many allies into the war. It was one of the most notable conflicts of the Middle Ages, in which five generations of kings from two rival dynasties fought for the throne of the largest kingdom in Western Europe. The war marked both the height of chivalry and its subsequent decline, and the development of strong national identities in both countries. <span class="btn-link text-primary">(read more)</span></p>
                                </div>
                                <div class="answer-image-preview col-sm-4">
                                    <img class="rounded" src="https://cdn.history.com/sites/2/2016/04/Battle_of_crecy_froissart-E.jpeg">
                                </div>
                            </div>
                            <small class="text-muted"><i class="far fa-tags"></i> <span class="btn-link text-muted">History</span>, <span class="btn-link">Education</span></small>
                        </a>

                    </div>
                </div>
            </div>
        </section>


    </main><!-- /.container -->
    <!-- /.container -->
    </body>

@endsection
