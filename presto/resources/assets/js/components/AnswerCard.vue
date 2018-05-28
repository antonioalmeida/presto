<template>
    <div @click.capture="onClickRedirect" class="list-group-item list-group-item-action flex-column align-items-start">
        <div class="d-flex w-100 justify-content-between flex-column mb-1">

            <h4 class="mb-3">{{ answer.question.title }}</h4>
            <div class="d-flex">
                <div>
                    <img class="rounded-circle pr-1" width="36" height="36"
                         :alt="answer.author.profile_picture + '\'s profile picture'"
                         :src="answer.author.profile_picture">
                </div>
                <h6>
                    <router-link :to="'/profile/' + answer.author.username" class="btn-link">{{answer.author.name}}
                    </router-link>
                    <br>
                    <small class="text-muted">answered {{ answer.date | moment("from") }}</small>
                </h6>
            </div>
        </div>
        <p class="mb-1">
            {{ contentPreview }}
            <router-link :to="'/questions/' + answer.question.id + '/answers/' + answer.id"
                         class="btn-link text-primary">(read more)
            </router-link>
        </p>

        <small class="text-muted"><i class="far fa-tags"></i>
            <router-link v-for="(topic, index) in this.topicsEncoded" class="text-muted" :key="topic.id"
                         :to="'/topic/' + topic.encodedName">
                {{ topic.name }}
                <template v-if="index != answer.question.topics.length -1">,
                </template>
            </router-link>

            <span v-if="answer.question.topics.length === 0" class="text-muted">No topics</span></small>

    </div>

</template>

<script>
    export default {

        props: ['answer'],

        name: 'AnswerCard',

        data() {
            return {
                topicsEncoded: []
            }
        },

        computed: {
            contentPreview: function () {
                let stripped = this.answer.content.replace(/(<([^>]+)>)/ig, "")

                if (stripped.length > 169) {
                    stripped = stripped.substring(0, 169);
                    stripped += "...";
                }

                return stripped;
            }

        },

        created() {
            //So whitespaces are encoded in the href attribute
            this.topicsEncoded = this.answer.question.topics.map(topic => {
                let newTopic = topic;
                newTopic.encodedName = encodeURI(topic.name);
                return newTopic;
            })
        },


        methods: {
            onClickRedirect: function () {
                this.$router.push({path: '/questions/' + this.answer.question.id + '/answers/' + this.answer.id});
            }
        },

    }
</script>
