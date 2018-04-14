@extends('layouts.master')

@section('title')
    Followers | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5">

    @include('pages.profile.profile')


    <!-- content -->
        <section class="container my-4">
            <h3>Followers</h3>

            <div class="card-deck mt-md-4">
                @foreach($member->followers as $follower)
                    @if($loop->index % 4 == 0 && !$loop->first && !$loop->last)
            </div>
            <div class="card-deck mt-md-4">
                @endif
                <div class="card">
                    <div class="card-body d-flex flex-wrap justify-content-between">
                        <div class="d-flex align-items-center">
                            <div>
                                <img class="user-preview rounded-circle pr-2" width="60px" heigth="60px" src="{{$follower->profile_picture}}">
                            </div>
                            <div>
                                <a class="text-dark" href="{{Route('profile', $follower->username)}}"><h5>{{ $follower->name}}</h5></a>
                                <h6><small class="text-muted"><i class="fas fa-gem text-primary"></i>{{$follower->score}} points</small></h6>
                            </div>
                        </div>
                        <p class="text-collapse">{{$follower->bio}}</p>
                        @include('partials.follow', ['follower' => $follower])
                    </div>
                </div>
                @endforeach
            </div>
        </section>
    </main>


    <!-- /.container -->
    </body>

@endsection
