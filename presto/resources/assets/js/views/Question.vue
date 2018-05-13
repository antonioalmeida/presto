
<template>

<main role="main" class="mt-5">

        <section class="container pt-5">
            <div class="row">
                <div class="offset-md-2 col-md-8">
                    <h1>{{ question.title }}</h1>
                    <h4><small>{{ question.content }}</small></h4>
                    <h5>
                        <small class="text-muted"><i class="far fa-fw fa-tags"></i>

                            <router-link v-for="(topic, index) in question.topics" :key="topic.id" :to="'/topic/' + topic.name" class="text-muted">
                                {{ topic.name }}<template v-if="index != question.topics.length -1">,</template>
                            </router-link>

                            <span v-if="question.topics.length === 0" class="text-muted">No topics</span>

                        </small>
                    </h5>

                    <div class="card my-3">
                        <comments-list :comments="question.comments"></comments-list>
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

                    </div>

                    <div class="mt-3" role="tablist">
                    	<b-collapse id="accordion1" accordion="my-accordion" role="tabpanel">

                           <div class="card">

                            <editor 
                                v-model="editorContent" 
                                :init="editorInit" 
                                @onChange="answerShowError = false">
                            </editor>

                            <div class="card-footer">
                               <span v-if="answerShowError" class="text-danger"><small>You can't submit an empty answer.<br></small></span>

                               <button @click="onAnswerSubmit" class="mt-1 btn btn-sm btn-primary">Submit</button>

                               <button class="mt-1 btn btn-sm btn-link">Cancel</button>
                           </div>                              
                       </div>

                   </b-collapse>

                    	<b-collapse id="accordion2" accordion="my-accordion" role="tabpanel">

                            <div class="card">
                                <b-form-textarea 
                                    v-model="commentText"
                                    placeholder="Leave a comment..."
                                    :rows="2"
                                    :max-rows="6">
                                </b-form-textarea>
                                <div class="card-footer">
                                    <button @click="onCommentSubmit" class="btn btn-sm btn-primary">Submit</button>
                                    <button v-b-toggle.accordion2 class="btn btn-sm btn-link">Cancel</button>
                                </div>
                            </div>

                    		</b-collapse>
                    </div>

                    <h4 class="mt-5"> {{ answers.length }} Answer(s)</h4>
                    
                    <AnswerPartial v-for="answer in answers" v-bind:answerData="answer" :key="answer.id"></AnswerPartial>
                    
                </div>
            </div>
        </section>
      </main>
</div>
</template>

<script>
import { Collapse, FormTextarea } from 'bootstrap-vue/es/components'
import CommentsList from '../components/CommentsList'
import AnswerPartial from '../components/AnswerPartial'
import Editor from '@tinymce/tinymce-vue';

export default {

	props: ['id', 'created'],

	name: 'Question',

	components: {
		'Collapse': Collapse,
        'CommentsList': CommentsList,
        'FormTextarea': FormTextarea,
        'Editor': Editor,
        'AnswerPartial': AnswerPartial
	},

	data () {
		return {
			question: {
                comments: [],
                topics: [],
            },
            answers: {},
            commentText: '',
            editorInit: require('../tiny-mce-config').default,
            editorContent: '',

            //error handling utils
            answerShowError: false,
            commentShowError: false,
        }
    },

    mounted() {
        this.loader = this.$loading.show();
        this.getData(this.id);
    },

    watch: {
        '$route' (to, from) {
            this.loader = this.$loading.show();
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
            .then(({data}) => {
                this.answers = data;
                this.loader.hide();
            })
            .catch((error) => {
                console.log(error);
            }); 
        },

        onCommentSubmit: function() {
            axios.post('/api/comments/question/' + this.question.id, {
                'content': this.commentText,
            })
            .then(({data}) => {
                this.question.comments.push(data);
                this.commentText = '';
            })
            .catch((error) => {
                console.log(error);
            }); 
        },

        onAnswerSubmit: function() {
            if(this.editorContent.length === 0) {
                this.answerShowError = true;
                return;
            }

            axios.post('/api/questions/' + this.question.id + '/answers/', {
                'content': this.editorContent,
            })
            .then(({data}) => {
                    console.log(data);
                    this.answers.push(data);
                    this.editorContent = '';

            })
            .catch(({response}) => {
                this.errors = response.data.errors;
                this.showError = true;
            }); 

        }
    }
}
</script>
