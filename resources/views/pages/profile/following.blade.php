@extends('layouts.master')

@section('title')
    Followings | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5">

    @include('pages.profile.profile')

    <!-- content -->
        <section class="container my-4">
            <h3>Following</h3>
            <div class="card-deck mt-md-4">
            @foreach($member->followings as $following)
                @if($loop->index % 4 == 0 && !$loop->first && !$loop->last)
                    </div>
                    <div class="card-deck mt-md-4">
                @endif
                        <div class="card">
                            <div class="card-body d-flex flex-wrap justify-content-between">
                                <div class="d-flex align-items-center">
                                    <div>
                                        <img class="user-preview rounded-circle pr-2" width="60px" heigth="60px" src="{{$following->profile_picture}}">
                                    </div>
                                    <div>
                                        <a class="text-dark" href="{{Route('profile', $following->username)}}"><h5>{{ $following->name}}</h5></a>
                                        <h6><small class="text-muted"><i class="fas fa-gem text-primary"></i>{{$following->score}} points</small></h6>
                                    </div>
                                </div>
                                <p class="text-collapse">{{$following->bio}}</p>
                                @include('partials.follow', ['member' => $member, 'follower' => $following])

                            </div>
                        </div>
            @endforeach
                    </div>
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
