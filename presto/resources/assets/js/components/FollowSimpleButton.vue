<template>
    <button @click.stop.prevent="toggleFollow($event)"
            :class="{ [classesDefault]: (!isActive), [classesActive]: (isActive) }"
    >
        <i v-if="value" class="far fa-fw fa-user"></i>
        <i v-else class="far fa-fw fa-user-plus"></i>
    </button>
</template>

<script>
    export default {

        props: ['value', 'classesDefault', 'classesActive', 'path'],

        name: 'FollowSimpleButton',

        data() {
            return {
                isActive: this.value,
            }
        },

        methods: {
            toggleFollow: function (event) {
                let icon = event.target.children[0];

                axios.post(this.path)
                    .then(({data}) => {
                        if (data.following) {
                            icon.classList.remove("fa-user-plus");
                            icon.classList.add("fa-user");
                            this.isActive = true;
                        } else {
                            icon.classList.remove("fa-user");
                            icon.classList.add("fa-user-plus");
                            this.isActive = false;
                        }
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }
        },
    }
</script>
