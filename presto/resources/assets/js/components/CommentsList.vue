
<template>
	<div class="card-body">
		<h6><small>{{ comments.length > 0 ? comments.length : 'No' }} Comments</small></h6>
		<div class="d-flex list-group list-group-flush short-padding">

			<template v-if="comments.length > 0">
				<comment-card :comment="comments[0]" :key="comments[0].id"></comment-card>

				<b-collapse id="collapse1" v-model="showingMore">
					<comment-card v-for="(comment,index) in comments" v-if="index > 0" :key="comment.id" :comment="comment"></comment-card>
				</b-collapse>

				<a @click="showingMore = !showingMore" class="btn btn-lg btn-link text-dark" role="button">
					<span v-if="!showingMore">View More</span>
					<span v-else>Show Less</span>
				</a>
			</template>
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
