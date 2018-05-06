<template>
	<b-modal centered hide-header id="modal" lazy>
		<div class="modal-body">
			<div>
				<input name="title" placeholder="Write your question" type="text" class="main-question">

				<vue-tags-input
				v-model="tag"
				:tags="tags"
				:validation="validation"
				placeholder=""
				@tags-changed="(newTags => tags = newTags)"/>
				</div>
		</div>
		<div slot="modal-footer">
			<b-button variant="link" @click="show = false">Cancel</b-button>
			<b-button variant="primary">Submit</b-button>
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
			question: '',
			tag: '',
			tags: [],

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
		}
	}
}
</script>


