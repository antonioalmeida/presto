@extends('layouts.master')

@section('title')
    Answer | Presto
@endsection

@section('content')

    <body class="">
    <main role="main" class="mt-4">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>{{$answer->question->title}}</h1>
                    <h4><small>This is the question's description.</small></h4>
                    <h5><small class="text-muted"><i class="far fa-fw fa-tags"></i>
                    @forelse ($answer->question->topics as $topic)
                    <a class="text-muted" href="{{Route('topic', $topic->name)}}">{{ $topic->name }}</a>{{$loop->last ? '' : ','}}
                    @empty
                    <span class="text-muted">No topics</span>
                    @endforelse
                    </small></h5>
                    <hr>

                    <div class="mt-4">

                        @include('partials.answer', ['answer' => $answer])
                    </div>
                </div>
            </div>
        </section>


    </main>
    <!-- /.container -->
    </body>

@endsection
