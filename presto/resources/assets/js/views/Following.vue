<template>
	<section class="container">
		<div class="offset-md-3 col-md-7 mb-4">
			<h4 class="mb-4">{{ username }} is following</h4>
			
			<div class="list-group">

				<member-card :key="user.id" :member="user" v-for="user in following">
				</member-card>

			</div>
		</div>
	</section>
</template>

<script>
export default {

	props:['username'],

	name: 'Following',

	components: {
		MemberCard: require('../components/MemberCard'),
	},

	mounted() {
		this.loader = this.$loading.show();
		this.getFollowing(this.username);
	},

	data () {
		return {
			following: []
		}
	},

	methods: {
		getFollowing: function(username)  {
			axios.get('/api/profile/' + username + '/following')
			.then(({data}) => {
				this.following = data;
				this.loader.hide();
			})
			.catch((error) => {
				console.log(error);
			});    
		},
	}
}
</script>

