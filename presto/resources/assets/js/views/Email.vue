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
                                <input id="email" type="email" class="form-control" v-model="email"
                                       placeholder="Your e-mail...">
                            </div>

                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-primary">Send Password Reset Link</button>
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
                        if (data.response.data != null) {
                            this.$alerts.addSuccess(data.response.data);
                            // window.location.href = '/';

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
