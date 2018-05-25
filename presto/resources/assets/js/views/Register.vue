<template>
    <main class="img-background" role="main">
      <section class="pt-5 container">
            <div class="card my-3 py-3">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 offset-md-3">
                            <h1 class="text-center">Join Presto.</h1>
                            <p class="lead">Create an account to access your personalized feed, follow your favorite
                                writers and help contribute to the world's knowledge.</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="offset-lg-2 mb-2 col-md-6 col-lg-4 d-flex flex-column align-items-center">
                        <form id="signupForm" @submit.prevent="onSubmit">
                            
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-user"></i></div>
                                </div>
                                <input v-model="username" type="text" class="form-control" id="inlineFormInputGroup"
                                       placeholder="Your Username">
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-at"></i></div>
                                </div>
                                <input v-model="email" type="email" class="form-control" id="inlineFormInputGroup"
                                       placeholder="your@email.com">
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="far fa-key"></i></div>
                                </div>
                                <input v-model="password" type="password" class="form-control"
                                       id="inlineFormInputGroup" placeholder="Password" >
                            </div>
                            <div class="input-group mb-2">
                                <div class="input-group-prepend">
                                    <div class="input-group-text"><i class="fas fa-key"></i></div>
                                </div>
                                <input v-model="password_confirmation" type="password" class="form-control"
                                       id="inlineFormInputGroup" placeholder="Confirm Password">
                            </div>
                            <div class="form-check mb-2 mx-1">
                                <input v-model="terms" class="form-check-input" type="checkbox" id="defaultCheck1"
                                       >
                                <label class="form-check-label" for="defaultCheck1">
                                    <small>I accept Presto's <a href="">Terms and Conditions</a>.</small>
                                </label>
                            </div>
                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-primary">Sign Up</button>
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
            document.title = "Sign up | Presto";
        },

        data() {
            return {
                username: null,
                email: null,
                password: null,
                password_confirmation: null,
                terms: null,
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
            checkForm:function() {
                if(!this.username) {
                    this.$alerts.addError("Username required.");
                    return false;
                }

                if(!this.email) {
                    this.$alerts.addError("Email required.");
                    return false;
                }

                if(!this.password) {
                   this.$alerts.addError("Password required.");
                   return false;
                }

                if(!this.terms) {
                   this.$alerts.addError("Terms required.");
                   return false;
                }
               
                if(!this.$alerts.length)
                 return true;
            },

            onSubmit: function () {
               if(!this.checkForm()){
                   return;
               }
                
                axios.post('/signup', {
                    'username': this.username,
                    'email': this.email,
                    'password': this.password,
                    'password_confirmation': this.password_confirmation,
                    'terms': this.terms,
                })
                    .then(({data}) => {
                        // this.$router.push({path: '/'});
                        window.location.href = '/';
                        this.$alerts.addSuccess('Member successfully registered!');
                    })
                    .catch(({response}) => {
                        this.$alerts.addError(response.data.message);

                        let errors = response.data.errors;
                        for(let key in errors){
                            for(let message of errors[key]){
                                console.log(message);
                                this.$alerts.addError(message);
                            }
                        }
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
