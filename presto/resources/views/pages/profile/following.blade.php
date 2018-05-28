@extends('layouts.master')

@section('title')
    Followings | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="my-5">

    @include('pages.profile.profile')

    <!-- content -->
        <section class="container">

            <div class="list-group offset-md-3 col-md-7">
                <h4 class="mb-4">{{ $member->name }} is following</h4>
                @foreach($member->followings as $following)
                    <div onclick="location.assign('{{Route('profile', $following->username)}}');"
                         class="list-group-item list-group-item-action flex-column align-items-start">
                        <div class="d-flex w-100 justify-content-begin">

                            <div class="align-self-center">
                                <img class="rounded-circle pr-2" width="60px" heigth="60px"
                                     src="{{$following->profile_picture}}">
                            </div>
                            <div class="d-flex flex-column">
                                <h6 class="mb-1">{{ $following->name }}</h6>
                                <h6 class="text-collapse">
                                    <small>{{ $following->bio }}</small>
                                </h6>
                                <h6>
                                    <small class="text-muted"><i
                                                class="fas fa-gem text-primary"></i> {{$following->score}} points
                                    </small>
                                </h6>
                            </div>

                            <div class="ml-auto align-self-center flex-wrap">
                                @include('partials.follow', ['followTarget' => $following])
                            </div>

                        </div>

                    </div>
                @endforeach
            </div>
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
