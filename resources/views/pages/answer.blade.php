@extends('layouts.master')

@section('title')
    Answer | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>Where has Math been invented?</h1>
                    <h4><small>This is the question's description.</small></h4>
                    <h5><small class="text-muted"><i class="far fa-fw fa-tags"></i> <a class="text-muted" href="">Education</a>, <a class="text-muted" href="">Science</a></small></h5>

                    <hr>

                    <div class="mt-4">

                        <div class="d-flex flex-wrap">
                            <div class="align-self-center">
                                <img class="rounded-circle ml-1 mr-2" width="50px" heigth="50px" src="assets/img/portrait-man.jpeg">
                            </div>
                            <div class="ml-1">
                                <h5>António Almeida</h5>
                                <h6><small class="text-muted">answered 23h ago</small></h6>
                            </div>
                            <div class="ml-3">
                                <a href="" class="btn btn-sm btn-outline-primary"><i class="far fa-fw fa-user-plus"></i><span class="text-collapse"> Follow</span></a>
                            </div>
                        </div>

                        <hr>
                        <div>
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper. Phasellus eu orci quis erat rhoncus feugiat eget congue leo. Cras aliquam purus felis, sit amet accumsan purus dapibus ac. Praesent volutpat imperdiet mattis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Proin in ex eu arcu maximus efficitur. Etiam ac lectus eu ipsum sodales lobortis et sit amet magna. Ut venenatis purus non risus tempor malesuada.
                            </p>

                            <p>
                                Nullam nunc eros, pharetra eu felis sit amet, hendrerit pretium enim. Etiam malesuada leo tortor, in rutrum justo feugiat ac. Ut dapibus neque et ante semper, in pellentesque sapien consequat. Integer lacinia magna vitae felis ultricies dapibus. In semper semper sollicitudin. Pellentesque varius dictum odio, vel iaculis dolor efficitur vitae. Ut quam dui, dapibus sit amet ante varius, scelerisque aliquam metus. Suspendisse vitae lacus ut eros sagittis blandit. Praesent accumsan justo nec odio sodales, in finibus tellus egestas. Aliquam nec placerat metus, a imperdiet risus. Aliquam malesuada, nunc ac suscipit bibendum, velit ex interdum diam, id viverra ipsum nisl eu magna.
                            </p>

                            <div class="row">
                                <div class="col-md-6"><img class="rounded img-fluid" src="https://upload.wikimedia.org/wikipedia/commons/1/1a/Kapitolinischer_Pythagoras_adjusted.jpg">
                                </div>

                                <div class="col-md-6">
                                    <p>
                                        In tristique luctus enim, vitae porttitor augue rutrum ut. Mauris non gravida turpis, mollis porta augue. Pellentesque et ultrices leo. Proin cursus dapibus risus sed commodo. Etiam non bibendum tortor, a ultrices massa. Suspendisse ut mi a mi suscipit sagittis sit amet tristique magna. Duis egestas varius massa, eu ultrices sem convallis vitae. Sed ultrices iaculis lacus vitae viverra.
                                    </p>

                                    <p>
                                        In tristique luctus enim, vitae porttitor augue rutrum ut. Mauris non gravida turpis, mollis porta augue. Pellentesque et ultrices leo. Proin cursus dapibus risus sed commodo. Etiam non bibendum tortor, a ultrices massa. Suspendisse ut mi a mi suscipit sagittis sit amet tristique magna. Duis egestas varius massa, eu ultrices sem convallis vitae. Sed ultrices iaculis lacus vitae viverra.
                                    </p>
                                </div>
                            </div>

                            <p>
                                In tristique luctus enim, vitae porttitor augue rutrum ut. Mauris non gravida turpis, mollis porta augue. Pellentesque et ultrices leo. Proin cursus dapibus risus sed commodo. Etiam non bibendum tortor, a ultrices massa. Suspendisse ut mi a mi suscipit sagittis sit amet tristique magna. Duis egestas varius massa, eu ultrices sem convallis vitae. Sed ultrices iaculis lacus vitae viverra.
                            </p>

                            <div class="d-flex">
                                <div>
                                    <a href="" class="btn"><i class="far fa-fw fa-arrow-up"></i> Upvote <span class="badge badge-primary">19</span> <span class="sr-only">upvote number</span></a>
                                    <a href="" class="btn"><i class="far fa-fw fa-arrow-down"></i> Downvote <span class="badge badge-primary">9</span> <span class="sr-only">downvote number</span></a>
                                    <a href="" class="btn">
                                        <i class="far fa-fw fa-comment"></i> Comment
                                    </a>
                                </div>
                            </div>

                        </div>

                        <div class="card my-3">
                            <div class="card-body">
                                <h6><small>3 Comments</small></h6>
                                <div class="d-flex list-group list-group-flush short-padding">
                                    
                                    <div class="list-group-item">
                                        <div class="d-flex flex-column">
                                            <div class="ml-1">
                                                <div class="d-flex">
                                                    <div class="align-self-center">
                                                        <img class="rounded-circle mr-2" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                                    </div>
                                                    <div class="d-flex flex-column">
                                                        <span><strong>António Almeida</strong></span>
                                                        <span class="text-muted">5h ago</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="pl-2 mt-1">
                                                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.  Phasellus eu orci quis erat rhoncus feugiat eget congue leo.</p>
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <a class="text-muted" href="">Upvote</a> <span class="text-muted">&bull;</span> <a class="text-muted" href="#">Downvote</a>
                                                    </div>
                                                    <div class="ml-auto">
                                                        <a href="#" class="text-muted"><small>Report</small></a>
                                                    </div>
                                                </div>
                                            </div>

                                            <a class="btn btn-lg btn-link" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
                                                View More
                                            </a>
                                        </div>
                                    </div>

                                    <div class="collapse" id="collapseExample">

                                        <div class="list-group-item">
                                            <div class="d-flex flex-column">
                                                <div class="ml-1">
                                                    <div class="d-flex">
                                                        <div class="align-self-center">
                                                            <img class="rounded-circle mr-2" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <span><strong>António Almeida</strong></span>
                                                            <span class="text-muted">5h ago</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="pl-2 mt-1">
                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.  Phasellus eu orci quis erat rhoncus feugiat eget congue leo.</p>
                                                    <div class="d-flex justify-content-between">
                                                        <div>
                                                            <a class="text-muted" href="">Upvote</a> <span class="text-muted">&bull;</span> <a class="text-muted" href="#">Downvote</a>
                                                        </div>
                                                        <div class="ml-auto">
                                                            <a href="#" class="text-muted"><small>Report</small></a>
                                                        </div>
                                                    </div>  </div>
                                            </div>
                                        </div>

                                        <div class="list-group-item">
                                            <div class="d-flex flex-column">
                                                <div class="ml-1">
                                                    <div class="d-flex">
                                                        <div class="align-self-center">
                                                            <img class="rounded-circle mr-2" width="36px" heigth="36px" src="assets/img/portrait-man.jpeg">
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <span><strong>António Almeida</strong></span>
                                                            <span class="text-muted">5h ago</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="pl-2 mt-1">
                                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.  Phasellus eu orci quis erat rhoncus feugiat eget congue leo.</p>
                                                    <div class="d-flex justify-content-between">
                                                        <div>
                                                            <a class="text-muted" href="">Upvote</a> <span class="text-muted">&bull;</span> <a class="text-muted" href="#">Downvote</a>
                                                        </div>
                                                        <div class="ml-auto">
                                                            <a href="#" class="text-muted"><small>Report</small></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>


    </main>
    <!-- /.container -->
    </body>

@endsection
