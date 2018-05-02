
<template>
	<div class="card-body">
		<h6><small>{{ comments.length }} Comments</small></h6>
		<div class="d-flex list-group list-group-flush short-padding">

			<comment-card :comment="comments[0]"></comment-card>

			<b-collapse v-model="showingMore">
				<comment-card v-for="comment in comments" :comment="comment"></comment-card>
			</b-collapse>

			<b-btn @click="showingMore = !showingMore" class="btn btn-lg btn-link text-dark" role="button">
				<span v-if="!showMore">View More</span>
				<span v-else>Show Less</span>
			</b-btn>

		</div>
	</div>
</template>

<script>
import CommentCard from './CommentCard'
import { Collapse } from 'bootstrap-vue/es/components'

export default {

	props: ['comments'],

	components: {
		'CommentCard': CommentCard,
		'Collapse': Collapse
	},

	name: 'CommentsList',

	data () {
		return {
			showingMore: false
		}
	}
}
</script>
