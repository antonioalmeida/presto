<template>
    <b-alert class="alert-bottom" :variant="variant"
             dismissible
             :show="dismissCountDown"
             @dismissed="dismissCountDown=0"
             @dismiss-count-down="countDownChanged">

        <div class="alert-message">
            <strong v-if="variant == 'danger'">Oh no!</strong>
            <strong v-else>Yes!</strong>
            <template v-for="message in text"> {{ message }} <br></template>
        </div>

    </b-alert>
</template>

<script>
    export default {

        name: 'Alerts',

        data() {
            return {
                dismissCountDown: 0,
                text: [],
                variant: 'danger'
            }
        },

        created() {
            Vue.prototype.$alerts = this;
        },

        methods: {
            addError(text) {
                this.dismissCountDown = 5;
                this.text.push(text);
                this.variant = 'danger';
            },

            addSuccess(text) {
                this.dismissCountDown = 5;
                this.text.push(text);
                this.variant = 'primary';
            },

            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown
            },
        }
    }
</script>

