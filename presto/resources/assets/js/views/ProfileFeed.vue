<template>
	<section class="small-container">
		<div class="container">
			<router-view></router-view>
		</div>
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

                            <div class="list-group">
                            	<template v-for="question in questions">
                            		<question-card v-bind:question="question"></question-card> 
                            	</template>
                            </div>

                        </div>
                        <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">

                            <!-- answers go here 
                            @foreach(user.answers->sortByDesc('date') as $answer)
                            @include('partials.answer-card',['answer', $answer]) 
                            @endforeach -->

                        </div>
                    </div>

                </div>
            </div>

        </div>
    </section>
</template>

<script>
export default {

	props: ['username'],

	name: 'ProfileFeed',

	components: {
		QuestionCard: require('../components/QuestionCard')
	},

	mounted() {
		this.loader = this.$loading.show();
		this.getQuestions(this.username);
	},

	data () {
		return {
			questions: {}
		}
	},

	methods: {
		getQuestions: function(username) {
			let request = '/api/profile';
			if(username)
				request += '/' + username;
			request += '/questions';

			axios.get(request)
			.then(({data}) => {
				this.questions = data;
				this.loader.hide();
			})
			.catch((error) => {
				console.log(error);
			}); 
		}
	}
}
</script>

