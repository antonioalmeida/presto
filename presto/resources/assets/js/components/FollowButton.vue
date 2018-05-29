<template>
    <button @click.stop.prevent="toggleFollow()"
            :class="{ [classesDefault]: (!isActive || !value), [classesActive]: (isActive && value) }"
            @mouseover="handleHover()" @mouseleave="handleLeave()">

                <i v-if="value && !isActive" class="far fa-fw fa-user"></i>
                <i v-if="value && isActive" class="far fa-fw fa-user-times"></i>
                <i v-if="!value" class="far fa-fw fa-user-plus"></i>
        {{ text }}
    </button>
</template>

<script>
    export default {

        props: ['value', 'classesDefault', 'classesActive', 'path'],

        name: 'FollowButton',

        data() {
            return {
                isActive: false
            }
        },

        methods: {
            handleHover: function (e) {
                this.isActive = true;
            },

            handleLeave: function (e) {
                this.isActive = false;
            },

            toggleFollow: function () {
                axios.post(this.path)
                    .then(({data}) => {
                        this.$emit('input', data.following);
                        this.$emit('update:data', data);
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },
        },

        computed: {

            text: function () {
                if (this.value) {
                    if (this.isActive)
                        return 'Unfollow';
                    return 'Following';
                }
                return 'Follow';
            }
        }
    }
</script>

<style lang="css" scoped>
</style>