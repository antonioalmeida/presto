@extends('layouts.master')

@section('title')
    Question | Presto
@endsection

@section('content')


    <body>
    <main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>{{ $question->title }}</h1>
                    <h4><small>{{ $question->content }}</small></h4>
                    <h5>
                        <small class="text-muted"><i class="far fa-fw fa-tags"></i>
                            @forelse ($question->topics as $topic)
                            <a class="text-muted" href="{{Route('topic', $topic->name)}}">{{ $topic->name }}</a>{{$loop->last ? '' : ','}}
                            @empty
                            <span class="text-muted">No topics</span>
                            @endforelse
                        </small>
                    </h5>

                    <div class="card my-3">
                        <div class="card-body">
                            <h6><small>{{$question->comments->count()}} Comments</small></h6>
                            <div id="questionComments" class="d-flex list-group list-group-flush short-padding">

                                @foreach ($question->comments as $comment)
                                    @if ($loop->first && !$loop->last)
                                        @include('partials.comment', ['comment' => $comment])
                                        <div class="collapse" id="commentCollapse{{ $question->id}}">
                                    @elseif($loop->last && !$loop->first)
                                        @include('partials.comment', ['comment' => $comment])
                                        </div>
                                    @else
                                        @include('partials.comment', ['comment' => $comment])
                                    @endif
                                    
                                @endforeach

                                <a class="btn btn-lg btn-link text-dark" data-toggle="collapse" href="#commentCollapse{{ $question->id}}" role="button" aria-expanded="false" aria-controls="commentCollapse{{ $question->id}}">
                                    View More
                                </a>

                            </div>
                        </div>
                    </div>

                    <div id="questionAcordion" class="mt-3">

                        <div class="d-flex justify-content-between flex-wrap">
                            <div>
                                <a id="headingAnswer" class="btn btn-primary" data-toggle="collapse" role="button" href="#answerCollapse" aria-expanded="false" aria-controls="answerCollapse">
                                    <i class="far fa-fw fa-pen"></i> Answer
                                </a>

                                <a id="headingComment" class="btn" data-toggle="collapse" href="#commentCollapse" role="button" aria-expanded="false" aria-controls="commentCollapse">
                                    <i class="far fa-fw fa-comment"></i> Comment
                                </a>

                                <a class="btn" href="">
                                    <i class="far fa-fw fa-check"></i> Solve
                                </a>
                            </div>

                            @can('update', $question)
                            <div class="ml-auto mt-2">
                                <small>
                                    <a href="btn" class="text-muted">Edit</a> |
                                    <a href="btn" class="text-danger">Delete</a>
                                </small>
                            </div>
                            @endcan
                        </div>

                        <div id="answerCollapse" class="collapse mt-2 pb-2" aria-labelledby="headingAnswer" data-parent="#questionAcordion">
                            <div class="card">
                                <div id="summernote"></div>

                                <div class="card-footer">
                                    <button class="btn btn-sm btn-primary">Submit</button>
                                    <button class="btn btn-sm btn-link">Cancel</button>
                                </div>
                            </div>
                        </div>

                        <div id="commentCollapse" class="collapse mt-2 pb-2" aria-labelledby="headingComment" data-parent="#questionAcordion">
                            <form id="question-add-comment" data-question-id="{{ $question->id}}">
                            {{ csrf_field() }}
                            <div class="card">
                               <div class="input-group">
                                <textarea class="form-control" name="content" placeholder="Leave a comment..."></textarea required>
                            </div>
                            <div class="card-footer">
                                    <button type="submit" class="btn btn-sm btn-primary">Submit</button>
                                    <button class="btn btn-sm btn-link">Cancel</button>
                                </div>
                            </div>
                            </form>
                        </div>

   
                    </div>

                    <h4 class="mt-4">{{ $question->getNumAnswers() }} Answer(s)</h4>

                    <div class="">
                        <hr>
                        @foreach ($question->answers as $answer)
                        @include('partials.answer', ['answer' => $answer])
                        @endforeach
                    </div>
                </div>
            </div>
        </section>

    </main>


    <!-- /.container -->
    </body>

@endsection
