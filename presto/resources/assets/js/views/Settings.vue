<template>
    <main class="grey-background mt-5">
        <section>
            <div class="container align-items-center mt-5">
                <h4>Account</h4>
                <hr>
                <div class="row">
                    <div class="col-md-3 col-sm-6 py-2">
                        <h6>Email</h6>
                    </div>
                    <div class="col-md-9 col-sm-6 py-2">
                        <span>{{ this.user.email }}</span>
                        <br>
                        <a href="#" variant="outline-light" v-b-modal.editEmailModal>Change Email</a>
                    </div>
                </div>
                <br>
                <hr>
                <div class="row">
                    <div class="col-md-3 py-2 col-sm-6">
                        <h6>Password</h6>
                    </div>
                    <div class="col-md-9 py-2 col-sm-6">
                        <a href="#" variant="outline-light" v-b-modal.changePasswordModal> Change Password</a>
                    </div>
                </div>
            </div>

            <!-- Edit email modal -->
            <b-modal lazy centered
                title="Update your email"
                id="editEmailModal"
                ok-variant="primary"
                cancel-variant="link"
                ok-title="Submit"
                cancel-title="Cancel"
                @ok="onEmailSubmit"
            >
            <div class="input-group">
                <input v-model="emailInput" type="email"
                class="form-control" placeholder="New email"
                aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
            </div>
            </b-modal>

            <!-- edit password modal -->
            <b-modal lazy centered
                title="Update your password"
                id="changePasswordModal"
                ok-variant="primary"
                cancel-variant="link"
                ok-title="Submit"
                cancel-title="Cancel"
                @ok="onPasswordSubmit"
            >
            <div class="input-group">
                <input v-model="passwordInput" type="password"
                class="form-control" placeholder="New password"
                aria-label="Default" aria-describedby="inputGroup-sizing-default"
                pattern="^(?=.*\d)(?=.*[a-zA-Z])(?=.*[&quot;-_?!@#+*$%&/()=])[&quot;\w\-?!@#+*$%&/()=]{8,32}$"
                title="New password is not valid. It must have 8-32 characters and contain alphanumeric and special (&quot;;-?!@#+*$%&/()=) characters"
                required>
            </div>
            </b-modal>
        </section>
    </main>
</template>

<script>
    export default {

        name: 'Settings',

        data() {
            return {
                user: {},
                emailInput: '',
                passwordInput: ''
            }
        },

        created() {
            document.title = 'Settings | Presto';
            this.loader = this.$loading.show();
            this.getUser();
        },

        methods: {
            getUser: function () {
                axios.get('/api/profile/')
                    .then(({data}) => {
                        this.user = data;
                        this.emailInput = data.email;

                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onEmailSubmit: function () {
                if (this.emailError) return;
                axios.post('api/members/' + this.user.username + '/settings/email', {
                    'email': this.emailInput
                })
                    .then(({data}) => {
                        this.user.email = this.emailInput;
                        this.$alerts.addSuccess('Email successfully updated!')
                    })
                    .catch(({response}) => {
                        this.$alerts.addError(response.data.errors.email[0]);
                    });

            },

            onPasswordSubmit: function () {
                if (this.passwordError) return;
                axios.post('api/members/' + this.user.username + '/settings/password', {
                    'password': this.passwordInput
                })
                    .then(({data}) => {
                        this.$alerts.addSuccess('Password successfully updated!')
                    })
                    .catch(({response}) => {
                        this.$alerts.addError('Could not update password.');
                    });

            }
        }
    }
</script>
