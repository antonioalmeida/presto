@extends('layouts.master')

@section('title')
    Question | Presto
@endsection

@section('content')


    <body class="grey-background">
    <main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>{{ $question->title }}</h1>
                    <h4><small>{{ $question->content }}</small></h4>
                    <h5><small class="text-muted"><i class="far fa-fw fa-tags"></i>
                        @foreach ($question->topics as $topic)
                            <a class="text-muted" href="{{Route('topic', $topic->name)}}">{{ $topic->name }}</a>, 
                        @endforeach
                    </small>
                    </h5>


                    <div class="d-flex justify-content-between flex-wrap">

                        <div class="mt-2">
                            <a class="btn btn-primary" data-toggle="collapse" href="#answerCollapse" role="button" aria-expanded="false" aria-controls="answerCollapse">
                                <i class="far fa-fw fa-pen"></i> Answer
                            </a>
                            <a class="btn" href="">
                                <i class="far fa-fw fa-comment"></i> Comment
                            </a>
                            <a class="btn" href="">
                                <i class="far fa-fw fa-check"></i> Solve
                            </a>
                        </div>

                        <div class="mt-2">
                            <small>
                                <a href="btn" class="text-muted">Edit</a> |
                                <a href="btn" class="text-danger">Delete</a>
                            </small>
                        </div>
                    </div>


                    <div class="collapse mt-2 pb-2" id="answerCollapse">
                        <div class="card">
                            <div id="summernote"></div>

                            <div class="card-footer">
                                <button class="btn btn-sm btn-primary">Submit</button>
                                <button class="btn btn-sm btn-link">Cancel</button>
                            </div>
                        </div>
                    </div>


                    <h4 class="mt-4">{{ $question->getNumAnswers() }} Answer(s)</h4>
                    <hr>

                    <div class="mt-4">
                        @foreach ($question->answers as $answer)
                        @include('partials.answer', ['answer' => $answer])
                        @endforeach
                    </div>
                </div>
            </div>
        </section>

        <section class="container my-3">

            <h5 class="m-3">More answers by António Almeida</h5>
            <div class="card-deck m-2">
                <div class="card list-group-item-action" role="button">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">What is Maths?</h5>
                        <p class="card-text">This is a longer card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                        <span class="ml-1 mt-auto card-text"><small class="text-muted">6.4k views</small></span>
                    </div>
                </div>
                <div class="card list-group-item-action">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">How big is the universe?</h5>
                        <p class="card-text">This card has supporting text below as a natural lead-in to additional content.</p>
                        <span class="ml-1 mt-auto card-text"><small class="text-muted">6.4k views</small></span>
                    </div>
                </div>
                <div class="card list-group-item-action">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">How big is the universe?</h5>
                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.</p>
                        <span class="ml-1 mt-auto card-text"><small class="text-muted">6.4k views</small></span>
                    </div>
                </div>
            </div>
        </section>

    </main>


    <!-- /.container -->
    </body>

@endsection
