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
                              <?php $filter_types = ['questions', 'answers', 'topics', 'members']; ?>
                              @foreach($filter_types as $type_filter)
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="<?=$type_filter?>" />
                                      <input type="hidden" name="limit_date" value="{{$limit_date}}" />
                                      @if($type === $type_filter)
                                        <input type="submit" value="<?=ucfirst($type_filter)?>" class="filter-btn btn-link selected-filter" />
                                      @else
                                        <input type="submit" value="<?=ucfirst($type_filter)?>" class="filter-btn btn-link" />
                                      @endif
                                  </form>
                                </div>
                              @endforeach
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Author</h4>
                            <div class="dropdown-divider"></div>
                            <div class="input-group">
                                @if($type == 'questions' || $type == 'answers')
                                <input type="text" class="form-control" placeholder="Find People">
                                @else
                                <input type="text" class="form-control filter-disabled" placeholder="Find People" disabled>
                                @endif
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Time</h4>
                            <div class="dropdown-divider"></div>
                            <div class="typeFilter">
                              <?php $filter_dates = array(
                                array('1 January 1970', 'All Time'),
                                array('-1 day', 'Past day'),
                                array('-1 week', 'Past week'),
                                array('-1 month', 'Past month'),
                                array('-1 year', 'Past year')
                              ); ?>
                              @foreach($filter_dates as $date_filter)
                                <div class="form-check">
                                  <form method="POST" action="{{ Route('search')}}">
                                          {{ csrf_field() }}
                                      <input type="hidden" name="text_search" value="{{$query}}" />
                                      <input type="hidden" name="type" value="{{$type}}" />
                                      <input type="hidden" name="limit_date" value="<?=date('Y-m-d H:i:s', strtotime($date_filter[0]))?>" />
                                      @if($type == 'questions' || $type == 'answers')
                                        @if(date('Y-m-d', strtotime($limit_date)) === date('Y-m-d', strtotime($date_filter[0])))
                                          <input type="submit" value="<?=$date_filter[1]?>" class="btn-link text-muted filter-btn selected-filter" />
                                        @else
                                          <input type="submit" value="<?=$date_filter[1]?>" class="btn-link text-muted filter-btn" />
                                        @endif
                                      @else
                                      <input type="submit" value="<?=$date_filter[1]?>" class="btn-link text-muted filter-btn filter-disabled" disabled/>
                                      @endif
                                  </form>
                                </div>
                              @endforeach
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
                                        @foreach($result->sortByDesc('date') as $answer)
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
                                        @foreach($result as $topic)
                                        <div onclick="location.assign('{{Route('topic', $topic->name)}}');" class="list-group-item list-group-item-action flex-column align-items-start">
                                          <div class="d-flex w-100 justify-content-begin">
                                            <div class="align-self-center">
                                               <img class="rounded-circle pr-2" width="60px" heigth="60px" src="{{$topic->picture}}">
                                           </div>
                                            <div class="d-flex flex-column">
                                              <h6 class="mb-1">{{ $topic->name }}</h6>
                                              <h6 class="text-collapse"><small>{{ $topic->description }}</small></h6>
                                            </div>
                                            <div class="ml-auto align-self-center flex-wrap">
                                              @include('partials.follow-topic', ['followTarget' => $topic])
                                            </div>
                                          </div>
                                        </div>
                                        @endforeach
                                        @break
                                      @default
                                        @break
                                    @endswitch
                                </div>

                      @if($type == 'questions' || $type == 'answers')
                            </div>
                            <div class="tab-pane fade" id="nav-oldest" role="tabpanel" aria-labelledby="nav-oldest-tab">
                              <div class="list-group">
                                @switch($type)
                                  @case('questions')
                                    @foreach($result->sortBy('date') as $question)
                                      @include('partials.question-card', ['question', $question])
                                    @endforeach
                                    @break
                                  @case('answers')
                                    @foreach($result->sortBy('date') as $answer)
                                      @include('partials.answer-card', ['answer', $answer])
                                    @endforeach
                                    @break
                                  @default
                                    @break
                                @endswitch
                              </div>
                            </div>

                            <div class="tab-pane fade" id="nav-rating" role="tabpanel" aria-labelledby="nav-rating-tab">
                              <div class="list-group">
                                <!-- TODO: Although sortByDesc is used, questions/answers are in inverted ordered according to positive ratings?? Investigate -->
                                @switch($type)
                                  @case('questions')
                                    @foreach($result->sortByDesc(function($product, $key){return count($product->questionRatings()->where('rate',1));}) as $question)
                                      @include('partials.question-card', ['question', $question])
                                    @endforeach
                                    @break
                                  @case('answers')
                                    @foreach($result->sortByDesc(function($product, $key){return count($product->answerRatings()->where('rate',1));}) as $answer)
                                      @include('partials.answer-card', ['answer', $answer])
                                    @endforeach
                                    @break
                                  @default
                                    @break
                                @endswitch
                              </div>
                            </div>
                        </div>
                      @endif
                    </div>
        </section>
    </main>

    <!-- /.container -->
    </body>

@endsection
