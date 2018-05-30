<template>
    <main class="img-background">
        <section class="pt-5 container">
            <div class="card py-5 my-5">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 offset-md-3">
                            <h1 class="text-center">Reset Password</h1>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 offset-lg-4 col-lg-4 d-flex flex-column align-items-center">

                        <form class="form-horizontal" @submit.prevent="onSubmit">

                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-at"></i></div>
                                </div>
                                <label hidden for="email">Email</label>
                                <input id="email" name="email" type="email" class="form-control" v-model="email"
                                       placeholder="Your e-mail...">
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <i class="far fa-key"></i>
                                        <b href="#" data-placement="top" data-toggle="tooltip" role="help" title=""
                                           data-original-title="8 to 32 characters. Must contain a letter, a number and at least one of the following -_?!@#+*$%/()="><sup>(?)</sup></b>
                                    </div>
                                </div>
                                <label hidden for="password">Password</label>
                                <input id="password" v-model="password" type="password" class="form-control"
                                       placeholder="Password"
                                       pattern="^(?=.*\d)(?=.*[a-zA-Z])(?=.*[&quot;-_?!@#+*$%&/()=])[&quot;\w\-?!@#+*$%&/()=]{8,32}$"
                                       required>
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <i class="fas fa-key"></i>
                                        <b href="#" data-placement="top" data-toggle="tooltip" role="help" title=""
                                           data-original-title=""><sup>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</sup></b>
                                    </div>
                                </div>
                                <label hidden for="password_confirmation">Password Confirmation</label>
                                <input id="password_confirmation" v-model="password_confirmation" type="password" class="form-control"
                                       placeholder="Confirm Password"
                                       required>
                            </div>

                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-primary">Reset Password</button>
                            </div>

                        </form>
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
                        if (data.response.data != null) {
                            this.$alerts.addSuccess(data.response.data);
                            window.location.href = '/';

                        } else if (data.response.error != null) {
                            this.$alerts.addError(data.response.error);
                        }
                    })
                    .catch(({error}) => {
                    });
            },

        }

    }
</script>
