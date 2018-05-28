<template>
    <main class="img-background">
        <section class="pt-5 container">
            <div class="row">
                <div class="col-md-8 col-md-offset-2">
                    <div class="panel panel-default">
                        <div class="panel-heading">Reset Password</div>

                        <div class="panel-body">
                            <form class="form-horizontal" @submit.prevent="onSubmit">
                                <div>
                                    <label for="email" class="col-md-4 control-label">E-Mail Address</label>

                                    <div class="col-md-6">
                                        <input id="email" type="email" class="form-control" v-model="email">

                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-4">
                                        <button type="submit" class="btn btn-primary">
                                            Send Password Reset Link
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main><!-- /.container -->
</template>

<script>
    export default {

        name: 'ResetPassword',

        created() {
            document.title = "Reset Password| Presto";
        },

        data() {
            return {
                email: null,
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.loader.hide();
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
            }
        },

        methods: {
            checkForm: function () {
                if (!this.email) {
                    this.$alerts.addError("Email required.");
                    return false;
                }


                if (!this.$alerts.length)
                    return true;
            },

            onSubmit: function () {
                if (!this.checkForm()) {
                    return;
                }

                axios.post('/password/email', {
                    'email': this.email,
                })
                    .then(({data}) => {
                        // this.$router.push({path: '/'});
                        if(data.response.data != null){
                            this.$alerts.addSuccess(data.response.data);
                            // window.location.href = '/';

                        } else if(data.response.error != null){
                            this.$alerts.addError(data.response.error);
                        }
                    })
                    .catch(({error}) => {
                    });
            },


        }

    }
</script>
