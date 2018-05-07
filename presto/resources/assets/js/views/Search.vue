<template>
	    <body class="grey-background">
    <main role="main" class="mt-5 mb-2">
        <section class="container wrapper mt-5">
            <div class="row">
                <div class="col-md-3 mt-2">
                    <div class="offcanvas-collapse" :class="{ open: isOffcanvasOpen }">
                        <div>
                            <h4 class="pt-4">Type</h4>
                            <div class="dropdown-divider"></div>

                            <b-form-radio-group class="text-muted" v-model="type"
	                            	:options="typeOptions"
	                            	stacked
	                            	name="radiosStacked">
	                        </b-form-radio-group>

                            </div>
                        <div>
                            <h4 class="pt-4">Author</h4>
                            <div class="dropdown-divider"></div>
                            <div class="input-group">
                            	<!--
                                @if($type == 'questions' || $type == 'answers')
                                <input type="text" class="form-control" placeholder="Find People">
                                @else
                                <input type="text" class="form-control filter-disabled" placeholder="Find People" disabled>
                                @endif
                            -->
                            </div>
                        </div>
                        <div>
                            <h4 class="pt-4">Time</h4>
                            <div class="dropdown-divider"></div>
                            	<!--
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
                                      <input type="hidden" name="text_search" value="{{query }}" />
                                      <input type="hidden" name="type" value="{{$type}}" />
                                      <input type="hidden" name="limit_date" value="<?=date('Y-m-d H:i:s', strtotime($date_filter[0]))?>" />

                                      <!--
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
                          -->
                            </div>
                        </div>
                    </div>
                <div class="col-md-8">
                    <div class="d-flex justify-content-between flex-wrap">
                        <h3><small class="text-muted">Results for </small> {{ query }}</h3>
                        <button @click="isOffcanvasOpen = !isOffcanvasOpen" class="btn btn-link text-mobile">
                            <i class="far fa-fw fa-filter"></i> Filter
                        </button>
                    </div>
                    <!--
                      @if($type == 'questions' || $type == 'answers')
                  -->
                  <template v-if="results == null">
                  </template>
                  <h5 v-else-if="results.length === 0"> <small> No results. </small></h5>
                  <template v-else>
                        <nav>
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" id="nav-newest-tab" data-toggle="tab" href="#nav-newest" role="tab" aria-controls="nav-newest" aria-selected="true">Newest</a>
                                <a class="nav-item nav-link" id="nav-oldest-tab" data-toggle="tab" href="#nav-oldest" role="tab" aria-controls="nav-oldest" aria-selected="false">Oldest</a>
                                <a class="nav-item nav-link" id="nav-rating-tab" data-toggle="tab" href="#nav-rating" role="tab" aria-controls="nav-rating" aria-selected="false">Rating</a>
                            </div>
                        </nav>

                        <div class="tab-content mb-5" id="nav-tabContent">
                            <div class="tab-pane fade show active" id="nav-newest" role="tabpanel" aria-labelledby="nav-newest-tab">
                            	<!--
                      @endif
                  -->
                                <div class="list-group">

                                	<template v-if="type == 'questions'">
                                		<question-card :key="question.id" v-for="question in results" :question="question"></question-card> 
                                	</template>

                                	<template v-if="type == 'answers'">
                                		<answer-card :key="answer.id" v-for="answer in results" :answer="answer"></answer-card> 
                                	</template>

                                	<template v-if="type == 'members'">
                                		<member-card :key="member.id" v-for="member in results" :member="member"></member-card> 
                                	</template>

                                	<template v-if="type == 'topics'">
                                		<topic-card :key="topic.id" v-for="topic in results" :topic="topic"></topic-card> 
                                	</template>

                                </div>

                                <!--
                      @if($type == 'questions' || $type == 'answers')
                  -->
                            </div>
                            <div class="tab-pane fade" id="nav-oldest" role="tabpanel" aria-labelledby="nav-oldest-tab">
                              <div class="list-group">
                              	<!--
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
                            -->
                              </div>
                            </div>

                            <div class="tab-pane fade" id="nav-rating" role="tabpanel" aria-labelledby="nav-rating-tab">
                              <div class="list-group">
                                <!-- TODO: Although sortByDesc is used, questions/answers are in inverted ordered according to positive ratings?? Investigate -->
                                <!--
                                @switch($type)
                                  @case('questions')
                                    @foreach($result->sortByDesc(function($product, $key){return $product->questionRatings()->where('rate',1)->count();}) as $question)
                                      @include('partials.question-card', ['question', $question])
                                    @endforeach
                                    @break
                                  @case('answers')
                                    @foreach($result->sortByDesc(function($product, $key){return $product->answerRatings()->where('rate',1)->count();}) as $answer)
                                      @include('partials.answer-card', ['answer', $answer])
                                    @endforeach
                                    @break
                                  @default
                                    @break
                                @endswitch
                            -->
                              </div>
                            </div>
                        </div>

                    </template>
                 
                	</div>
                </div>
        </section>
    </main>

    <!-- /.container -->
    </body>
</template>

<script>
export default {

	props:['query'],

	name: 'Search',

	components: {
		QuestionCard: require('../components/QuestionCard'),
		AnswerCard: require('../components/AnswerCard'),
		MemberCard: require('../components/MemberCard'),
		TopicCard: require('../components/TopicCard')
	},

	mounted() {
		this.loader = this.$loading.show();
        this.getResults(this.query);
	},

	watch: {
		type: function() {
			this.results = null;
			this.loader = this.$loading.show();
			this.getResults(this.query);
		}
	},

	data () {
		return {
			results: null,
			type: 'questions',
			isOffcanvasOpen: false,

			typeOptions: [
				{ text: 'Questions', value: 'questions' },
				{ text: 'Answers', value: 'answers' },
				{ text: 'Members', value: 'members' },
				{ text: 'Topics', value: 'topics' }
			]
		}
	},

	   methods: {
        getData: function(id) {
            this.getQuestion(id);
            this.getAnswers(id);
        },

        getResults: function(query) {
            let request = '/api/search/' + query;

            axios.get(request, {
            	params: {
            		type: this.type
            	}
            })
            .then(({data}) => {
                this.results = data;
                this.loader.hide();
            })
            .catch((error) => {
                console.log(error);
            }); 
        }
    }



}
</script>

<style lang="css">
	@media (max-width: 767.98px) {
  .offcanvas-collapse {
    position: fixed;
    top: 56px; /* Height of navbar */
    bottom: 0;
    left: 0;
    width: 16.5rem;
    padding-right: 1rem;
    padding-left: 3.5rem;
    overflow-y: auto;
    background-color: white;
    transition: -webkit-transform .3s ease-in-out;
    transition: transform .3s ease-in-out;
    transition: transform .3s ease-in-out, -webkit-transform .3s ease-in-out;
    -webkit-transform: translateX(-150%);
    transform: translateX(-150%);
    z-index: 1030;
  }

  .offcanvas-collapse.open {
    -webkit-transform: translateX(-2rem);
    transform: translateX(-2rem); /* Account for horizontal padding on navbar */
  }
}
</style>

