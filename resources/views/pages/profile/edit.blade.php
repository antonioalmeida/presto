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
                            <img class="profile-pic img-fluid rounded-circle m-2" src="{{$member->profile_picture}}" />
                            <span class="fa-layers fa-fw fa-2x">
                                <i class="fas fa-circle text-shadow" style="color:white"></i>
                                <a href=""><i class="fa-inverse fa-fw fas fa-pencil-alt text-muted" data-fa-transform="shrink-8"></i></a>
                            </span>
                        </div>

                        <form method="POST" action="{{Route('profile.update', $member)}}">
                            {{ method_field('PUT') }}
                            {{ csrf_field() }}
                            <div class="col-md-6 mobile-center text-shadow edit-profile">
                                <input name="name" type="text" class="form-control input-h2" id="exampleFormControlInput1" value="{{$member->name}}">
                                <input name="username" type="text" class="form-control input-h4 mt-2" id="exampleFormControlInput1" value="{{$member->username}}">

                                <!-- bio -->
                                <div class="bio mt-3">
                                    <input name="bio" type="text" class="form-control input-h6 lead-adapt mt-2" id="exampleFormControlInput1" value="{{$member->bio}}">


                                    <div class="ml-1 mt-3">
                                        <button type="submit" class="btn btn-light">Save</button>
                                        <a href="{{Route('profile', $member)}}" class="btn btn-danger">Cancel</a>
                                    </div>


                                </div>

                            </div>

                            @include ('includes.errors')

                        </form>

                    </div>

                </div>
            </div>
        </section>

    </main><!-- /.container -->


    <!-- /.container -->
    </body>

@endsection
