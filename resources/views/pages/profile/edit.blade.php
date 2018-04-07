@extends('layouts.master')

@section('title')
    Profile | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" src="assets/img/portrait-man.jpeg" />
                            <span class="fa-layers fa-fw fa-2x">
              <i class="fas fa-circle text-shadow" style="color:white"></i>
              <a href=""><i class="fa-inverse fa-fw fas fa-pencil-alt text-muted" data-fa-transform="shrink-8"></i></a>
            </span>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-profile">
                            <input type="text" class="form-control input-h2" id="exampleFormControlInput1" placeholder="António Almeida">
                            <input type="text" class="form-control input-h4 mt-2" id="exampleFormControlInput1" placeholder="@antonioalmeida">

                            <!-- bio -->
                            <div class="bio mt-3">
                                <input type="text" class="form-control input-h6 lead-adapt mt-2" id="exampleFormControlInput1" placeholder="This platform is awesome, the best I've ever seen.">


                                <div class="ml-1 mt-3">
                                    <a href="profile.html" class="btn btn-light">Save</a>
                                    <a href="profile.html" class="btn btn-danger">Cancel</a>
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
