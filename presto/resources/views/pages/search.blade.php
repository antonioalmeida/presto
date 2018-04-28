@extends('layouts.master')

@section('title')
    Search | Presto
@endsection

@section('content')

    <body class="grey-background">
    <main role="main" class="mt-5 mb-2">
        <section class="container wrapper mt-5">
            <div class="row">
                <div class="col-md-3 mt-2">
                    <div class="offcanvas-collapse" id="navbarsExampleDefault">
                        <div>
                            <h4 class="pt-4">Type</h4>
                            <div class="dropdown-divider"></div>
                            <div class="typeFilter">
                                <div class="form-check">
                                    <input id="checkAll" class="form-check-input" type="checkbox" id="typeFilterAll">
                                    <label class="form-check-label text-muted btn-link" for="typeFilterAll">
                                        <strong>All Types</strong>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter0">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter0">
                                        Questions
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter1">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter1">
                                        Answers
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter2">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter2">
                                        Topics
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFilter3">
                                    <label class="form-check-label text-muted btn-link" for="typeFilter3">
                                        Users
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Author</h4>
                            <div class="dropdown-divider"></div>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Find People">
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Time</h4>
                            <div class="dropdown-divider"></div>
                            <div class="typeFilter">
                                <div class="form-check">
                                    <input name="time" id="checkAll" class="form-check-input" type="radio" id="timeFilterAll" checked>
                                    <label class="form-check-label text-muted btn-link" for="timeFilterAll">
                                        <strong>All Time</strong>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter0">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter0">
                                        Past Day
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter1">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter1">
                                        Past Week
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter2">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter2">
                                        Past Month
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter3">
                                    <label class="form-check-label text-muted btn-link" for="timeFilter3">
                                        Past Year
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="d-flex justify-content-between flex-wrap">
                        <h3><small class="text-muted">Results for </small> {{$query}}</h3>
                        <button class="btn btn-link text-mobile" type="button" data-toggle="offcanvas">
                            <i class="far fa-fw fa-filter"></i> Filter
                        </button>
                    </div>
                    <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-newest-tab" data-toggle="tab" href="#nav-newest" role="tab" aria-controls="nav-newest" aria-selected="true">Newest</a>
                                <a class="nav-item nav-link" id="nav-oldest-tab" data-toggle="tab" href="#nav-oldest" role="tab" aria-controls="nav-oldest" aria-selected="false">Oldest</a>
                                <a class="nav-item nav-link" id="nav-rating-tab" data-toggle="tab" href="#nav-rating" role="tab" aria-controls="nav-rating" aria-selected="false">Rating</a>
                            </div>
                        </nav>

                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-newest" role="tabpanel" aria-labelledby="nav-newest-tab">
                                <!-- Questions go here -->

                                <div class="list-group">
                                    @foreach($questions->sortByDesc('date') as $question)
                                       @include('partials.question-card', ['question', $question]) 
                                    @endforeach
                                </div>


                            </div>
                            <div class="tab-pane fade" id="nav-oldest" role="tabpanel" aria-labelledby="nav-oldest-tab">
                                <!-- answers go here -->
                                <div class="list-group">
                                
                                </div>
                            </div>
                        </div>
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
