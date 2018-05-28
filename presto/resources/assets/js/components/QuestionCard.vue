<template>
    <div @click.capture="onClickRedirect" class="list-group-item list-group-item-action flex-column align-items-start">
        <div class="d-flex w-100 justify-content-between flex-md-nowrap flex-wrap-reverse">

            <h4 class="mb-1 max-w-71">{{ question.title }}</h4>

            <small class="pb-1">
                <router-link :to="'/profile/' + question.author.username" class="btn-link">
                        <img
                        class="user-preview rounded-circle pr-1" width="36" height="36"
                        :src="question.author.profile_picture"
                        :alt="question.author.name + '\'s profile picture'"> {{question.author.name}}
                </router-link>
                <span class="text-muted">asked</span>
            </small>
        </div>


        <small class="text-muted"><i class="far fa-tags"></i>
            <router-link v-for="(topic, index) in this.topicsEncoded" class="text-muted" :key="topic.id"
                         :to="'/topic/' + topic.encodedName">
                {{ topic.name }}
                <template v-if="index != question.topics.length -1">,</template>
            </router-link>

            <span v-if="question.topics.length === 0" class="text-muted">No topics</span>
        </small>

    </div>
</template>

<script>
    export default {

        props: ['question'],

        name: 'QuestionCard',

        data() {
            return {
              topicsEncoded: []
            }
        },

        created() {
          //So whitespaces are encoded in the href attribute
          this.topicsEncoded = this.question.topics.map(topic => {
            let newTopic = topic;
            newTopic.encodedName = encodeURI(topic.name);
            return newTopic;
          })
        },

        methods: {
            onClickRedirect:function() {
                this.$router.push({path: '/questions/' + this.question.id});
            }
        }
    }
</script>
