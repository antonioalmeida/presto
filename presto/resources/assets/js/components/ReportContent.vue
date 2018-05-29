<template>
	<b-modal centered
		:id="modalName"
		ref="reportModal"
		title="Report Comment"
		ok-variant="primary"
		cancel-variant="link"
		ok-title="Submit"
		cancel-title="Cancel"
		@ok="handleReportSubmit"
	>
		<b-form-input
			type="text"
			v-model="reportReason"
			required
			placeholder="Why are you flagging this comment?">
		</b-form-input>
	</b-modal>
</template>

<script>
export default {

	props: {
		modalName: String,
		type: String,
		endpoint: String,
	},

	name: 'ReportContent',

	data () {
		return {
			reportReason: '',
		}
	},

	methods: {
		handleReportSubmit: function(event) {
			event.preventDefault();
			axios.post(this.endpoint, {
				'reason': this.reportReason
			})
			.then(({data}) => {
				this.$alerts.addSuccess(this.type + ' successfully reported!');
				this.$refs.reportModal.hide();
			})
			.catch(({response}) => {
				let messages = [];
				let errors = response.data.errors;
				for (let key in errors) {
					for (let message of errors[key]) {
						messages.push(message);
					}
				}
				this.$alerts.addArrayError(messages);
			});
		},	
	}
}
</script>
