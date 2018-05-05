<template>
	<button @click="toggleFollow()" :class="{ [classesDefault]: (!isActive || !value), [classesActive]: (isActive && value) }" @mouseover="handleHover()" @mouseleave="handleLeave()">
			<i v-if="value" :class="{'far fa-fw': true, 'fa-user': !isActive, 'fa-user-times': isActive }"></i>
			<i v-else class="far fa-fw fa-user-plus"></i>
			{{ text }}
		</button>
</template>

<script>
export default {

	props: ['value', 'classesDefault', 'classesActive', 'path'],

	name: 'FollowButton',

	data () {
		return {
			isActive: false
		}
	},

	computed: {
		text: function() { 
			if (this.value) {
				if(this.isActive)
					return 'Unfollow';
				return 'Following';
			}
			return 'Follow'; 
		}
	},

	methods: {
		handleHover: function(e) {
			this.isActive = true;
		},

		handleLeave: function(e) {
			this.isActive = false;
		},

		toggleFollow: function() {
			axios.post(this.path)
			.then(({data}) => {
				this.$emit('input', data.following);
			})
			.catch((error) => {
				console.log(error);
			}); 
		}
	},
}
</script>

<style lang="css" scoped>
</style>