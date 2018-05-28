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
                      <a href="" data-toggle="modal" data-target="#editEmailModal">Change Email</a>
                  </div>
              </div>
              <br>
              <hr>
              <div class="row">
                  <div class="col-md-3 py-2 col-sm-6">
                      <h6>Password</h6>
                  </div>
                  <div class="col-md-9 py-2 col-sm-6">
                      <a href="" data-toggle="modal" data-target="#changePasswordModal"> Change Password</a>
                  </div>
              </div>
          </div>

    <div class="modal fade" id="editEmailModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                    <div class="modal-body">
                        <div>
                            <h6><label for="email">Change your E-Mail</label></h6>
                            <div class="input-group">
                                <input @input="updateErrors" v-model="emailInput" type="email" name="email" class="form-control" placeholder="New email"
                                       aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                            </div>
                        </div>
                        <span v-if="emailError" class="text-danger"><small>New email is not invalid, please enter an email in the correct format.</small></span>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                        <button @click="onEmailSubmit" class="btn btn-primary">Save</button>
                    </div>
            </div>
        </div>
    </div>

    <!-- edit password modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                    <div class="modal-body">
                        <div>
                            <h6><label for="password">Change your password</label></h6>
                            <div class="input-group">
                                <input @input="updateErrors" v-model="passwordInput" type="password" name="password" class="form-control" placeholder="New password"
                                       aria-label="Default" aria-describedby="inputGroup-sizing-default"
                                       pattern="^(?=.*\d)(?=.*[a-zA-Z])(?=.*[&quot;-_?!@#+*$%&/()=])[&quot;\w\-?!@#+*$%&/()=]{8,32}$"
                                       required>
                            </div>
                        </div>
                        <span v-if="passwordError" class="text-danger"><small>New password is not valid. It must have 8-32 characters and contain alphanumeric and special (";-?!@#+*$%&/()=) characters.</small></span>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                        <button @click="onPasswordSubmit" class="btn btn-primary">Save</button>
                    </div>
            </div>
        </div>
    </div>
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
                passwordInput: '',
                passwordError: true,
                emailError: false
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
                if(this.emailError) return;
                axios.post('api/members/' + this.user.username + '/settings/email', {
                    'email': this.emailInput
                })
                    .then(({data}) => {
                        $('#editEmailModal').modal('toggle');
                        this.user.email = this.emailInput;
                        this.$alerts.addSuccess('Email successfully updated!')
                    })
                    .catch(({response}) => {

                    });

            },

            onPasswordSubmit: function () {
                if(this.passwordError) return;
                axios.post('api/members/' + this.user.username + '/settings/password', {
                    'password': this.passwordInput
                })
                    .then(({data}) => {
                        $('#changePasswordModal').modal('toggle');
                        this.$alerts.addSuccess('Password successfully updated!')
                    })
                    .catch(({response}) => {

                    });

            },

            updateErrors: function(evt) {
              this.passwordError = !document.querySelector('input[type="password"]').validity.valid;
              this.emailError = !document.querySelector('input[type="email"]').validity.valid;
            }
        }
    }
</script>
