<template>
    <main class="grey-background mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" :src="user.profile_picture"/>
                            <span class="fa-layers fa-fw fa-2x">
                                 <i class="fas fa-circle text-shadow" style="color:white"></i>
                                <a href="" data-toggle="modal" data-target="#editPicture"><i
                                        class="fa-inverse fa-fw fas fa-pencil-alt text-muted"
                                        data-fa-transform="shrink-8"></i></a>
								</span>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-profile">

                            <input v-model="nameInput" type="text" class="form-control input-h2"
                                   pattern="^[a-zA-Z\s]{1,35}$"
                                   title="Name can only contain letters. 35 characters max allowed"
                                   placeholder="Your name..."
                                   required>
                            <input v-model="usernameInput" type="text" class="form-control input-h4 mt-2"
                                   pattern="^[a-zA-Z][\w-]{1,18}(?![-_])\w$"
                                   title="2 to 20 characters. Must start with a letter. Can contain alphanumeric characters, - and _ (but not end with the latter two)"
                                   placeholder="Your username..."
                                   required>

                            <div class="mt-3">
                                <input v-model="bioInput" type="text" class="form-control input-h6 lead-adapt mt-2"
                                       placeholder="Your bio...">

                                <div class="ml-1 mt-3">
                                    <button @click="onSubmit" class="btn btn-light">Save</button>
                                    <router-link :to="'/profile/' + user.username" class="btn btn-danger">Cancel
                                    </router-link>
                                </div>

                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </section>
        <!-- edit picture modal -->
        <div class="modal fade" id="editPicture" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div>
                        <div class="modal-body">
                            <div>
                                <h6><label for="profilePicture">Change your photo</label></h6>
                                <div class="input-group">
                                    <input type="text" v-model="profilePicture" class="form-control"
                                           placeholder="New URL"
                                           aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                            <button @click="onPicSubmit" type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

</template>

<script>
    export default {

        name: 'EditProfile',

        data() {
            return {
                user: {},
                nameInput: '',
                usernameInput: '',
                bioInput: '',
                profilePicture: '',
            }
        },

        created() {
            document.title = "Edit Profile | Presto";
            this.loader = this.$loading.show();
            this.getUser();
        },

        methods: {
            getUser: function () {
                axios.get('/api/profile/')
                    .then(({data}) => {
                        this.user = data;
                        this.nameInput = data.name;
                        this.usernameInput = data.username;
                        this.bioInput = data.bio;

                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onSubmit: function () {
                this.loader = this.$loading.show();
                axios.post('/api/profile/', {
                    'name': this.nameInput,
                    'username': this.usernameInput,
                    'bio': this.bioInput,
                })
                    .then(({data}) => {
                        this.loader.hide();
                        this.$router.push({path: '/profile/' + data.username});
                        this.$alerts.addSuccess('Profile successfully edited!');
                        location.reload();
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                    });

            },

            onPicSubmit: function () {
                axios.patch('api/member/edit-profile-pic', {
                    'profile-pic-url': this.profilePicture
                })
                    .then(({data}) => {
                        $('#editPicture').modal('toggle');
                        this.user.profile_picture = this.profilePicture;
                        this.$alerts.addSuccess('Photo successfully updated!');
                        location.reload();
                    })
                    .catch(({response}) => {

                    });
            },
        }
    }
</script>
