<template>
    <!-- TODO: add link to question -->
    <router-link :to="'/questions/' + question.id"
                 class="list-group-item list-group-item-action flex-column align-items-start">
        <div class="d-flex w-100 justify-content-between flex-md-nowrap flex-wrap-reverse">

            <h4 class="mb-1 max-w-70">{{ question.title }}</h4>

            <small class="pb-1">
                <router-link :to="'/profile/' + question.author.username" class="btn-link"><img
                        class="user-preview rounded-circle pr-1" width="36px" heigth="36px"
                        :src="question.author.profile_picture"> {{question.author.name}}
                </router-link>
                <span class="text-muted">asked</span>
            </small>
        </div>


        <small class="text-muted"><i class="far fa-tags"></i>
            <router-link v-for="(topic, index) in question.topics" class="text-muted" :key="topic.id"
                         :to="'/topic/' + topic.name">
                {{ topic.name }}
                <template v-if="index != question.topics.length -1">,</template>
            </router-link>

            <span v-if="question.topics.length === 0" class="text-muted">No topics</span>
        </small>

    </router-link>
</template>

<script>
    export default {

        props: ['question'],

        name: 'QuestionCard',

        data() {
            return {}
        }
    }
</script>

