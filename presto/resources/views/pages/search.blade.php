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
                              <!-- TODO Try to make code cleaner with loop
                              START LOOP
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="{{$type}}" />
                                      <input type="submit" value="CAPS_FIRST_LETTER_($type)" class="btn-link" />
                                  </form>
                                </div>
                              END LOOP
                            -->
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="submit" value="Questions" class="form-check-label btn-link" />
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="questions" />
                                  </form>
                                </div>
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="answers" />
                                      <input type="submit" value="Answers" class="btn-link" />
                                  </form>
                                </div>
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="topics" />
                                      <input type="submit" value="Topics" class="btn-link" />
                                  </form>
                                </div>
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="members" />
                                      <input type="submit" value="Members" class="btn-link" />
                                  </form>
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
                                <div>
                                    <input name="time" id="checkAll" class="form-check-input" type="radio" id="timeFilterAll" checked>
                                    <label class="form-check-label text-muted" for="timeFilterAll">
                                        <strong>All Time</strong>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter0">
                                    <label class="form-check-label text-muted" for="timeFilter0">
                                        Past Day
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter1">
                                    <label class="form-check-label text-muted" for="timeFilter1">
                                        Past Week
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter2">
                                    <label class="form-check-label text-muted" for="timeFilter2">
                                        Past Month
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input name="time" class="form-check-input" type="radio" id="timeFilter3">
                                    <label class="form-check-label text-muted" for="timeFilter3">
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
                      @if($type == 'questions' || $type == 'answers')
                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-newest-tab" data-toggle="tab" href="#nav-newest" role="tab" aria-controls="nav-newest" aria-selected="true">Newest</a>
                                <a class="nav-item nav-link" id="nav-oldest-tab" data-toggle="tab" href="#nav-oldest" role="tab" aria-controls="nav-oldest" aria-selected="false">Oldest</a>
                                <a class="nav-item nav-link" id="nav-rating-tab" data-toggle="tab" href="#nav-rating" role="tab" aria-controls="nav-rating" aria-selected="false">Rating</a>
                            </div>
                        </nav>

                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-newest" role="tabpanel" aria-labelledby="nav-newest-tab">
                      @endif
                                <div class="list-group">
                                    @switch($type)
                                      @case('questions')
                                        @foreach($result->sortByDesc('date') as $question)
                                          @include('partials.question-card', ['question', $question])
                                        @endforeach
                                        @break
                                      @case('answers')
                                        @foreach($result->sortByDesc('date') as $answers)
                                          @include('partials.answer-card', ['answer', $answer])
                                        @endforeach
                                        @break
                                      @case('members')
                                        @foreach($result as $member)
                                        <div onclick="location.assign('{{Route('profile', $member->username)}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                          <div class="d-flex w-100 justify-content-begin">
                                            <div class="align-self-center">
                                               <img class="rounded-circle pr-2" width="60px" heigth="60px" src="{{$member->profile_picture}}">
                                           </div>
                                            <div class="d-flex flex-column">
                                              <h6 class="mb-1">{{ $member->name }}</h6>
                                              <h6 class="text-collapse"><small>{{ $member->bio }}</small></h6>
                                              <h6><small class="text-muted">@ {{$member->username}} </small></h6>
                                            </div>

                                            <div class="ml-auto align-self-center flex-wrap">
                                              @include('partials.follow', ['followTarget' => $member])
                                            </div>
                                          </div>
                                        </div>
                                        @endforeach
                                        @break
                                      @case('topics')
                                        @break
                                      @default
                                        @break
                                    @endswitch
                                </div>

                      @if($type === 'questions' || $type === 'answers')
                            </div>
                            <div class="tab-pane fade" id="nav-oldest" role="tabpanel" aria-labelledby="nav-oldest-tab">
                      @endif
                                <div class="list-group">

                                </div>
                      @if($type === 'questions' || $type === 'answers')
                            </div>
                        </div>
                      @endif
                    </div>
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
