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
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Questions</a> <div><span class="badge badge-danger ">{{$notifications->where('type','Question')->count()}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Answers</a> <div><span class="badge badge-danger ">{{$notifications->where('type','Answer')->count()}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Comments</a> <div><span class="badge badge-danger ">{{$notifications->where('type','Comment')->count()}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">People</a> <div><span class="badge badge-danger ">{{$notifications->where('type','Follow')->count()}}</span></div></li>
                            <li class="d-flex justify-content-between"><a href="" class="text-muted">Upvotes</a> <div><span class="badge badge-danger ">{{$notifications->where('type','Rating')->count()}}</span></div></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-9 mt-4">
                    <div class="list-group mt-4">
                        <h4 class="text-mobile">Notifications</h4>

                        @foreach($notifications_p as $notification)
                        <div class="list-group-item list-group-item-action flex-column align-items-start">
                            <div class="notifications-card d-flex w-100 justify-content-between flex-wrap">
                                <div>
                                    <!-- <a href="" class="pb-1"><img class="rounded-circle pr-1" width="36px" heigth="36px" src="assets/img/portrait-man2.jpeg">João Damas</a>
                                    <span class="text-muted">answered your question to </span>
                                    <a href="">"When did the French Revolution begin?"</a>. -->
                                    {{substr($notification->content, 0, 90)}}{{(strlen($notification->content)>169 ? '...' : '')}}
                                    </div>

                                <div>
                                    <span class="mb-1 text-muted"><small>{{Carbon::parse($notification->date)->diffForHumans(Carbon::now(), true)}}</small></span>
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
