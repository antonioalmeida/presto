<template>
    <router-link :to="'/topic/' + topic.name"
                 class="list-group-item list-group-item-action flex-column align-items-start">

        <div class="d-flex w-100 justify-content-begin">
            <div class="align-self-center">
                <img class="rounded-circle pr-2" width="60" height="60" :alt="'Picture for topic ' + topic.name":src="picture">
            </div>
            <div class="d-flex flex-column">
                <h6 class="mb-1">{{ topic.name }}</h6>
                <h6 class="text-muted text-collapse">
                    <small>{{ topic.description || "No description"}}</small>
                </h6>
            </div>

            <div class="ml-auto align-self-center flex-wrap">
                Follow
            </div>
        </div>
    </router-link>
</template>

<script>
    export default {

        props: ['topic'],

        name: 'TopicCard',

        data() {
            return {}
        },

        computed: {
            picture: function () {
                if (this.topic.picture)
                    return this.topic.picture;
                return ('https://identicon.org?s=250x250&t=' + this.topic.name + this.topic.description);
            }
        }

    }
</script>
