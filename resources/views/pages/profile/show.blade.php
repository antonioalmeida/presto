@php
use Carbon\Carbon;
@endphp

@extends('layouts.master')

@section('title')
    Profile | Presto
@endsection

@section('content')

    <body class="grey-background">

    <main class="mt-4" role="main">

    @include('pages.profile.profile')


    <!-- content -->
        <section class="small-container">
            <div class="container">

                <div class="row">
                    <div class="col-md-8 offset-md-2">

                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">Questions</a>
                                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false">Answers</a>
                            </div>
                        </nav>
                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
                                <!-- Questions go here -->

                                <div class="list-group">
                                    @foreach($member->questions as $question)
                                       @include('partials.question-card', ['question', $question]) 
                                    @endforeach
                                </div>


                            </div>
                            <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
                                <!-- answers go here -->
                                @foreach($member->answers as $answer)
                                @include('partials.answer-card',['answer', $answer]) 
                                @endforeach
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
