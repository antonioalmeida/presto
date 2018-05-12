<template>
    <router-link :to="'/' + notification.data['data']['url']" class="list-group-item list-group-item-action flex-column align-items-start">

        <div class="notifications-card d-flex w-100 justify-content-between flex-wrap">
            <div>
                <template v-if="notification.data['type'] == 'Follow'">
                    <a :href="'/profile/' + notification.data['data']['follower_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px" :src="notification.data['data']['follower_picture']">{{notification.data['data']['follower_name']}}</a>
                    <span class="text-muted"> started following you.</span>
                </template>

                <template v-if="notification.data['type'] == 'Question'">
                    <a :href="'/profile/' + notification.data['data']['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px" :src="notification.data['data']['following_picture']">{{notification.data['data']['following_name']}}</a>
                    <span class="text-muted"> posted a question.</span>
                </template>

                <template v-if="notification.data['type'] == 'Answer'">
                    <a :href="'/profile/' + notification.data['data']['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px" :src="notification.data['data']['following_picture']">{{notification.data['data']['following_name']}}</a>
                    <span class="text-muted"> answered your question: </span> {{notification.data['data']['question_title']}}
                </template>

                <template v-if="notification.data['type'] == 'Comment'">
                 <a :href="'/profile/' + notification.data['data']['following_username']" class="pb-1">
                        <img class="rounded-circle pr-1" width="36px" heigth="36px" :src="notification.data['data']['following_picture']">{{notification.data['data']['following_name']}}</a>
                   <span class="text-muted"> left a comment on your<span v-if="notification.data['data']['type'] == 'Answer' "> answer to the </span> question: </span><a :href="'/questions/' + notification.data['data']['question_id']" class="pb-1">{{notification.data['data']['question_title']}}</a>
                </template>
            </div>
                <!--Rate-->

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
            return {

            }
        }
    }
</script>