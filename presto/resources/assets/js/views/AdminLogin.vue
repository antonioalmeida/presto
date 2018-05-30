<template>
    <main class="img-background">
        <section class="pt-5 container">
            <div class="card py-5 my-5">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 offset-md-3">
                            <h1 class="text-center">Welcome Administrator.</h1>
                            <p class="lead">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac
                                massa tristique semper.</p>
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
                                <input v-model="email" type="email" class="form-control"
                                       placeholder="your@email.com">
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-key"></i></div>
                                </div>
                                <input v-model="password" type="password" class="form-control"
                                       placeholder="Password"
                                       required>
                            </div>
                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-primary">Login</button>
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
        name: "AdminLogin",

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

                axios.post('/admin/login', {
                    'email': this.email,
                    'password': this.password,
                })
                    .then(({data}) => {
                        // this.$router.push({path: '/'});
                        window.location.href = '/admin';
                        this.$alerts.addSuccess('Member successfully loggedin!');
                    })
                    .catch(({response}) => {
                        this.$alerts.addError(response.data.message);

                        let errors = response.data.errors;
                        for (let key in errors) {
                            for (let message of errors[key]) {
                                console.log(message);
                                this.$alerts.addError(message);
                            }
                        }
                    });
            },
        }
    }
</script>