<template>
	<div>
		<a @click.stop.prevent="rateContent(1)" class="btn"
		:class="{'text-primary text-strong' : content.isUpvoted}">

			<i class="far fa-fw fa-arrow-up"></i>
			<template v-if="content.isUpvoted">Upvoted</template>
			<template v-else>Upvote</template>
			<span :class="[content.isUpvoted ? 'badge-primary' : 'badge-light']" class="badge">{{ content.upvotes }}</span>
			<span class="sr-only">upvote number</span>
		</a>
		<a @click.stop.prevent="rateContent(-1)" class="btn"
		:class="{'text-danger text-strong' : content.isDownvoted}">
		<i class="far fa-fw fa-arrow-down"></i>
		<template v-if="content.isDownvoted">Downvoted</template>
		<template v-else>Downvote</template>
		<span :class="[content.isDownvoted ? 'badge-danger' : 'badge-light']" class="badge">{{ content.downvotes }} </span>
		<span class="sr-only">downvote number</span></a>
	</div>
</template>

<script>
export default {

	props: ['content', 'endpoint'],

	name: 'RateContent',

	data () {
		return {

		}
	},

	methods: {
		rateContent: function (vote) {
			axios.post(this.endpoint, {
				'rate': vote,
			})
			.then(({data}) => {
				this.content.isUpvoted = data.isUpvoted;
				this.content.isDownvoted = data.isDownvoted;
				this.content.upvotes = data.upvotes;
				this.content.downvotes = data.downvotes;
			})
			.catch((error) => {
				console.log(error);
			});
		}

	}
}
</script>

