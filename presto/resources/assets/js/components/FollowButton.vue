<template>
    <button @click.stop.prevent="toggleFollow()"
            :class="{ [classesDefault]: (!value), [classesActive]: (isActive && value), [classesValue]: (value && !isActive)}"
            @mouseover="handleHover()" @mouseleave="handleLeave()">

                <i v-if="value && !isActive" class="far fa-fw fa-user"></i>
                <i v-if="value && isActive" class="far fa-fw fa-user-times"></i>
                <i v-if="!value" class="far fa-fw fa-user-plus"></i>
        <span v-if="useText" class="text-collapse">{{ text }}</span>
    </button>
</template>

<script>
    export default {

        props: {
            value: Boolean,
            classesDefault: String,
            classesValue: String,
            classesActive:  String,
            path: String,
            useText: {
                default: true,
                type: Boolean
            }
        },

        name: 'FollowButton',

        data() {
            return {
                isActive: false,
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
