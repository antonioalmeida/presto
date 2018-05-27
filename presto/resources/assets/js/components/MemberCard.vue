<template>
    <router-link :to="'/profile/' + member.username"
                 class="list-group-item list-group-item-action flex-column align-items-start">

        <div class="d-flex w-100 justify-content-begin">
            <div class="align-self-center">
                <img class="rounded-circle pr-2" width="60" height="60" :alt="member.name + '\'s profile picture'":src="member.profile_picture">
            </div>
            <div class="d-flex flex-column">
                <h6 class="mb-1">{{ member.name }}</h6>
                <h6 class="text-collapse">
                    <small>{{ member.bio }}</small>
                </h6>
                <h6>
                    <small class="text-muted">@ {{ member.username }}</small>
                </h6>
            </div>

            <div class="ml-auto align-self-center flex-wrap">
                <follow-button
                        v-model="member.isFollowing"
                        :classesDefault="'btn btn-sm btn-primary'"
                        :classesActive="'btn btn-sm btn-outline-primary'"
                        :path="'/api/member/' + member.username + '/toggle-follow'"
                        @update:data="value => this.$parent.$emit('update:data', value)"
                >
                </follow-button>

            </div>
        </div>
    </router-link>
</template>

<script>

    import FollowButton from '../components/FollowButton'

    export default {

        props: ['member'],

        name: 'MemberCard',

        components: {
            'FollowButton': FollowButton
        },

        data() {
            return {}
        }
    }
</script>
