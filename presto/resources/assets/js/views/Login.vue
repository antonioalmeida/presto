<template>
    <main class="img-background">
        <section class="pt-5 container">
            <div class="card py-5 my-5">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 offset-md-3">
                            <h1 class="text-center">Welcome back.</h1>
                            <p class="lead">Log in to your account to access your personalized feed and see what your
                                favorite writers have been up to.</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 offset-lg-2 col-lg-4 d-flex flex-column align-items-center">
                        <form id="loginForm" @submit.prevent="onSubmit">
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-at"></i></div>
                                </div>
                                <label hidden for="email">Email</label>
                                <input v-model="email" id="email" type="email" class="form-control"
                                       placeholder="your@email.com">
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-key"></i></div>
                                </div>
                                <label hidden for="password">Password</label>
                                <input v-model="password" id="password" type="password" class="form-control"
                                       placeholder="Password"
                                       required>
                            </div>
                            <div>
                                <a class="text-dark" href="/password/reset"><small>Forgot your password?</small></a>
                            </div>
                            <div class="mt-2 d-flex justify-content-center">
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>

                        </form>
                    </div>
                    <div class="col-md-6 col-lg-4 d-flex flex-column align-items-center mb-5">
                        <span @click="loginGoogleAPI" class="btn btn-google"><i class="fab fa-google"></i> Sign in
                            with Google</span>
                        <!-- <div class="m-2 g-signin2" data-width="254" data-height="40" data-longtitle="true"></div>
                        <div class="fb-login-button m-2" data-max-rows="1" data-size="large" data-button-type="continue_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false"></div> -->
                    </div>
                </div>
            </div>
        </section>
    </main><!-- /.container -->
</template>

<script>
    export default {

        name: 'Login',

        created() {
            document.title = "Login | Presto";
        },

        data() {
            return {
                email: null,
                password: null,
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

                if (!this.$alerts.length)
                    return true;
            },

            onSubmit: function (e) {
                if (!this.checkForm()) {
                    return;
                }

                axios.post('/login', {
                    'email': this.email,
                    'password': this.password,
                })
                    .then(({data}) => {
                        // this.$router.push({path: '/'});
                        window.location.href = '/';
                    })
                    .catch(({response}) => {
                        this.$alerts.addError(response.data.message);

                        let errors = response.data.errors;
                        let messages = [];
                        for (let key in errors) {
                            for (let message of errors[key]) {
                                messages.push(message);
                            }
                        }
                        this.$alerts.addArrayError(messages);

                    });
            },

            loginGoogleAPI: function () {
                axios.get('/auth/google')
                    .then(({data}) => {
                        window.location.href = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },
        }

    }
</script>
