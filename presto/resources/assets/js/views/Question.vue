
<template>

<main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>{{ question.title }}</h1>
                    <h4><small>{{ question.content }}</small></h4>
                    <h5>
                        <small class="text-muted"><i class="far fa-fw fa-tags"></i>
                        	<!--
                            @forelse (question.topics as $topic)
                            <a class="text-muted" href="{{Route('topic', $topic->name)}}">{{ $topic->name }}</a>{{$loop->last ? '' : ','}}
                            @empty
                            <span class="text-muted">No topics</span>
                            @endforelse
                        -->
                        </small>
                    </h5>

                    <div class="card my-3">
                        <div class="card-body">
                            <h6><small>69 Comments</small></h6>
                            <div class="d-flex list-group list-group-flush short-padding">

                            	<!--
                                @foreach (question.comments as $comment)
                                    @if ($loop->first && !$loop->last)
                                        @include('partials.comment', ['comment' => $comment])
                                        <div class="collapse" :id="commentCollapse{{ question.id}}">
                                    @elseif($loop->last && !$loop->first)
                                        @include('partials.comment', ['comment' => $comment])
                                        </div>
                                    @else
                                        @include('partials.comment', ['comment' => $comment])
                                    @endif

                                @endforeach
                            -->

                                <a class="btn btn-lg btn-link text-dark" data-toggle="collapse" role="button" aria-expanded="false" >
                                    View More
                                </a>

                            </div>
                        </div>
                    </div>

                    <div :id="'questionAcordion'" class="mt-3">

                        <div class="d-flex justify-content-between flex-wrap">

                            <div>

                            	<b-btn href="#" v-b-toggle.accordion1 variant="primary">
                            		<i class="far fa-fw fa-pen"></i> Answer
                            	</b-btn>

                            	<b-btn href="#" v-b-toggle.accordion2 variant="outline-primary">
                            		<i class="far fa-fw fa-comment"></i> Comment
                            	</b-btn>

                            	<b-btn href="#" v-b-toggle.accordion3 variant="link">
                            		<i class="far fa-fw fa-check"></i> Solve
                            	</b-btn>

                            </div>

                            <!--
                            @can('update', $question)
                            <div class="ml-auto mt-2">
                                <small>
                                    <a href="btn" class="text-muted">Edit</a> |
                                    <a href="btn" class="text-danger">Delete</a>
                                </small>
                            </div>
                            @endcan
                        	-->
                        </div>

                        <div :id="'answerCollapse'" class="collapse mt-2 pb-2" aria-labelledby="headingAnswer" data-parent="#questionAcordion">

                        <form action="" method="post">
                            <div class="card">

                            <!--{{ csrf_field() }}-->
                                <textarea name="content" :id="'myeditor'"></textarea>
                                <div class="card-footer">
                                    <button type="submit" class="btn btn-sm btn-primary">Submit</button>
                                    <button class="btn btn-sm btn-link">Cancel</button>
                                </div>                              
                            </div>
                            </form>
                            
                        </div>

                        <div :id="'commentCollapse'" class="collapse mt-2 pb-2" aria-labelledby="headingComment" data-parent="#questionAcordion">
                            <form :id="'question-add-comment'">
                            <!-- {{ csrf_field() }} -->
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

                    <div class="mt-3" role="tablist">
                    	<b-collapse id="accordion1" accordion="my-accordion" role="tabpanel">

                    		<form action="" method="post">
                    			<div class="card">

                    				<!--{{ csrf_field() }}-->
                    				<textarea name="content" :id="'myeditor'"></textarea>
                    				<div class="card-footer">
                    					<button type="submit" class="btn btn-sm btn-primary">Submit</button>
                    					<button class="btn btn-sm btn-link">Cancel</button>
                    				</div>                              
                    			</div>
                    		</form>

                    	</b-collapse>

                    	<b-collapse id="accordion2" accordion="my-accordion" role="tabpanel">
                    		<!-- {{ csrf_field() }} -->
                    		<form :id="'question-add-comment'">
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
                    		</b-collapse>
                    </div>

                    <h4 class="mt-4"> <!-- {{ question.nr_answers () }} --> Answer(s)</h4>

                    <!--
                    <div class="">
                        <hr>
                        @foreach (question.answers as $answer)
                        @include('partials.answer', ['answer' => $answer])
                        @endforeach
                    </div>
                -->
                </div>
            </div>
        </section>
      </main>
</div>
</template>

<script>
import { Collapse } from 'bootstrap-vue/es/components'

export default {

	props: ['id'],

	name: 'Question',

	components: {
		'Collapse': Collapse,
	},

	data () {
		return {
			question: {},
			answers: {}
		}
	},

	mounted() {
        //this.getData(this.id);
    },

    watch: {
        '$route' (to, from) {
            console.log(to.params);
            this.getData(to.params.id);
        }
    },

    methods: {
        getData: function(id) {
            this.getQuestion(id);
            this.getAnswers(id);
        },

        getQuestion: function(id)  {
            axios.get('/api/questions/' + id)
            .then(({data}) => this.question = data)
            .catch((error) => {
                console.log(error);
            });    
        },

        getAnswers: function(questionId) {
            let request = '/api/questions/' + questionId + '/answers';

            axios.get(request)
            .then(({data}) => this.answers = data)
            .catch((error) => {
                console.log(error);
            }); 
        }
    }
}
</script>
