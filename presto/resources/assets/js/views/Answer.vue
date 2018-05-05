<template>
    <div>
        Ola
    </div>
</template>

<script>
import CommentsList from '../components/CommentsList'

export default {

    props: ['answer'],

    name: 'Answer',

    components: {
        'CommentsList': CommentsList
    },

    data () {
        return {

        }
    }
}
</script>
