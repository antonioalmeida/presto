<template>
	<main class="mt-5 grey-background">

		<section class="mt-5 container">
			<h3>Reports</h3>

			<b-table hover
				:items="reports"
				:fields="fields">
			</b-table>
		</section>

	</main>
</template>

<script>
	export default {

		created() {
			document.title = "Reports | Presto";
			this.loader = this.$loading.show();
			this.getData();
		},

		name: 'Reports',

		data () {
			return {
				reports: [],
				fields: [ 'content.content', 'member.name', 'reason', 'date'],
			}
		},

		methods: {
			getData: function (username) {
				axios.get('/api/reports/' + (username || ''))
				.then(({data}) => {
					this.reports = data;
					for(let i = 0; i < this.reports.length; ++i){
						this.reports[i].content.content = this.reports[i].content.content.replace(/(<([^>]+)>)/ig,""); //Strip HTML tags JS style 8-)
						this.reports[i].content.content = (this.reports[i].content.content.length < 50 ? this.reports[i].content.content : this.reports[i].content.content.substring(0,50)+'...');
					}
					this.loader.hide();
				})
				.catch((error) => {
					console.log(error);
				});
			},
		}

	}
</script>
