<template>
	<section class="container">

		<div class="list-group offset-md-3 col-md-7">
			<h4 class="mb-4">{{ username }}'s followers</h4>
		
		<member-card :key="follower.id" :member="follower" v-for="follower in followers">
		</member-card>

		</div>

	</section>
</template>

<script>
export default {

	props:['username'],

	name: 'Followers',

	components: {
		MemberCard: require('../components/MemberCard'),
	},

	mounted() {
		this.loader = this.$loading.show();
		this.getFollowers(this.username);
	},

	data () {
		return {
			followers: []
		}
	},

	methods: {
		getFollowers: function(username)  {
			axios.get('/api/profile/' + username + '/followers')
			.then(({data}) => {
				this.followers = data;
			})
			.catch((error) => {
				console.log(error);
			});    
		},
	}
}
</script>

