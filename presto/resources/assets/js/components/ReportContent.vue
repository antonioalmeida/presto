<template>
	<b-modal centered lazy
		:id="modalName"
		ref="reportModal"
		:title="'Report ' + type"
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
			:placeholder="'Why are you reporting this ' + typeLowerCase + '?'">
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
			    if(data.error != null){
                    this.$alerts.addError(data.error );
				} else {
                    this.$alerts.addSuccess(this.type + ' successfully reported!');
                }
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
	},

	computed: {
		typeLowerCase: function() {
			return this.type.toLowerCase();
		}
	}
}
</script>
