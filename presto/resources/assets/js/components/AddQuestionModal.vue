<template>
	<b-modal centered hide-header id="modal" lazy v-model="showModal">
		<div class="modal-body">
			<div>
				<input v-model="title" placeholder="Write your question" type="text" class="main-question">

				<vue-tags-input
				v-model="tag"
				:tags="tags"
				:validation="validation"
				placeholder=""
				@tags-changed="(newTags => tags = newTags)"/>
				</div>

				<div v-if="showError" class="ml-1">
					<span v-for="error in errors" class="text-danger"><small> {{ error[0] }}<br></small></span>
				</div>
		</div>
		<div slot="modal-footer">
			<b-button variant="link" @click="show = false">Cancel</b-button>
			<b-button variant="primary" @click="onSubmit">Submit</b-button>
		</div>
	</b-modal>
</template>

<script>
import VueTagsInput from '@johmun/vue-tags-input';

export default {

	name: 'AddQuestionModal',

	components: {
		'vue-tags-input': VueTagsInput
	},

	data () {
		return {
			title: '',
			tag: '',
			tags: [{
				text: 'Science'
			}, {
				text: 'Physics'
			}],

			validation: [{
				type: 'min-length',
				rule: /^.{3,}$/,
			}, {
				type: 'no-numbers',
				rule: /^([^0-9]*)$/,
			}, {
				type: 'no-braces',
				rule(text) {
					return text.indexOf('{') !== -1 || text.indexOf('}') !== -1;
				},
			}],

			showError: false,
			errors: [],

			showModal: false,
		}
	},

	methods: {
		onSubmit: function() {
            axios.post('/api/questions', {
                'title': this.title,
                'tags': this.tagsString
            })
            .then(({data}) => {
                this.redirect(data.id);
            })
            .catch(({response}) => {
            	this.errors = response.data.errors;
            	this.showError = true;
            }); 
        },

        redirect: function(id) {
			this.$router.push({ path: '/questions/' + id });
			this.showModal = false;
        }
	},

	computed: {
		tagsString: function() {
			return this.tags.map(value => value.text);
		}
	}
}
</script>


