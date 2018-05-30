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
				fields: [ 'id', 'member_id', 'reason', 'date'],
			}
		},

		methods: {
			getData: function (username) {
				axios.get('/api/reports/' + (username || ''))
				.then(({data}) => {
					this.reports = data;
					this.loader.hide();
				})
				.catch((error) => {
					console.log(error);
				});
			},
		}

	}
</script>
