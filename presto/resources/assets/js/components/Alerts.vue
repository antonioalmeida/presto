<template>
    <b-alert class="alert-bottom" :variant="variant"
             dismissible
             :show="dismissCountDown"
             @dismissed="dismissDown"
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
            addArrayError(errors) {
                this.addArrayMessage(errors);
                this.variant = 'danger';
            },

            addArraySuccess(success) {
                this.addArrayMessage(success);
                this.variant = 'primary';
            },

            addError(text) {
                this.addMessage(text);
                this.variant = 'danger';
            },

            addSuccess(text) {
                this.addMessage(text);
                this.variant = 'primary';
            },

            addMessage(text) {
                this.text = [];
                this.dismissCountDown = 3;
                this.text.push(text);
            },

            addArrayMessage(messages) {
                this.text = messages;
                this.dismissCountDown = 3;
            },

            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown;
            },

            dismissDown() {
                this.dismissCountDown = 0;
                this.text = [];
            }
        }
    }
</script>

