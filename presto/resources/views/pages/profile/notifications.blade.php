@php
use Carbon\Carbon;
@endphp

@extends('layouts.master')

@section('title')
    Notifications | Presto
@endsection

@section('content')

    <body class="grey-background">

    <main role="main" class="mt-5">
        <div class="container">
            <div class="row">


                <div class="col-md-2 offset-1 text-collapse">
                    <div class="mt-4">
                        <h4 class="pt-4">Notifications</h4>
                        <div class="dropdown-divider"></div>
                        <ul class="no-bullets pl-0">
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Questions</a> <div><span class="badge badge-danger ">{{$counters['Questions']}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Answers</a> <div><span class="badge badge-danger ">{{$counters['Answers']}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Comments</a> <div><span class="badge badge-danger ">{{$counters['Comments']}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">People</a> <div><span class="badge badge-danger ">{{$counters['Follows']}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Upvotes</a> <div><span class="badge badge-danger ">{{$counters['Rating']}}</span></div></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9 mt-4">
                    <div class="list-group mt-4">
                        <h4 class="text-mobile">Notifications</h4>

                        @foreach($notifications_p as $notification)
                       
                            @include('partials.notifications-card', $notification)

                                <div>
                                    <span class="mb-1 text-muted"><small>{{Carbon::parse($notification->created_at)->diffForHumans(Carbon::now(), true)}} ago</small></span>
                                </div>
                            </div>
                        </div>
                        @endforeach

                {{ $notifications_p->links('pagination.default') }}

                       

                    </div>
                </div>
            </div>
        </div>
    </main><!-- /.container -->



    <!-- /.container -->
    </body>

@endsection
