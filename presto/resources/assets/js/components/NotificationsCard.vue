<template>
    <router-link :to="'/' + notification.data['url']"
                 class="list-group-item list-group-item-action flex-column align-items-start">

        <div class="notifications-card d-flex w-100 justify-content-between flex-wrap">
            <div>
                <template v-if="notification.data['type'] == 'Follow'">
                    <a :href="'/profile/' + notification.data['follower_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['follower_picture']">{{notification.data['follower_name']}}</a>
                    <span class="text-muted"> started following you.</span>
                </template>

                <template v-if="notification.data['type'] == 'Question'">
                    <a :href="'/profile/' + notification.data['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['following_picture']">{{notification.data['following_name']}}</a>
                    <span class="text-muted"> posted a question.</span>
                </template>

                <template v-if="notification.data['type'] == 'Answer'">
                    <a :href="'/profile/' + notification.data['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['following_picture']">{{notification.data['following_name']}}</a>
                    <span class="text-muted"> answered your question: </span> {{notification.data['question_title']}}
                </template>

                <template v-if="notification.data['type'] == 'Comment'">
                    <a :href="'/profile/' + notification.data['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['following_picture']">{{notification.data['following_name']}}</a>
                    <span class="text-muted"> left a comment on your<span
                            v-if="notification.data['type_comment'] == 'Answer' "> answer to the </span> question: </span><a
                        :href="'/questions/' + notification.data['question_id']" class="pb-1">{{notification.data['question_title']}}</a>
                </template>

                 <template v-if="notification.data['type'] == 'Rating'">
                    <a :href="'/profile/' + notification.data['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['following_picture']">{{notification.data['following_name']}}</a>
                    <span class="text-muted"> upvote your comment to the<span
                            v-if="notification.data['type_comment'] == 'Answer' "> answer to the </span> question: </span><a
                        :href="'/questions/' + notification.data['question_id']" class="pb-1">{{notification.data['question_title']}}</a>
                </template>

                 <template v-if="notification.data['type'] == 'Mention'">
                    <a :href="'/profile/' + notification.data['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px"
                             :src="notification.data['following_picture']">{{notification.data['following_name']}}</a>
                    <span class="text-muted"> mentioned you on their comment to the <span
                            v-if="notification.data['type_comment'] == 'Answer' "> answer to the </span> question: </span><a
                        :href="'/questions/' + notification.data['question_id']" class="pb-1">{{notification.data['question_title']}}</a>
                </template>
            </div>

            <div>
                    <span class="mb-1 text-muted">
                        <small>{{ notification.created_at | moment("from") }}</small>
                    </span>
            </div>

        </div>


    </router-link>
</template>

<script>
    export default {

        props: ['notification'],

        name: 'NotificationsCard',

        data() {
            return {}
        }
    }
</script>