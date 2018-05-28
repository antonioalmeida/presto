@extends('layouts.master')

@section('title')
    Profile | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main class="mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" src="{{$member->profile_picture}}"/>
                            <span class="fa-layers fa-fw fa-2x">
                                <i class="fas fa-circle text-shadow" style="color:white"></i>
                                <a href="" data-toggle="modal" data-target="#editPicture"><i
                                            class="fa-inverse fa-fw fas fa-pencil-alt text-muted"
                                            data-fa-transform="shrink-8"></i></a>
                            </span>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-profile">
                            <form method="POST" action="{{Route('profile.update', $member)}}">
                                {{ method_field('PUT') }}
                                {{ csrf_field() }}
                                <input name="name" type="text" class="form-control input-h2"
                                       id="exampleFormControlInput1" value="{{$member->name}}">
                                <input name="username" type="text" class="form-control input-h4 mt-2"
                                       id="exampleFormControlInput1" value="{{$member->username}}">

                                <div class="mt-3">
                                    <input name="bio" type="text" class="form-control input-h6 lead-adapt mt-2"
                                           id="exampleFormControlInput1" value="{{$member->bio}}">

                                    <div class="ml-1 mt-3">
                                        <button type="submit" class="btn btn-light">Save</button>
                                        <a href="{{Route('profile', $member)}}" class="btn btn-danger">Cancel</a>
                                    </div>


                                </div>

                            </form>
                        </div>

                    </div>

                </div>
            </div>
        </section>

    </main><!-- /.container -->


    <!-- /.container -->
    </body>

    <!-- edit picture modal -->
    <div class="modal fade" id="editPicture" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="POST" action="{{ Route('api.edit-profile-pic')}}">
                    {{ method_field('PATCH') }}
                    {{ csrf_field() }}
                    <div class="modal-body">
                        <div>
                            <h6><label for="profile-pic-url">Change your photo</label></h6>
                            <div class="input-group">
                                <input type="text" name="profile-pic-url" class="form-control" placeholder="New URL"
                                       aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

@endsection
