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
                                        <input id="email" type="email" class="form-control" v-model="email"
                                               autofocus>


                                    </div>
                                </div>

                                <div>
                                    <label for="password" class="col-md-4 control-label">Password</label>

                                    <div class="col-md-6">
                                        <input id="password" type="password" class="form-control" v-model="password"
                                               required>

                                    </div>
                                </div>

                                <div>
                                    <label for="password-confirm" class="col-md-4 control-label">Confirm
                                        Password</label>
                                    <div class="col-md-6">
                                        <input id="password-confirm" type="password" class="form-control"
                                               v-model="password_confirmation" required>

                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-4">
                                        <button type="submit" class="btn btn-primary">
                                            Reset Password
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

        props: ['token'],

        name: 'ResetPassword2',

        created() {
            document.title = "Reset Password | Presto";
        },

        data() {
            return {
                email: null,
                password: null,
                password_confirmation: null,
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

                if (!this.password) {
                    this.$alerts.addError("Password required.");
                    return false;
                }

                if (!this.password_confirmation) {
                    this.$alerts.addError("Password required.");
                    return false;
                }

                if (!this.$alerts.length)
                    return true;
            },

            onSubmit: function () {
                if (!this.checkForm()) {
                    return;
                }

                axios.post('/password/reset', {
                    'token': this.token,
                    'email': this.email,
                    'password': this.password,
                    'password_confirmation': this.password_confirmation,
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
